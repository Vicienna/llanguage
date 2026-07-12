class Flashcard {
  final String word;
  final String translation;
  final String? exampleSentence;
  final String? imageUrl;
  final String? definition;

  const Flashcard({
    required this.word,
    required this.translation,
    this.exampleSentence,
    this.imageUrl,
    this.definition,
  });
}
