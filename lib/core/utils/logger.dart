class Logger {
  static void info(String message) {
    // ignore: avoid_print
    print('[LLanguage] $message');
  }

  static void error(String message, [Object? error]) {
    // ignore: avoid_print
    print('[LLanguage ERROR] $message${error != null ? ': $error' : ''}');
  }
}
