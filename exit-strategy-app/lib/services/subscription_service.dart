import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../config.dart';

class SubscriptionService extends ChangeNotifier {
  bool _isPremiumUser = false;
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  bool get isPremiumUser => _isPremiumUser;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Constructor - load subscription status from SharedPreferences
  SubscriptionService() {
    _loadSubscriptionStatus();
  }

  // Load subscription status from SharedPreferences
  Future<void> _loadSubscriptionStatus() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _isPremiumUser = prefs.getBool('isPremiumUser') ?? false;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to load subscription status: $e';
      notifyListeners();
    }
  }

  // Save subscription status to SharedPreferences
  Future<void> _saveSubscriptionStatus() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isPremiumUser', _isPremiumUser);
    } catch (e) {
      _errorMessage = 'Failed to save subscription status: $e';
      notifyListeners();
    }
  }

  // Start the purchase flow
  Future<void> startPurchase(BuildContext context) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // In a real app, this would connect to the in_app_purchase API
      // For this demo, we'll simulate a successful purchase
      await _simulatePurchaseFlow(context);
    } catch (e) {
      _errorMessage = 'Purchase failed: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Simulate purchase flow (for demo purposes)
  Future<void> _simulatePurchaseFlow(BuildContext context) async {
    // Show a confirmation dialog
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Purchase'),
        content: Text(
          'Subscribe to Exit Strategy Premium for \$${Config.subscriptionPrice}/month?\n\n'
          'Features include:\n'
          '• Custom rescue messages\n'
          '• Delayed rescue timing\n'
          '• Priority support',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Subscribe'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.amber,
            ),
          ),
        ],
      ),
    );

    if (result == true) {
      // Simulate API call delay
      await Future.delayed(const Duration(seconds: 2));
      
      // Update subscription status
      _isPremiumUser = true;
      await _saveSubscriptionStatus();
      
      // Show success message
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Successfully subscribed to Premium!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    }
  }

  // Cancel subscription
  Future<void> cancelSubscription(BuildContext context) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // In a real app, this would connect to the in_app_purchase API
      // For this demo, we'll simulate a successful cancellation
      await Future.delayed(const Duration(seconds: 1));
      
      _isPremiumUser = false;
      await _saveSubscriptionStatus();
      
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Subscription cancelled'),
          ),
        );
      }
    } catch (e) {
      _errorMessage = 'Failed to cancel subscription: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Verify subscription with backend (would be used in a real app)
  Future<bool> verifySubscription() async {
    try {
      // In a real app, this would make an API call to verify the subscription
      // For this demo, we'll just return the current status
      return _isPremiumUser;
    } catch (e) {
      _errorMessage = 'Failed to verify subscription: $e';
      notifyListeners();
      return false;
    }
  }

  // For testing/demo purposes only - toggle premium status
  void togglePremiumStatus() {
    _isPremiumUser = !_isPremiumUser;
    _saveSubscriptionStatus();
    notifyListeners();
  }
}