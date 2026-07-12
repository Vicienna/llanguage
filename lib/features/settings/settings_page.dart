import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/providers/ai_providers.dart';
import '../../core/theme/app_colors.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final aiService = ref.watch(aiServiceProvider);
    final providers = aiService.allProviders;
    final active = aiService.activeProvider;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('AI Provider', style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          )),
          const SizedBox(height: 8),
          Text(
            active != null ? 'Active: ${active.name}' : 'No provider selected',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 16),
          ...providers.map((p) => _ProviderCard(
            provider: p,
            isActive: p.name == active?.name,
            onTap: () {
              aiService.setActiveProvider(p.name);
              ref.invalidate(aiServiceProvider);
            },
            ref: ref,
          )),
        ],
      ),
    );
  }
}

class _ProviderCard extends ConsumerWidget {
  final dynamic provider;
  final bool isActive;
  final VoidCallback onTap;
  final WidgetRef ref;

  const _ProviderCard({
    required this.provider,
    required this.isActive,
    required this.onTap,
    required this.ref,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    return Card(
      elevation: isActive ? 3 : 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: isActive ? BorderSide(color: theme.colorScheme.primary, width: 2) : BorderSide.none,
      ),
      child: ExpansionTile(
        leading: CircleAvatar(
          backgroundColor: isActive
              ? theme.colorScheme.primary.withValues(alpha: 0.15)
              : theme.colorScheme.surfaceContainerHighest,
          child: Icon(Icons.smart_toy, color: isActive ? theme.colorScheme.primary : null),
        ),
        title: Text(provider.name, style: theme.textTheme.titleMedium?.copyWith(
          fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
        )),
        subtitle: Text(provider.baseUrl),
        trailing: isActive
            ? Icon(Icons.check_circle, color: AppColors.success)
            : const Icon(Icons.radio_button_unchecked),
        onExpansionChanged: (_) => onTap(),
        children: [
          if (provider.apiKeyRequired) _ApiKeyInput(providerName: provider.name, ref: ref),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Row(
              children: [
                Text('Model: ', style: theme.textTheme.bodySmall),
                Text(provider.defaultModel, style: theme.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w600,
                )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ApiKeyInput extends ConsumerStatefulWidget {
  final String providerName;
  final WidgetRef ref;

  const _ApiKeyInput({required this.providerName, required this.ref});

  @override
  ConsumerState<_ApiKeyInput> createState() => _ApiKeyInputState();
}

class _ApiKeyInputState extends ConsumerState<_ApiKeyInput> {
  final _controller = TextEditingController();
  bool _obscured = true;
  bool _saved = false;

  @override
  void initState() {
    super.initState();
    _loadKey();
  }

  Future<void> _loadKey() async {
    final storage = ref.read(secureStorageProvider);
    final key = await storage.getApiKey(widget.providerName);
    if (key != null) {
      _controller.text = key;
      setState(() => _saved = true);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              obscureText: _obscured,
              decoration: InputDecoration(
                hintText: 'API Key',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                isDense: true,
                suffixIcon: _saved
                    ? const Icon(Icons.check, color: AppColors.success)
                    : null,
              ),
            ),
          ),
          IconButton(
            icon: Icon(_obscured ? Icons.visibility_off : Icons.visibility),
            onPressed: () => setState(() => _obscured = !_obscured),
          ),
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () async {
              final storage = ref.read(secureStorageProvider);
              await storage.saveApiKey(widget.providerName, _controller.text);
              setState(() => _saved = true);
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('API Key saved')),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
