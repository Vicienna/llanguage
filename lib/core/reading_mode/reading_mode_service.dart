import 'package:http/http.dart' as http;

class ReadingModeService {
  final http.Client _client;

  ReadingModeService({http.Client? client}) : _client = client ?? http.Client();

  Future<String> fetchContent(String url) async {
    final response = await _client.get(Uri.parse(url));
    if (response.statusCode != 200) {
      throw ReadingException('HTTP ${response.statusCode}');
    }
    return _extractText(response.body);
  }

  String _extractText(String html) {
    final cleaned = _removeTags(html, ['script', 'style', 'nav', 'footer', 'header', 'aside']);
    final body = _extractBody(cleaned);

    final tags = ['p', 'h1', 'h2', 'h3', 'h4', 'h5', 'h6', 'li', 'blockquote'];
    final parts = <String>[];
    for (final tag in tags) {
      final regex = RegExp('<$tag[^>]*>(.*?)</$tag>', dotAll: true, caseSensitive: false);
      for (final match in regex.allMatches(body)) {
        final text = _stripTags(match.group(1)!);
        if (text.trim().isNotEmpty) {
          parts.add(text.trim());
        }
      }
    }
    return parts.join('\n\n');
  }

  String _removeTags(String html, List<String> tags) {
    var result = html;
    for (final tag in tags) {
      result = result.replaceAllMapped(
        RegExp('<$tag[^>]*>.*?</$tag>', dotAll: true, caseSensitive: false),
        (_) => '',
      );
    }
    return result;
  }

  String _extractBody(String html) {
    final match = RegExp('<body[^>]*>(.*?)</body>', dotAll: true, caseSensitive: false)
        .firstMatch(html);
    return match?.group(1) ?? html;
  }

  String _stripTags(String html) {
    return html.replaceAll(RegExp(r'<[^>]*>'), '').trim();
  }

  List<String> extractPotentialVocab(String text, String language) {
    final words = text.split(RegExp(r'\s+'))
        .map((w) => w.replaceAll(RegExp(r"[^\p{L}\p{N}']", unicode: true), ''))
        .where((w) => w.length >= 3 && w.length <= 30)
        .map((w) => w.toLowerCase())
        .toSet()
        .toList();
    words.sort();
    return words;
  }

  void dispose() => _client.close();
}

class ReadingException implements Exception {
  final String message;
  const ReadingException(this.message);
  @override
  String toString() => 'ReadingException: $message';
}
