import 'package:flutter/material.dart';

class NearbyShareScreen extends StatefulWidget {
  const NearbyShareScreen({super.key});

  @override
  State<NearbyShareScreen> createState() =>
      _NearbyShareScreenState();
}

class _NearbyShareScreenState
    extends State<NearbyShareScreen> {

  bool scanning = false;

  final List<Map<String, dynamic>> devices = [
    {
      "name": "Rescue Node 01",
      "distance": "12 m",
      "connected": true,
    },
    {
      "name": "Rescue Node 02",
      "distance": "28 m",
      "connected": true,
    },
    {
      "name": "Volunteer Device",
      "distance": "45 m",
      "connected": false,
    },
  ];

  void startScanning() async {
    setState(() {
      scanning = true;
    });

    await Future.delayed(
      const Duration(seconds: 2),
    );

    setState(() {
      scanning = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          "Nearby rescue devices updated",
        ),
      ),
    );
  }

  void shareRequest(
    Map<String, dynamic> device,
  ) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "SOS request shared with ${device["name"]}",
        ),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0F14),

      appBar: AppBar(
        backgroundColor: const Color(0xFF0B0F14),
        elevation: 0,
        title: const Text(
          "Nearby Share",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
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
                color: const Color(0xFFFF6B00)
                    .withOpacity(0.10),
                border: Border.all(
                  color: const Color(0xFFFF6B00)
                      .withOpacity(0.35),
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
              style: TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.bold,
              ),
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
                onPressed: scanning
                    ? null
                    : startScanning,
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      const Color(0xFFFF6B00),
                  disabledBackgroundColor:
                      Colors.white12,
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(15),
                  ),
                ),
                icon: scanning
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child:
                            CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(
                        Icons.radar_rounded,
                        color: Colors.white,
                      ),
                label: Text(
                  scanning
                      ? "SCANNING..."
                      : "SCAN NEARBY DEVICES",
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
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Text(
                  "${devices.length} found",
                  style: const TextStyle(
                    color: Colors.white38,
                    fontSize: 12,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 15),

            ...devices.map(
              (device) => _deviceCard(device),
            ),

            const SizedBox(height: 20),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(17),
              decoration: BoxDecoration(
                color: const Color(0xFF151B23),
                borderRadius:
                    BorderRadius.circular(17),
                border: Border.all(
                  color: const Color(0xFF252D38),
                ),
              ),
              child: const Row(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [

                  Icon(
                    Icons.info_outline_rounded,
                    color: Color(0xFFFF6B00),
                  ),

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

  Widget _deviceCard(
    Map<String, dynamic> device,
  ) {
    final bool connected =
        device["connected"] as bool;

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
                  : const Color(0xFFFF6B00)
                      .withOpacity(0.12),
              borderRadius:
                  BorderRadius.circular(14),
            ),
            child: Icon(
              connected
                  ? Icons.devices_rounded
                  : Icons.phone_android_rounded,
              color: connected
                  ? Colors.green
                  : const Color(0xFFFF6B00),
            ),
          ),

          const SizedBox(width: 13),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [

                Text(
                  device["name"],
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 4),

                Row(
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      size: 13,
                      color: Colors.white38,
                    ),
                    const SizedBox(width: 3),
                    Text(
                      device["distance"],
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
            onPressed: () {
              shareRequest(device);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  const Color(0xFFFF6B00),
              padding:
                  const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 9,
              ),
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(10),
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