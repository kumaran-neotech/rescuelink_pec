import 'package:flutter/material.dart';

class RequestSafetyScreen extends StatefulWidget {
  const RequestSafetyScreen({super.key});

  @override
  State<RequestSafetyScreen> createState() =>
      _RequestSafetyScreenState();
}

class _RequestSafetyScreenState
    extends State<RequestSafetyScreen> {
  bool safeMode = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Request Safety",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(22),
        child: Column(
          children: [
            const SizedBox(height: 15),

            const Text(
              "Need Immediate Help?",
              style: TextStyle(
                fontSize: 27,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              "Send your safety request to nearby RescueLink users.",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white54,
              ),
            ),

            const SizedBox(height: 40),

            // BIG MIC
            GestureDetector(
              onTap: () {
                setState(() {
                  safeMode = !safeMode;
                });
              },
              child: Container(
                width: 175,
                height: 175,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: safeMode
                      ? Colors.red
                      : const Color(0xFFFF6B00),
                  boxShadow: [
                    BoxShadow(
                      color: (safeMode
                              ? Colors.red
                              : const Color(0xFFFF6B00))
                          .withOpacity(0.3),
                      blurRadius: 35,
                      spreadRadius: 7,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.mic_rounded,
                  size: 85,
                  color: Colors.white,
                ),
              ),
            ),

            const SizedBox(height: 20),

            Text(
              safeMode
                  ? "Safety request active"
                  : "Tap to request safety",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 35),

            _safetyOption(
              Icons.home_work_outlined,
              "Shelter Required",
            ),

            _safetyOption(
              Icons.local_hospital_outlined,
              "Medical Assistance",
            ),

            _safetyOption(
              Icons.water_drop_outlined,
              "Food / Water",
            ),

            _safetyOption(
              Icons.directions_car_outlined,
              "Evacuation",
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      const Color(0xFFFF6B00),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text(
                  "REQUEST SAFETY",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _safetyOption(
    IconData icon,
    String title,
  ) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: const Color(0xFF151B23),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: const Color(0xFFFF6B00),
            size: 27,
          ),
          const SizedBox(width: 15),
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          const Icon(
            Icons.arrow_forward_ios,
            size: 15,
            color: Colors.white38,
          ),
        ],
      ),
    );
  }
}