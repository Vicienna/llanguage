class AiUsage {
  final int promptTokens;
  final int completionTokens;

  const AiUsage({required this.promptTokens, required this.completionTokens});

  factory AiUsage.fromJson(Map<String, dynamic> json) => AiUsage(
        promptTokens: json['prompt_tokens'] as int,
        completionTokens: json['completion_tokens'] as int,
      );
}

class AiResponse {
  final String content;
  final String model;
  final AiUsage? usage;

  const AiResponse({required this.content, required this.model, this.usage});

  factory AiResponse.fromJson(Map<String, dynamic> json) {
    final choices = json['choices'] as List<dynamic>;
    final message = choices.first['message'] as Map<String, dynamic>;
    return AiResponse(
      content: message['content'] as String,
      model: json['model'] as String,
      usage: json['usage'] != null ? AiUsage.fromJson(json['usage'] as Map<String, dynamic>) : null,
    );
  }
}
