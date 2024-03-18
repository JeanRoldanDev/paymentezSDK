class Environment {
  static const clientAppCode =
      String.fromEnvironment('CLIENTAPPCODE', defaultValue: 'test');
  static const clientAppKey =
      String.fromEnvironment('CLIENTAPPKEY', defaultValue: 'test');
}
