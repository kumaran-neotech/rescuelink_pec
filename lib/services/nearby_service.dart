import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:nearby_connections/nearby_connections.dart';
import 'package:permission_handler/permission_handler.dart';

import '../models/rescue_ticket.dart';

class NearbyDevice {
  final String endpointId;
  final String endpointName;

  NearbyDevice({
    required this.endpointId,
    required this.endpointName,
  });
}

class NearbyService {
  static const String serviceId = 'com.rescuelink.app';
  static const String deviceName = 'RescueLink';

  final Set<String> _connectedEndpoints = <String>{};

  final Set<String> _processedTickets = <String>{};

  final StreamController<NearbyDevice>
      _deviceFoundController =
      StreamController<NearbyDevice>.broadcast();

  final StreamController<String>
      _deviceLostController =
      StreamController<String>.broadcast();

  final StreamController<Map<String, dynamic>>
      _connectionController =
      StreamController<Map<String, dynamic>>.broadcast();

  Stream<NearbyDevice> get deviceFound =>
      _deviceFoundController.stream;

  Stream<String> get deviceLost =>
      _deviceLostController.stream;

  Stream<Map<String, dynamic>>
      get connectionEvents =>
          _connectionController.stream;

  // ==========================================================
  // PERMISSIONS
  // ==========================================================

  Future<bool> requestNearbyPermissions() async {
    try {
      final List<Permission> permissions = [
        Permission.bluetoothScan,
        Permission.bluetoothConnect,
        Permission.bluetoothAdvertise,
        Permission.location,
      ];

      final Map<Permission, PermissionStatus> statuses =
          await permissions.request();

      debugPrint(
        'Permission statuses: $statuses',
      );

      final bool scan =
          statuses[Permission.bluetoothScan]
                  ?.isGranted ??
              false;

      final bool connect =
          statuses[Permission.bluetoothConnect]
                  ?.isGranted ??
              false;

      final bool advertise =
          statuses[Permission.bluetoothAdvertise]
                  ?.isGranted ??
              false;

      final bool location =
          statuses[Permission.location]
                  ?.isGranted ??
              false;

      final bool result =
          scan &&
          connect &&
          advertise &&
          location;

      debugPrint(
        'Nearby permissions granted: $result',
      );

      return result;
    } catch (e) {
      debugPrint(
        'Permission error: $e',
      );

      return false;
    }
  }

  Future<bool> checkBluetoothPermission() async {
    try {
      final PermissionStatus scan =
          await Permission.bluetoothScan.status;

      final PermissionStatus connect =
          await Permission.bluetoothConnect.status;

      final PermissionStatus advertise =
          await Permission.bluetoothAdvertise.status;

      return scan.isGranted &&
          connect.isGranted &&
          advertise.isGranted;
    } catch (e) {
      debugPrint(
        'Bluetooth permission error: $e',
      );

      return false;
    }
  }

  // ==========================================================
  // START ADVERTISING
  // ==========================================================

  Future<bool> startAdvertising() async {
    try {
      final bool permissionGranted =
          await checkBluetoothPermission();

      if (!permissionGranted) {
        debugPrint(
          'Bluetooth permission not granted.',
        );

        return false;
      }

      await Nearby().startAdvertising(
        deviceName,
        Strategy.P2P_CLUSTER,
        serviceId: serviceId,

        onConnectionInitiated: (
          String endpointId,
          ConnectionInfo connectionInfo,
        ) {
          debugPrint(
            'Incoming connection: $endpointId',
          );

          Nearby().acceptConnection(
            endpointId,
            onPayLoadRecieved: (
              String endpointId,
              Payload payload,
            ) async {
              await _handlePayload(
                endpointId,
                payload,
              );
            },
          );
        },

        onConnectionResult: (
          String endpointId,
          Status status,
        ) {
          debugPrint(
            'Connection result: '
            '$endpointId -> $status',
          );

          if (status == Status.CONNECTED) {
            _connectedEndpoints.add(
              endpointId,
            );
          } else {
            _connectedEndpoints.remove(
              endpointId,
            );
          }

          _connectionController.add({
            'endpointId': endpointId,
            'statusCode': status,
          });
        },

        onDisconnected: (
          String endpointId,
        ) {
          debugPrint(
            'Disconnected: $endpointId',
          );

          _connectedEndpoints.remove(
            endpointId,
          );

          _deviceLostController.add(
            endpointId,
          );
        },
      );

      debugPrint(
        'Advertising started.',
      );

      return true;
    } catch (e) {
      debugPrint(
        'Advertising error: $e',
      );

      return false;
    }
  }

  // ==========================================================
  // STOP ADVERTISING
  // ==========================================================

  Future<void> stopAdvertising() async {
    try {
      await Nearby().stopAdvertising();

      debugPrint(
        'Advertising stopped.',
      );
    } catch (e) {
      debugPrint(
        'Stop advertising error: $e',
      );
    }
  }

  // ==========================================================
  // START DISCOVERY
  // ==========================================================

  Future<bool> startDiscovery() async {
    try {
      final bool permissionGranted =
          await checkBluetoothPermission();

      if (!permissionGranted) {
        debugPrint(
          'Bluetooth permission not granted.',
        );

        return false;
      }

      await Nearby().startDiscovery(
        deviceName,
        Strategy.P2P_CLUSTER,
        serviceId: serviceId,

        onEndpointFound: (
          String endpointId,
          String endpointName,
          String foundServiceId,
        ) {
          debugPrint(
            'Nearby device found: '
            '$endpointName ($endpointId)',
          );

          _deviceFoundController.add(
            NearbyDevice(
              endpointId: endpointId,
              endpointName: endpointName,
            ),
          );
        },

        onEndpointLost: (
          String? endpointId,
        ) {
          if (endpointId != null) {
            debugPrint(
              'Nearby device lost: $endpointId',
            );

            _deviceLostController.add(
              endpointId,
            );
          }
        },
      );

      debugPrint(
        'Discovery started.',
      );

      return true;
    } catch (e) {
      debugPrint(
        'Discovery error: $e',
      );

      return false;
    }
  }

  // ==========================================================
  // STOP DISCOVERY
  // ==========================================================

  Future<void> stopDiscovery() async {
    try {
      await Nearby().stopDiscovery();

      debugPrint(
        'Discovery stopped.',
      );
    } catch (e) {
      debugPrint(
        'Stop discovery error: $e',
      );
    }
  }

  // ==========================================================
  // REQUEST CONNECTION
  // ==========================================================

  Future<void> requestConnection(
    String endpointId,
  ) async {
    try {
      await Nearby().requestConnection(
        deviceName,
        endpointId,

        onConnectionInitiated: (
          String endpointId,
          ConnectionInfo connectionInfo,
        ) {
          debugPrint(
            'Connection initiated: $endpointId',
          );

          Nearby().acceptConnection(
            endpointId,
            onPayLoadRecieved: (
              String endpointId,
              Payload payload,
            ) async {
              await _handlePayload(
                endpointId,
                payload,
              );
            },
          );
        },

        onConnectionResult: (
          String endpointId,
          Status status,
        ) {
          debugPrint(
            'Connection result: '
            '$endpointId -> $status',
          );

          if (status == Status.CONNECTED) {
            _connectedEndpoints.add(
              endpointId,
            );
          } else {
            _connectedEndpoints.remove(
              endpointId,
            );
          }

          _connectionController.add({
            'endpointId': endpointId,
            'statusCode': status,
          });
        },

        onDisconnected: (
          String endpointId,
        ) {
          debugPrint(
            'Disconnected: $endpointId',
          );

          _connectedEndpoints.remove(
            endpointId,
          );

          _deviceLostController.add(
            endpointId,
          );
        },
      );
    } catch (e) {
      debugPrint(
        'Request connection error: $e',
      );
    }
  }

  // ==========================================================
  // BROADCAST PAYLOAD
  // ==========================================================

  Future<void> broadcastPayload(
    List<int> bytes, {
    String? excludeEndpointId,
  }) async {
    if (_connectedEndpoints.isEmpty) {
      debugPrint(
        'No connected devices.',
      );

      return;
    }

    final Uint8List payload =
        Uint8List.fromList(bytes);

    final List<String> endpoints =
        List<String>.from(
      _connectedEndpoints,
    );

    for (final String endpointId in endpoints) {
      if (excludeEndpointId != null &&
          endpointId == excludeEndpointId) {
        continue;
      }

      try {
        await Nearby().sendBytesPayload(
          endpointId,
          payload,
        );

        debugPrint(
          'Payload sent to $endpointId',
        );
      } catch (e) {
        debugPrint(
          'Payload send error: $e',
        );
      }
    }
  }

  // ==========================================================
  // RECEIVE PAYLOAD
  // ==========================================================

  Future<void> _handlePayload(
    String endpointId,
    Payload payload,
  ) async {
    try {
      if (payload.type != PayloadType.BYTES) {
        debugPrint(
          'Unsupported payload type.',
        );

        return;
      }

      if (payload.bytes == null ||
          payload.bytes!.isEmpty) {
        debugPrint(
          'Empty payload received.',
        );

        return;
      }

      final String jsonString =
          utf8.decode(
        payload.bytes!,
        allowMalformed: false,
      );

      debugPrint(
        'Received payload: $jsonString',
      );

      final dynamic decoded =
          jsonDecode(jsonString);

      if (decoded is! Map) {
        debugPrint(
          'Invalid ticket format.',
        );

        return;
      }

      final Map<String, dynamic> jsonData =
          Map<String, dynamic>.from(
        decoded,
      );

      final RescueTicket ticket =
          RescueTicket.fromMap(
        jsonData,
      );

      final String ticketId =
          ticket.ticketId;

      if (ticketId.isEmpty) {
        debugPrint(
          'Ticket ID is empty.',
        );

        return;
      }

      // Prevent infinite A -> B -> C -> A forwarding.
      if (_processedTickets.contains(ticketId)) {
        debugPrint(
          'Duplicate ticket ignored: $ticketId',
        );

        return;
      }

      // Mark before forwarding.
      _processedTickets.add(ticketId);

      debugPrint(
        'Ticket received successfully.',
      );

      debugPrint(
        'Ticket ID: ${ticket.ticketId}',
      );

      debugPrint(
        'Priority: ${ticket.priority}',
      );

      debugPrint(
        'Victims: ${ticket.victims}',
      );

      debugPrint(
        'Location: ${ticket.location}',
      );

      // Forward ticket to other connected devices.
      await broadcastPayload(
        utf8.encode(jsonString),
        excludeEndpointId: endpointId,
      );

      debugPrint(
        'Ticket forwarded successfully.',
      );
    } catch (e) {
      debugPrint(
        'Payload processing error: $e',
      );
    }
  }

  // ==========================================================
  // SEND TICKET
  // ==========================================================

  Future<void> sendTicket(
    RescueTicket ticket,
  ) async {
    try {
      final String jsonString =
          jsonEncode(
        ticket.toMap(),
      );

      final List<int> bytes =
          utf8.encode(jsonString);

      _processedTickets.add(
        ticket.ticketId,
      );

      await broadcastPayload(bytes);

      debugPrint(
        'Rescue ticket sent successfully.',
      );
    } catch (e) {
      debugPrint(
        'Send ticket error: $e',
      );
    }
  }

  // ==========================================================
  // GETTERS
  // ==========================================================

  int get connectedDeviceCount {
    return _connectedEndpoints.length;
  }

  Set<String> get connectedEndpoints {
    return Set.unmodifiable(
      _connectedEndpoints,
    );
  }

  // ==========================================================
  // CLEAR TICKETS
  // ==========================================================

  void clearProcessedTickets() {
    _processedTickets.clear();
  }

  // ==========================================================
  // DISPOSE
  // ==========================================================

  void dispose() {
    _deviceFoundController.close();
    _deviceLostController.close();
    _connectionController.close();

    _connectedEndpoints.clear();
    _processedTickets.clear();
  }
}
