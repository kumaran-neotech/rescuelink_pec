import 'package:flutter/material.dart';
import '../app_data.dart';

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

  bool passwordVisible = false;
  bool loggedIn = false;

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  // ==========================================================
  // VOLUNTEER LOGIN
  // ==========================================================

  void volunteerLogin() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final email =
        emailController.text.trim().toLowerCase();

    if (!AppData.instance.isVolunteerEmail(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Only @rescuelink.com volunteer accounts are allowed.",
          ),
          backgroundColor: Colors.redAccent,
        ),
      );

      return;
    }

    AppData.instance.setVolunteer(
      name: nameController.text.trim(),
      email: email,
      phone: phoneController.text.trim(),
    );

    setState(() {
      loggedIn = true;
    });
  }

  // ==========================================================
  // ACCEPT REQUEST
  // ==========================================================

  void acceptRequest(RescueRequest request) {
    AppData.instance.acceptRequest(request.id);

    setState(() {});

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "Request ${request.id} accepted successfully.",
        ),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!loggedIn) {
      return _buildVolunteerLogin();
    }

    return _buildVolunteerDashboard();
  }

  // ==========================================================
  // VOLUNTEER LOGIN SCREEN
  // ==========================================================

  Widget _buildVolunteerLogin() {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0F14),

      appBar: AppBar(
        backgroundColor: const Color(0xFF0B0F14),
        elevation: 0,
        title: const Text(
          "Volunteer Access",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(22),
        child: Form(
          key: _formKey,
          child: Column(
            children: [

              const SizedBox(height: 20),

              // ICON
              Container(
                width: 125,
                height: 125,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFFFF6B00)
                      .withOpacity(0.12),
                  border: Border.all(
                    color: const Color(0xFFFF6B00)
                        .withOpacity(0.4),
                    width: 2,
                  ),
                ),
                child: const Icon(
                  Icons.volunteer_activism_rounded,
                  size: 65,
                  color: Color(0xFFFF6B00),
                ),
              ),

              const SizedBox(height: 25),

              const Text(
                "Volunteer Portal",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                "Authorized RescueLink volunteers only",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white38,
                ),
              ),

              const SizedBox(height: 30),

              _textField(
                controller: nameController,
                label: "Volunteer Name",
                icon: Icons.person_outline,
                validator: (value) {
                  if (value == null ||
                      value.trim().isEmpty) {
                    return "Enter your name";
                  }

                  return null;
                },
              ),

              const SizedBox(height: 15),

              _textField(
                controller: emailController,
                label: "RescueLink Email",
                hint: "name@rescuelink.com",
                icon: Icons.email_outlined,
                keyboardType:
                    TextInputType.emailAddress,
                validator: (value) {
                  if (value == null ||
                      value.trim().isEmpty) {
                    return "Enter your email";
                  }

                  if (!AppData.instance
                      .isVolunteerEmail(value)) {
                    return "Use your @rescuelink.com email";
                  }

                  return null;
                },
              ),

              const SizedBox(height: 15),

              _textField(
                controller: phoneController,
                label: "Phone Number",
                icon: Icons.phone_outlined,
                keyboardType: TextInputType.phone,
                maxLength: 10,
                validator: (value) {
                  if (value == null ||
                      value.trim().length != 10) {
                    return "Enter a valid 10-digit number";
                  }

                  if (!RegExp(r'^[0-9]+$')
                      .hasMatch(value.trim())) {
                    return "Enter numbers only";
                  }

                  return null;
                },
              ),

              const SizedBox(height: 15),

              _textField(
                controller: passwordController,
                label: "Password",
                icon: Icons.lock_outline,
                obscureText: !passwordVisible,
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      passwordVisible =
                          !passwordVisible;
                    });
                  },
                  icon: Icon(
                    passwordVisible
                        ? Icons.visibility_off
                        : Icons.visibility,
                    color: Colors.white54,
                  ),
                ),
                validator: (value) {
                  if (value == null ||
                      value.length < 6) {
                    return "Password must contain at least 6 characters";
                  }

                  return null;
                },
              ),

              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                height: 58,
                child: ElevatedButton.icon(
                  onPressed: volunteerLogin,
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        const Color(0xFFFF6B00),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(16),
                    ),
                  ),
                  icon: const Icon(
                    Icons.login_rounded,
                    color: Colors.white,
                  ),
                  label: const Text(
                    "ENTER VOLUNTEER PORTAL",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 25),

              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.orange
                      .withOpacity(0.08),
                  borderRadius:
                      BorderRadius.circular(15),
                  border: Border.all(
                    color: Colors.orange
                        .withOpacity(0.2),
                  ),
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
                        "Access is restricted to official RescueLink volunteer email accounts.",
                        style: TextStyle(
                          color: Colors.white54,
                          fontSize: 12,
                          height: 1.4,
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

  // ==========================================================
  // VOLUNTEER DASHBOARD
  // ==========================================================

  Widget _buildVolunteerDashboard() {
    final volunteer =
        AppData.instance.volunteer;

    final requests =
        AppData.instance.requests;

    final pendingRequests = requests
        .where((request) =>
            request.status == "Pending")
        .toList();

    return Scaffold(
      backgroundColor: const Color(0xFF0B0F14),

      appBar: AppBar(
        backgroundColor: const Color(0xFF0B0F14),
        elevation: 0,
        title: const Text(
          "Volunteer Dashboard",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {});
        },

        child: SingleChildScrollView(
          physics:
              const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [

              // VOLUNTEER HEADER
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: const Color(0xFF151B23),
                  borderRadius:
                      BorderRadius.circular(20),
                  border: Border.all(
                    color: const Color(0xFF252D38),
                  ),
                ),
                child: Row(
                  children: [

                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFFFF6B00)
                            .withOpacity(0.15),
                      ),
                      child: const Icon(
                        Icons.volunteer_activism,
                        color: Color(0xFFFF6B00),
                        size: 32,
                      ),
                    ),

                    const SizedBox(width: 15),

                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [

                          Text(
                            "Welcome, ${volunteer?.name ?? "Volunteer"}",
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 5),

                          Text(
                            volunteer?.email ?? "",
                            style: const TextStyle(
                              color: Colors.white38,
                              fontSize: 12,
                            ),
                          ),

                          const SizedBox(height: 5),

                          Row(
                            children: const [

                              Icon(
                                Icons.verified,
                                color: Colors.green,
                                size: 15,
                              ),

                              SizedBox(width: 5),

                              Text(
                                "Authorized Volunteer",
                                style: TextStyle(
                                  color: Colors.green,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              // STATISTICS
              Row(
                children: [

                  Expanded(
                    child: _statCard(
                      "Pending",
                      "${pendingRequests.length}",
                      Icons.pending_actions,
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: _statCard(
                      "Total",
                      "${requests.length}",
                      Icons.assignment,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              const Text(
                "Victim Requests",
                style: TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 5),

              const Text(
                "Emergency requests requiring assistance",
                style: TextStyle(
                  color: Colors.white38,
                  fontSize: 12,
                ),
              ),

              const SizedBox(height: 18),

              if (requests.isEmpty)
                _noRequests()
              else
                ...requests.map(
                  (request) =>
                      _requestCard(request),
                ),
            ],
          ),
        ),
      ),
    );
  }

  // ==========================================================
  // REQUEST CARD
  // ==========================================================

  Widget _requestCard(
    RescueRequest request,
  ) {
    final accepted =
        request.status == "Accepted";

    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: const Color(0xFF151B23),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: accepted
              ? Colors.green.withOpacity(0.3)
              : const Color(0xFFFF6B00)
                  .withOpacity(0.25),
        ),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [

          Row(
            children: [

              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: accepted
                      ? Colors.green.withOpacity(0.12)
                      : const Color(0xFFFF6B00)
                          .withOpacity(0.12),
                  borderRadius:
                      BorderRadius.circular(13),
                ),
                child: Icon(
                  accepted
                      ? Icons.check_circle_outline
                      : Icons.warning_amber_rounded,
                  color: accepted
                      ? Colors.green
                      : const Color(0xFFFF6B00),
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [

                    Text(
                      request.type,
                      style: const TextStyle(
                        fontWeight:
                            FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      request.id,
                      style: const TextStyle(
                        color: Colors.white38,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: accepted
                      ? Colors.green.withOpacity(0.12)
                      : Colors.orange.withOpacity(0.12),
                  borderRadius:
                      BorderRadius.circular(20),
                ),
                child: Text(
                  request.status,
                  style: TextStyle(
                    color: accepted
                        ? Colors.green
                        : Colors.orange,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 17),

          _requestDetail(
            Icons.people_outline,
            "Victims",
            "${request.victims}",
          ),

          _requestDetail(
            Icons.location_on_outlined,
            "Location",
            request.location,
          ),

          _requestDetail(
            Icons.priority_high_rounded,
            "Priority",
            request.priority,
          ),

          const SizedBox(height: 12),

          if (!accepted)
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                onPressed: () {
                  acceptRequest(request);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      const Color(0xFFFF6B00),
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(13),
                  ),
                ),
                icon: const Icon(
                  Icons.check_circle_outline,
                  color: Colors.white,
                ),
                label: const Text(
                  "ACCEPT REQUEST",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            )
          else
            Container(
              width: double.infinity,
              padding:
                  const EdgeInsets.symmetric(
                vertical: 13,
              ),
              decoration: BoxDecoration(
                color: Colors.green
                    .withOpacity(0.08),
                borderRadius:
                    BorderRadius.circular(13),
              ),
              child: const Row(
                mainAxisAlignment:
                    MainAxisAlignment.center,
                children: [

                  Icon(
                    Icons.check_circle,
                    color: Colors.green,
                    size: 18,
                  ),

                  SizedBox(width: 8),

                  Text(
                    "REQUEST ACCEPTED",
                    style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
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
  // TEXT FIELD
  // ==========================================================

  Widget _textField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? hint,
    TextInputType? keyboardType,
    bool obscureText = false,
    int? maxLength,
    Widget? suffixIcon,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      maxLength: maxLength,
      validator: validator,
      style: const TextStyle(
        color: Colors.white,
      ),
      decoration: InputDecoration(
        counterText: "",
        labelText: label,
        hintText: hint,
        labelStyle: const TextStyle(
          color: Colors.white54,
        ),
        hintStyle: const TextStyle(
          color: Colors.white30,
        ),
        prefixIcon: Icon(
          icon,
          color: const Color(0xFFFF6B00),
        ),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: const Color(0xFF151B23),
        border: OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(14),
          borderSide: const BorderSide(
            color: Colors.white12,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(14),
          borderSide: const BorderSide(
            color: Color(0xFFFF6B00),
          ),
        ),
      ),
    );
  }

  // ==========================================================
  // STAT CARD
  // ==========================================================

  Widget _statCard(
    String title,
    String value,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: const Color(0xFF151B23),
        borderRadius: BorderRadius.circular(17),
      ),
      child: Column(
        children: [

          Icon(
            icon,
            color: const Color(0xFFFF6B00),
            size: 28,
          ),

          const SizedBox(height: 10),

          Text(
            value,
            style: const TextStyle(
              fontSize: 23,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 3),

          Text(
            title,
            style: const TextStyle(
              color: Colors.white38,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // REQUEST DETAIL
  // ==========================================================

  Widget _requestDetail(
    IconData icon,
    String title,
    String value,
  ) {
    return Padding(
      padding:
          const EdgeInsets.only(bottom: 9),
      child: Row(
        children: [

          Icon(
            icon,
            size: 17,
            color: Colors.white38,
          ),

          const SizedBox(width: 9),

          Text(
            "$title: ",
            style: const TextStyle(
              color: Colors.white38,
              fontSize: 12,
            ),
          ),

          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // NO REQUESTS
  // ==========================================================

  Widget _noRequests() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: const Color(0xFF151B23),
        borderRadius:
            BorderRadius.circular(18),
      ),
      child: const Column(
        children: [

          Icon(
            Icons.inbox_outlined,
            color: Colors.white30,
            size: 55,
          ),

          SizedBox(height: 15),

          Text(
            "No victim requests",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 17,
            ),
          ),

          SizedBox(height: 5),

          Text(
            "New emergency requests will appear here.",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white38,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}