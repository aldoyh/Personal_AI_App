import 'dart:io';

class SecurityConfig {
  static void initializeSecurityConfig() {
    HttpOverrides.global = _DevHttpOverrides();
  }
}

class _DevHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (cert, host, port) => true;
  }
}
