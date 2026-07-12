class ImageAnalysisResult {
  final String label;
  final String description;
  final List<DetectedObject> objects;

  const ImageAnalysisResult({
    required this.label,
    required this.description,
    this.objects = const [],
  });

  factory ImageAnalysisResult.fromJson(Map<String, dynamic> json) {
    return ImageAnalysisResult(
      label: json['label'] as String? ?? '',
      description: json['description'] as String? ?? '',
      objects: (json['objects'] as List<dynamic>?)
              ?.map((e) => DetectedObject.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

class DetectedObject {
  final String name;
  final double confidence;

  const DetectedObject({required this.name, required this.confidence});

  factory DetectedObject.fromJson(Map<String, dynamic> json) {
    return DetectedObject(
      name: json['name'] as String,
      confidence: (json['confidence'] as num).toDouble(),
    );
  }
}
