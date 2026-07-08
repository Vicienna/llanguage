import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'core/constants/app_constants.dart';
import 'features/splash/splash_page.dart';
import 'features/home/home_page.dart';
import 'features/translator/translator_page.dart';
import 'features/course/course_overview_page.dart';
import 'features/settings/settings_page.dart';

class LLanguageApp extends ConsumerWidget {
  const LLanguageApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: AppConstants.appName,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      initialRoute: '/splash',
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/splash':
            return MaterialPageRoute(builder: (_) => const SplashPage());
          case '/home':
            return MaterialPageRoute(builder: (_) => const HomePage());
          case '/translator':
            return MaterialPageRoute(builder: (_) => const TranslatorPage());
          case '/courses':
            return MaterialPageRoute(builder: (_) => const CourseOverviewPage());
          case '/settings':
            return MaterialPageRoute(builder: (_) => const SettingsPage());
          default:
            return MaterialPageRoute(builder: (_) => const SplashPage());
        }
      },
    );
  }
}
