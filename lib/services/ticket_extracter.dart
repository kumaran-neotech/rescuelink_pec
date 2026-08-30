
import '../models/rescue_ticket.dart';

class TicketExtractor {
  static RescueTicket extract({
    required String text,
    required String location,
  }) {
    final String lower = text.toLowerCase();

    // ==========================================================
    // DETECT EMERGENCY TYPE
    // ==========================================================

    String type = 'Other';

    if (_containsAny(lower, [
      'heart',
      'medical',
      'injury',
      'injured',
      'bleeding',
      'unconscious',
      'sick',
      'hospital',
      'ambulance',
    ])) {
      type = 'Medical Emergency';
    } else if (_containsAny(lower, [
      'fire',
      'burning',
      'flames',
      'smoke',
    ])) {
      type = 'Fire';
    } else if (_containsAny(lower, [
      'flood',
      'water entered',
      'water everywhere',
      'flooding',
    ])) {
      type = 'Flood';
    } else if (_containsAny(lower, [
      'earthquake',
      'earth quake',
      'building shaking',
      'ground shaking',
    ])) {
      type = 'Earthquake';
    } else if (_containsAny(lower, [
      'landslide',
      'land slide',
      'mudslide',
      'rocks falling',
    ])) {
      type = 'Landslide';
    } else if (_containsAny(lower, [
      'accident',
      'crash',
      'collision',
      'vehicle accident',
      'car accident',
    ])) {
      type = 'Accident';
    } else if (_containsAny(lower, [
      'trapped',
      'stuck',
      'cannot get out',
      'cant get out',
    ])) {
      type = 'Trapped Person';
    } else if (_containsAny(lower, [
      'building collapsed',
      'building collapse',
      'collapsed building',
    ])) {
      type = 'Building Collapse';
    } else if (_containsAny(lower, [
      'missing',
      'lost person',
      'person missing',
    ])) {
      type = 'Missing Person';
    }

    // ==========================================================
    // DETECT VICTIMS
    // ==========================================================

    int victims = _extractVictims(lower);

    // ==========================================================
    // DETECT PRIORITY
    // ==========================================================

    String priority = _extractPriority(lower);

    return RescueTicket(
      ticketId:
          'RL-${DateTime.now().millisecondsSinceEpoch}',
      type: type,
      location: location,
      priority: priority,
      victims: victims,
      message: text.trim(),
      createdAt: DateTime.now(),
    );
  }

  // ==========================================================
  // VICTIM EXTRACTION
  // ==========================================================

  static int _extractVictims(String text) {
    final words = <String, int>{
      'zero': 0,
      'one': 1,
      'two': 2,
      'three': 3,
      'four': 4,
      'five': 5,
      'six': 6,
      'seven': 7,
      'eight': 8,
      'nine': 9,
      'ten': 10,
      'eleven': 11,
      'twelve': 12,
      'thirteen': 13,
      'fourteen': 14,
      'fifteen': 15,
      'sixteen': 16,
      'seventeen': 17,
      'eighteen': 18,
      'nineteen': 19,
      'twenty': 20,
    };

    final victimPattern = RegExp(
      r'(\d+)\s*(?:people|person|persons|victims|members|'
      r'people are|persons are)',
      caseSensitive: false,
    );

    final match = victimPattern.firstMatch(text);

    if (match != null) {
      final number = int.tryParse(match.group(1)!);

      if (number != null) {
        return number.clamp(1, 100);
      }
    }

    for (final entry in words.entries) {
      if (text.contains('${entry.key} people') ||
          text.contains('${entry.key} persons') ||
          text.contains('${entry.key} victims') ||
          text.contains('${entry.key} person')) {
        return entry.value < 1 ? 1 : entry.value;
      }
    }

    // Search for a standalone number if there is
    // no explicit victim keyword.
    final numberMatch =
        RegExp(r'\b\d+\b').firstMatch(text);

    if (numberMatch != null) {
      final number =
          int.tryParse(numberMatch.group(0)!);

      if (number != null && number > 0) {
        return number.clamp(1, 100);
      }
    }

    return 1;
  }

  // ==========================================================
  // PRIORITY EXTRACTION
  // ==========================================================

  static String _extractPriority(String text) {
    if (_containsAny(text, [
      'critical',
      'critically',
      'life threatening',
      'life-threatening',
      'dying',
      'immediate help',
      'urgent',
      'very urgent',
      'severe',
      'serious',
    ])) {
      return 'High';
    }

    if (_containsAny(text, [
      'moderate',
      'need help',
      'needs help',
      'somewhat urgent',
    ])) {
      return 'Medium';
    }

    if (_containsAny(text, [
      'low priority',
      'not urgent',
      'minor',
    ])) {
      return 'Low';
    }

    // Automatically infer high priority for
    // major disaster/emergency situations.
    if (_containsAny(text, [
      'fire',
      'building collapse',
      'earthquake',
      'trapped',
      'unconscious',
      'bleeding',
      'flood',
      'accident',
    ])) {
      return 'High';
    }

    return 'Medium';
  }

  // ==========================================================
  // KEYWORD HELPER
  // ==========================================================

  static bool _containsAny(
    String text,
    List<String> words,
  ) {
    for (final word in words) {
      if (text.contains(word)) {
        return true;
      }
    }

    return false;
  }
}