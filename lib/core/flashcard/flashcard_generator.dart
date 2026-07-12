import '../image_analyzer/image_analyzer_service.dart';
import '../translation/models/translation_request.dart';
import '../translation/models/translation_result.dart';
import '../translation/translation_service.dart';
import 'models/flashcard.dart';

class FlashcardGenerator {
  final TranslationService _translationService;
  final ImageAnalyzerService _imageAnalyzer;

  FlashcardGenerator({
    required TranslationService translationService,
    required ImageAnalyzerService imageAnalyzer,
  })  : _translationService = translationService,
        _imageAnalyzer = imageAnalyzer;

  Future<Flashcard> generateFromImage(String imageUrl, String targetLang) async {
    final analysis = await _imageAnalyzer.analyze(imageUrl);
    final word = analysis.label;

    TranslationResult translation;
    try {
      translation = await _translationService.translate(
        TranslationRequest(text: word, targetLang: targetLang),
      );
    } catch (_) {
      translation = TranslationResult(
        translatedText: word,
        sourceText: word,
        detectedSourceLang: 'en',
        targetLang: targetLang,
      );
    }

    return Flashcard(
      word: word,
      translation: translation.translatedText,
      imageUrl: imageUrl,
      definition: analysis.description,
    );
  }

  Future<Flashcard> generateFromText(String word, String targetLang) async {
    final translation = await _translationService.translate(
      TranslationRequest(text: word, targetLang: targetLang),
    );

    final definition = translation.definitions.isNotEmpty
        ? translation.definitions.first
        : null;

    return Flashcard(
      word: word,
      translation: translation.translatedText,
      definition: definition,
    );
  }
}
