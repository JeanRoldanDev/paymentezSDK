extension DynamicExtensions on Map<String, dynamic> {
  double getDouble(String key) {
    final value = this[key];
    if (value is String) {
      return double.parse(value);
    }

    if (value is int) {
      return double.parse(value.toString());
    }

    if (value is bool) {
      return value ? 1 : 0;
    }

    if (value is double) {
      return value;
    }

    return 0;
  }

  int getInt(String key) {
    final value = this[key];
    if (value is String) {
      return int.parse(value);
    }

    if (value is int) {
      return int.parse(value.toString());
    }

    if (value is bool) {
      return value ? 1 : 0;
    }

    if (value is int) {
      return value;
    }

    return 0;
  }

  Map<String, dynamic> getMap(String key) {
    return this[key] as Map<String, dynamic>;
  }

  List<dynamic> getList(String key) {
    return this[key] as List<dynamic>;
  }

  DateTime getDateTime(String key) {
    return DateTime.parse(this[key].toString());
  }

  bool getBool(String key) {
    final value = this[key];
    if (value is bool) {
      return value;
    }
    return false;
  }
}
