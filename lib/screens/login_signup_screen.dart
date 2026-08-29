import 'package:flutter/material.dart';
import 'app_data.dart';
import 'home_screen.dart';

class LoginSignupScreen extends StatefulWidget {
  const LoginSignupScreen({super.key});

  @override
  State<LoginSignupScreen> createState() =>
      _LoginSignupScreenState();
}

class _LoginSignupScreenState
    extends State<LoginSignupScreen> {
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

  // ==========================================================
  // EMAIL VALIDATION
  // ==========================================================

  String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Email is required";
    }

    final email = value.trim();

    final emailRegex = RegExp(
      r'^[\w.%+-]+@[\w.-]+\.[A-Za-z]{2,}$',
    );

    if (!emailRegex.hasMatch(email)) {
      return "Enter a valid email address";
    }

    return null;
  }

  // ==========================================================
  // PHONE VALIDATION
  // ==========================================================

  String? validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Phone number is required";
    }

    if (!RegExp(r'^[0-9]{10}$')
        .hasMatch(value.trim())) {
      return "Phone number must contain exactly 10 digits";
    }

    return null;
  }

  // ==========================================================
  // PASSWORD VALIDATION
  // ==========================================================

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return "Password is required";
    }

    if (value.length < 8) {
      return "Password must contain at least 8 characters";
    }

    return null;
  }

  // ==========================================================
  // NAME VALIDATION
  // ==========================================================

  String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Name is required";
    }

    if (value.trim().length < 3) {
      return "Enter a valid name";
    }

    return null;
  }

  // ==========================================================
  // SUBMIT
  // ==========================================================

  void submit() {
    FocusScope.of(context).unfocus();

    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    if (isLogin) {
      login();
    } else {
      signup();
    }
  }

  // ==========================================================
  // SIGNUP
  // ==========================================================

  void signup() {
    final name = nameController.text.trim();
    final email =
        emailController.text.trim().toLowerCase();
    final phone = phoneController.text.trim();
    final password = passwordController.text;

    final success = AppData.instance.registerUser(
      name: name,
      email: email,
      phone: phone,
      password: password,
    );

    if (!success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.redAccent,
          duration: Duration(seconds: 3),
          content: Row(
            children: [
              Icon(
                Icons.error_outline,
                color: Colors.white,
              ),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  "This email is already registered.",
                ),
              ),
            ],
          ),
        ),
      );

      return;
    }

    // Keep email for login.
    emailController.text = email;

    // Clear signup-only fields.
    nameController.clear();
    phoneController.clear();
    passwordController.clear();

    // Move to login mode.
    setState(() {
      isLogin = true;
      obscurePassword = true;
    });

    _formKey.currentState?.reset();

    // Signup success message.
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: Colors.green,
        duration: Duration(seconds: 3),
        content: Row(
          children: [
            Icon(
              Icons.check_circle,
              color: Colors.white,
              size: 24,
            ),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                "Signup successful",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================================
  // LOGIN
  // ==========================================================

  void login() {
    final email =
        emailController.text.trim().toLowerCase();

    final password = passwordController.text;

    final success = AppData.instance.loginUser(
      email: email,
      password: password,
    );

    if (!success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.redAccent,
          duration: Duration(seconds: 3),
          content: Row(
            children: [
              Icon(
                Icons.error_outline,
                color: Colors.white,
              ),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  "Incorrect email or password.",
                ),
              ),
            ],
          ),
        ),
      );

      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
        content: Row(
          children: [
            Icon(
              Icons.check_circle,
              color: Colors.white,
            ),
            SizedBox(width: 10),
            Text(
              "Login successful",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );

    // Open Home screen.
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => const HomeScreen(),
      ),
      (route) => false,
    );
  }

  // ==========================================================
  // SWITCH LOGIN / SIGNUP
  // ==========================================================

  void switchMode(bool loginMode) {
    setState(() {
      isLogin = loginMode;
      passwordController.clear();
      obscurePassword = true;

      if (!loginMode) {
        emailController.clear();
      }
    });

    _formKey.currentState?.reset();
  }

  // ==========================================================
  // BUILD
  // ==========================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0F14),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 20,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 25),

                // ==================================================
                // LOGO
                // ==================================================

                Center(
                  child: Container(
                    width: 82,
                    height: 82,
                    decoration: BoxDecoration(
                      color:
                          const Color(0xFFFF6B00),
                      borderRadius:
                          BorderRadius.circular(26),
                      boxShadow: [
                        BoxShadow(
                          color:
                              const Color(0xFFFF6B00)
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

                const Center(
                  child: Text(
                    "RescueLink",
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
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

                // ==================================================
                // LOGIN / SIGNUP SWITCH
                // ==================================================

                Container(
                  height: 55,
                  padding:
                      const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color:
                        const Color(0xFF151B23),
                    borderRadius:
                        BorderRadius.circular(17),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () =>
                              switchMode(true),
                          child: Container(
                            alignment:
                                Alignment.center,
                            decoration:
                                BoxDecoration(
                              color: isLogin
                                  ? const Color(
                                      0xFFFF6B00)
                                  : Colors.transparent,
                              borderRadius:
                                  BorderRadius
                                      .circular(13),
                            ),
                            child: Text(
                              "Login",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight:
                                    FontWeight.bold,
                                color: isLogin
                                    ? Colors.white
                                    : Colors.white60,
                              ),
                            ),
                          ),
                        ),
                      ),

                      Expanded(
                        child: GestureDetector(
                          onTap: () =>
                              switchMode(false),
                          child: Container(
                            alignment:
                                Alignment.center,
                            decoration:
                                BoxDecoration(
                              color: !isLogin
                                  ? const Color(
                                      0xFFFF6B00)
                                  : Colors.transparent,
                              borderRadius:
                                  BorderRadius
                                      .circular(13),
                            ),
                            child: Text(
                              "Sign Up",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight:
                                    FontWeight.bold,
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

                // ==================================================
                // SIGNUP NAME
                // ==================================================

                if (!isLogin) ...[
                  const Text(
                    "Full Name",
                    style: TextStyle(
                      fontWeight:
                          FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 9),

                  TextFormField(
                    controller:
                        nameController,
                    textInputAction:
                        TextInputAction.next,
                    validator:
                        validateName,
                    style:
                        const TextStyle(
                      color: Colors.white,
                    ),
                    decoration:
                        _inputDecoration(
                      "Enter your name",
                      Icons.person_outline,
                    ),
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    "Phone Number",
                    style: TextStyle(
                      fontWeight:
                          FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 9),

                  TextFormField(
                    controller:
                        phoneController,
                    keyboardType:
                        TextInputType.phone,
                    textInputAction:
                        TextInputAction.next,
                    maxLength: 10,
                    validator:
                        validatePhone,
                    style:
                        const TextStyle(
                      color: Colors.white,
                    ),
                    decoration:
                        _inputDecoration(
                      "Enter 10 digit phone number",
                      Icons.phone_outlined,
                    ).copyWith(
                      counterText: "",
                    ),
                  ),

                  const SizedBox(height: 20),
                ],

                // ==================================================
                // EMAIL
                // ==================================================

                const Text(
                  "Email",
                  style: TextStyle(
                    fontWeight:
                        FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 9),

                TextFormField(
                  controller:
                      emailController,
                  keyboardType:
                      TextInputType.emailAddress,
                  textInputAction:
                      TextInputAction.next,
                  validator:
                      validateEmail,
                  style:
                      const TextStyle(
                    color: Colors.white,
                  ),
                  decoration:
                      _inputDecoration(
                    "Enter your email",
                    Icons.email_outlined,
                  ),
                ),

                const SizedBox(height: 20),

                // ==================================================
                // PASSWORD
                // ==================================================

                const Text(
                  "Password",
                  style: TextStyle(
                    fontWeight:
                        FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 9),

                TextFormField(
                  controller:
                      passwordController,
                  obscureText:
                      obscurePassword,
                  validator:
                      validatePassword,
                  textInputAction:
                      TextInputAction.done,

                  // ENTER KEY SUBMITS
                  onFieldSubmitted:
                      (_) => submit(),

                  style:
                      const TextStyle(
                    color: Colors.white,
                  ),

                  decoration:
                      _inputDecoration(
                    "Minimum 8 characters",
                    Icons.lock_outline,
                  ).copyWith(
                    suffixIcon:
                        IconButton(
                      icon: Icon(
                        obscurePassword
                            ? Icons
                                .visibility_off_outlined
                            : Icons
                                .visibility_outlined,
                        color:
                            Colors.white54,
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

                // ==================================================
                // SUBMIT BUTTON
                // ==================================================

                SizedBox(
                  width:
                      double.infinity,
                  height: 58,
                  child:
                      ElevatedButton(
                    onPressed: submit,
                    style:
                        ElevatedButton
                            .styleFrom(
                      backgroundColor:
                          const Color(
                              0xFFFF6B00),
                      foregroundColor:
                          Colors.white,
                      elevation: 5,
                      shape:
                          RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius
                                .circular(17),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment:
                          MainAxisAlignment
                              .center,
                      children: [
                        Icon(
                          isLogin
                              ? Icons
                                  .login_rounded
                              : Icons
                                  .person_add_alt_1_rounded,
                        ),
                        const SizedBox(
                            width: 10),
                        Text(
                          isLogin
                              ? "Login"
                              : "Create Account",
                          style:
                              const TextStyle(
                            fontSize: 16,
                            fontWeight:
                                FontWeight
                                    .bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 25),

                // ==================================================
                // OFFLINE
                // ==================================================

                Container(
                  width:
                      double.infinity,
                  padding:
                      const EdgeInsets.all(
                          16),
                  decoration:
                      BoxDecoration(
                    color:
                        const Color(0xFF111820),
                    borderRadius:
                        BorderRadius.circular(
                            17),
                    border: Border.all(
                      color:
                          const Color(
                              0xFF252D38),
                    ),
                  ),
                  child: const Row(
                    children: [
                      Icon(
                        Icons
                            .wifi_off_rounded,
                        color: Color(
                            0xFFFF6B00),
                        size: 25,
                      ),
                      SizedBox(width: 13),
                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment
                                  .start,
                          children: [
                            Text(
                              "Offline Ready",
                              style:
                                  TextStyle(
                                fontWeight:
                                    FontWeight
                                        .bold,
                              ),
                            ),
                            SizedBox(
                                height: 3),
                            Text(
                              "Emergency communication works without internet",
                              style:
                                  TextStyle(
                                color: Colors
                                    .white54,
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

                const Center(
                  child: Text(
                    "Your safety. Our connection.",
                    style: TextStyle(
                      color:
                          Colors.white38,
                      fontSize: 12,
                      fontStyle:
                          FontStyle.italic,
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

  // ==========================================================
  // INPUT DECORATION
  // ==========================================================

  InputDecoration _inputDecoration(
    String hint,
    IconData icon,
  ) {
    return InputDecoration(
      hintText: hint,
      hintStyle:
          const TextStyle(
        color: Colors.white30,
      ),
      prefixIcon: Icon(
        icon,
        color:
            const Color(0xFFFF6B00),
      ),
      filled: true,
      fillColor:
          const Color(0xFF151B23),

      border:
          OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(14),
        borderSide:
            BorderSide.none,
      ),

      enabledBorder:
          OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(14),
        borderSide:
            const BorderSide(
          color: Colors.white12,
        ),
      ),

      focusedBorder:
          OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(14),
        borderSide:
            const BorderSide(
          color:
              Color(0xFFFF6B00),
        ),
      ),

      errorBorder:
          OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(14),
        borderSide:
            const BorderSide(
          color: Colors.redAccent,
        ),
      ),

      focusedErrorBorder:
          OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(14),
        borderSide:
            const BorderSide(
          color: Colors.redAccent,
        ),
      ),
    );
  }
}