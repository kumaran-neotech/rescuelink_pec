import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() =>
      _SettingsScreenState();
}

class _SettingsScreenState
    extends State<SettingsScreen> {
  bool notifications = true;
  bool location = true;
  bool offlineMode = true;
  bool darkMode = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Settings",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 15),

            // BIG MIC
            Container(
              width: 135,
              height: 135,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF151B23),
                border: Border.all(
                  color: const Color(0xFFFF6B00),
                  width: 3,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFFF6B00)
                        .withOpacity(0.2),
                    blurRadius: 25,
                  ),
                ],
              ),
              child: const Icon(
                Icons.mic_rounded,
                size: 65,
                color: Color(0xFFFF6B00),
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              "RescueLink Controls",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 30),

            _settingSwitch(
              Icons.notifications_outlined,
              "Notifications",
              "Receive emergency updates",
              notifications,
              (value) {
                setState(() {
                  notifications = value;
                });
              },
            ),

            _settingSwitch(
              Icons.location_on_outlined,
              "Location",
              "Allow emergency location sharing",
              location,
              (value) {
                setState(() {
                  location = value;
                });
              },
            ),

            _settingSwitch(
              Icons.wifi_off_rounded,
              "Offline Mode",
              "Use offline communication",
              offlineMode,
              (value) {
                setState(() {
                  offlineMode = value;
                });
              },
            ),

            _settingSwitch(
              Icons.dark_mode_outlined,
              "Dark Mode",
              "Use dark emergency interface",
              darkMode,
              (value) {
                setState(() {
                  darkMode = value;
                });
              },
            ),

            const SizedBox(height: 20),

            _settingButton(
              Icons.security_outlined,
              "Privacy & Security",
            ),

            _settingButton(
              Icons.help_outline,
              "Help & Support",
            ),

            _settingButton(
              Icons.info_outline,
              "About RescueLink",
            ),

            const SizedBox(height: 25),

            const Text(
              "RescueLink v1.0.0",
              style: TextStyle(
                color: Colors.white38,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _settingSwitch(
    IconData icon,
    String title,
    String subtitle,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color(0xFF151B23),
        borderRadius: BorderRadius.circular(17),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: const Color(0xFFFF6B00),
            size: 26,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Colors.white38,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor:
                const Color(0xFFFF6B00),
          ),
        ],
      ),
    );
  }

  Widget _settingButton(
    IconData icon,
    String title,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF151B23),
        borderRadius: BorderRadius.circular(17),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: const Color(0xFFFF6B00),
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