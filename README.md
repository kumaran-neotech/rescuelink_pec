#  RescueLink

![Flutter](https://img.shields.io/badge/Flutter-3.0+-blue)
![Dart](https://img.shields.io/badge/Dart-3.0-blue)
![Platform](https://img.shields.io/badge/Platform-Android-green)
![AI](https://img.shields.io/badge/AI-Vosk-orange)
![Status](https://img.shields.io/badge/Status-Active-success)
![License](https://img.shields.io/badge/License-MIT-yellow)

### Offline Disaster Communication & Emergency Response Network

RescueLink is an AI-powered offline emergency communication platform designed for disaster situations where mobile towers, internet connectivity, and traditional communication systems fail.

The system allows affected people to generate SOS requests using voice or text and relay them through nearby devices using Bluetooth mesh communication until they reach rescue volunteers.

---

## Problem Statement

During floods, earthquakes, cyclones, landslides, and other disasters, communication infrastructure often becomes unavailable.

People cannot:

- Contact emergency services
- Share their location
- Request rescue assistance
- Communicate with nearby rescue teams

RescueLink solves this problem through an offline-first communication network.

---

## Key Features

###  Offline SOS Generation

Users can generate emergency requests without internet.

###  Voice-to-Text AI

Using Vosk Offline Speech Recognition.

- No internet required
- Works completely on-device
- Converts voice into emergency messages

###  Bluetooth Mesh Communication

Using Nearby Connections API.

Messages can hop between nearby devices until they reach a volunteer.

###  Smart Ticket System

Each emergency request generates:

- Unique Ticket ID
- Priority Level
- Number of Victims
- Emergency Type
- Timestamp

###  Location Tracking

Stores GPS coordinates when available.

###  Volunteer Dashboard

Rescue teams can:

- View tickets
- Accept requests
- Track emergencies
- Update rescue status

###  Offline First Design

Core functionality works even without:

- Internet
- Mobile network
- Wi-Fi

---

## Tech Stack

### Frontend

- Flutter
- Dart

### AI

- Vosk Offline Speech Recognition

### Communication

- Nearby Connections API
- Bluetooth

### Local Storage

- Hive Database

### Maps

- OpenStreetMap
- Flutter Map

### Location

- Geolocator

---

## Architecture

User
↓
Voice / Text SOS
↓
Vosk AI Processing
↓
Ticket Generation
↓
Bluetooth Relay Network
↓
Volunteer Dashboard
↓
Rescue Team

---

## Screenshots

### Login Screen

(Add screenshot)

### Emergency Ticket

(Add screenshot)

### Voice Recognition

(Add screenshot)

### Volunteer Dashboard

(Add screenshot)

---

## Future Improvements

- AI Prioritization Engine
- Disaster Prediction Integration
- Satellite Communication Support
- LoRa Long Range Communication
- Multi-language Voice Recognition
- Emergency Heatmaps

---

## Team

### Team RescueLink

- Kumaran S
- Pragadesh B
- Vishal M
- Lokeshwaran A

---

## Impact

RescueLink aims to ensure that no emergency request is lost simply because communication infrastructure fails.

"Even when networks fail, RescueLink connects lives."

---

## License

MIT License
