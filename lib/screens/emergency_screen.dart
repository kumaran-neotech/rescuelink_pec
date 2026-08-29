import 'package:flutter/material.dart';

class EmergencyScreen extends StatefulWidget {
  const EmergencyScreen({super.key});

  @override
  State<EmergencyScreen> createState() => _EmergencyScreenState();
}

class _EmergencyScreenState extends State<EmergencyScreen> {
  bool isRecording = false;

  void toggleRecording() {
    setState(() {
      isRecording = !isRecording;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Emergency",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 15),

            const Text(
              "Report an Emergency",
              style: TextStyle(
                fontSize: 27,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              "Speak clearly. RescueLink will create your emergency request.",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white54,
                fontSize: 14,
              ),
            ),

            const SizedBox(height: 45),

            // BIG MICROPHONE
            GestureDetector(
              onTap: toggleRecording,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: isRecording ? 190 : 170,
                height: isRecording ? 190 : 170,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isRecording
                      ? Colors.red
                      : const Color(0xFFFF6B00),
                  boxShadow: [
                    BoxShadow(
                      color: (isRecording
                              ? Colors.red
                              : const Color(0xFFFF6B00))
                          .withOpacity(0.35),
                      blurRadius: 35,
                      spreadRadius: 8,
                    ),
                  ],
                ),
                child: Icon(
                  isRecording
                      ? Icons.stop_rounded
                      : Icons.mic_rounded,
                  size: 85,
                  color: Colors.white,
                ),
              ),
            ),

            const SizedBox(height: 25),

            Text(
              isRecording
                  ? "Listening..."
                  : "Tap & Speak",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: isRecording
                    ? Colors.redAccent
                    : Colors.white,
              ),
            ),

            const SizedBox(height: 40),

            // EMERGENCY TYPES
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Emergency Type",
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 15),

            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                _emergencyChip("Fire", Icons.local_fire_department),
                _emergencyChip("Medical", Icons.medical_services),
                _emergencyChip("Flood", Icons.water),
                _emergencyChip("Accident", Icons.car_crash),
                _emergencyChip("Trapped", Icons.warning_rounded),
              ],
            ),

            const SizedBox(height: 30),

            // VICTIM COUNT
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: const Color(0xFF151B23),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.groups_rounded,
                    color: Color(0xFFFF6B00),
                  ),
                  const SizedBox(width: 14),
                  const Expanded(
                    child: Text(
                      "Number of Victims",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.remove),
                  ),
                  const Text(
                    "1",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.add),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.send_rounded),
                label: const Text(
                  "CREATE SOS REQUEST",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF6B00),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _emergencyChip(String title, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 11,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF151B23),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: const Color(0xFF252D38),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 19,
            color: const Color(0xFFFF6B00),
          ),
          const SizedBox(width: 7),
          Text(title),
        ],
      ),
    );
  }
}