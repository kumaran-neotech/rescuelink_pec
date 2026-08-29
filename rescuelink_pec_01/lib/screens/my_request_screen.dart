import 'package:flutter/material.dart';
import '../app_data.dart';

class MyRequestsScreen extends StatefulWidget {
  const MyRequestsScreen({super.key});

  @override
  State<MyRequestsScreen> createState() =>
      _MyRequestsScreenState();
}

class _MyRequestsScreenState
    extends State<MyRequestsScreen> {

  @override
  Widget build(BuildContext context) {
    final requests = AppData.instance.requests;

    return Scaffold(
      backgroundColor: const Color(0xFF0B0F14),

      appBar: AppBar(
        backgroundColor: const Color(0xFF0B0F14),
        elevation: 0,
        title: const Text(
          "My Requests",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: requests.isEmpty
          ? _emptyState()
          : ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: requests.length,
              itemBuilder: (context, index) {
                final request = requests[index];

                return _requestCard(request);
              },
            ),
    );
  }

  Widget _emptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center,
          children: [

            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFFF6B00)
                    .withOpacity(0.12),
              ),
              child: const Icon(
                Icons.assignment_outlined,
                size: 50,
                color: Color(0xFFFF6B00),
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              "No Requests Yet",
              style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              "Your emergency and safety requests will appear here.",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white38,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _requestCard(RescueRequest request) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF151B23),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFF252D38),
        ),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [

          Row(
            children: [

              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0xFFFF6B00)
                      .withOpacity(0.12),
                  borderRadius:
                      BorderRadius.circular(13),
                ),
                child: const Icon(
                  Icons.warning_rounded,
                  color: Color(0xFFFF6B00),
                ),
              ),

              const SizedBox(width: 13),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      request.type,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      request.id,
                      style: const TextStyle(
                        color: Colors.white38,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.12),
                  borderRadius:
                      BorderRadius.circular(20),
                ),
                child: Text(
                  request.status,
                  style: const TextStyle(
                    color: Colors.orange,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          _detail(
            Icons.people_outline,
            "Victims",
            "${request.victims}",
          ),

          _detail(
            Icons.location_on_outlined,
            "Location",
            request.location,
          ),

          _detail(
            Icons.priority_high_rounded,
            "Priority",
            request.priority,
          ),

          const SizedBox(height: 8),

          Text(
            "${request.time.day}/${request.time.month}/${request.time.year} "
            "${request.time.hour.toString().padLeft(2, '0')}:"
            "${request.time.minute.toString().padLeft(2, '0')}",
            style: const TextStyle(
              color: Colors.white30,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  Widget _detail(
    IconData icon,
    String title,
    String value,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Icon(
            icon,
            size: 18,
            color: Colors.white38,
          ),
          const SizedBox(width: 10),
          Text(
            "$title: ",
            style: const TextStyle(
              color: Colors.white38,
              fontSize: 12,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}