import 'package:flutter/material.dart';
import '../app_data.dart';

class EmergencyScreen extends StatefulWidget {
  const EmergencyScreen({super.key});

  @override
  State<EmergencyScreen> createState() =>
      _EmergencyScreenState();
}

class _EmergencyScreenState
    extends State<EmergencyScreen> {

  // ==========================================================
  // CONTROLLERS
  // ==========================================================

  final TextEditingController locationController =
      TextEditingController();

  final TextEditingController messageController =
      TextEditingController();

  // ==========================================================
  // EMERGENCY OPTIONS
  // ==========================================================

  String? selectedEmergency;

  String selectedPriority = "High";

  int victims = 1;

  final List<String> emergencyTypes = [
    "Medical Emergency",
    "Fire",
    "Flood",
    "Earthquake",
    "Landslide",
    "Accident",
    "Trapped Person",
    "Building Collapse",
    "Missing Person",
    "Other",
  ];

  // ==========================================================
  // DISPOSE
  // ==========================================================

  @override
  void dispose() {
    locationController.dispose();
    messageController.dispose();
    super.dispose();
  }

  // ==========================================================
  // CREATE SOS
  // ==========================================================

  void createSOS() {

    if (selectedEmergency == null) {
      _showError(
        "Please select the type of emergency.",
      );
      return;
    }

    if (locationController.text.trim().isEmpty) {
      _showError(
        "Please enter your location.",
      );
      return;
    }

    if (messageController.text.trim().isEmpty) {
      _showError(
        "Please enter an emergency message.",
      );
      return;
    }

    // SAVE REQUEST
    AppData.instance.addRequest(
      type: selectedEmergency!,
      victims: victims,
      location: locationController.text.trim(),
      priority: selectedPriority,
      message: messageController.text.trim(),
    );

    // SUCCESS MESSAGE
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          "Emergency SOS request created successfully!",
        ),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 3),
      ),
    );

    // CLEAR FORM
    setState(() {
      selectedEmergency = null;
      selectedPriority = "High";
      victims = 1;
      locationController.clear();
      messageController.clear();
    });
  }

  // ==========================================================
  // ERROR MESSAGE
  // ==========================================================

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.redAccent,
      ),
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
          "Emergency SOS",
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

              // ==================================================
              // SOS HEADER
              // ==================================================

              _buildHeader(),

              const SizedBox(height: 25),

              // ==================================================
              // EMERGENCY TYPE
              // ==================================================

              _sectionTitle(
                "Type of Emergency",
                Icons.warning_amber_rounded,
              ),

              const SizedBox(height: 12),

              _buildEmergencyDropdown(),

              const SizedBox(height: 25),

              // ==================================================
              // NUMBER OF VICTIMS
              // ==================================================

              _sectionTitle(
                "Number of Victims",
                Icons.people_alt_outlined,
              ),

              const SizedBox(height: 12),

              _buildVictimCounter(),

              const SizedBox(height: 25),

              // ==================================================
              // PRIORITY
              // ==================================================

              _sectionTitle(
                "Emergency Priority",
                Icons.priority_high_rounded,
              ),

              const SizedBox(height: 12),

              _buildPrioritySelector(),

              const SizedBox(height: 25),

              // ==================================================
              // LOCATION
              // ==================================================

              _sectionTitle(
                "Location",
                Icons.location_on_outlined,
              ),

              const SizedBox(height: 12),

              TextField(
                controller: locationController,
                style: const TextStyle(
                  color: Colors.white,
                ),
                decoration: InputDecoration(
                  hintText:
                      "Enter your current location",
                  hintStyle: const TextStyle(
                    color: Colors.white38,
                  ),
                  filled: true,
                  fillColor:
                      const Color(0xFF151B23),
                  prefixIcon: const Icon(
                    Icons.location_on_outlined,
                    color: Color(0xFFFF6B00),
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
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 25),

              // ==================================================
              // MERGED TEXT SOS
              // ==================================================

              _sectionTitle(
                "Emergency Message",
                Icons.message_outlined,
              ),

              const SizedBox(height: 12),

              TextField(
                controller: messageController,
                maxLines: 5,
                style: const TextStyle(
                  color: Colors.white,
                ),
                decoration: InputDecoration(
                  hintText:
                      "Describe your emergency...",
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
              ),

              const SizedBox(height: 30),

              // ==================================================
              // CREATE SOS BUTTON
              // ==================================================

              _buildCreateButton(),

              const SizedBox(height: 20),

              // ==================================================
              // SAFETY MESSAGE
              // ==================================================

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
            const Color(0xFFFF6B00)
                .withOpacity(0.20),
            const Color(0xFF151B23),
          ],
        ),
        borderRadius:
            BorderRadius.circular(22),
        border: Border.all(
          color: const Color(0xFFFF6B00)
              .withOpacity(0.30),
        ),
      ),
      child: Row(
        children: [

          Container(
            width: 65,
            height: 65,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFFF6B00)
                  .withOpacity(0.15),
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
                  "Emergency SOS",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                SizedBox(height: 5),

                Text(
                  "Send your emergency details to nearby rescue volunteers.",
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
        borderRadius:
            BorderRadius.circular(15),
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
            "Select emergency type",
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
          onChanged: (value) {
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
        borderRadius:
            BorderRadius.circular(15),
        border: Border.all(
          color: Colors.white12,
        ),
      ),
      child: Row(
        mainAxisAlignment:
            MainAxisAlignment.spaceBetween,
        children: [

          const Text(
            "People requiring help",
            style: TextStyle(
              color: Colors.white70,
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
                    "$victims",
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
      borderRadius:
          BorderRadius.circular(12),
      child: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: const Color(0xFFFF6B00)
              .withOpacity(0.12),
          borderRadius:
              BorderRadius.circular(12),
        ),
        child: Icon(
          icon,
          color: const Color(0xFFFF6B00),
        ),
      ),
    );
  }

  // ==========================================================
  // PRIORITY SELECTOR
  // ==========================================================

  Widget _buildPrioritySelector() {
    return Row(
      children: [

        Expanded(
          child: _priorityButton(
            "Low",
            Colors.green,
          ),
        ),

        const SizedBox(width: 10),

        Expanded(
          child: _priorityButton(
            "Medium",
            Colors.orange,
          ),
        ),

        const SizedBox(width: 10),

        Expanded(
          child: _priorityButton(
            "High",
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
    final selected =
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
            const EdgeInsets.symmetric(
          vertical: 14,
        ),
        decoration: BoxDecoration(
          color: selected
              ? color.withOpacity(0.20)
              : const Color(0xFF151B23),
          borderRadius:
              BorderRadius.circular(13),
          border: Border.all(
            color: selected
                ? color
                : Colors.white12,
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Column(
          children: [

            Icon(
              priority == "High"
                  ? Icons.priority_high
                  : priority == "Medium"
                      ? Icons.remove
                      : Icons.check,
              color: selected
                  ? color
                  : Colors.white38,
            ),

            const SizedBox(height: 5),

            Text(
              priority,
              style: TextStyle(
                color: selected
                    ? color
                    : Colors.white54,
                fontWeight:
                    selected
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
  // CREATE BUTTON
  // ==========================================================

  Widget _buildCreateButton() {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton.icon(
        onPressed: createSOS,
        style: ElevatedButton.styleFrom(
          backgroundColor:
              const Color(0xFFFF6B00),
          foregroundColor: Colors.white,
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(17),
          ),
        ),
        icon: const Icon(
          Icons.sos_rounded,
          size: 27,
        ),
        label: const Text(
          "CREATE SOS REQUEST",
          style: TextStyle(
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
        borderRadius:
            BorderRadius.circular(15),
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
              "Make sure your emergency information and location are correct before creating the SOS request.",
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