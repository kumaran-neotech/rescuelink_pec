
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

  factory RescueTicket.fromMap(Map<dynamic, dynamic> map) {
    return RescueTicket(
      ticketId: map['ticketId']?.toString() ?? '',
      type: map['type']?.toString() ?? 'Other',
      location: map['location']?.toString() ?? 'Unknown',
      priority: map['priority']?.toString() ?? 'High',
      victims: _parseInt(map['victims'], 1),
      message: map['message']?.toString() ?? '',
      createdAt: _parseDateTime(map['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return toMap();
  }

  factory RescueTicket.fromJson(Map<String, dynamic> json) {
    return RescueTicket.fromMap(json);
  }

  String toRawPayload() {
    return toJsonString(toJson());
  }

  static String toJsonString(Map<String, dynamic> data) {
    return _jsonEncode(data);
  }

  static String _jsonEncode(Map<String, dynamic> data) {
    final entries = data.entries.map((entry) {
      final key = entry.key.replaceAll('"', '\\"');
      final value = entry.value;

      if (value is String) {
        final escaped = value
            .replaceAll('\\', '\\\\')
            .replaceAll('"', '\\"')
            .replaceAll('\n', '\\n')
            .replaceAll('\r', '\\r');

        return '"$key":"$escaped"';
      }

      return '"$key":$value';
    }).join(',');

    return '{$entries}';
  }

  static int _parseInt(dynamic value, int fallback) {
    if (value is int) return value;

    if (value is num) {
      return value.toInt();
    }

    return int.tryParse(value?.toString() ?? '') ?? fallback;
  }

  static DateTime _parseDateTime(dynamic value) {
    if (value is DateTime) {
      return value;
    }

    return DateTime.tryParse(
          value?.toString() ?? '',
        ) ??
        DateTime.now();
  }
}
