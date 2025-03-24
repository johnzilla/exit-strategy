# Product Context

This file provides a high-level overview of the project and the expected product that will be created. Initially it is based upon projectBrief.md (if provided) and all other available project-related information in the working directory. This file is intended to be updated as the project evolves, and should be used to inform all other modes of the project's goals and context.
2025-03-23 20:35:00 - Initial creation based on exit-strategy-plan.md
2025-03-23 22:38:00 - Updated frontend technology from Flutter to HTML/JS PWA

## Project Goal

The Exit Strategy app helps users escape awkward social situations by triggering real "rescue" texts or calls. The app assigns a Twilio-provided phone number to a VIP contact (e.g., "Mom") in the user's phone, and sends a message or call from that number when needed.

## Key Features

- **Free Tier**: 3 pre-set templates, immediate trigger
- **Paid Tier**: Custom messages, timer delay ($10/month)
- **Frontend**: HTML/JS Progressive Web App (PWA)
- **Backend**: Python Flask API integrated with Twilio
- **External Service**: Twilio for SMS and voice calls
- **Deployment Options**: Docker (containerized) or Vercel (serverless)

## Overall Architecture

The architecture follows a client-server model:
- **Frontend**: HTML/JS Progressive Web App (PWA) with a simple UI for triggering rescues and configuring templates
- **Backend**: Python Flask API that handles rescue requests and integrates with Twilio
- **External Service**: Twilio for sending SMS and making voice calls
- **Deployment**: Docker container or Vercel serverless function

The user flow is:
1. User sets up the app by adding the Twilio number as a VIP contact
2. User selects a template (free tier) or creates a custom message (paid tier)
3. User triggers a rescue (immediate or delayed)
4. Backend receives the request and uses Twilio to send the message/call
5. User receives the "rescue" message/call on their phone

## Development Priorities

- Minimal but good unit and CI pipeline tests
- Security (especially for Twilio credentials)
- Stability
- Clean, maintainable code structure