# 📱 G.One Citizen App — Flutter

<div align="center">

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![BLoC](https://img.shields.io/badge/BLoC-13B9FD?style=for-the-badge&logo=flutter&logoColor=white)
![Roboflow](https://img.shields.io/badge/Roboflow_AI-8E44AD?style=for-the-badge&logoColor=white)

**The citizen-facing Flutter app for G.One waste management platform**

</div>

---

## 📌 Overview

The G.One Citizen App allows residents to actively participate in waste management. Citizens can report illegal dumping with AI-assisted classification, schedule waste pickups, find nearby collection centers, earn points and badges, and watch training videos — all from their mobile device.
---

🚀 Live Demo

Citizen App (Flutter)

🔗 https://appetize.io/app/b_tmudra5u7uhtscvsgzt7y3mesq

Admin Dashboard

🔗 https://gone-admin.vercel.app

Backend API

🔗 https://gonebackend-production.up.railway.app

---

## ✨ Features

### 🤖 AI Waste Scanner
- Point camera at any waste item
- Roboflow AI model classifies the waste type in real time
- Result auto-fills the report submission form

### 📸 Report Illegal Dumping
- Capture or upload a photo of the dumping site
- Add a description
- GPS location auto-tagged
- Submit to backend → earn **110 points** instantly

### 🗺️ Nearest Collection Centers
- Uses device GPS to get current location
- Fetches all registered waste centers from backend
- Calculates distance using **Haversine formula**
- Shows centers sorted by nearest first with directions

### 🏆 Leaderboard & Gamification
- Live leaderboard ranked by points (fetched from backend)
- Personal stats: points, level (1–10), streak days, badges
- Encourages continued participation

### 📦 Schedule Waste Pickup
- Enter pickup address
- Select date and time slot
- Track status: Pending → Assigned → Completed

### 🎓 Training Videos
- Browse waste management training modules uploaded by admin
- Watch videos, earn XP on completion

---

## 🏗️ Architecture

Built with **Clean Architecture** pattern:

```
lib/
├── blocs/           # BLoC state management (Events, States, Blocs)
│   ├── auth/
│   ├── report/
│   └── pickup/
├── models/          # Data models (Report, User, PickupRequest)
├── repositories/    # Data layer — calls ApiService, returns models
├── services/        # ApiService — all HTTP calls with JWT headers
├── pages/           # UI screens
│   ├── login_page.dart
│   ├── dashboard_page.dart
│   ├── report_page.dart
│   ├── profile_page.dart
│   ├── leaderboard_page.dart
│   ├── nearest_centers_page.dart
│   ├── schedule_pickup_page.dart
│   └── training_page.dart
└── main.dart
```

---

## 🔐 Authentication

- JWT token stored in memory after login
- Every API request includes `Authorization: Bearer <token>` header
- Auto-redirect to login if token is missing

---

## ⚙️ Tech Stack

- Flutter 3.x / Dart
- BLoC + Provider state management
- `http` — REST API calls
- `image_picker` — camera and gallery photo selection
- `geolocator` — GPS coordinates
- `google_maps_flutter` — map display and location picker
- `uuid` — unique ID generation

---

## 🔗 Related Repositories

- [gone-backend](../gone-backend) — Spring Boot REST API
- [gone-admin](../gone-admin) — Admin Flutter dashboard

