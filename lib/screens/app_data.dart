
import 'package:flutter/material.dart';

class UserData {
  final String name;
  final String email;
  final String phone;
  final String password;

  UserData({
    required this.name,
    required this.email,
    required this.phone,
    required this.password,
  });
}

class RescueRequest {
  final String id;
  final String type;
  final int victims;
  final String location;
  final String priority;
  final String message;

  DateTime time;
  String status;

  RescueRequest({
    required this.id,
    required this.type,
    required this.victims,
    required this.location,
    required this.priority,
    required this.message,
    DateTime? time,
    this.status = "Pending",
  }) : time = time ?? DateTime.now();
}

class VolunteerData {
  final String name;
  final String email;
  final String phone;

  VolunteerData({
    required this.name,
    required this.email,
    required this.phone,
  });
}

class AppData extends ChangeNotifier {
  AppData._privateConstructor();

  static final AppData instance = AppData._privateConstructor();

  // ==========================================================
  // REGISTERED USER
  // ==========================================================

  UserData? registeredUser;

  // ==========================================================
  // CURRENT LOGIN STATUS
  // ==========================================================

  bool isLoggedIn = false;

  // ==========================================================
  // CURRENT USER INFORMATION
  // ==========================================================

  String userName = "";
  String userEmail = "";
  String userPhone = "";

  // ==========================================================
  // VOLUNTEER DATA
  // ==========================================================

  VolunteerData? volunteer;

  // ==========================================================
  // SOS REQUESTS
  // ==========================================================

  final List<RescueRequest> requests = [];

  // ==========================================================
  // APPROVED VOLUNTEER EMAILS
  // ==========================================================

  final List<String> volunteerEmails = [
    "volunteer@rescuelink.com",
    "admin@rescuelink.com",
    "rescue@rescuelink.com",
  ];

  // ==========================================================
  // REGISTER USER
  // ==========================================================

  bool registerUser({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) {
    final normalizedEmail = email.trim().toLowerCase();

    // Prevent duplicate email registration.
    if (registeredUser != null &&
        registeredUser!.email.toLowerCase() == normalizedEmail) {
      return false;
    }

    registeredUser = UserData(
      name: name.trim(),
      email: normalizedEmail,
      phone: phone.trim(),
      password: password,
    );

    // Do NOT automatically login after signup.
    isLoggedIn = false;

    // Clear current profile until login.
    userName = "";
    userEmail = "";
    userPhone = "";

    notifyListeners();

    return true;
  }

  // ==========================================================
  // LOGIN USER
  // ==========================================================

  bool loginUser({
    required String email,
    required String password,
  }) {
    if (registeredUser == null) {
      return false;
    }

    final normalizedEmail = email.trim().toLowerCase();

    // Check email and password.
    if (registeredUser!.email.toLowerCase() == normalizedEmail &&
        registeredUser!.password == password) {
      // Login successful.
      isLoggedIn = true;

      // Store the registered information in current user.
      userName = registeredUser!.name;
      userEmail = registeredUser!.email;
      userPhone = registeredUser!.phone;

      notifyListeners();

      return true;
    }

    return false;
  }

  // ==========================================================
  // LOGOUT
  // ==========================================================

  void logout() {
    isLoggedIn = false;

    // Clear currently logged-in profile.
    userName = "";
    userEmail = "";
    userPhone = "";

    notifyListeners();
  }

  // ==========================================================
  // SET USER
  // ==========================================================

  void setUser({
    required String name,
    required String email,
    required String phone,
  }) {
    userName = name;
    userEmail = email;
    userPhone = phone;

    notifyListeners();
  }

  // ==========================================================
  // UPDATE USER
  // ==========================================================

  void updateUser({
    required String name,
    required String email,
    required String phone,
  }) {
    userName = name;
    userEmail = email;
    userPhone = phone;

    // Also update registered account information.
    if (registeredUser != null) {
      registeredUser = UserData(
        name: name,
        email: email.trim().toLowerCase(),
        phone: phone,
        password: registeredUser!.password,
      );
    }

    notifyListeners();
  }

  // ==========================================================
  // CHECK VOLUNTEER EMAIL
  // ==========================================================

  bool isVolunteerEmail(String email) {
    return volunteerEmails.contains(
      email.trim().toLowerCase(),
    );
  }

  // ==========================================================
  // SET VOLUNTEER
  // ==========================================================

  void setVolunteer({
    required String name,
    required String email,
    required String phone,
  }) {
    volunteer = VolunteerData(
      name: name,
      email: email,
      phone: phone,
    );

    notifyListeners();
  }

  // ==========================================================
  // ADD RESCUE REQUEST
  // ==========================================================

  void addRequest({
    required String ticketId,
    required String type,
    required int victims,
    required String location,
    required String priority,
    required String message,
  }) {
    requests.add(
      RescueRequest(
        id: ticketId,
        type: type,
        victims: victims,
        location: location,
        priority: priority,
        message: message,
      ),
    );

    notifyListeners();
  }

  // ==========================================================
  // ACCEPT RESCUE REQUEST
  // ==========================================================

  void acceptRequest(String requestId) {
    final index = requests.indexWhere(
      (request) => request.id == requestId,
    );

    if (index != -1) {
      requests[index].status = "Accepted";
      notifyListeners();
    }
  }
}