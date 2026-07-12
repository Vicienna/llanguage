class AiMessage {
  final String role;
  final String content;

  const AiMessage({required this.role, required this.content});

  Map<String, dynamic> toJson() => {'role': role, 'content': content};

  factory AiMessage.fromJson(Map<String, dynamic> json) =>
      AiMessage(role: json['role'] as String, content: json['content'] as String);
}

class AiRequest {
  final String model;
  final List<AiMessage> messages;
  final double temperature;
  final int maxTokens;

  const AiRequest({
    required this.model,
    required this.messages,
    this.temperature = 0.7,
    this.maxTokens = 1024,
  });

  Map<String, dynamic> toJson() => {
        'model': model,
        'messages': messages.map((m) => m.toJson()).toList(),
        'temperature': temperature,
        'max_tokens': maxTokens,
      };
}
