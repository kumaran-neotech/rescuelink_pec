
import 'package:flutter/material.dart';
import 'app_data.dart';
import 'login_signup_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() =>
      _ProfileScreenState();
}

class _ProfileScreenState
    extends State<ProfileScreen> {

  @override
  void initState() {
    super.initState();

    AppData.instance.addListener(_refresh);
  }

  @override
  void dispose() {
    AppData.instance.removeListener(_refresh);
    super.dispose();
  }

  void _refresh() {
    if (mounted) {
      setState(() {});
    }
  }

  // ==========================================================
  // EDIT PROFILE
  // ==========================================================

  void editProfile() {
    final nameController =
        TextEditingController(
      text: AppData.instance.userName,
    );

    final emailController =
        TextEditingController(
      text: AppData.instance.userEmail,
    );

    final phoneController =
        TextEditingController(
      text: AppData.instance.userPhone,
    );

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor:
              const Color(0xFF151B23),

          title: const Text(
            "Edit Profile",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),

          content:
              SingleChildScrollView(
            child: Column(
              mainAxisSize:
                  MainAxisSize.min,
              children: [

                // NAME
                TextField(
                  controller:
                      nameController,
                  style:
                      const TextStyle(
                    color: Colors.white,
                  ),
                  decoration:
                      _dialogDecoration(
                    "Name",
                    Icons.person_outline,
                  ),
                ),

                const SizedBox(height: 15),

                // EMAIL
                TextField(
                  controller:
                      emailController,
                  keyboardType:
                      TextInputType.emailAddress,
                  style:
                      const TextStyle(
                    color: Colors.white,
                  ),
                  decoration:
                      _dialogDecoration(
                    "Email",
                    Icons.email_outlined,
                  ),
                ),

                const SizedBox(height: 15),

                // PHONE
                TextField(
                  controller:
                      phoneController,
                  keyboardType:
                      TextInputType.phone,
                  maxLength: 10,
                  style:
                      const TextStyle(
                    color: Colors.white,
                  ),
                  decoration:
                      _dialogDecoration(
                    "Phone Number",
                    Icons.phone_outlined,
                  ).copyWith(
                    counterText: "",
                  ),
                ),
              ],
            ),
          ),

          actions: [

            TextButton(
              onPressed: () {
                Navigator.pop(
                    dialogContext);
              },
              child: const Text(
                "CANCEL",
                style: TextStyle(
                  color: Colors.white54,
                ),
              ),
            ),

            ElevatedButton(
              style:
                  ElevatedButton.styleFrom(
                backgroundColor:
                    const Color(
                        0xFFFF6B00),
              ),
              onPressed: () {
                final name =
                    nameController.text
                        .trim();

                final email =
                    emailController.text
                        .trim()
                        .toLowerCase();

                final phone =
                    phoneController.text
                        .trim();

                if (name.isEmpty ||
                    email.isEmpty ||
                    phone.isEmpty) {
                  ScaffoldMessenger
                          .of(context)
                      .showSnackBar(
                    const SnackBar(
                      backgroundColor:
                          Colors.redAccent,
                      content: Text(
                        "All fields are required.",
                      ),
                    ),
                  );

                  return;
                }

                if (!RegExp(
                  r'^[\w.%+-]+@[\w.-]+\.[A-Za-z]{2,}$',
                ).hasMatch(email)) {
                  ScaffoldMessenger
                          .of(context)
                      .showSnackBar(
                    const SnackBar(
                      backgroundColor:
                          Colors.redAccent,
                      content: Text(
                        "Enter a valid email address.",
                      ),
                    ),
                  );

                  return;
                }

                if (!RegExp(
                  r'^[0-9]{10}$',
                ).hasMatch(phone)) {
                  ScaffoldMessenger
                          .of(context)
                      .showSnackBar(
                    const SnackBar(
                      backgroundColor:
                          Colors.redAccent,
                      content: Text(
                        "Phone number must contain exactly 10 digits.",
                      ),
                    ),
                  );

                  return;
                }

                // UPDATE GLOBAL APP DATA
                AppData.instance.updateUser(
                  name: name,
                  email: email,
                  phone: phone,
                );

                Navigator.pop(
                    dialogContext);

                ScaffoldMessenger
                        .of(context)
                    .showSnackBar(
                  const SnackBar(
                    backgroundColor:
                        Colors.green,
                    content: Row(
                      children: [
                        Icon(
                          Icons
                              .check_circle,
                          color:
                              Colors.white,
                        ),
                        SizedBox(
                            width: 10),
                        Text(
                          "Profile updated successfully",
                          style:
                              TextStyle(
                            fontWeight:
                                FontWeight
                                    .bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
              child: const Text(
                "SAVE",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight:
                      FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // ==========================================================
  // LOGOUT
  // ==========================================================

  void logout() {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor:
              const Color(0xFF151B23),

          title: const Text(
            "Logout",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),

          content: const Text(
            "Are you sure you want to logout?",
            style: TextStyle(
              color: Colors.white70,
            ),
          ),

          actions: [

            TextButton(
              onPressed: () {
                Navigator.pop(
                    dialogContext);
              },
              child: const Text(
                "CANCEL",
                style: TextStyle(
                  color: Colors.white54,
                ),
              ),
            ),

            ElevatedButton(
              style:
                  ElevatedButton.styleFrom(
                backgroundColor:
                    const Color(
                        0xFFFF6B00),
              ),
              onPressed: () {
                // Close dialog.
                Navigator.pop(
                    dialogContext);

                // Clear current login.
                AppData.instance.logout();

                // Return to login.
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        const LoginSignupScreen(),
                  ),
                  (route) => false,
                );
              },
              child: const Text(
                "LOGOUT",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight:
                      FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // ==========================================================
  // BUILD
  // ==========================================================

  @override
  Widget build(BuildContext context) {
    final appData =
        AppData.instance;

    return Scaffold(
      backgroundColor:
          const Color(0xFF0B0F14),

      appBar: AppBar(
        backgroundColor:
            const Color(0xFF0B0F14),
        elevation: 0,

        title: const Text(
          "Profile",
          style: TextStyle(
            fontWeight:
                FontWeight.bold,
          ),
        ),

        actions: [
          IconButton(
            tooltip: "Logout",
            onPressed: logout,
            icon: const Icon(
              Icons.logout_rounded,
              color:
                  Color(0xFFFF6B00),
            ),
          ),
        ],
      ),

      body:
          SingleChildScrollView(
        padding:
            const EdgeInsets.all(20),

        child: Column(
          children: [

            const SizedBox(height: 15),

            // ==================================================
            // PROFILE IMAGE
            // ==================================================

            Container(
              width: 115,
              height: 115,
              decoration:
                  BoxDecoration(
                shape:
                    BoxShape.circle,
                color:
                    const Color(
                        0xFFFF6B00),
                boxShadow: [
                  BoxShadow(
                    color:
                        const Color(
                                0xFFFF6B00)
                            .withOpacity(
                                0.25),
                    blurRadius: 25,
                  ),
                ],
              ),
              child:
                  const Icon(
                Icons.person_rounded,
                size: 70,
                color:
                    Colors.white,
              ),
            ),

            const SizedBox(height: 18),

            // ==================================================
            // USER NAME
            // ==================================================

            Text(
              appData.userName.isEmpty
                  ? "User"
                  : appData.userName,
              style:
                  const TextStyle(
                fontSize: 25,
                fontWeight:
                    FontWeight.bold,
              ),
            ),

            const SizedBox(height: 5),

            // ==================================================
            // EMAIL
            // ==================================================

            Text(
              appData.userEmail.isEmpty
                  ? "No email"
                  : appData.userEmail,
              style:
                  const TextStyle(
                color:
                    Colors.white54,
                fontSize: 14,
              ),
            ),

            const SizedBox(height: 25),

            // ==================================================
            // EDIT PROFILE
            // ==================================================

            SizedBox(
              width:
                  double.infinity,
              height: 52,
              child:
                  ElevatedButton.icon(
                style:
                    ElevatedButton.styleFrom(
                  backgroundColor:
                      const Color(
                          0xFFFF6B00),
                  shape:
                      RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(
                            14),
                  ),
                ),
                onPressed:
                    editProfile,
                icon:
                    const Icon(
                  Icons.edit_rounded,
                  color:
                      Colors.white,
                ),
                label:
                    const Text(
                  "Edit Profile",
                  style:
                      TextStyle(
                    color:
                        Colors.white,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 25),

            // ==================================================
            // INFORMATION
            // ==================================================

            _infoCard(
              Icons.person_outline_rounded,
              "Full Name",
              appData.userName,
            ),

            _infoCard(
              Icons.email_outlined,
              "Email Address",
              appData.userEmail,
            ),

            _infoCard(
              Icons.phone_outlined,
              "Phone Number",
              appData.userPhone,
            ),

            const SizedBox(height: 15),

            // ==================================================
            // ACCOUNT TYPE
            // ==================================================

            Container(
              width:
                  double.infinity,
              padding:
                  const EdgeInsets.all(18),
              decoration:
                  BoxDecoration(
                color:
                    const Color(
                        0xFF151B23),
                borderRadius:
                    BorderRadius.circular(
                        18),
                border:
                    Border.all(
                  color:
                      const Color(
                          0xFF252D38),
                ),
              ),
              child:
                  const Row(
                children: [

                  Icon(
                    Icons
                        .verified_user_rounded,
                    color:
                        Color(
                            0xFFFF6B00),
                    size: 30,
                  ),

                  SizedBox(width: 14),

                  Expanded(
                    child:
                        Column(
                      crossAxisAlignment:
                          CrossAxisAlignment
                              .start,
                      children: [

                        Text(
                          "Account Type",
                          style:
                              TextStyle(
                            color:
                                Colors.white54,
                            fontSize: 12,
                          ),
                        ),

                        SizedBox(
                            height: 4),

                        Text(
                          "Normal User",
                          style:
                              TextStyle(
                            fontWeight:
                                FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ==================================================
            // LOGOUT BUTTON
            // ==================================================

            SizedBox(
              width:
                  double.infinity,
              height: 52,
              child:
                  OutlinedButton.icon(
                onPressed: logout,
                icon:
                    const Icon(
                  Icons.logout_rounded,
                  color:
                      Colors.redAccent,
                ),
                label:
                    const Text(
                  "Logout",
                  style:
                      TextStyle(
                    color:
                        Colors.redAccent,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),
                style:
                    OutlinedButton.styleFrom(
                  side:
                      const BorderSide(
                    color:
                        Colors.redAccent,
                  ),
                  shape:
                      RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(
                            14),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 25),
          ],
        ),
      ),
    );
  }

  // ==========================================================
  // INFO CARD
  // ==========================================================

  Widget _infoCard(
    IconData icon,
    String title,
    String value,
  ) {
    return Container(
      width:
          double.infinity,
      margin:
          const EdgeInsets.only(
              bottom: 12),
      padding:
          const EdgeInsets.all(17),
      decoration:
          BoxDecoration(
        color:
            const Color(0xFF151B23),
        borderRadius:
            BorderRadius.circular(17),
        border:
            Border.all(
          color:
              const Color(0xFF252D38),
        ),
      ),
      child:
          Row(
        children: [

          Container(
            width: 45,
            height: 45,
            decoration:
                BoxDecoration(
              color:
                  const Color(
                          0xFFFF6B00)
                      .withOpacity(
                          0.12),
              borderRadius:
                  BorderRadius.circular(
                      13),
            ),
            child:
                Icon(
              icon,
              color:
                  const Color(
                      0xFFFF6B00),
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child:
                Column(
              crossAxisAlignment:
                  CrossAxisAlignment
                      .start,
              children: [

                Text(
                  title,
                  style:
                      const TextStyle(
                    color:
                        Colors.white38,
                    fontSize: 11,
                  ),
                ),

                const SizedBox(
                    height: 4),

                Text(
                  value.isEmpty
                      ? "Not available"
                      : value,
                  style:
                      const TextStyle(
                    fontSize: 14,
                    fontWeight:
                        FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // DIALOG INPUT DECORATION
  // ==========================================================

  InputDecoration _dialogDecoration(
    String label,
    IconData icon,
  ) {
    return InputDecoration(
      labelText: label,
      labelStyle:
          const TextStyle(
        color: Colors.white60,
      ),
      prefixIcon:
          Icon(
        icon,
        color:
            const Color(0xFFFF6B00),
      ),
      enabledBorder:
          OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(12),
        borderSide:
            const BorderSide(
          color: Colors.white24,
        ),
      ),
      focusedBorder:
          OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(12),
        borderSide:
            const BorderSide(
          color:
              Color(0xFFFF6B00),
        ),
      ),
    );
  }
}