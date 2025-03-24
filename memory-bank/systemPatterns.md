# System Patterns

This file documents recurring patterns and standards used in the project.
It is optional, but recommended to be updated as the project evolves.
2025-03-23 20:36:00 - Initial creation.
2025-03-23 22:38:00 - Updated frontend patterns from Flutter to HTML/JS PWA.

## Coding Patterns

### Frontend (HTML/JS PWA)

- **State Management**: Use localStorage for persistent state
- **API Communication**: Use Fetch API for backend communication
- **Error Handling**: Implement try-catch blocks with user-friendly error messages
- **Code Organization**:
  - Separate concerns (HTML, CSS, JS)
  - Modular JavaScript files (app.js, api.js, config.js)
  - Use classes for encapsulation

### Backend (Python)

- **API Structure**: RESTful API with Flask
- **Error Handling**: Use proper HTTP status codes and error messages
- **Security**: 
  - Store sensitive information in environment variables
  - Validate input data
  - Implement proper authentication for paid features
- **Code Organization**:
  - Separate routes from business logic
  - Use services for external API communication (Twilio)

## Architectural Patterns

- **Client-Server Architecture**: Flutter mobile app communicating with Python backend
- **Microservices**: Backend focused on a single responsibility (sending rescue messages)
- **API Gateway**: Use API gateway pattern for routing requests to the backend
- **Environment-based Configuration**: Different configurations for development, testing, and production

## Testing Patterns

- **Unit Testing**: Test individual components in isolation
- **Integration Testing**: Test communication between components
- **Mocking**: Mock external services (Twilio) for testing
- **Test-Driven Development**: Write tests before implementing features
- **Continuous Integration**: Automate testing with GitHub Actions