import 'dart:async';

import 'package:flutter/material.dart';

import '../models/rescue_ticket.dart';
import '../services/bluetooth_service.dart';
import '../services/nearby_service.dart';

class NearbyShareScreen extends StatefulWidget {
  const NearbyShareScreen({super.key});

  @override
  State<NearbyShareScreen> createState() => _NearbyShareScreenState();
}

class _NearbyShareScreenState extends State<NearbyShareScreen> {
  bool scanning = false;

  // endpointId -> device info, populated live from BluetoothService streams
  final Map<String, NearbyDevice> _devices = {};
  final Set<String> _connectedIds = {};

  StreamSubscription<NearbyDevice>? _foundSub;
  StreamSubscription<String>? _lostSub;
  StreamSubscription<Map<String, dynamic>>? _connectionSub;

  @override
  void initState() {
    super.initState();

    _foundSub = BluetoothService.deviceFound.listen((device) {
      setState(() {
        _devices[device.endpointId] = device;
      });
    });

    _lostSub = BluetoothService.deviceLost.listen((endpointId) {
      setState(() {
        _devices.remove(endpointId);
        _connectedIds.remove(endpointId);
      });
    });

    _connectionSub = BluetoothService.connectionEvents.listen((event) {
      final String? endpointId = event['endpointId'] as String?;
      if (endpointId == null) return;

      if (event['type'] == 'connected') {
        setState(() => _connectedIds.add(endpointId));
      } else if (event['type'] == 'disconnected' ||
          event['type'] == 'connectionFailed') {
        setState(() => _connectedIds.remove(endpointId));
      }
    });
  }

  @override
  void dispose() {
    _foundSub?.cancel();
    _lostSub?.cancel();
    _connectionSub?.cancel();
    BluetoothService.stopMeshMode();
    super.dispose();
  }

  // ==========================================================
  // SCAN / ADVERTISE
  // ==========================================================
  Future<void> startScanning() async {
    setState(() => scanning = true);

    final bool started = await BluetoothService.startMeshMode();

    setState(() => scanning = false);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          started
              ? "Scanning for nearby rescue devices"
              : "Couldn't start nearby share — check Bluetooth & location permissions",
        ),
        backgroundColor: started ? null : Colors.red,
      ),
    );
  }

  // ==========================================================
  // SHARE SOS TICKET WITH A SPECIFIC DEVICE
  // ==========================================================
  Future<void> shareRequest(NearbyDevice device) async {
    // Connect first if we're not already connected to this endpoint.
    if (!_connectedIds.contains(device.endpointId)) {
      await BluetoothService.connectToDevice(device.endpointId);

      // Give the handshake a moment to complete.
      await Future.delayed(const Duration(seconds: 2));

      if (!_connectedIds.contains(device.endpointId)) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Couldn't connect to ${device.deviceName}"),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
    }

    // TODO: replace with the real active SOS ticket (e.g. from AppData)
    // instead of building a placeholder one here.
    final ticket = RescueTicket(
      ticketId: 'RL-${DateTime.now().millisecondsSinceEpoch}',
      type: 'Other',
      location: 'Unknown',
      priority: 'High',
      victims: 1,
      message: 'SOS - Emergency assistance needed',
      createdAt: DateTime.now(),
    );

    final bool sent = await BluetoothService.sendTicket(ticket);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          sent
              ? "SOS request shared with ${device.deviceName}"
              : "Failed to share SOS request",
        ),
        backgroundColor: sent ? Colors.green : Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final deviceList = _devices.values.toList();

    return Scaffold(
      backgroundColor: const Color(0xFF0B0F14),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0B0F14),
        elevation: 0,
        title: const Text(
          "Nearby Share",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 15),

            // NETWORK ICON
            Container(
              width: 145,
              height: 145,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFFF6B00).withOpacity(0.10),
                border: Border.all(
                  color: const Color(0xFFFF6B00).withOpacity(0.35),
                  width: 2,
                ),
              ),
              child: const Icon(
                Icons.hub_rounded,
                color: Color(0xFFFF6B00),
                size: 75,
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              "Nearby Rescue Network",
              style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            const Text(
              "Share emergency requests with nearby devices without relying on the internet.",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white38,
                fontSize: 13,
                height: 1.4,
              ),
            ),

            const SizedBox(height: 25),

            // SCAN BUTTON
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                onPressed: scanning ? null : startScanning,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF6B00),
                  disabledBackgroundColor: Colors.white12,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                icon: scanning
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.radar_rounded, color: Colors.white),
                label: Text(
                  scanning ? "SCANNING..." : "SCAN NEARBY DEVICES",
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),

            Row(
              children: [
                const Text(
                  "Nearby Devices",
                  style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                Text(
                  "${deviceList.length} found",
                  style: const TextStyle(color: Colors.white38, fontSize: 12),
                ),
              ],
            ),

            const SizedBox(height: 15),

            if (deviceList.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Text(
                  scanning
                      ? "Searching for nearby devices..."
                      : "No devices found yet. Tap scan to search.",
                  style: const TextStyle(color: Colors.white38, fontSize: 13),
                ),
              )
            else
              ...deviceList.map((device) => _deviceCard(device)),

            const SizedBox(height: 20),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(17),
              decoration: BoxDecoration(
                color: const Color(0xFF151B23),
                borderRadius: BorderRadius.circular(17),
                border: Border.all(color: const Color(0xFF252D38)),
              ),
              child: const Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.info_outline_rounded, color: Color(0xFFFF6B00)),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      "Nearby Share is designed for emergency communication between nearby rescue devices.",
                      style: TextStyle(
                        color: Colors.white54,
                        fontSize: 12,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _deviceCard(NearbyDevice device) {
    final bool connected = _connectedIds.contains(device.endpointId);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color(0xFF151B23),
        borderRadius: BorderRadius.circular(17),
        border: Border.all(
          color: connected
              ? Colors.green.withOpacity(0.25)
              : const Color(0xFF252D38),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: connected
                  ? Colors.green.withOpacity(0.12)
                  : const Color(0xFFFF6B00).withOpacity(0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              connected ? Icons.devices_rounded : Icons.phone_android_rounded,
              color: connected ? Colors.green : const Color(0xFFFF6B00),
            ),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  device.deviceName,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      connected
                          ? Icons.check_circle_outline
                          : Icons.wifi_tethering,
                      size: 13,
                      color: Colors.white38,
                    ),
                    const SizedBox(width: 3),
                    Text(
                      connected ? "Connected" : "Discovered",
                      style: const TextStyle(
                        color: Colors.white38,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () => shareRequest(device),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF6B00),
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 9,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text(
              "SHARE",
              style: TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}