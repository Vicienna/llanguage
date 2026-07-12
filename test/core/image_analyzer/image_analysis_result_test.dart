import 'package:flutter_test/flutter_test.dart';
import 'package:llanguage/core/image_analyzer/models/image_analysis_result.dart';

void main() {
  group('ImageAnalysisResult', () {
    test('fromJson parses full result', () {
      final json = {
        'label': 'cat',
        'description': 'A orange cat sitting on a sofa',
        'objects': [
          {'name': 'cat', 'confidence': 0.98},
          {'name': 'sofa', 'confidence': 0.85},
        ],
      };

      final result = ImageAnalysisResult.fromJson(json);
      expect(result.label, equals('cat'));
      expect(result.description, contains('cat'));
      expect(result.objects.length, equals(2));
      expect(result.objects[0].name, equals('cat'));
      expect(result.objects[0].confidence, equals(0.98));
    });

    test('fromJson handles missing fields', () {
      final result = ImageAnalysisResult.fromJson({});
      expect(result.label, isEmpty);
      expect(result.description, isEmpty);
      expect(result.objects, isEmpty);
    });
  });

  group('DetectedObject', () {
    test('fromJson parses correctly', () {
      final obj = DetectedObject.fromJson({'name': 'dog', 'confidence': 0.95});
      expect(obj.name, equals('dog'));
      expect(obj.confidence, equals(0.95));
    });

    test('fromJson handles integer confidence', () {
      final obj = DetectedObject.fromJson({'name': 'cat', 'confidence': 1});
      expect(obj.confidence, equals(1.0));
    });
  });
}
