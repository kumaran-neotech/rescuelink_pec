import 'package:flutter/material.dart';

class VolunteerScreen extends StatefulWidget {
  const VolunteerScreen({super.key});

  @override
  State<VolunteerScreen> createState() =>
      _VolunteerScreenState();
}

class _VolunteerScreenState
    extends State<VolunteerScreen> {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final volunteerIdController = TextEditingController();

  bool obscurePassword = true;

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    volunteerIdController.dispose();
    super.dispose();
  }

  String? validateVolunteerEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Volunteer email is required";
    }

    final email = value.trim().toLowerCase();

    if (!email.endsWith("@rescuelink.com")) {
      return "Use a @rescuelink.com email";
    }

    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@rescuelink\.com$',
    );

    if (!emailRegex.hasMatch(email)) {
      return "Enter a valid RescueLink email";
    }

    return null;
  }

  String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return "Phone number is required";
    }

    if (!RegExp(r'^[0-9]{10}$')
        .hasMatch(value.trim())) {
      return "Enter exactly 10 digits";
    }

    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return "Password is required";
    }

    if (value.length < 8) {
      return "Minimum 8 characters required";
    }

    return null;
  }

  void registerVolunteer() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Volunteer registration successful!",
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Volunteer",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(22),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 10),

              // VOLUNTEER ICON
              Container(
                width: 95,
                height: 95,
                decoration: BoxDecoration(
                  color: const Color(0xFFFF6B00),
                  borderRadius:
                      BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFFF6B00)
                          .withOpacity(0.3),
                      blurRadius: 25,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.volunteer_activism_rounded,
                  size: 55,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 18),

              const Text(
                "Become a RescueLink Volunteer",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 7),

              const Text(
                "Help coordinate emergency response in your area.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white54,
                ),
              ),

              const SizedBox(height: 30),

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
                ),
                child: const Icon(
                  Icons.mic_rounded,
                  size: 65,
                  color: Color(0xFFFF6B00),
                ),
              ),

              const SizedBox(height: 15),

              const Text(
                "Voice-assisted volunteer registration",
                style: TextStyle(
                  color: Colors.white54,
                  fontSize: 12,
                ),
              ),

              const SizedBox(height: 30),

              _label("Full Name"),

              TextFormField(
                controller: nameController,
                validator: (value) {
                  if (value == null ||
                      value.trim().length < 3) {
                    return "Enter your full name";
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  hintText: "Enter full name",
                  prefixIcon:
                      Icon(Icons.person_outline),
                ),
              ),

              const SizedBox(height: 18),

              _label("Volunteer ID"),

              TextFormField(
                controller: volunteerIdController,
                validator: (value) {
                  if (value == null ||
                      value.trim().isEmpty) {
                    return "Volunteer ID is required";
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  hintText: "Example: RL-VOL-001",
                  prefixIcon:
                      Icon(Icons.badge_outlined),
                ),
              ),

              const SizedBox(height: 18),

              _label("RescueLink Email"),

              TextFormField(
                controller: emailController,
                keyboardType:
                    TextInputType.emailAddress,
                validator: validateVolunteerEmail,
                decoration: const InputDecoration(
                  hintText: "name@rescuelink.com",
                  prefixIcon:
                      Icon(Icons.email_outlined),
                ),
              ),

              const SizedBox(height: 18),

              _label("Phone Number"),

              TextFormField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                maxLength: 10,
                validator: validatePhone,
                decoration: const InputDecoration(
                  hintText: "10 digit phone number",
                  prefixIcon:
                      Icon(Icons.phone_outlined),
                  counterText: "",
                ),
              ),

              const SizedBox(height: 18),

              _label("Password"),

              TextFormField(
                controller: passwordController,
                obscureText: obscurePassword,
                validator: validatePassword,
                decoration: InputDecoration(
                  hintText: "Minimum 8 characters",
                  prefixIcon:
                      const Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        obscurePassword =
                            !obscurePassword;
                      });
                    },
                    icon: Icon(
                      obscurePassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                height: 58,
                child: ElevatedButton.icon(
                  onPressed: registerVolunteer,
                  icon: const Icon(
                    Icons.volunteer_activism,
                  ),
                  label: const Text(
                    "REGISTER AS VOLUNTEER",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        const Color(0xFFFF6B00),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(17),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: const Color(0xFF151B23),
                  borderRadius:
                      BorderRadius.circular(16),
                ),
                child: const Row(
                  children: [
                    Icon(
                      Icons.verified_user_outlined,
                      color: Color(0xFFFF6B00),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        "Only authorized @rescuelink.com accounts can participate as volunteers.",
                        style: TextStyle(
                          color: Colors.white54,
                          fontSize: 12,
                        ),
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

  Widget _label(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Text(
          text,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}