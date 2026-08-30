import 'dart:async';
import 'dart:typed_data';

import 'package:nearby_connections/nearby_connections.dart';
import 'package:permission_handler/permission_handler.dart';

// ==========================================================
// SIMPLE DEVICE MODEL EXPOSED TO THE REST OF THE APP
// ==========================================================
class NearbyDevice {
  final String endpointId;
  final String deviceName;

  NearbyDevice({
    required this.endpointId,
    required this.deviceName,
  });
}

class NearbyService {
  // Must be unique to your app and identical on every device
  // that should be able to discover each other.
  static const String _serviceId = 'com.rescuelink.mesh';

  final Nearby _nearby = Nearby();

  // endpointId -> deviceName, only for endpoints that are CONNECTED
  final Map<String, String> _connectedEndpoints = {};

  final StreamController<NearbyDevice> _deviceFoundController =
      StreamController<NearbyDevice>.broadcast();

  final StreamController<String> _deviceLostController =
      StreamController<String>.broadcast();

  final StreamController<Map<String, dynamic>> _connectionEventsController =
      StreamController<Map<String, dynamic>>.broadcast();

  Stream<NearbyDevice> get deviceFound => _deviceFoundController.stream;
  Stream<String> get deviceLost => _deviceLostController.stream;
  Stream<Map<String, dynamic>> get connectionEvents =>
      _connectionEventsController.stream;

  int get connectedDeviceCount => _connectedEndpoints.length;

  // ==========================================================
  // PERMISSIONS
  // ==========================================================
  Future<bool> requestNearbyPermissions() async {
    final statuses = await [
      Permission.bluetoothAdvertise,
      Permission.bluetoothConnect,
      Permission.bluetoothScan,
      Permission.nearbyWifiDevices,
      Permission.location,
    ].request();

    // DEBUG: print each permission's status individually so we can see
    // exactly which one is blocking startup. Remove once everything works.
    statuses.forEach((permission, status) {
      print('[NearbyService] $permission -> $status');
    });

    final bool allGranted =
        statuses.values.every((status) => status.isGranted);

    if (!allGranted) {
      print('[NearbyService] Permission check FAILED overall.');
    }

    return allGranted;
  }

  // ==========================================================
  // ADVERTISING  (makes this device discoverable)
  // ==========================================================
  Future<bool> startAdvertising() async {
    try {
      final String userName =
          'RescueLink-${DateTime.now().millisecondsSinceEpoch % 10000}';

      return await _nearby.startAdvertising(
        userName,
        Strategy.P2P_CLUSTER,
        serviceId: _serviceId,
        onConnectionInitiated: _onConnectionInitiated,
        onConnectionResult: _onConnectionResult,
        onDisconnected: _onDisconnected,
      );
    } catch (e) {
      print('startAdvertising error: $e');
      return false;
    }
  }

  Future<void> stopAdvertising() async {
    await _nearby.stopAdvertising();
  }

  // ==========================================================
  // DISCOVERY  (finds other advertising devices)
  // ==========================================================
  Future<bool> startDiscovery() async {
    try {
      return await _nearby.startDiscovery(
        'RescueLink-Scanner',
        Strategy.P2P_CLUSTER,
        serviceId: _serviceId,
        onEndpointFound: (endpointId, endpointName, serviceId) {
          _deviceFoundController.add(
            NearbyDevice(
              endpointId: endpointId,
              deviceName: endpointName,
            ),
          );
        },
        onEndpointLost: (endpointId) {
          if (endpointId != null) {
            _deviceLostController.add(endpointId);
          }
        },
      );
    } catch (e) {
      print('startDiscovery error: $e');
      return false;
    }
  }

  Future<void> stopDiscovery() async {
    await _nearby.stopDiscovery();
  }

  // ==========================================================
  // CONNECTION HANDSHAKE
  // ==========================================================
  Future<void> requestConnection(String endpointId) async {
    await _nearby.requestConnection(
      'RescueLink-User',
      endpointId,
      onConnectionInitiated: _onConnectionInitiated,
      onConnectionResult: _onConnectionResult,
      onDisconnected: _onDisconnected,
    );
  }

  void _onConnectionInitiated(String endpointId, ConnectionInfo info) async {
    // Auto-accept: fine for an emergency mesh where every node is trusted.
    await _nearby.acceptConnection(
      endpointId,
      onPayLoadRecieved: (fromEndpointId, payload) {
        if (payload.type == PayloadType.BYTES && payload.bytes != null) {
          final String message = String.fromCharCodes(payload.bytes!);
          _connectionEventsController.add({
            'type': 'payloadReceived',
            'endpointId': fromEndpointId,
            'message': message,
          });
        }
      },
    );
  }

  void _onConnectionResult(String endpointId, Status status) {
    if (status == Status.CONNECTED) {
      _connectedEndpoints[endpointId] = endpointId;
      _connectionEventsController.add({
        'type': 'connected',
        'endpointId': endpointId,
      });
    } else {
      _connectionEventsController.add({
        'type': 'connectionFailed',
        'endpointId': endpointId,
      });
    }
  }

  void _onDisconnected(String endpointId) {
    _connectedEndpoints.remove(endpointId);
    _connectionEventsController.add({
      'type': 'disconnected',
      'endpointId': endpointId,
    });
  }

  // ==========================================================
  // SEND DATA
  //
  // NOTE: this broadcasts to every currently-connected endpoint.
  // Nearby Connections has no built-in "send to just one endpoint
  // I'm not yet connected to" — you must requestConnection() and
  // wait for onConnectionResult(CONNECTED) before broadcastPayload
  // will actually reach that device.
  // ==========================================================
  Future<void> broadcastPayload(List<int> bytes) async {
    final Uint8List data = Uint8List.fromList(bytes);

    for (final endpointId in _connectedEndpoints.keys) {
      await _nearby.sendBytesPayload(endpointId, data);
    }
  }

  // ==========================================================
  // CLEANUP
  // ==========================================================
  void dispose() {
    _deviceFoundController.close();
    _deviceLostController.close();
    _connectionEventsController.close();
  }
}