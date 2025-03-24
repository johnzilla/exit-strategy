import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class UserSettings {
  String vipContactName;
  String vipPhoneNumber;
  bool preferCallOverText;
  List<String> favoriteTemplateIds;
  String? customMessage;

  UserSettings({
    this.vipContactName = 'Mom',
    this.vipPhoneNumber = '',
    this.preferCallOverText = false,
    this.favoriteTemplateIds = const [],
    this.customMessage,
  });

  // Create from JSON
  factory UserSettings.fromJson(Map<String, dynamic> json) {
    return UserSettings(
      vipContactName: json['vipContactName'] ?? 'Mom',
      vipPhoneNumber: json['vipPhoneNumber'] ?? '',
      preferCallOverText: json['preferCallOverText'] ?? false,
      favoriteTemplateIds: List<String>.from(json['favoriteTemplateIds'] ?? []),
      customMessage: json['customMessage'],
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'vipContactName': vipContactName,
      'vipPhoneNumber': vipPhoneNumber,
      'preferCallOverText': preferCallOverText,
      'favoriteTemplateIds': favoriteTemplateIds,
      'customMessage': customMessage,
    };
  }

  // Create a copy with updated fields
  UserSettings copyWith({
    String? vipContactName,
    String? vipPhoneNumber,
    bool? preferCallOverText,
    List<String>? favoriteTemplateIds,
    String? customMessage,
  }) {
    return UserSettings(
      vipContactName: vipContactName ?? this.vipContactName,
      vipPhoneNumber: vipPhoneNumber ?? this.vipPhoneNumber,
      preferCallOverText: preferCallOverText ?? this.preferCallOverText,
      favoriteTemplateIds: favoriteTemplateIds ?? this.favoriteTemplateIds,
      customMessage: customMessage ?? this.customMessage,
    );
  }

  // Save settings to SharedPreferences
  Future<void> saveToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(toJson());
    await prefs.setString('user_settings', jsonString);
  }

  // Load settings from SharedPreferences
  static Future<UserSettings> loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('user_settings');
    
    if (jsonString == null) {
      return UserSettings();
    }
    
    try {
      final json = jsonDecode(jsonString);
      return UserSettings.fromJson(json);
    } catch (e) {
      // If there's an error parsing the JSON, return default settings
      return UserSettings();
    }
  }

  // Check if settings are complete (VIP contact is set up)
  bool get isSetupComplete => vipPhoneNumber.isNotEmpty && vipContactName.isNotEmpty;

  @override
  String toString() {
    return 'UserSettings(vipContactName: $vipContactName, vipPhoneNumber: $vipPhoneNumber, '
        'preferCallOverText: $preferCallOverText, favoriteTemplateIds: $favoriteTemplateIds, '
        'customMessage: $customMessage)';
  }
}