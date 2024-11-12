import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final themeProvider = ChangeNotifierProvider<ThemeNotifier>((ref) {
  return ThemeNotifier();
});

class ThemeNotifier extends ChangeNotifier {
  ThemeNotifier() {
    // Get the initial platform brightness when the notifier is created
    _isDarkMode =
        PlatformDispatcher.instance.platformBrightness == Brightness.dark;

    // Listen for platform brightness changes
    PlatformDispatcher.instance.onPlatformBrightnessChanged = () {
      _isDarkMode =
          PlatformDispatcher.instance.platformBrightness == Brightness.dark;
      notifyListeners();
    };
  }

  bool _isDarkMode = false;

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }

  bool get isDarkMode => _isDarkMode;
}
