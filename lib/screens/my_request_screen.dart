import 'package:flutter/material.dart';

class MyRequestsScreen extends StatelessWidget {
  const MyRequestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "My Requests",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 10),

            const Text(
              "Emergency Requests",
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 30),

            // BIG MIC
            Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFFF6B00),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFFF6B00)
                        .withOpacity(0.3),
                    blurRadius: 30,
                    spreadRadius: 6,
                  ),
                ],
              ),
              child: const Icon(
                Icons.mic_rounded,
                size: 70,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              "Voice Emergency History",
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 30),

            _requestCard(
              "SOS-1024",
              "Medical Emergency",
              "2 Victims",
              "Received",
              Colors.green,
            ),

            _requestCard(
              "SOS-1023",
              "Accident",
              "4 Victims",
              "Rescue Assigned",
              Colors.orange,
            ),

            _requestCard(
              "SOS-1022",
              "Flood",
              "6 Victims",
              "Resolved",
              Colors.blue,
            ),
          ],
        ),
      ),
    );
  }

  Widget _requestCard(
    String id,
    String type,
    String victims,
    String status,
    Color statusColor,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF151B23),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFF252D38),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(
                Icons.emergency_rounded,
                color: Color(0xFFFF6B00),
                size: 30,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      id,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      type,
                      style: const TextStyle(
                        color: Colors.white60,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                status,
                style: TextStyle(
                  color: statusColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ],
          ),

          const SizedBox(height: 15),

          Row(
            children: [
              const Icon(
                Icons.groups_outlined,
                size: 18,
                color: Colors.white54,
              ),
              const SizedBox(width: 6),
              Text(victims),
              const Spacer(),
              const Icon(
                Icons.arrow_forward_ios,
                size: 14,
                color: Colors.white38,
              ),
            ],
          ),
        ],
      ),
    );
  }
}