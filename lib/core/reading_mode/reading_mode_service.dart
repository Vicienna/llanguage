import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as html_parser;
import 'package:html/dom.dart' as html_dom;

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
    final document = html_parser.parse(html);
    document.querySelectorAll('script, style, nav, footer, header, aside')
        .forEach((e) => e.remove());

    final body = document.body;
    if (body == null) return '';

    final paragraphs = body.querySelectorAll('p, h1, h2, h3, h4, h5, h6, li, blockquote');
    return paragraphs
        .map((e) => e.text.trim())
        .where((t) => t.isNotEmpty)
        .join('\n\n');
  }

  List<String> extractPotentialVocab(String text, String language) {
    final words = text.split(RegExp(r'\s+'))
        .map((w) => w.replaceAll(RegExp(r'[^\p{L}\p{N}\']'), ''))
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
