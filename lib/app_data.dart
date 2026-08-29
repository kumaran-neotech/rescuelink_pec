import 'package:flutter/material.dart';

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

  // User Data
  String userName = "";
  String userEmail = "";
  String userPhone = "";

  // Volunteer Data
  VolunteerData? volunteer;

  // SOS Requests
  final List<RescueRequest> requests = [];

  // Approved volunteer emails
  final List<String> volunteerEmails = [
    "volunteer@rescuelink.com",
    "admin@rescuelink.com",
    "rescue@rescuelink.com",
  ];

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

  void updateUser({
    required String name,
    required String email,
    required String phone,
  }) {
    userName = name;
    userEmail = email;
    userPhone = phone;
    notifyListeners();
  }

  bool isVolunteerEmail(String email) {
  return volunteerEmails.contains(
    email.trim().toLowerCase(),
  );
}

bool emailExists(String email) {
  return userEmail.toLowerCase() ==
      email.toLowerCase();
}

bool phoneExists(String phone) {
  return userPhone == phone;
}
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

  void acceptRequest(String requestId) {
    final index = requests.indexWhere((r) => r.id == requestId);

    if (index != -1) {
      requests[index].status = "Accepted";
      notifyListeners();
    }
  }
}