import 'package:flutter/material.dart';

class TextScreen extends StatefulWidget {
  const TextScreen({super.key});

  @override
  State<TextScreen> createState() => _TextScreenState();
}

class _TextScreenState extends State<TextScreen> {
  final messageController = TextEditingController();

  @override
  void dispose() {
    messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Text Emergency",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 10),

            const Text(
              "Send Emergency Message",
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 7),

            const Text(
              "Send your emergency message even without internet.",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white54,
              ),
            ),

            const SizedBox(height: 30),

            // BIG MIC
            Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFFF6B00),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFFF6B00)
                        .withOpacity(0.3),
                    blurRadius: 30,
                    spreadRadius: 6,
                  ),
                ],
              ),
              child: const Icon(
                Icons.mic_rounded,
                size: 70,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 18),

            const Text(
              "Tap microphone to dictate",
              style: TextStyle(
                color: Colors.white60,
              ),
            ),

            const SizedBox(height: 30),

            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Emergency Message",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 10),

            TextField(
              controller: messageController,
              maxLines: 6,
              decoration: InputDecoration(
                hintText:
                    "Type your emergency message...",
                prefixIcon: const Padding(
                  padding: EdgeInsets.only(bottom: 90),
                  child: Icon(
                    Icons.message_outlined,
                  ),
                ),
                filled: true,
                fillColor: const Color(0xFF151B23),
                border: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(18),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 20),

            // QUICK MESSAGES
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Quick Message",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 12),

            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _quickMessage("I need medical help"),
                _quickMessage("I am trapped"),
                _quickMessage("Send rescue team"),
                _quickMessage("Need evacuation"),
              ],
            ),

            const SizedBox(height: 25),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.send_rounded),
                label: const Text(
                  "SEND EMERGENCY MESSAGE",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      const Color(0xFFFF6B00),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(16),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _quickMessage(String text) {
    return GestureDetector(
      onTap: () {
        messageController.text = text;
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          color: const Color(0xFF151B23),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: const Color(0xFF252D38),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}