import 'dart:convert';
import 'dart:io';

class Helpers {
  static Future<Map<String, dynamic>> getJsonLocalMap(
    String path,
    String fileName,
  ) async {
    final filePath = '$path/$fileName';
    final jsonString = await File(filePath).readAsString();
    return json.decode(jsonString) as Map<String, dynamic>;
  }

  static Future<String> getJsonLocal(
    String path,
    String fileName,
  ) async {
    final filePath = '$path/$fileName';
    final jsonString = await File(filePath).readAsString();
    return jsonString;
  }
}
