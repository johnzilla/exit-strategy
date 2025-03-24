// Configuration file for the Exit Strategy app
// Contains environment-specific settings and API endpoints

import 'package:flutter_dotenv/flutter_dotenv.dart';

class Config {
  // Backend API URL - update this for production
  static String get backendUrl {
    // Use environment variable if available, otherwise use default
    return dotenv.env['BACKEND_URL'] ?? "http://localhost:8000";
  }
  
  // API endpoints
  static const String sendRescueEndpoint = "/send-rescue";
  static const String templatesEndpoint = "/templates";
  static const String verifySubscriptionEndpoint = "/verify-subscription";
  
  // Subscription settings
  static const double subscriptionPrice = 10.0; // $10/month
  static const String subscriptionId = "exit_strategy_premium";
  
  // Default templates for free tier
  static const List<Map<String, String>> defaultTemplates = [
    {
      "title": "Emergency Call",
      "message": "I need you to come home right away. It's an emergency."
    },
    {
      "title": "Work Emergency",
      "message": "Your boss called. There's an urgent issue at work that needs your attention immediately."
    },
    {
      "title": "Family Emergency",
      "message": "Please call me as soon as possible. There's a family emergency."
    }
  ];
  
  // API authentication
  static String get apiKey {
    return dotenv.env['API_KEY'] ?? "your_api_key_here";
  }
  
  // Get authorization header for API requests
  static Map<String, String> get authHeaders {
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${Config.apiKey}',
    };
  }
}