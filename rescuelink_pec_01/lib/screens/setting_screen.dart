import 'package:flutter/material.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  bool notificationsEnabled = true;
  bool locationEnabled = true;
  bool offlineNetworkEnabled = true;

  void showPrivacySecurity() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF151B23),
          title: const Row(
            children: [
              Icon(
                Icons.security_rounded,
                color: Color(0xFFFF6B00),
              ),
              SizedBox(width: 10),
              Text("Privacy & Security"),
            ],
          ),
          content: const SingleChildScrollView(
            child: Text(
              "RescueLink is designed for emergency communication.\n\n"
              "• Your profile information is used for identification.\n"
              "• Emergency requests contain only the information required for rescue.\n"
              "• Location information is used to help rescue teams identify your location.\n"
              "• Nearby communication is intended for emergency request sharing.",
              style: TextStyle(
                color: Colors.white70,
                height: 1.5,
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                "CLOSE",
                style: TextStyle(
                  color: Color(0xFFFF6B00),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void showHelpSupport() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF151B23),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25),
        ),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(22),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                const Text(
                  "Help & Support",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 20),

                _supportItem(
                  Icons.help_outline_rounded,
                  "How RescueLink Works",
                  "Learn how emergency requests are created and shared.",
                  () {
                    Navigator.pop(context);

                    showDialog(
                      context: this.context,
                      builder: (context) {
                        return AlertDialog(
                          backgroundColor:
                              const Color(0xFF151B23),
                          title: const Text(
                            "How RescueLink Works",
                          ),
                          content: const Text(
                            "1. Create an emergency request.\n"
                            "2. Select emergency details.\n"
                            "3. Add the number of victims.\n"
                            "4. Add your location.\n"
                            "5. Create the SOS request.\n"
                            "6. Nearby rescue volunteers can receive and accept the request.",
                            style: TextStyle(
                              color: Colors.white70,
                              height: 1.5,
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () =>
                                  Navigator.pop(context),
                              child: const Text(
                                "OK",
                                style: TextStyle(
                                  color:
                                      Color(0xFFFF6B00),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),

                _supportItem(
                  Icons.contact_support_outlined,
                  "Contact Support",
                  "Get assistance with RescueLink.",
                  () {
                    Navigator.pop(context);

                    ScaffoldMessenger.of(
                      this.context,
                    ).showSnackBar(
                      const SnackBar(
                        content: Text(
                          "Support request option opened.",
                        ),
                      ),
                    );
                  },
                ),

                _supportItem(
                  Icons.report_problem_outlined,
                  "Report a Problem",
                  "Tell us about an issue in the application.",
                  () {
                    Navigator.pop(context);

                    showDialog(
                      context: this.context,
                      builder: (context) {
                        final controller =
                            TextEditingController();

                        return AlertDialog(
                          backgroundColor:
                              const Color(0xFF151B23),
                          title: const Text(
                            "Report a Problem",
                          ),
                          content: TextField(
                            controller: controller,
                            maxLines: 4,
                            decoration:
                                const InputDecoration(
                              hintText:
                                  "Describe the problem...",
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () =>
                                  Navigator.pop(context),
                              child: const Text(
                                "CANCEL",
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);

                                ScaffoldMessenger.of(
                                  this.context,
                                ).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      "Problem report submitted.",
                                    ),
                                  ),
                                );
                              },
                              style:
                                  ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color(
                                  0xFFFF6B00,
                                ),
                              ),
                              child: const Text(
                                "SUBMIT",
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),

                const SizedBox(height: 15),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _supportItem(
    IconData icon,
    String title,
    String subtitle,
    VoidCallback onTap,
  ) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        width: 45,
        height: 45,
        decoration: BoxDecoration(
          color: const Color(0xFFFF6B00)
              .withOpacity(0.12),
          borderRadius: BorderRadius.circular(13),
        ),
        child: Icon(
          icon,
          color: const Color(0xFFFF6B00),
        ),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(
          color: Colors.white38,
          fontSize: 11,
        ),
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios_rounded,
        size: 16,
        color: Colors.white38,
      ),
      onTap: onTap,
    );
  }

  void showAbout() {
    showAboutDialog(
      context: context,
      applicationName: "RescueLink",
      applicationVersion: "1.0.0",
      applicationIcon: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: const Color(0xFFFF6B00),
          borderRadius: BorderRadius.circular(15),
        ),
        child: const Icon(
          Icons.shield_rounded,
          color: Colors.white,
        ),
      ),
      children: const [
        Text(
          "RescueLink is an offline disaster communication "
          "application designed to help victims communicate "
          "emergency information with nearby rescue volunteers.",
        ),
      ],
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
          "Settings",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [

          const Text(
            "Preferences",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 12),

          // NOTIFICATIONS
          _settingSwitch(
            icon: Icons.notifications_outlined,
            title: "Notifications",
            subtitle:
                "Receive emergency request notifications",
            value: notificationsEnabled,
            onChanged: (value) {
              setState(() {
                notificationsEnabled = value;
              });
            },
          ),

          // LOCATION
          _settingSwitch(
            icon: Icons.location_on_outlined,
            title: "Location Services",
            subtitle:
                "Allow RescueLink to use your location",
            value: locationEnabled,
            onChanged: (value) {
              setState(() {
                locationEnabled = value;
              });
            },
          ),

          // OFFLINE NETWORK
          _settingSwitch(
            icon: Icons.hub_outlined,
            title: "Offline Rescue Network",
            subtitle:
                "Allow nearby emergency communication",
            value: offlineNetworkEnabled,
            onChanged: (value) {
              setState(() {
                offlineNetworkEnabled = value;
              });
            },
          ),

          const SizedBox(height: 30),

          const Text(
            "Information",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 12),

          // PRIVACY
          _settingTile(
            icon: Icons.security_rounded,
            title: "Privacy & Security",
            subtitle: "Manage your privacy information",
            onTap: showPrivacySecurity,
          ),

          // HELP
          _settingTile(
            icon: Icons.help_outline_rounded,
            title: "Help & Support",
            subtitle: "Get help with RescueLink",
            onTap: showHelpSupport,
          ),

          // ABOUT
          _settingTile(
            icon: Icons.info_outline_rounded,
            title: "About RescueLink",
            subtitle: "Application information",
            onTap: showAbout,
          ),

          const SizedBox(height: 35),

          const Center(
            child: Text(
              "RescueLink • Offline Disaster Communication",
              style: TextStyle(
                color: Colors.white30,
                fontSize: 11,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _settingSwitch({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF151B23),
        borderRadius: BorderRadius.circular(16),
      ),
      child: SwitchListTile(
        value: value,
        onChanged: onChanged,
        activeColor: const Color(0xFFFF6B00),
        secondary: Icon(
          icon,
          color: const Color(0xFFFF6B00),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(
            color: Colors.white38,
            fontSize: 11,
          ),
        ),
      ),
    );
  }

  Widget _settingTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF151B23),
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Icon(
          icon,
          color: const Color(0xFFFF6B00),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(
            color: Colors.white38,
            fontSize: 11,
          ),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios_rounded,
          size: 15,
          color: Colors.white38,
        ),
      ),
    );
  }
}