import '../providers/ai_provider.dart';
import '../providers/openai_compatible.dart';

class AiService {
  final Map<String, AiProvider> _providers = {};
  AiProvider? _activeProvider;

  static final AiService _instance = AiService._();
  static AiService get instance => _instance;
  AiService._();

  void registerProvider(AiProvider provider) {
    _providers[provider.name] = provider;
  }

  void setActiveProvider(String name) {
    final provider = _providers[name];
    if (provider == null) {
      throw ArgumentError('Provider not found: $name');
    }
    _activeProvider = provider;
  }

  AiProvider? get activeProvider => _activeProvider;

  List<AiProvider> get allProviders => _providers.values.toList();

  void loadPresets() {
    final presets = [
      OpenAiCompatible(
        name: 'OpenRouter',
        baseUrl: 'https://openrouter.ai/api',
        defaultModel: 'openai/gpt-4o',
      ),
      OpenAiCompatible(
        name: 'Groq',
        baseUrl: 'https://api.groq.com/openai',
        defaultModel: 'llama-3.3-70b-versatile',
      ),
      OpenAiCompatible(
        name: 'xAI',
        baseUrl: 'https://api.x.ai',
        defaultModel: 'grok-2-latest',
      ),
      OpenAiCompatible(
        name: 'DeepSeek',
        baseUrl: 'https://api.deepseek.com',
        defaultModel: 'deepseek-chat',
      ),
      OpenAiCompatible(
        name: 'Ollama',
        baseUrl: 'http://localhost:11434',
        defaultModel: 'llama3',
        apiKeyRequired: false,
      ),
    ];
    for (final p in presets) {
      registerProvider(p);
    }
  }

  void addCustomProvider({
    required String name,
    required String baseUrl,
    required String defaultModel,
    bool apiKeyRequired = true,
  }) {
    registerProvider(OpenAiCompatible(
      name: name,
      baseUrl: baseUrl,
      defaultModel: defaultModel,
      apiKeyRequired: apiKeyRequired,
    ));
  }
}
