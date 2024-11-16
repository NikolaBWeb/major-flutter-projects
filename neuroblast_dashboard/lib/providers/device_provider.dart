import 'dart:io';
import 'package:flutter/material.dart';

class DeviceProvider extends ChangeNotifier {
  String? getOS() {
    if (Platform.isAndroid) {
      return 'android';
    } else if (Platform.isIOS) {
      return 'ios';
    } else {
      return null;
    }
  }
}
