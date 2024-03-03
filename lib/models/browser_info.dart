import 'dart:convert';

import 'package:flutter/foundation.dart';

@immutable
class BrowserInfo {
  const BrowserInfo({
    required this.language,
    required this.javaEnabled,
    required this.jsEnabled,
    required this.colorDepth,
    required this.screenHeight,
    required this.screenWidth,
    required this.timezoneOffset,
    required this.userAgent,
    required this.acceptHeader,
  });

  factory BrowserInfo.fromMap(Map<String, dynamic> map) {
    return BrowserInfo(
      language: map['language'] as String,
      javaEnabled: map['java_enabled'] as bool,
      jsEnabled: map['js_enabled'] as bool,
      colorDepth: map['color_depth'] as int,
      screenHeight: map['screen_height'] as int,
      screenWidth: map['screen_width'] as int,
      timezoneOffset: map['timezone_offset'] as int,
      userAgent: map['user_agent'] as String,
      acceptHeader: map['accept_header'] as String,
    );
  }

  factory BrowserInfo.fromJson(String source) =>
      BrowserInfo.fromMap(json.decode(source) as Map<String, dynamic>);
  final String language;
  final bool javaEnabled;
  final bool jsEnabled;
  final int colorDepth;
  final int screenHeight;
  final int screenWidth;
  final int timezoneOffset;
  final String userAgent;
  final String acceptHeader;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'language': language,
      'java_enabled': javaEnabled,
      'js_enabled': jsEnabled,
      'color_depth': colorDepth,
      'screen_height': screenHeight,
      'screen_width': screenWidth,
      'timezone_offset': timezoneOffset,
      'user_agent': userAgent,
      'accept_header': acceptHeader,
    };
  }

  String toJson() => json.encode(toMap());

  @override
  String toString() {
    // ignore: lines_longer_than_80_chars
    return 'BrowserInfo(language: $language, javaEnabled: $javaEnabled, jsEnabled: $jsEnabled, colorDepth: $colorDepth, screenHeight: $screenHeight, screenWidth: $screenWidth, timezoneOffset: $timezoneOffset, userAgent: $userAgent, acceptHeader: $acceptHeader)';
  }

  @override
  bool operator ==(covariant BrowserInfo other) {
    if (identical(this, other)) return true;

    return other.language == language &&
        other.javaEnabled == javaEnabled &&
        other.jsEnabled == jsEnabled &&
        other.colorDepth == colorDepth &&
        other.screenHeight == screenHeight &&
        other.screenWidth == screenWidth &&
        other.timezoneOffset == timezoneOffset &&
        other.userAgent == userAgent &&
        other.acceptHeader == acceptHeader;
  }

  @override
  int get hashCode {
    return language.hashCode ^
        javaEnabled.hashCode ^
        jsEnabled.hashCode ^
        colorDepth.hashCode ^
        screenHeight.hashCode ^
        screenWidth.hashCode ^
        timezoneOffset.hashCode ^
        userAgent.hashCode ^
        acceptHeader.hashCode;
  }
}
