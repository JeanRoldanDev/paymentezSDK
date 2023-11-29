class Env {
  Env._privateConstructor({
    required this.serverApplicationCode,
    required this.serverAppKey,
    required this.clientApplicationCode,
    required this.clientAppKey,
    required this.appCodePCI,
    required this.appKeyPCI,
  });

  final String serverApplicationCode;
  final String serverAppKey;
  final String clientApplicationCode;
  final String clientAppKey;
  final String appCodePCI;
  final String appKeyPCI;
  static Env? _instance;

  static Env get instance {
    if (_instance != null) return _instance!;
    _instance = Env._privateConstructor(
      serverApplicationCode:
          const String.fromEnvironment('SERVER_APPLICATION_CODE'),
      serverAppKey: const String.fromEnvironment('SERVER_APP_KEY'),
      clientApplicationCode:
          const String.fromEnvironment('CLIENT_APPLICATION_CODE'),
      clientAppKey: const String.fromEnvironment('CLIENT_APP_KEY'),
      appCodePCI: const String.fromEnvironment('PCI_APPLICATION_CODE'),
      appKeyPCI: const String.fromEnvironment('PCI_APP_KEY'),
    );
    return _instance!;
  }
}
