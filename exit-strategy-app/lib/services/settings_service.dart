import 'package:flutter/material.dart';
import '../models/user_settings.dart';

class SettingsService extends ChangeNotifier {
  UserSettings _settings = UserSettings();
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  UserSettings get settings => _settings;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isSetupComplete => _settings.isSetupComplete;

  // Constructor - load settings from SharedPreferences
  SettingsService() {
    _loadSettings();
  }

  // Load settings from SharedPreferences
  Future<void> _loadSettings() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _settings = await UserSettings.loadFromPrefs();
    } catch (e) {
      _errorMessage = 'Failed to load settings: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Save settings to SharedPreferences
  Future<void> saveSettings() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _settings.saveToPrefs();
    } catch (e) {
      _errorMessage = 'Failed to save settings: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Update VIP contact information
  Future<void> updateVipContact({
    required String name,
    required String phoneNumber,
  }) async {
    _settings = _settings.copyWith(
      vipContactName: name,
      vipPhoneNumber: phoneNumber,
    );
    
    await saveSettings();
  }

  // Update preference for call vs text
  Future<void> updateCallPreference(bool preferCall) async {
    _settings = _settings.copyWith(
      preferCallOverText: preferCall,
    );
    
    await saveSettings();
  }

  // Update custom message (premium feature)
  Future<void> updateCustomMessage(String? message) async {
    _settings = _settings.copyWith(
      customMessage: message,
    );
    
    await saveSettings();
  }

  // Add a template to favorites
  Future<void> addFavoriteTemplate(String templateId) async {
    if (!_settings.favoriteTemplateIds.contains(templateId)) {
      final updatedFavorites = List<String>.from(_settings.favoriteTemplateIds)
        ..add(templateId);
      
      _settings = _settings.copyWith(
        favoriteTemplateIds: updatedFavorites,
      );
      
      await saveSettings();
    }
  }

  // Remove a template from favorites
  Future<void> removeFavoriteTemplate(String templateId) async {
    if (_settings.favoriteTemplateIds.contains(templateId)) {
      final updatedFavorites = List<String>.from(_settings.favoriteTemplateIds)
        ..remove(templateId);
      
      _settings = _settings.copyWith(
        favoriteTemplateIds: updatedFavorites,
      );
      
      await saveSettings();
    }
  }

  // Reset settings to default
  Future<void> resetSettings() async {
    _settings = UserSettings();
    await saveSettings();
  }
}