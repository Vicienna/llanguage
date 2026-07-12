import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/providers/database_provider.dart';
import '../../core/constants/app_constants.dart';

class SplashPage extends ConsumerWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    ref.listen(databaseInitProvider, (prev, next) {
      if (next.hasValue || next.hasError) {
        Navigator.of(context).pushReplacementNamed('/home');
      }
    });

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.translate, size: 80, color: theme.colorScheme.primary),
            const SizedBox(height: 24),
            Text(AppConstants.appName, style: theme.textTheme.headlineLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary,
            )),
            const SizedBox(height: 12),
            Text('Learn languages smarter', style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            )),
            const SizedBox(height: 48),
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
