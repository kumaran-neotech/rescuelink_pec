
import 'package:flutter/material.dart';
import 'home_screen.dart';

class LoginSignupScreen extends StatefulWidget {
  const LoginSignupScreen({super.key});

  @override
  State<LoginSignupScreen> createState() => _LoginSignupScreenState();
}

class _LoginSignupScreenState extends State<LoginSignupScreen> {
  bool isLogin = true;
  bool obscurePassword = true;

  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  // EMAIL VALIDATION
  String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Email is required";
    }

    final emailRegex = RegExp(
      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
    );

    if (!emailRegex.hasMatch(value.trim())) {
      return "Enter a valid email address";
    }

    return null;
  }

  // PHONE VALIDATION
  String? validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Phone number is required";
    }

    if (!RegExp(r'^[0-9]{10}$').hasMatch(value.trim())) {
      return "Phone number must contain exactly 10 digits";
    }

    return null;
  }

  // PASSWORD VALIDATION
  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return "Password is required";
    }

    if (value.length < 8) {
      return "Password must contain at least 8 characters";
    }

    return null;
  }

  // NAME VALIDATION
  String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Name is required";
    }

    if (value.trim().length < 3) {
      return "Enter a valid name";
    }

    return null;
  }

  void submit() {
    if (_formKey.currentState!.validate()) {
     void submit() {
  if (_formKey.currentState!.validate()) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const HomeScreen(),
      ),
    );
  }
  }else {
        debugPrint("Account creation successful");
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isLogin
                ? "Login successful"
                : "Account created successfully",
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 20,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                const SizedBox(height: 25),

                // LOGO
                Center(
                  child: Container(
                    width: 82,
                    height: 82,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF6B00),
                      borderRadius: BorderRadius.circular(26),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFFF6B00)
                              .withOpacity(0.30),
                          blurRadius: 25,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.shield_rounded,
                      size: 48,
                      color: Colors.white,
                    ),
                  ),
                ),

                const SizedBox(height: 22),

                // TITLE
                const Center(
                  child: Text(
                    "RescueLink",
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),

                const SizedBox(height: 6),

                const Center(
                  child: Text(
                    "Offline Disaster Communication",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white60,
                      fontSize: 14,
                    ),
                  ),
                ),

                const SizedBox(height: 38),

                // LOGIN / SIGN UP SWITCH
                Container(
                  height: 55,
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: const Color(0xFF151B23),
                    borderRadius: BorderRadius.circular(17),
                  ),
                  child: Row(
                    children: [

                      // LOGIN
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              isLogin = true;
                              _formKey.currentState?.reset();
                            });
                          },
                          child: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: isLogin
                                  ? const Color(0xFFFF6B00)
                                  : Colors.transparent,
                              borderRadius:
                                  BorderRadius.circular(13),
                            ),
                            child: Text(
                              "Login",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: isLogin
                                    ? Colors.white
                                    : Colors.white60,
                              ),
                            ),
                          ),
                        ),
                      ),

                      // SIGN UP
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              isLogin = false;
                              _formKey.currentState?.reset();
                            });
                          },
                          child: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: !isLogin
                                  ? const Color(0xFFFF6B00)
                                  : Colors.transparent,
                              borderRadius:
                                  BorderRadius.circular(13),
                            ),
                            child: Text(
                              "Sign Up",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: !isLogin
                                    ? Colors.white
                                    : Colors.white60,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                // HEADING
                Text(
                  isLogin
                      ? "Welcome Back"
                      : "Create Your Account",
                  style: const TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 7),

                Text(
                  isLogin
                      ? "Login to access your emergency network"
                      : "Join RescueLink and stay connected during emergencies",
                  style: const TextStyle(
                    color: Colors.white54,
                    fontSize: 14,
                  ),
                ),

                const SizedBox(height: 28),

                // NAME - SIGN UP ONLY
                if (!isLogin) ...[
                  const Text(
                    "Full Name",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 9),

                  TextFormField(
                    controller: nameController,
                    textInputAction: TextInputAction.next,
                    validator: validateName,
                    decoration: const InputDecoration(
                      hintText: "Enter your name",
                      prefixIcon:
                          Icon(Icons.person_outline),
                    ),
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    "Phone Number",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 9),

                  TextFormField(
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                    textInputAction: TextInputAction.next,
                    maxLength: 10,
                    validator: validatePhone,
                    decoration: const InputDecoration(
                      hintText: "Enter 10 digit phone number",
                      prefixIcon:
                          Icon(Icons.phone_outlined),
                      counterText: "",
                    ),
                  ),

                  const SizedBox(height: 20),
                ],

                // EMAIL
                const Text(
                  "Email",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 9),

                TextFormField(
                  controller: emailController,
                  keyboardType:
                      TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  validator: validateEmail,
                  decoration: const InputDecoration(
                    hintText: "Enter your email",
                    prefixIcon:
                        Icon(Icons.email_outlined),
                  ),
                ),

                const SizedBox(height: 20),

                // PASSWORD
                const Text(
                  "Password",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 9),

                TextFormField(
                  controller: passwordController,

                  // PASSWORD INVISIBLE
                  obscureText: obscurePassword,

                  validator: validatePassword,

                  textInputAction:
                      TextInputAction.done,

                  decoration: InputDecoration(
                    hintText:
                        "Minimum 8 characters",

                    prefixIcon:
                        const Icon(Icons.lock_outline),

                    // SHOW / HIDE PASSWORD
                    suffixIcon: IconButton(
                      icon: Icon(
                        obscurePassword
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                      ),
                      onPressed: () {
                        setState(() {
                          obscurePassword =
                              !obscurePassword;
                        });
                      },
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                // MAIN BUTTON
                SizedBox(
                  width: double.infinity,
                  height: 58,
                  child: ElevatedButton(
                    onPressed: submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          const Color(0xFFFF6B00),
                      foregroundColor: Colors.white,
                      elevation: 5,
                      shadowColor: const Color(0xFFFF6B00)
                          .withOpacity(0.3),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(17),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment:
                          MainAxisAlignment.center,
                      children: [

                        Icon(
                          isLogin
                              ? Icons.login_rounded
                              : Icons
                                  .person_add_alt_1_rounded,
                        ),

                        const SizedBox(width: 10),

                        Text(
                          isLogin
                              ? "Login"
                              : "Create Account",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 25),

                // OFFLINE INDICATOR
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF111820),
                    borderRadius:
                        BorderRadius.circular(17),
                    border: Border.all(
                      color: const Color(0xFF252D38),
                    ),
                  ),
                  child: const Row(
                    children: [

                      Icon(
                        Icons.wifi_off_rounded,
                        color: Color(0xFFFF6B00),
                        size: 25,
                      ),

                      SizedBox(width: 13),

                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [

                            Text(
                              "Offline Ready",
                              style: TextStyle(
                                fontWeight:
                                    FontWeight.bold,
                              ),
                            ),

                            SizedBox(height: 3),

                            Text(
                              "Emergency communication works without internet",
                              style: TextStyle(
                                color: Colors.white54,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 25),

                // FOOTER
                const Center(
                  child: Text(
                    "Your safety. Our connection.",
                    style: TextStyle(
                      color: Colors.white38,
                      fontSize: 12,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

