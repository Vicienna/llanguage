import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('LLanguage'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => Navigator.pushNamed(context, '/settings'),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('Welcome!', style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
          )),
          const SizedBox(height: 8),
          Text('What do you want to learn today?', style: theme.textTheme.bodyLarge?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          )),
          const SizedBox(height: 24),
          _FeatureCard(
            icon: Icons.translate,
            title: 'Translator',
            subtitle: 'Translate words & sentences with AI',
            color: AppColors.primary,
            onTap: () => Navigator.pushNamed(context, '/translator'),
          ),
          const SizedBox(height: 12),
          _FeatureCard(
            icon: Icons.menu_book,
            title: 'Courses',
            subtitle: 'Structured learning paths',
            color: AppColors.secondary,
            onTap: () => Navigator.pushNamed(context, '/courses'),
          ),
          const SizedBox(height: 12),
          _FeatureCard(
            icon: Icons.flash_on,
            title: 'Flashcards',
            subtitle: 'Spaced repetition practice',
            color: AppColors.posVerb,
            onTap: null,
          ),
          const SizedBox(height: 12),
          _FeatureCard(
            icon: Icons.emoji_events,
            title: 'Achievements',
            subtitle: 'Track your progress & streaks',
            color: AppColors.achievementPurple,
            onTap: null,
          ),
        ],
      ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback? onTap;

  const _FeatureCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withValues(alpha: 0.15),
          child: Icon(icon, color: color),
        ),
        title: Text(title, style: theme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w600,
        )),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
