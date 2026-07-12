class TranslationRequest {
  final String text;
  final String sourceLang;
  final String targetLang;

  const TranslationRequest({
    required this.text,
    this.sourceLang = 'auto',
    required this.targetLang,
  });

  Map<String, dynamic> toJson() => {
        'text': text,
        'source_lang': sourceLang,
        'target_lang': targetLang,
      };
}
