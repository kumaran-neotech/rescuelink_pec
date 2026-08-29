import 'package:hive_flutter/hive_flutter.dart';

class TicketStorage {

  static const String boxName = "tickets";

  static Future<void> saveTicket(
      Map<String, dynamic> ticket) async {

    final box = await Hive.openBox(boxName);

    await box.put(
      ticket['ticketId'],
      ticket,
    );
  }

  static Future<List<Map>> getTickets() async {

    final box = await Hive.openBox(boxName);

    return box.values
        .map((e) => Map<String, dynamic>.from(e))
        .toList();
  }
}