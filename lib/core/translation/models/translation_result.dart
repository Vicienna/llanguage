class TranslationResult {
  final String translatedText;
  final String sourceText;
  final String detectedSourceLang;
  final String targetLang;
  final List<WordBreakdown> wordBreakdown;
  final List<String> definitions;

  const TranslationResult({
    required this.translatedText,
    required this.sourceText,
    required this.detectedSourceLang,
    required this.targetLang,
    this.wordBreakdown = const [],
    this.definitions = const [],
  });

  factory TranslationResult.fromJson(Map<String, dynamic> json) {
    return TranslationResult(
      translatedText: json['translated_text'] as String,
      sourceText: json['source_text'] as String,
      detectedSourceLang: json['detected_source_lang'] as String? ?? 'auto',
      targetLang: json['target_lang'] as String,
      wordBreakdown: (json['word_breakdown'] as List<dynamic>?)
              ?.map((e) => WordBreakdown.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      definitions: (json['definitions'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() => {
        'translated_text': translatedText,
        'source_text': sourceText,
        'detected_source_lang': detectedSourceLang,
        'target_lang': targetLang,
        'word_breakdown': wordBreakdown.map((e) => e.toJson()).toList(),
        'definitions': definitions,
      };
}

class WordBreakdown {
  final String word;
  final String? translation;
  final String? definition;

  const WordBreakdown({required this.word, this.translation, this.definition});

  factory WordBreakdown.fromJson(Map<String, dynamic> json) {
    return WordBreakdown(
      word: json['word'] as String,
      translation: json['translation'] as String?,
      definition: json['definition'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'word': word,
        if (translation != null) 'translation': translation,
        if (definition != null) 'definition': definition,
      };
}
