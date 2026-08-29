import 'package:flutter/material.dart';
import '../app_data.dart';

class RequestSafetyScreen extends StatefulWidget {
  const RequestSafetyScreen({super.key});

  @override
  State<RequestSafetyScreen> createState() =>
      _RequestSafetyScreenState();
}

class _RequestSafetyScreenState
    extends State<RequestSafetyScreen> {

  String? selectedHelp;
  String? selectedUrgency;
  int people = 1;

  final TextEditingController locationController =
      TextEditingController();

  final List<String> helpTypes = [
    "Medical Assistance",
    "Food & Water",
    "Shelter",
    "Evacuation",
    "Rescue Team",
    "First Aid",
    "Missing Person",
    "Other",
  ];

  final List<String> urgencyTypes = [
    "Critical",
    "Urgent",
    "Normal",
  ];

  @override
  void dispose() {
    locationController.dispose();
    super.dispose();
  }

  void submitRequest() {
    if (selectedHelp == null) {
      _message("Please select the type of help required");
      return;
    }

    if (selectedUrgency == null) {
      _message("Please select urgency");
      return;
    }

    if (locationController.text.trim().isEmpty) {
      _message("Please enter your location");
      return;
    }

 String ticketId =
    "RL-${DateTime.now().millisecondsSinceEpoch}";

AppData.instance.addRequest(
  ticketId: ticketId,
  type: selectedHelp!,
  victims: people,
  location: locationController.text.trim(),
  priority: selectedUrgency!,
  message: "Safety Request",
);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF151B23),
          title: const Text("Request Submitted"),
          content: const Text(
            "Your safety request has been added successfully.",
            style: TextStyle(color: Colors.white70),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: const Text(
                "DONE",
                style: TextStyle(
                  color: Color(0xFFFF6B00),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _message(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.redAccent,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0F14),

      appBar: AppBar(
        backgroundColor: const Color(0xFF0B0F14),
        elevation: 0,
        title: const Text(
          "Request Safety",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Center(
              child: Container(
                width: 95,
                height: 95,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFFFF6B00)
                      .withOpacity(0.12),
                ),
                child: const Icon(
                  Icons.health_and_safety_rounded,
                  size: 50,
                  color: Color(0xFFFF6B00),
                ),
              ),
            ),

            const SizedBox(height: 25),

            const Text(
              "What help do you need?",
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: helpTypes.map((help) {
                final selected = selectedHelp == help;

                return ChoiceChip(
                  label: Text(help),
                  selected: selected,
                  onSelected: (_) {
                    setState(() {
                      selectedHelp = help;
                    });
                  },
                  selectedColor:
                      const Color(0xFFFF6B00),
                  backgroundColor:
                      const Color(0xFF151B23),
                  labelStyle: TextStyle(
                    color: selected
                        ? Colors.white
                        : Colors.white70,
                    fontWeight: FontWeight.w600,
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 28),

            const Text(
              "Number of People",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                IconButton(
                  onPressed: () {
                    if (people > 1) {
                      setState(() {
                        people--;
                      });
                    }
                  },
                  icon: const Icon(
                    Icons.remove_circle,
                    color: Color(0xFFFF6B00),
                  ),
                ),

                Text(
                  "$people",
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                IconButton(
                  onPressed: () {
                    if (people < 100) {
                      setState(() {
                        people++;
                      });
                    }
                  },
                  icon: const Icon(
                    Icons.add_circle,
                    color: Color(0xFFFF6B00),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            const Text(
              "Urgency",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            Wrap(
              spacing: 10,
              children: urgencyTypes.map((urgency) {
                final selected =
                    selectedUrgency == urgency;

                return ChoiceChip(
                  label: Text(urgency),
                  selected: selected,
                  onSelected: (_) {
                    setState(() {
                      selectedUrgency = urgency;
                    });
                  },
                  selectedColor:
                      const Color(0xFFFF6B00),
                  backgroundColor:
                      const Color(0xFF151B23),
                  labelStyle: TextStyle(
                    color: selected
                        ? Colors.white
                        : Colors.white70,
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 25),

            const Text(
              "Location",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            TextField(
              controller: locationController,
              style: const TextStyle(
                color: Colors.white,
              ),
              decoration: InputDecoration(
                hintText: "Enter your location",
                prefixIcon: const Icon(
                  Icons.location_on_outlined,
                  color: Color(0xFFFF6B00),
                ),
                filled: true,
                fillColor: const Color(0xFF151B23),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: submitRequest,
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      const Color(0xFFFF6B00),
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(15),
                  ),
                ),
                child: const Text(
                  "SUBMIT SAFETY REQUEST",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}