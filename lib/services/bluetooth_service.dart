import 'dart:convert';

import '../models/rescue_ticket.dart';
import 'nearby_service.dart';

class BluetoothService {
  static final NearbyService _nearbyService = NearbyService();

  // ==========================================================
  // START MESH MODE
  // ==========================================================

  static Future<bool> startMeshMode() async {
    try {
      final permissionsGranted =
          await _nearbyService.requestNearbyPermissions();

      if (!permissionsGranted) {
        print('Required nearby permissions were denied.');
        return false;
      }

      final advertisingStarted =
          await _nearbyService.startAdvertising();

      final discoveryStarted =
          await _nearbyService.startDiscovery();

      if (!advertisingStarted || !discoveryStarted) {
        print('Failed to start nearby mesh mode.');
        return false;
      }

      print('RescueLink mesh mode started.');

      return true;
    } catch (e) {
      print('Mesh Mode Error: $e');
      return false;
    }
  }

  // ==========================================================
  // STOP MESH MODE
  // ==========================================================

  static Future<void> stopMeshMode() async {
    try {
      await _nearbyService.stopAdvertising();
      await _nearbyService.stopDiscovery();

      print('RescueLink mesh mode stopped.');
    } catch (e) {
      print('Stop Mesh Mode Error: $e');
    }
  }

  // ==========================================================
  // SEND RESCUE TICKET
  // ==========================================================

  static Future<bool> sendTicket(
    RescueTicket ticket,
  ) async {
    try {
      final String rawPayload = jsonEncode(ticket.toMap());

      final List<int> bytes = utf8.encode(rawPayload);

      await _nearbyService.broadcastPayload(bytes);

      print('Rescue ticket sent.');

      return true;
    } catch (e) {
      print('Send Ticket Error: $e');
      return false;
    }
  }

  // ==========================================================
  // REQUEST CONNECTION
  // ==========================================================

  static Future<void> connectToDevice(
    String endpointId,
  ) async {
    try {
      await _nearbyService.requestConnection(endpointId);
    } catch (e) {
      print('Connection Error: $e');
    }
  }

  // ==========================================================
  // CONNECTED DEVICE COUNT
  // ==========================================================

  static int get connectedDeviceCount {
    return _nearbyService.connectedDeviceCount;
  }

  // ==========================================================
  // DEVICE FOUND STREAM
  // ==========================================================

  static Stream<NearbyDevice> get deviceFound {
    return _nearbyService.deviceFound;
  }

  // ==========================================================
  // DEVICE LOST STREAM
  // ==========================================================

  static Stream<String> get deviceLost {
    return _nearbyService.deviceLost;
  }

  // ==========================================================
  // CONNECTION STREAM
  // ==========================================================

  static Stream<Map<String, dynamic>> get connectionEvents {
    return _nearbyService.connectionEvents;
  }
}