class AppConfig {
  AppConfig._();

  /// Inject at build time: flutter run --dart-define=BASE_URL=https://api.yourapp.com
  /// Defaults to the local .NET dev server.
  static const String baseUrl = String.fromEnvironment(
    'BASE_URL',
    defaultValue: 'http://localhost:5066',
  );
}
