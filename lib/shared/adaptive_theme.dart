import 'package:flutter/material.dart';

ThemeData getAdaptiveThemeData(context) {
  return Theme.of(context).platform == TargetPlatform.iOS
      ? iOsTheme
      : androidTheme;
}

final ThemeData androidTheme = ThemeData(
  primarySwatch: Colors.lime,
  accentColor: Colors.blueAccent,
  buttonColor: Colors.blueAccent,
);

final ThemeData iOsTheme = ThemeData(
  primarySwatch: Colors.lime,
  accentColor: Colors.blueAccent,
  buttonColor: Colors.blueAccent,
);
