class DdgResult {
  final String query;
  final String? abstractText;
  final String? abstractSource;
  final String? answer;
  final String? definition;
  final List<DdgRelatedTopic> relatedTopics;
  final List<DdgImage> images;

  const DdgResult({
    required this.query,
    this.abstractText,
    this.abstractSource,
    this.answer,
    this.definition,
    this.relatedTopics = const [],
    this.images = const [],
  });

  factory DdgResult.fromJson(String query, Map<String, dynamic> json) {
    final related = (json['RelatedTopics'] as List<dynamic>?)
            ?.map((e) => DdgRelatedTopic.fromJson(e as Map<String, dynamic>))
            .where((t) => t.text != null)
            .toList() ??
        [];

    final images = (json['Image'] as String?) != null
        ? [DdgImage(url: json['Image'] as String, title: json['Heading'] as String?)]
        : <DdgImage>[];

    return DdgResult(
      query: query,
      abstractText: json['Abstract'] as String?,
      abstractSource: json['AbstractSource'] as String?,
      answer: json['Answer'] as String?,
      definition: json['Definition'] as String?,
      relatedTopics: related,
      images: images,
    );
  }
}

class DdgRelatedTopic {
  final String? text;
  final String? firstUrl;
  final String? iconUrl;

  const DdgRelatedTopic({this.text, this.firstUrl, this.iconUrl});

  factory DdgRelatedTopic.fromJson(Map<String, dynamic> json) {
    String? text;
    final result = json['Result'] as String?;
    if (result != null) {
      final stripped = result.replaceAll(RegExp(r'<[^>]*>'), '');
      text = stripped.trim();
    }
    return DdgRelatedTopic(
      text: text,
      firstUrl: json['FirstURL'] as String?,
      iconUrl: (json['Icon'] as Map<String, dynamic>?)?['URL'] as String?,
    );
  }
}

class DdgImage {
  final String url;
  final String? title;

  const DdgImage({required this.url, this.title});
}
