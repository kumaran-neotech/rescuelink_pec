import 'package:flutter/foundation.dart';

class RescueRequest {
  final String id;
  final String type;
  final int victims;
  final String location;
  final String priority;
  String status;
  final DateTime time;

  RescueRequest({
    required this.id,
    required this.type,
    required this.victims,
    required this.location,
    required this.priority,
    required this.status,
    required this.time,
  });
}

class VolunteerData {
  String name;
  String email;
  String phone;

  VolunteerData({
    required this.name,
    required this.email,
    required this.phone,
  });
}

class AppData extends ChangeNotifier {
  AppData._privateConstructor();

  static final AppData instance =
      AppData._privateConstructor();

  // ==========================================================
  // NORMAL USER
  // ==========================================================

  String userName = "";
  String userEmail = "";
  String userPhone = "";

  // ==========================================================
  // VOLUNTEER
  // ==========================================================

  VolunteerData? volunteer;

  // ==========================================================
  // RESCUE REQUESTS
  // ==========================================================

  final List<RescueRequest> requests = [];

  // ==========================================================
  // USER
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

  // ==========================================================
  // VOLUNTEER
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

  bool isVolunteerEmail(String email) {
    return email.trim().toLowerCase().endsWith(
          "@rescuelink.com",
        );
  }

  // ==========================================================
  // CREATE REQUEST
  // ==========================================================

  void addRequest({
    required String type,
    required int victims,
    required String location,
    required String priority,
    required String message,
  }) {
    requests.insert(
      0,
      RescueRequest(
        id: "RL${DateTime.now().millisecondsSinceEpoch}",
        type: type,
        victims: victims,
        location: location,
        priority: priority,
        status: "Pending",
        time: DateTime.now(),
      ),
    );

    notifyListeners();
  }

  // ==========================================================
  // VOLUNTEER ACCEPT REQUEST
  // ==========================================================

  void acceptRequest(String requestId) {
    for (final request in requests) {
      if (request.id == requestId) {
        request.status = "Accepted";
        break;
      }
    }

    notifyListeners();
  }
}