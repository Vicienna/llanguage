import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/providers/ai_providers.dart';
import '../../core/translation/models/translation_request.dart';
import '../../core/translation/models/translation_result.dart';
import '../../core/translation/translation_cache.dart';
import '../../core/translation/translation_service.dart';
import '../../core/translation/noop_cache_dao.dart';
import '../../core/duckduckgo/duckduckgo_service.dart';
import '../../core/theme/app_colors.dart';

class TranslatorPage extends ConsumerStatefulWidget {
  const TranslatorPage({super.key});

  @override
  ConsumerState<TranslatorPage> createState() => _TranslatorPageState();
}

class _TranslatorPageState extends ConsumerState<TranslatorPage> {
  final _controller = TextEditingController();
  TranslationResult? _result;
  bool _loading = false;
  String _sourceLang = 'auto';
  String _targetLang = 'id';

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _translate() async {
    if (_controller.text.trim().isEmpty) return;
    setState(() { _loading = true; _result = null; });

    try {
      final request = TranslationRequest(
        text: _controller.text.trim(),
        sourceLang: _sourceLang,
        targetLang: _targetLang,
      );

      final ai = ref.read(aiServiceProvider);
      final provider = ai.activeProvider;
      if (provider == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Configure AI provider in Settings first')),
          );
        }
        return;
      }

      final storage = ref.read(secureStorageProvider);
      final apiKey = await storage.getApiKey(provider.name);

      final cache = TranslationCache(NoOpCacheDao());
      final ddg = DuckDuckGoService();
      final service = TranslationService(
        aiProvider: provider,
        ddgService: ddg,
        cache: cache,
        apiKey: apiKey ?? '',
      );

      final result = await service.translate(request);
      if (mounted) setState(() { _result = result; });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      if (mounted) setState(() { _loading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Translator')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            children: [
              _LangDropdown(
                value: _sourceLang,
                label: 'From',
                onChanged: (v) => setState(() { _sourceLang = v!; }),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Icon(Icons.arrow_forward),
              ),
              _LangDropdown(
                value: _targetLang,
                label: 'To',
                onChanged: (v) => setState(() { _targetLang = v!; }),
              ),
            ],
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _controller,
            decoration: InputDecoration(
              hintText: 'Enter text to translate...',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              filled: true,
            ),
            maxLines: 4,
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: _loading ? null : _translate,
            icon: _loading
                ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                : const Icon(Icons.translate),
            label: Text(_loading ? 'Translating...' : 'Translate'),
          ),
          if (_result != null) ...[
            const SizedBox(height: 24),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Translation', style: theme.textTheme.titleMedium),
                    const SizedBox(height: 8),
                    Text(_result!.translatedText, style: theme.textTheme.bodyLarge),
                    if (_result!.definitions.isNotEmpty) ...[
                      const Divider(),
                      Text('Definitions', style: theme.textTheme.titleSmall),
                      const SizedBox(height: 4),
                      ..._result!.definitions.map((d) => Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('• ', style: TextStyle(color: AppColors.info)),
                            Expanded(child: Text(d)),
                          ],
                        ),
                      )),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _LangDropdown extends StatelessWidget {
  final String value;
  final String label;
  final ValueChanged<String?> onChanged;

  const _LangDropdown({required this.value, required this.label, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: DropdownButtonFormField<String>(
        value: value,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        ),
        items: const [
          DropdownMenuItem(value: 'auto', child: Text('Detect')),
          DropdownMenuItem(value: 'en', child: Text('English')),
          DropdownMenuItem(value: 'id', child: Text('Indonesian')),
          DropdownMenuItem(value: 'ja', child: Text('Japanese')),
          DropdownMenuItem(value: 'ko', child: Text('Korean')),
          DropdownMenuItem(value: 'zh', child: Text('Chinese')),
          DropdownMenuItem(value: 'es', child: Text('Spanish')),
          DropdownMenuItem(value: 'fr', child: Text('French')),
          DropdownMenuItem(value: 'de', child: Text('German')),
        ],
        onChanged: onChanged,
      ),
    );
  }
}
