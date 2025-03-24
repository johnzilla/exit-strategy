import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../config.dart';

class RescueService {
  // API endpoints
  final String _baseUrl = Config.backendUrl;
  final String _sendRescueEndpoint = Config.sendRescueEndpoint;

  // Send a rescue message/call
  Future<void> sendRescue({
    required String message,
    int delayMinutes = 0,
    bool isCall = false,
  }) async {
    try {
      // Get user phone number from settings
      final userPhone = '+1234567890'; // This would come from user settings in a real app
      
      // Prepare request body
      final body = jsonEncode({
        'message': message,
        'user_phone': userPhone,
        'delay_minutes': delayMinutes,
        'is_call': isCall,
        'is_premium': delayMinutes > 0, // Simple check for premium features
      });

      // Send request to backend
      final response = await http.post(
        Uri.parse('${Config.backendUrl}${Config.sendRescueEndpoint}'),
        headers: Config.authHeaders,
        body: body,
      );

      // Handle response
      if (response.statusCode == 200) {
        // Success
        return;
      } else {
        // Error
        final errorData = jsonDecode(response.body);
        throw Exception(errorData['message'] ?? 'Failed to send rescue');
      }
    } catch (e) {
      // For demo purposes, we'll simulate a successful response
      // In a real app, we would throw the exception
      debugPrint('Error sending rescue: $e');
      
      // Simulate API delay
      await Future.delayed(const Duration(seconds: 1));
      
      // In development mode, just pretend it worked
      if (const bool.fromEnvironment('dart.vm.product') == false) {
        debugPrint('DEVELOPMENT MODE: Simulating successful rescue send');
        return;
      } else {
        // In production, throw the error
        rethrow;
      }
    }
  }

  // Get available templates (would be used in a real app with custom templates)
  Future<List<Map<String, String>>> getTemplates() async {
    try {
      // In a real app, this would fetch templates from the backend
      // For this demo, we'll just return the default templates
      await Future.delayed(const Duration(milliseconds: 500));
      return Config.defaultTemplates;
    } catch (e) {
      debugPrint('Error fetching templates: $e');
      return Config.defaultTemplates;
    }
  }

  // Cancel a scheduled rescue (for premium users)
  Future<void> cancelRescue(String rescueId) async {
    try {
      // In a real app, this would make an API call to cancel the rescue
      // For this demo, we'll just simulate a successful cancellation
      await Future.delayed(const Duration(seconds: 1));
      debugPrint('Rescue $rescueId cancelled');
      return;
    } catch (e) {
      debugPrint('Error cancelling rescue: $e');
      rethrow;
    }
  }

  // Get rescue history (would be implemented in a real app)
  Future<List<Map<String, dynamic>>> getRescueHistory() async {
    try {
      // In a real app, this would fetch rescue history from the backend
      // For this demo, we'll just return some mock data
      await Future.delayed(const Duration(seconds: 1));
      
      return [
        {
          'id': '1',
          'message': 'I need you to come home right away. It\'s an emergency.',
          'timestamp': DateTime.now().subtract(const Duration(days: 2)).toIso8601String(),
          'status': 'delivered',
        },
        {
          'id': '2',
          'message': 'Your boss called. There\'s an urgent issue at work that needs your attention immediately.',
          'timestamp': DateTime.now().subtract(const Duration(days: 5)).toIso8601String(),
          'status': 'delivered',
        },
      ];
    } catch (e) {
      debugPrint('Error fetching rescue history: $e');
      return [];
    }
  }
}