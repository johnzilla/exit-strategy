# Exit Strategy App

A Flutter mobile application that helps users escape awkward social situations by triggering real "rescue" texts or calls.

## Features

- **Free Tier**: 3 pre-set templates, immediate trigger
- **Paid Tier**: Custom messages, timer delay ($10/month)
- **VIP Contact**: Assign a Twilio-provided phone number to a VIP contact in your phone
- **Rescue Trigger**: Send a message or call from that number when needed

## Getting Started

### Prerequisites

- Flutter SDK (2.17.0 or higher)
- Dart SDK
- Android Studio or VS Code with Flutter extensions
- A Twilio account with a phone number

### Installation

1. Clone the repository:
   ```
   git clone https://github.com/yourusername/exit-strategy.git
   cd exit-strategy/exit-strategy-app
   ```

2. Install dependencies:
   ```
   flutter pub get
   ```

3. Set up environment variables:
   - Copy `.env.example` to `.env`
   - Fill in your Twilio credentials and API key

4. Run the app:
   ```
   flutter run
   ```

## Project Structure

- `lib/models/`: Data models
- `lib/screens/`: UI screens
- `lib/services/`: API and business logic
- `lib/widgets/`: Reusable UI components
- `lib/utils/`: Utility functions
- `test/`: Unit and widget tests

## Architecture

The app follows a Provider pattern for state management:

- **Models**: Data structures for the app
- **Services**: Business logic and API communication
- **Screens**: UI components and user interaction
- **Providers**: State management using the Provider package

## Backend Integration

The app communicates with a Python Flask backend that integrates with Twilio for sending SMS and making voice calls. See the `exit-strategy-backend` directory for more information.

## Testing

Run tests with:
```
flutter test
```

## Deployment

### Android

```
flutter build apk --release
```

### iOS

```
flutter build ios --release
```

## License

This project is licensed under the MIT License - see the LICENSE file for details.