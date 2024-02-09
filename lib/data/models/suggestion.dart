class Suggestion {
  final String feedbackText;
  final double feedbackValue;
  final String suggText;
  final String email;

  Suggestion({
    required this.feedbackText,
    required this.feedbackValue,
    required this.suggText,
    required this.email,
  });

  Map toJson() {
    return {
      'feedbackText': feedbackText ?? '',
      'feedbackValue': feedbackValue ?? 0.0,
      'suggText': suggText ?? '',
      'email': email ?? '',
    };
  }
}
