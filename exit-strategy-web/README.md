# Exit Strategy Web Frontend

A simple HTML/JS Progressive Web App (PWA) for the Exit Strategy application.

## Overview

This web frontend allows users to:
- Set up a rescue contact
- Trigger rescue messages/calls using pre-defined templates
- Access premium features (custom messages and delayed rescues)

## Project Structure

```
exit-strategy-web/
├── index.html         # Main HTML file
├── styles.css         # CSS styles
├── app.js             # Main JavaScript file
├── api.js             # API integration
├── config.js          # Configuration settings
├── manifest.json      # PWA manifest
├── service-worker.js  # Service worker for offline functionality
├── icons/             # PWA icons
└── README.md          # This file
```

## Setup and Usage

### Local Development

1. Create the icons directory and add necessary icons:

```bash
mkdir -p icons
# Add icon files to the icons directory
```

2. Serve the directory with a local web server:

```bash
# Using Python
python -m http.server 8000

# Or using Node.js with http-server
npx http-server
```

3. Open your browser and navigate to `http://localhost:8000`

### Connecting to Backend

By default, the app expects the backend API to be available at `/api`. You can modify the `API_URL` constant in `app.js` to point to your backend:

```javascript
// In app.js
const API_URL = 'https://your-backend-url.com/api';
```

## API Integration

The web app communicates with the backend using the following endpoint:

- `POST /api/send-rescue`: Triggers a rescue message/call
  - Request body:
    ```json
    {
      "phone_number": "+1234567890",
      "contact_name": "Mom",
      "message": "Emergency! Call me ASAP!",
      "delay_minutes": 0
    }
    ```

## Deployment

This web app can be deployed to any static hosting service:

1. GitHub Pages
2. Netlify
3. Vercel
4. Firebase Hosting
5. AWS S3 + CloudFront

## PWA Features

This app is a Progressive Web App (PWA) with the following features:
- Installable on desktop and mobile devices
- Works offline (basic functionality)
- Responsive design for all screen sizes