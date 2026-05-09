# 🌿 G.One – AI-Driven Waste Management App ♻️

> **Green One (G.One)** — an AI-powered Flutter mobile app promoting sustainable waste management through **AI waste segregation**, **geolocation-based reporting**, **training modules**, **gamification**, and **recycling center scheduling**.


---

## 🧩 Features

✅ **AI Waste Segregation Scanner**  
- Capture waste images using the camera or gallery  
- Uses Roboflow API to identify waste type (plastic, metal, organic, etc.)  

✅ **Report Illegal Dumping**  
- Submit waste reports with image and geolocation  
- Helps local Green Champions track issues  

✅ **Schedule Pickup**  
- Book waste pickups and connect with nearby recycling centers  

✅ **Nearest Centers Finder**  
- Locate nearby biogas plants, recycling & W2E centers  

✅ **Gamification + Leaderboard**  
- Earn points and badges for contributing to a cleaner environment  

✅ **Training Videos**  
- Watch YouTube-based guides to learn waste segregation  

---

## 🧠 Tech Stack

| Layer | Technology |
|-------|-------------|
| **Frontend** | Flutter (Dart) |
| **State Management** | BLoC & Provider |
| **AI Integration** | Roboflow Detection API |
| **Media Handling** | `image_picker`, `youtube_player_iframe` |
| **Location Services** | `geolocator`, `url_launcher` |
| **UI Components** | Material Design, Google Fonts |
| **(Future)** Backend | Spring Boot (Java), MySQL / Firebase |

---

## 🚀 Project Structure

lib/
┣ 📂 blocs/ # BLoC State Management (Auth, Report, etc.)
┣ 📂 models/ # Data Models (Report, Center, Schedule)
┣ 📂 repositories/ # Data & API handling logic
┣ 📂 screens/ # All UI Screens (Dashboard, Scanner, etc.)
┣ 📜 main.dart # Entry point

