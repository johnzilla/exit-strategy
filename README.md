# Exit Strategy

A mobile application that helps users escape awkward social situations by triggering real "rescue" texts or calls.

## Overview

Exit Strategy is a solution for those uncomfortable social situations we all find ourselves in occasionally. The app assigns a Twilio-provided phone number to a VIP contact (e.g., "Mom") in the user's phone, and sends a message or call from that number when needed, providing a socially acceptable excuse to leave.

![Exit Strategy App](https://via.placeholder.com/800x400?text=Exit+Strategy+App)

## Features

- **Free Tier**: 3 pre-set templates, immediate trigger
- **Paid Tier**: Custom messages, timer delay ($10/month)
- **Frontend**: Flutter mobile app (iOS/Android)
- **Backend**: Python Flask API integrated with Twilio
- **External Service**: Twilio for SMS and voice calls
- **Deployment Options**: Docker (containerized) or Vercel (serverless)

## Project Structure

The project is organized into two main components:

- **exit-strategy-app/**: Flutter mobile application
- **exit-strategy-backend/**: Python Flask API backend

## Getting Started

### Prerequisites

- Flutter SDK (2.17.0 or higher)
- Dart SDK
- Python 3.9 or higher
- A Twilio account with a phone number
- pip (Python package manager)

### Installation

#### Frontend (Flutter)

1. Navigate to the app directory:
   ```
   cd exit-strategy-app
   ```

2. Install dependencies:
   ```
   flutter pub get
   ```

3. Set up environment variables:
   - Copy `.env.example` to `.env`
   - Fill in your API key and backend URL

4. Run the app:
   ```
   flutter run
   ```

#### Backend (Python)

1. Navigate to the backend directory:
   ```
   cd exit-strategy-backend
   ```

2. Create a virtual environment:
   ```
   python -m venv venv
   source venv/bin/activate  # On Windows: venv\Scripts\activate
   ```

3. Install dependencies:
   ```
   pip install -r requirements.txt
   ```

4. Set up environment variables:
   - Copy `.env.example` to `.env`
   - Fill in your Twilio credentials and API key

5. Run the app:
   ```
   flask run
   ```

## User Flow

1. User sets up the app by adding the Twilio number as a VIP contact
2. User selects a template (free tier) or creates a custom message (paid tier)
3. User triggers a rescue (immediate or delayed)
4. Backend receives the request and uses Twilio to send the message/call
5. User receives the "rescue" message/call on their phone

## Deployment

### Frontend

#### Android

```
cd exit-strategy-app
flutter build apk --release
```

#### iOS

```
cd exit-strategy-app
flutter build ios --release
```

### Backend

#### Docker

```
cd exit-strategy-backend
docker build -t exit-strategy-backend .
docker run -p 8000:8000 --env-file .env exit-strategy-backend
```

#### Vercel

```
cd exit-strategy-backend
vercel
```

## Development

### Implementation Plan

See [exit-strategy-implementation-plan.md](exit-strategy-implementation-plan.md) for detailed development steps and timeline.

### Architecture

- **Client-Server Architecture**: Flutter mobile app communicating with Python backend
- **State Management**: Provider pattern for Flutter app
- **API Communication**: RESTful API with Flask
- **External Integration**: Twilio API for SMS and voice calls

## Testing

### Frontend

```
cd exit-strategy-app
flutter test
```

### Backend

```
cd exit-strategy-backend
pytest
```

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- Twilio for providing the SMS and voice call API
- Flutter team for the excellent mobile app framework
- Flask team for the lightweight Python web framework
