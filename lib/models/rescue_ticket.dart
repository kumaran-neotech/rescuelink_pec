class RescueTicket {
  final String ticketId;
  final String type;
  final String location;
  final String priority;
  final int victims;
  final String message;
  final DateTime createdAt;

  RescueTicket({
    required this.ticketId,
    required this.type,
    required this.location,
    required this.priority,
    required this.victims,
    required this.message,
    required this.createdAt,
  });

  // ==========================================================
  // TO MAP  (used before jsonEncode when sending over the mesh)
  // ==========================================================
  Map<String, dynamic> toMap() {
    return {
      'ticketId': ticketId,
      'type': type,
      'location': location,
      'priority': priority,
      'victims': victims,
      'message': message,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  // ==========================================================
  // FROM MAP  (used after jsonDecode when receiving over the mesh)
  // ==========================================================
  factory RescueTicket.fromMap(Map<String, dynamic> map) {
    return RescueTicket(
      ticketId: map['ticketId'] as String,
      type: map['type'] as String,
      location: map['location'] as String,
      priority: map['priority'] as String,
      victims: map['victims'] as int,
      message: map['message'] as String,
      createdAt: DateTime.parse(map['createdAt'] as String),
    );
  }
}