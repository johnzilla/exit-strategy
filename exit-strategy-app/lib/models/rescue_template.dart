class RescueTemplate {
  final String id;
  final String title;
  final String message;
  final bool isPremium;
  final bool isCustom;

  RescueTemplate({
    required this.id,
    required this.title,
    required this.message,
    this.isPremium = false,
    this.isCustom = false,
  });

  // Create from JSON
  factory RescueTemplate.fromJson(Map<String, dynamic> json) {
    return RescueTemplate(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      message: json['message'] ?? '',
      isPremium: json['isPremium'] ?? false,
      isCustom: json['isCustom'] ?? false,
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'message': message,
      'isPremium': isPremium,
      'isCustom': isCustom,
    };
  }

  // Create a copy with updated fields
  RescueTemplate copyWith({
    String? id,
    String? title,
    String? message,
    bool? isPremium,
    bool? isCustom,
  }) {
    return RescueTemplate(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      isPremium: isPremium ?? this.isPremium,
      isCustom: isCustom ?? this.isCustom,
    );
  }

  @override
  String toString() {
    return 'RescueTemplate(id: $id, title: $title, message: $message, isPremium: $isPremium, isCustom: $isCustom)';
  }
}