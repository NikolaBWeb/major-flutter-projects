import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ContentProvider with ChangeNotifier {
  String _content = 'Main Content';

  String get content => _content;

  void updateContent(String newContent) {
    _content = newContent;
    notifyListeners();
  }
}

final contentProvider = ChangeNotifierProvider<ContentProvider>((ref) {
  return ContentProvider();
});
