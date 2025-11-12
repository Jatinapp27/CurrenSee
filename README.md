Currency Converter App

A modern Flutter application for real-time currency conversion and tracking.
This app allows users to convert between multiple currencies using live exchange rates, view historical trends through interactive charts, and set rate alerts for favorite currencies.

Features
🌍 Real-time currency conversion using API data
📊 Graph view for currency trends
💾 Favorites & saved conversions with SharedPreferences
🔔 Rate alerts (Firebase integration)
🔐 User authentication (Email, Google, Facebook, Twitter)
🎨 Attractive UI with a consistent theme across pages
🧭 Navigation Drawer showing user info and quick links

Tech Stack
Flutter (Dart)
Firebase Authentication & Firestore
Provider for state management
Shared Preferences for local storage
fl_chart for graphs

Project Structure
lib/
├── main.dart
├── core/
│   ├── constants/
│   └── theme/
├── data/
│   ├── models/
│   └── services/
├── screens/
│   ├── auth/
│   ├── home/
│   ├── currency_list/
│   └── profile/
└── widgets/

Clone the repository:
git clone https://github.com/Jatinapp27/CurrenSee.git

Install dependencies:
flutter pub get

Run the app:
flutter run
