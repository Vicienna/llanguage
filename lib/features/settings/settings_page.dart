import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/providers/ai_providers.dart';
import '../../core/providers/settings_provider.dart';
import '../../core/theme/app_colors.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ai = ref.watch(aiServiceProvider);
    final activeName = ref.watch(activeProviderNameProvider);
    final providers = ai.allProviders;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('AI Provider', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(
            activeName != null ? 'Active: $activeName' : 'No provider selected',
            style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
          ),
          const SizedBox(height: 16),
          ...providers.map((p) => _ProviderCard(
            key: ValueKey(p.name),
            provider: p,
            isActive: p.name == activeName,
          )),
          const SizedBox(height: 24),
          OutlinedButton.icon(
            onPressed: () => _showAddCustomDialog(context, ref),
            icon: const Icon(Icons.add),
            label: const Text('Add Custom Provider'),
          ),
        ],
      ),
    );
  }

  void _showAddCustomDialog(BuildContext context, WidgetRef ref) {
    final nameCtl = TextEditingController();
    final urlCtl = TextEditingController(text: 'https://');
    final modelCtl = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Custom Provider'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameCtl, decoration: const InputDecoration(labelText: 'Name', hintText: 'My Provider')),
            TextField(controller: urlCtl, decoration: const InputDecoration(labelText: 'Base URL', hintText: 'https://api.example.com')),
            TextField(controller: modelCtl, decoration: const InputDecoration(labelText: 'Default Model', hintText: 'gpt-4o-mini')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          FilledButton(onPressed: () async {
            await addCustomProvider(ref,
              name: nameCtl.text,
              baseUrl: urlCtl.text,
              defaultModel: modelCtl.text,
            );
            await setActiveProvider(ref, nameCtl.text);
            if (ctx.mounted) Navigator.pop(ctx);
          }, child: const Text('Add')),
        ],
      ),
    );
  }
}

class _ProviderCard extends ConsumerStatefulWidget {
  final dynamic provider;
  final bool isActive;

  const _ProviderCard({super.key, required this.provider, required this.isActive});

  @override
  ConsumerState<_ProviderCard> createState() => _ProviderCardState();
}

class _ProviderCardState extends ConsumerState<_ProviderCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final p = widget.provider;
    return Card(
      elevation: widget.isActive ? 3 : 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: widget.isActive ? BorderSide(color: theme.colorScheme.primary, width: 2) : BorderSide.none,
      ),
      child: Column(
        children: [
          ListTile(
            leading: CircleAvatar(
              backgroundColor: widget.isActive
                  ? theme.colorScheme.primary.withValues(alpha: 0.15)
                  : theme.colorScheme.surfaceContainerHighest,
              child: Icon(Icons.smart_toy, color: widget.isActive ? theme.colorScheme.primary : null),
            ),
            title: Text(p.name, style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: widget.isActive ? FontWeight.bold : FontWeight.normal,
            )),
            subtitle: Text(p.baseUrl, maxLines: 1, overflow: TextOverflow.ellipsis),
            trailing: widget.isActive
                ? const Icon(Icons.check_circle, color: AppColors.success)
                : const Icon(Icons.radio_button_unchecked),
            onTap: () async {
              await setActiveProvider(ref, p.name);
            },
          ),
          if (_expanded) ...[
            if (p.apiKeyRequired) _ApiKeyInput(providerName: p.name),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Row(
                children: [
                  Text('Model: ', style: theme.textTheme.bodySmall),
                  Expanded(
                    child: Text(p.defaultModel, style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600)),
                  ),
                ],
              ),
            ),
          ],
          InkWell(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Icon(_expanded ? Icons.expand_less : Icons.expand_more, size: 20),
            ),
            onTap: () => setState(() => _expanded = !_expanded),
          ),
        ],
      ),
    );
  }
}

class _ApiKeyInput extends ConsumerStatefulWidget {
  final String providerName;
  const _ApiKeyInput({required this.providerName});

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
    if (key != null && key.isNotEmpty) {
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
                suffixIcon: _saved ? const Icon(Icons.check, color: AppColors.success) : null,
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
