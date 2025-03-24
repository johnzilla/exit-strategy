# Exit Strategy Backend

A Python Flask API that integrates with Twilio to send "rescue" texts or calls for the Exit Strategy app.

## Features

- **Send Rescue**: API endpoint to send SMS or voice calls via Twilio
- **Templates**: API endpoint to get available message templates
- **Subscription Verification**: API endpoint to verify premium subscriptions
- **Delayed Rescues**: Support for scheduling delayed rescues (premium feature)

## Getting Started

### Prerequisites

- Python 3.9 or higher
- A Twilio account with a phone number
- pip (Python package manager)

### Installation

1. Clone the repository:
   ```
   git clone https://github.com/yourusername/exit-strategy.git
   cd exit-strategy/exit-strategy-backend
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

## API Endpoints

### Send Rescue

```
POST /send-rescue
```

Request body:
```json
{
  "message": "I need you to come home right away. It's an emergency.",
  "user_phone": "+1234567890",
  "delay_minutes": 0,
  "is_call": false,
  "is_premium": false
}
```

Response:
```json
{
  "success": true,
  "message": "Rescue sent successfully",
  "rescue_id": "SM123456789"
}
```

### Get Templates

```
GET /templates
```

Response:
```json
{
  "success": true,
  "templates": [
    {
      "id": "template_1",
      "title": "Emergency Call",
      "message": "I need you to come home right away. It's an emergency.",
      "isPremium": false,
      "isCustom": false
    },
    ...
  ]
}
```

### Verify Subscription

```
POST /verify-subscription
```

Request body:
```json
{
  "subscription_id": "exit_strategy_premium"
}
```

Response:
```json
{
  "success": true,
  "is_premium": true,
  "expiration_date": "2025-04-23T20:07:41.123456"
}
```

## Deployment Options

### Docker

Build and run the Docker container:
```
docker build -t exit-strategy-backend .
docker run -p 8000:8000 --env-file .env exit-strategy-backend
```

### Vercel

Deploy to Vercel:
```
vercel
```

## Security

- API key authentication is required for all endpoints
- Environment variables are used for sensitive information
- Input validation is performed on all requests

## License

This project is licensed under the MIT License - see the LICENSE file for details.