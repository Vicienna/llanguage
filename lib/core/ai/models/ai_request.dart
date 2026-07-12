class AiMessage {
  final String role;
  final String content;
  final List<String> imageUrls;

  const AiMessage({
    required this.role,
    required this.content,
    this.imageUrls = const [],
  });

  Map<String, dynamic> toJson() {
    if (imageUrls.isEmpty) {
      return {'role': role, 'content': content};
    }
    return {
      'role': role,
      'content': [
        {'type': 'text', 'text': content},
        ...imageUrls.map((url) => {
              'type': 'image_url',
              'image_url': {'url': url},
            }),
      ],
    };
  }

  factory AiMessage.fromJson(Map<String, dynamic> json) {
    final contentRaw = json['content'];
    if (contentRaw is List) {
      final text = contentRaw
          .where((e) => e['type'] == 'text')
          .map((e) => e['text'] as String)
          .join('\n');
      final images = contentRaw
          .where((e) => e['type'] == 'image_url')
          .map((e) => e['image_url']['url'] as String)
          .toList();
      return AiMessage(role: json['role'] as String, content: text, imageUrls: images);
    }
    return AiMessage(role: json['role'] as String, content: contentRaw as String);
  }
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
