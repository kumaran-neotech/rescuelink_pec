import 'package:flutter/material.dart';

import 'emergency_screen.dart';
import 'my_request_screen.dart';
import 'profile_screen.dart';
import 'request_safety_screen.dart';
import 'setting_screen.dart';
import 'voluenteer_screen.dart';
import 'nearby_share_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // ==========================================================
  // OPEN NORMAL SCREEN
  // ==========================================================

  void openScreen(BuildContext context, Widget screen) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => screen,
      ),
    );
  }

  // ==========================================================
  // BUILD
  // ==========================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0F14),

      // ======================================================
      // APP BAR
      // ======================================================

      appBar: AppBar(
        backgroundColor: const Color(0xFF0B0F14),
        elevation: 0,
        title: const Row(
          children: [
            Icon(
              Icons.shield_rounded,
              color: Color(0xFFFF6B00),
              size: 30,
            ),
            SizedBox(width: 10),
            Text(
              'RescueLink',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 21,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Profile',
            onPressed: () {
              openScreen(
                context,
                const ProfileScreen(),
              );
            },
            icon: const Icon(
              Icons.person_outline_rounded,
            ),
          ),
          IconButton(
            tooltip: 'Settings',
            onPressed: () {
              openScreen(
                context,
                const SettingScreen(),
              );
            },
            icon: const Icon(
              Icons.settings_outlined,
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),

      // ======================================================
      // BODY
      // ======================================================

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            20,
            10,
            20,
            30,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Welcome back!',
                style: TextStyle(
                  color: Colors.white54,
                  fontSize: 14,
                ),
              ),

              const SizedBox(height: 5),

              const Text(
                'Stay Safe. Stay Connected.',
                style: TextStyle(
                  fontSize: 27,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 18),

              // ==================================================
              // OFFLINE NETWORK
              // ==================================================

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: const Color(0xFF101C17),
                  borderRadius: BorderRadius.circular(17),
                  border: Border.all(
                    color: Colors.green.withOpacity(0.25),
                  ),
                ),
                child: const Row(
                  children: [
                    Icon(
                      Icons.wifi_off_rounded,
                      color: Colors.green,
                      size: 25,
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Offline Network Active',
                            style: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 3),
                          Text(
                            'Ready for emergency communication',
                            style: TextStyle(
                              color: Colors.white54,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.check_circle_rounded,
                      color: Colors.green,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              // ==================================================
              // EMERGENCY SOS TITLE
              // ==================================================

              const Center(
                child: Text(
                  'EMERGENCY SOS',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
              ),

              const SizedBox(height: 18),

              // ==================================================
              // TAP & SPEAK
              // ==================================================

              Center(
                child: GestureDetector(
                  onTap: () {
                    openScreen(
                      context,
                      const EmergencyScreen(),
                    );
                  },
                  child: Container(
                    width: 190,
                    height: 190,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFFFF6B00),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFFF6B00)
                              .withOpacity(0.30),
                          blurRadius: 45,
                          spreadRadius: 8,
                        ),
                      ],
                    ),
                    child: Container(
                      margin: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color:
                              Colors.white.withOpacity(0.30),
                          width: 2,
                        ),
                      ),
                      child: const Column(
                        mainAxisAlignment:
                            MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.mic_rounded,
                            size: 78,
                            color: Colors.white,
                          ),
                          SizedBox(height: 3),
                          Text(
                            'TAP & SPEAK',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              const Center(
                child: Text(
                  'Speak your emergency to create an SOS request',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white38,
                    fontSize: 12,
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // ==================================================
              // SERVICES
              // ==================================================

              const Text(
                'RescueLink Services',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 15),

              Row(
                children: [
                  Expanded(
                    child: _serviceCard(
                      context,
                      icon: Icons.warning_amber_rounded,
                      title: 'Emergency',
                      subtitle: 'Report SOS',
                      onTap: () {
                        openScreen(
                          context,
                          const EmergencyScreen(),
                        );
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              Row(
                children: [
                  Expanded(
                    child: _serviceCard(
                      context,
                      icon: Icons.health_and_safety_rounded,
                      title: 'Request Safety',
                      subtitle: 'Request help',
                      onTap: () {
                        openScreen(
                          context,
                          const RequestSafetyScreen(),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _serviceCard(
                      context,
                      icon: Icons.assignment_rounded,
                      title: 'My Requests',
                      subtitle: 'Track SOS',
                      onTap: () {
                        openScreen(
                          context,
                          const MyRequestsScreen(),
                        );
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              Row(
                children: [
                  Expanded(
                    child: _serviceCard(
                      context,
                      icon: Icons.volunteer_activism_rounded,
                      title: 'Volunteer',
                      subtitle: 'Join rescue',
                      onTap: () {
                        openScreen(
                          context,
                          const VolunteerScreen(),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _serviceCard(
                      context,
                      icon: Icons.person_rounded,
                      title: 'Profile',
                      subtitle: 'My account',
                      onTap: () {
                        openScreen(
                          context,
                          const ProfileScreen(),
                        );
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              Row(
                children: [
                  Expanded(
                    child: _serviceCard(
                      context,
                      icon: Icons.settings_rounded,
                      title: 'Settings',
                      subtitle: 'App controls',
                      onTap: () {
                        openScreen(
                          context,
                          const SettingScreen(),
                        );
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 28),

              // ==================================================
              // NEARBY SHARE
              // ==================================================

              Row(
                children: [
                  Expanded(
                    child: _serviceCard(
                      context,
                      icon: Icons.hub_rounded,
                      title: 'Nearby Share',
                      subtitle: 'Share SOS nearby',
                      onTap: () {
                        openScreen(
                          context,
                          const NearbyShareScreen(),
                        );
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 28),

              // ==================================================
              // RESCUE NETWORK
              // ==================================================

              const Text(
                'Rescue Network',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 15),

              GestureDetector(
                onTap: () {
                  _showNetworkDialog(context);
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: const Color(0xFF151B23),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: const Color(0xFF252D38),
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 52,
                            height: 52,
                            decoration: BoxDecoration(
                              color: const Color(0xFFFF6B00)
                                  .withOpacity(0.12),
                              borderRadius:
                                  BorderRadius.circular(15),
                            ),
                            child: const Icon(
                              Icons.hub_rounded,
                              color: Color(0xFFFF6B00),
                              size: 28,
                            ),
                          ),
                          const SizedBox(width: 14),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Offline Rescue Network',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'Nearby devices available',
                                  style: TextStyle(
                                    color: Colors.white38,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 16,
                            color: Colors.white38,
                          ),
                        ],
                      ),

                      const SizedBox(height: 18),

                      Row(
                        children: [
                          _networkNode(),
                          _networkLine(),
                          _networkNode(),
                          _networkLine(),
                          _networkNode(),
                          _networkLine(),
                          _networkNode(),
                        ],
                      ),

                      const SizedBox(height: 15),

                      const Row(
                        children: [
                          Icon(
                            Icons.circle,
                            color: Colors.green,
                            size: 10,
                          ),
                          SizedBox(width: 7),
                          Text(
                            '4 nearby nodes connected',
                            style: TextStyle(
                              color: Colors.green,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 25),

              // ==================================================
              // EMERGENCY TIP
              // ==================================================

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: const Color(0xFF151B23),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Row(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.lightbulb_outline_rounded,
                      color: Color(0xFFFF6B00),
                      size: 27,
                    ),

                    SizedBox(width: 13),

                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Emergency Tip',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          SizedBox(height: 5),

                          Text(
                            "If the internet is unavailable, use RescueLink's offline network to transmit your emergency request.",
                            style: TextStyle(
                              color: Colors.white54,
                              fontSize: 11,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ==========================================================
  // SERVICE CARD
  // ==========================================================

  Widget _serviceCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF151B23),
          borderRadius: BorderRadius.circular(17),
          border: Border.all(
            color: const Color(0xFF252D38),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color:
                    const Color(0xFFFF6B00).withOpacity(0.12),
                borderRadius: BorderRadius.circular(13),
              ),
              child: Icon(
                icon,
                color: const Color(0xFFFF6B00),
                size: 25,
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: Colors.white38,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),

            const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 14,
              color: Colors.white38,
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================================
  // NETWORK NODE
  // ==========================================================

  Widget _networkNode() {
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.green.withOpacity(0.12),
        border: Border.all(
          color: Colors.green.withOpacity(0.5),
          width: 1.5,
        ),
      ),
      child: const Center(
        child: Icon(
          Icons.wifi_rounded,
          size: 14,
          color: Colors.green,
        ),
      ),
    );
  }

  // ==========================================================
  // NETWORK LINE
  // ==========================================================

  Widget _networkLine() {
    return Expanded(
      child: Container(
        height: 2,
        margin: const EdgeInsets.symmetric(
          horizontal: 5,
        ),
        color: Colors.green.withOpacity(0.35),
      ),
    );
  }

  // ==========================================================
  // NETWORK DIALOG
  // ==========================================================

  void _showNetworkDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: const Color(0xFF151B23),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          title: const Row(
            children: [
              Icon(
                Icons.hub_rounded,
                color: Color(0xFFFF6B00),
              ),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Rescue Network',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          content: const Text(
            'RescueLink is ready to communicate with nearby devices through the offline rescue network.',
            style: TextStyle(
              color: Colors.white70,
              height: 1.5,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text(
                'OK',
                style: TextStyle(
                  color: Color(0xFFFF6B00),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}