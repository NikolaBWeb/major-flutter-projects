# NeuroBlast Dashboard

NeuroBlast Dashboard is a Flutter-based application designed to provide a comprehensive dashboard for neurological data analysis and visualization.

## Project Overview

This project is a Flutter application that integrates with Firebase for backend services. It's designed to work across multiple platforms including Android, iOS, and web.

## Features

- User authentication using Firebase Auth
- Real-time data synchronization with Cloud Firestore
- Analytics tracking with Firebase Analytics
- Data visualization using fl_chart and syncfusion_flutter_charts
- Responsive design for various screen sizes
- Custom theming for a consistent look and feel

## Getting Started

### Prerequisites

- Flutter SDK (^3.6.0-279.0.dev)
- Dart SDK (^3.6.0-279.0.dev)
- Firebase account and project set up

### Installation

1. Clone the repository:
   ```
   git clone https://github.com/your-username/neuroblast_dashboard.git
   ```

2. Navigate to the project directory:
   ```
   cd neuroblast_dashboard
   ```

3. Install dependencies:
   ```
   flutter pub get
   ```

4. Set up Firebase:
   - Create a new Firebase project
   - Add your app to the Firebase project
   - Download and place the necessary configuration files (google-services.json for Android, GoogleService-Info.plist for iOS)
   - Update the Firebase configuration in the project

5. Run the app:
   ```
   flutter run
   ```

## Project Structure

The main application code is located in the `lib` directory. Key files and directories include:

- `main.dart`: Entry point for the application.
- `providers/`: Contains state management providers.
- `screens/`: Contains all screen widgets for the application.
- `widgets/`: Contains reusable UI components.
- `models/`: Defines data models used in the app.


## Dependencies

Key dependencies for this project include:

dependencies:
  flutter:
    sdk: flutter
  cloud_firestore: ^5.4.3
  cupertino_icons: ^1.0.8
  firebase_analytics: ^11.3.3
  firebase_auth: ^5.3.1
  firebase_core: ^3.6.0
  firebase_storage: ^12.3.2
  flutter_riverpod: ^2.5.1
  google_fonts: ^6.2.1
  very_good_analysis: ^6.0.0
  fl_chart: ^0.69.0
  syncfusion_flutter_charts: ^27.1.52

## Contributing

Contributions to the NeuroBlast Dashboard project are welcome. Please feel free to submit issues, fork the repository and send pull requests!


## Contact

For questions, suggestions, or collaboration opportunities, please reach out to the project maintainer:

- **LinkedIn:** [Nikola Beronja](https://www.linkedin.com/in/nbwebdev/)
- **Email:** nikolaberonja45@gmail.com
- **GitHub:** [NikolaBWeb](https://github.com/NikolaBWeb) 


