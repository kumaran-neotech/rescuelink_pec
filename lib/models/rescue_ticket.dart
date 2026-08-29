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

  factory RescueTicket.fromMap(Map map) {
    return RescueTicket(
      ticketId: map['ticketId'],
      type: map['type'],
      location: map['location'],
      priority: map['priority'],
      victims: map['victims'],
      message: map['message'],
      createdAt: DateTime.parse(map['createdAt']),
    );
  }
}