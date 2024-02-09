class SuggestionModel {
  final String id;
  final String email;
  final String feedbackText;
  final int feedbackValue;
  final String suggText;

  SuggestionModel({
    required this.id,
    required this.email,
    required this.feedbackText,
    required this.feedbackValue,
    required this.suggText,
  });

  factory SuggestionModel.fromJson(Map<String, dynamic> json) {
    return SuggestionModel(
      id: json['_id'],
      email: json['email'],
      feedbackText: json['feedbackText'],
      feedbackValue: json['feedbackValue'],
      suggText: json['suggText'],
    );
  }
}
