import 'package:flutter/material.dart';

import '../models/rescue_ticket.dart';
import '../app_data.dart';
import '../services/location_service.dart';

class EmergencyScreen extends StatefulWidget {
  const EmergencyScreen({super.key});

  @override
  State<EmergencyScreen> createState() =>
      _EmergencyScreenState();
}

class _EmergencyScreenState extends State<EmergencyScreen> {
  final TextEditingController messageController =
      TextEditingController();

  String? selectedEmergency;
  String selectedPriority = 'High';

  int victims = 1;

  String currentLocation = '';
  bool loadingLocation = false;
  bool creatingSOS = false;

  final List<String> emergencyTypes = [
    'Medical Emergency',
    'Fire',
    'Flood',
    'Earthquake',
    'Landslide',
    'Accident',
    'Trapped Person',
    'Building Collapse',
    'Missing Person',
    'Other',
  ];

  @override
  void initState() {
    super.initState();

    // Automatically request and detect location
    // when the Emergency screen opens.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getLocation();
    });
  }

  @override
  void dispose() {
    messageController.dispose();
    super.dispose();
  }

  // ==========================================================
  // GET CURRENT LOCATION
  // ==========================================================

  Future<void> getLocation() async {
    if (!mounted) return;

    setState(() {
      loadingLocation = true;
    });

    try {
      final String location =
          await LocationService.getLocationText();

      if (!mounted) return;

      setState(() {
        currentLocation = location;
        loadingLocation = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        loadingLocation = false;
      });

      _showError(
        e.toString().replaceFirst('Exception: ', ''),
      );
    }
  }

  // ==========================================================
  // CREATE SOS
  // ==========================================================

  Future<void> createSOS() async {
    if (creatingSOS) return;

    if (selectedEmergency == null) {
      _showError(
        'Please select the type of emergency.',
      );
      return;
    }

    if (currentLocation.isEmpty) {
      _showError(
        'Current location is not available. '
        'Please tap the location button.',
      );
      return;
    }

    final String message =
        messageController.text.trim();

    if (message.isEmpty) {
      _showError(
        'Please enter an emergency message.',
      );
      return;
    }

    setState(() {
      creatingSOS = true;
    });

    try {
      final String ticketId =
          'RL-${DateTime.now().millisecondsSinceEpoch}';

      final RescueTicket ticket = RescueTicket(
        ticketId: ticketId,
        type: selectedEmergency!,
        location: currentLocation,
        priority: selectedPriority,
        victims: victims,
        message: message,
        createdAt: DateTime.now(),
      );

      // Save request to existing AppData.
      AppData.instance.addRequest(
        ticketId: ticket.ticketId,
        type: ticket.type,
        victims: ticket.victims,
        location: ticket.location,
        priority: ticket.priority,
        message: ticket.message,
      );

      if (!mounted) return;

      setState(() {
        creatingSOS = false;
      });

      await _showSuccess(ticket);

      if (!mounted) return;

      setState(() {
        selectedEmergency = null;
        selectedPriority = 'High';
        victims = 1;
        currentLocation = '';
        messageController.clear();
      });

      // Get fresh location after clearing the form.
      await getLocation();
    } catch (e) {
      if (!mounted) return;

      setState(() {
        creatingSOS = false;
      });

      _showError(
        'Unable to create SOS: $e',
      );
    }
  }

  // ==========================================================
  // ERROR
  // ==========================================================

  void _showError(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // ==========================================================
  // SUCCESS
  // ==========================================================

  Future<void> _showSuccess(
    RescueTicket ticket,
  ) async {
    if (!mounted) return;

    await showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: const Color(0xFF151B23),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          title: const Row(
            children: [
              Icon(
                Icons.check_circle,
                color: Colors.green,
              ),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'SOS Generated',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          content: Text(
            'Emergency request created successfully.\n\n'
            'Ticket ID:\n${ticket.ticketId}\n\n'
            'Location:\n${ticket.location}',
            style: const TextStyle(
              color: Colors.white70,
              height: 1.5,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text(
                'OK',
                style: TextStyle(
                  color: Color(0xFFFF6B00),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // ==========================================================
  // BUILD
  // ==========================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0F14),

      appBar: AppBar(
        backgroundColor: const Color(0xFF0B0F14),
        elevation: 0,
        title: const Text(
          'Emergency SOS',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              _buildHeader(),

              const SizedBox(height: 25),

              _sectionTitle(
                'Type of Emergency',
                Icons.warning_amber_rounded,
              ),

              const SizedBox(height: 12),

              _buildEmergencyDropdown(),

              const SizedBox(height: 25),

              _sectionTitle(
                'Number of Victims',
                Icons.people_alt_outlined,
              ),

              const SizedBox(height: 12),

              _buildVictimCounter(),

              const SizedBox(height: 25),

              _sectionTitle(
                'Emergency Priority',
                Icons.priority_high_rounded,
              ),

              const SizedBox(height: 12),

              _buildPrioritySelector(),

              const SizedBox(height: 25),

              _sectionTitle(
                'Current Location',
                Icons.location_on_outlined,
              ),

              const SizedBox(height: 12),

              _buildLocationCard(),

              const SizedBox(height: 25),

              _sectionTitle(
                'Emergency Message',
                Icons.message_outlined,
              ),

              const SizedBox(height: 12),

              _buildMessageField(),

              const SizedBox(height: 30),

              _buildCreateButton(),

              const SizedBox(height: 20),

              _buildSafetyMessage(),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  // ==========================================================
  // HEADER
  // ==========================================================

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFFFF6B00).withOpacity(0.20),
            const Color(0xFF151B23),
          ],
        ),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color:
              const Color(0xFFFF6B00).withOpacity(0.30),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 65,
            height: 65,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color:
                  const Color(0xFFFF6B00).withOpacity(0.15),
            ),
            child: const Icon(
              Icons.sos_rounded,
              size: 38,
              color: Color(0xFFFF6B00),
            ),
          ),

          const SizedBox(width: 15),

          const Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  'Emergency SOS',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'Send your emergency details to nearby rescue volunteers.',
                  style: TextStyle(
                    color: Colors.white54,
                    fontSize: 12,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // SECTION TITLE
  // ==========================================================

  Widget _sectionTitle(
    String title,
    IconData icon,
  ) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: const Color(0xFFFF6B00),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  // ==========================================================
  // EMERGENCY DROPDOWN
  // ==========================================================

  Widget _buildEmergencyDropdown() {
    return Container(
      padding:
          const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: const Color(0xFF151B23),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: Colors.white12,
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedEmergency,
          isExpanded: true,
          dropdownColor:
              const Color(0xFF151B23),
          hint: const Text(
            'Select emergency type',
            style: TextStyle(
              color: Colors.white38,
            ),
          ),
          icon: const Icon(
            Icons.keyboard_arrow_down_rounded,
            color: Color(0xFFFF6B00),
          ),
          items: emergencyTypes.map(
            (String type) {
              return DropdownMenuItem<String>(
                value: type,
                child: Text(
                  type,
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
              );
            },
          ).toList(),
          onChanged: (String? value) {
            setState(() {
              selectedEmergency = value;
            });
          },
        ),
      ),
    );
  }

  // ==========================================================
  // VICTIM COUNTER
  // ==========================================================

  Widget _buildVictimCounter() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 15,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF151B23),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: Colors.white12,
        ),
      ),
      child: Row(
        mainAxisAlignment:
            MainAxisAlignment.spaceBetween,
        children: [
          const Expanded(
            child: Text(
              'People requiring help',
              style: TextStyle(
                color: Colors.white70,
              ),
            ),
          ),

          Row(
            children: [
              _counterButton(
                Icons.remove,
                () {
                  if (victims > 1) {
                    setState(() {
                      victims--;
                    });
                  }
                },
              ),

              SizedBox(
                width: 55,
                child: Center(
                  child: Text(
                    '$victims',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              _counterButton(
                Icons.add,
                () {
                  if (victims < 100) {
                    setState(() {
                      victims++;
                    });
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _counterButton(
    IconData icon,
    VoidCallback onPressed,
  ) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color:
              const Color(0xFFFF6B00).withOpacity(0.12),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          icon,
          color: const Color(0xFFFF6B00),
        ),
      ),
    );
  }

  // ==========================================================
  // PRIORITY
  // ==========================================================

  Widget _buildPrioritySelector() {
    return Row(
      children: [
        Expanded(
          child: _priorityButton(
            'Low',
            Colors.green,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _priorityButton(
            'Medium',
            Colors.orange,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _priorityButton(
            'High',
            Colors.redAccent,
          ),
        ),
      ],
    );
  }

  Widget _priorityButton(
    String priority,
    Color color,
  ) {
    final bool selected =
        selectedPriority == priority;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedPriority = priority;
        });
      },
      child: AnimatedContainer(
        duration:
            const Duration(milliseconds: 200),
        padding:
            const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: selected
              ? color.withOpacity(0.20)
              : const Color(0xFF151B23),
          borderRadius: BorderRadius.circular(13),
          border: Border.all(
            color:
                selected ? color : Colors.white12,
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              priority == 'High'
                  ? Icons.priority_high
                  : priority == 'Medium'
                      ? Icons.remove
                      : Icons.check,
              color:
                  selected ? color : Colors.white38,
            ),
            const SizedBox(height: 5),
            Text(
              priority,
              style: TextStyle(
                color:
                    selected ? color : Colors.white54,
                fontWeight: selected
                    ? FontWeight.bold
                    : FontWeight.normal,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================================
  // LOCATION CARD
  // ==========================================================

  Widget _buildLocationCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color(0xFF151B23),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: currentLocation.isNotEmpty
              ? Colors.green.withOpacity(0.35)
              : Colors.white12,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 45,
            height: 45,
            decoration: BoxDecoration(
              color: currentLocation.isNotEmpty
                  ? Colors.green.withOpacity(0.12)
                  : const Color(0xFFFF6B00)
                      .withOpacity(0.12),
              borderRadius:
                  BorderRadius.circular(12),
            ),
            child: Icon(
              currentLocation.isNotEmpty
                  ? Icons.location_on
                  : Icons.location_searching,
              color: currentLocation.isNotEmpty
                  ? Colors.green
                  : const Color(0xFFFF6B00),
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  currentLocation.isEmpty
                      ? 'Detecting location...'
                      : 'Location detected',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  currentLocation.isEmpty
                      ? 'GPS location is required for the SOS request.'
                      : currentLocation,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white54,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 8),

          IconButton(
            tooltip: 'Refresh location',
            onPressed:
                loadingLocation ? null : getLocation,
            icon: loadingLocation
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child:
                        CircularProgressIndicator(
                      strokeWidth: 2,
                    ),
                  )
                : const Icon(
                    Icons.my_location,
                    color: Color(0xFFFF6B00),
                  ),
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // MESSAGE
  // ==========================================================

  Widget _buildMessageField() {
    return TextField(
      controller: messageController,
      maxLines: 5,
      style: const TextStyle(
        color: Colors.white,
      ),
      decoration: InputDecoration(
        hintText:
            'Describe your emergency...',
        hintStyle: const TextStyle(
          color: Colors.white38,
        ),
        filled: true,
        fillColor:
            const Color(0xFF151B23),
        prefixIcon: const Padding(
          padding: EdgeInsets.only(
            left: 15,
            right: 10,
            top: 15,
          ),
          child: Icon(
            Icons.message_outlined,
            color: Color(0xFFFF6B00),
          ),
        ),
        prefixIconConstraints:
            const BoxConstraints(
          minWidth: 50,
          minHeight: 50,
        ),
        border: OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
        enabledBorder:
            OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(15),
          borderSide:
              const BorderSide(
            color: Colors.white12,
          ),
        ),
        focusedBorder:
            OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(15),
          borderSide:
              const BorderSide(
            color: Color(0xFFFF6B00),
            width: 1.5,
          ),
        ),
      ),
    );
  }

  // ==========================================================
  // CREATE BUTTON
  // ==========================================================

  Widget _buildCreateButton() {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton.icon(
        onPressed:
            creatingSOS ? null : createSOS,
        style: ElevatedButton.styleFrom(
          backgroundColor:
              const Color(0xFFFF6B00),
          disabledBackgroundColor:
              Colors.white12,
          foregroundColor: Colors.white,
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(17),
          ),
        ),
        icon: creatingSOS
            ? const SizedBox(
                width: 23,
                height: 23,
                child:
                    CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : const Icon(
                Icons.sos_rounded,
                size: 27,
              ),
        label: Text(
          creatingSOS
              ? 'CREATING SOS...'
              : 'CREATE SOS REQUEST',
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }

  // ==========================================================
  // SAFETY MESSAGE
  // ==========================================================

  Widget _buildSafetyMessage() {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.green.withOpacity(0.06),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: Colors.green.withOpacity(0.15),
        ),
      ),
      child: const Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.info_outline,
            color: Colors.green,
            size: 20,
          ),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'Your GPS location is automatically attached to the SOS request. Verify that location services are enabled before sending an emergency request.',
              style: TextStyle(
                color: Colors.white54,
                fontSize: 11,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}