import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TranslatorPage extends ConsumerWidget {
  const TranslatorPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Deep Translator'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Source Language Input
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text('🇮🇩', style: TextStyle(fontSize: 24)),
                        const SizedBox(width: 8),
                        Text('Indonesia', style: Theme.of(context).textTheme.titleMedium),
                        const Spacer(),
                        IconButton(
                          icon: const Icon(Icons.swap_horiz),
                          onPressed: () {},
                        ),
                        const Text('🇬🇧', style: TextStyle(fontSize: 24)),
                        const SizedBox(width: 8),
                        Text('English', style: Theme.of(context).textTheme.titleMedium),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const TextField(
                      maxLines: 3,
                      decoration: InputDecoration(
                        hintText: 'Masukkan teks...',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Translate Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.translate),
                label: const Text('Terjemahkan'),
              ),
            ),

            const SizedBox(height: 16),

            // Result Area
            Expanded(
              child: Card(
                child: Center(
                  child: Text(
                    'Hasil terjemahan akan muncul di sini',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
