# Healthcare App

The Healthcare App is a comprehensive solution designed to manage and monitor health-related data. It integrates with Firebase for authentication and data storage, and it supports push notifications to keep users informed about their health updates.

## Features

- **User Authentication**: Sign in with Google and manage user profiles.
- **Health Reports**: Submit and view health reports with images.
- **Push Notifications**: Receive notifications for health updates and reminders.
- **Local Notifications**: Get notified about important health events even when the app is in the background.
- **Profile Management**: View and update user profiles.
- **Symptom Tracking**: Add and track symptoms over time.

## Technologies Used

- **Flutter**: The app is built using Flutter for cross-platform compatibility.
- **Firebase**: Firebase is used for authentication, Firestore for database, and Firebase Messaging for push notifications.
- **Provider**: State management is handled using the Provider package.
- **Local Notifications**: Implemented using the `flutter_local_notifications` package.
- **Time Zone Data**: Managed using the `timezone` package.

## Getting Started

### Prerequisites

- Flutter SDK
- Firebase account

### Installation

1. **Clone the repository**:
    ```sh
    git clone https://github.com/yourusername/healthcare.git
    cd healthcare
    ```

2. **Install dependencies**:
    ```sh
    flutter pub get
    ```

3. **Set up Firebase**:
    - Follow the instructions to set up Firebase for your Flutter project.
    - Add the `google-services.json` file for Android and `GoogleService-Info.plist` for iOS.

4. **Run the app**:
    ```sh
    flutter run
    ```

## Project Structure

- **lib/main.dart**: Entry point of the application.
- **lib/pages/**: Contains the main screens of the app.
- **lib/models/**: Data models used in the app.
- **lib/services/**: Services for notifications and other functionalities.
- **lib/widgets/**: Custom widgets used throughout the app.
- **lib/constants/**: Contains constant values used in the app.

## Usage

- **Sign In**: Use Google Sign-In to authenticate.
- **Submit Health Report**: Fill out the form and submit health reports with images.
- **View Notifications**: Receive and view push and local notifications.
- **Manage Profile**: View and update your profile information.
- **Track Symptoms**: Add and track your symptoms over time.

## Contributing

Contributions are welcome! Please fork the repository and submit a pull request for any improvements or bug fixes.

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Contact

For any questions or suggestions, please contact [supunnimantha199@gmail.com](mailto:supunnimantha199@gmail.com).
