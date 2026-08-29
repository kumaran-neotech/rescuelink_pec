import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "My Profile",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(22),
        child: Column(
          children: [
            const SizedBox(height: 15),

            // PROFILE IMAGE
            Container(
              width: 110,
              height: 110,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFFFF6B00),
              ),
              child: const Icon(
                Icons.person_rounded,
                size: 65,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 15),

            const Text(
              "RescueLink User",
              style: TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.bold,
              ),
            ),

            const Text(
              "user@rescuelink.com",
              style: TextStyle(
                color: Colors.white54,
              ),
            ),

            const SizedBox(height: 30),

            // BIG MIC
            Container(
              width: 130,
              height: 130,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF151B23),
                border: Border.all(
                  color: const Color(0xFFFF6B00),
                  width: 3,
                ),
              ),
              child: const Icon(
                Icons.mic_rounded,
                size: 65,
                color: Color(0xFFFF6B00),
              ),
            ),

            const SizedBox(height: 15),

            const Text(
              "Voice Profile",
              style: TextStyle(
                color: Colors.white60,
              ),
            ),

            const SizedBox(height: 30),

            _profileItem(
              Icons.person_outline,
              "Full Name",
              "RescueLink User",
            ),

            _profileItem(
              Icons.phone_outlined,
              "Phone Number",
              "+91 XXXXX XXXXX",
            ),

            _profileItem(
              Icons.email_outlined,
              "Email",
              "user@rescuelink.com",
            ),

            _profileItem(
              Icons.location_on_outlined,
              "Location",
              "Location not set",
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.edit),
                label: const Text(
                  "EDIT PROFILE",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      const Color(0xFFFF6B00),
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

  Widget _profileItem(
    IconData icon,
    String title,
    String value,
  ) {
    return Container(
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
          ),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white54,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}