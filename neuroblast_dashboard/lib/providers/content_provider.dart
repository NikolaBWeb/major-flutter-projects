import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// A provider class that manages the content state for the application.
///
/// This class extends [ChangeNotifier] to allow for reactive updates
/// to the UI when the content changes. It holds a single piece of content
/// as a string and provides methods to access and update this content.
class ContentProvider with ChangeNotifier {
  String _content = 'Patients';

  /// Returns the current content.
  ///
  /// This getter provides read-only access to the private [_content] field,
  /// allowing other parts of the application to retrieve the current content
  /// without being able to directly modify it.
  ///
  /// @return A [String] representing the current content.
  String get content => _content;

  /// Updates the content with the provided new content.
  ///
  /// This method sets the [_content] to the [newContent] provided
  /// and notifies all listeners of the change, triggering UI updates.
  ///
  /// @param newContent A [String] representing the new content to be set.
  void updateContent(String newContent) {
    _content = newContent;
    notifyListeners();
  }
}

/// A [ChangeNotifierProvider] that creates and provides a
/// [ContentProvider] instance.
///
/// This provider allows for the creation and
///  management of a single [ContentProvider]
/// instance throughout the application.
/// It can be used with Riverpod's `ref.watch`
/// or `ref.read` to access the current content state or update it.
///
/// Usage:
/// ```dart
/// final content = ref.watch(contentProvider).content;
/// ref.read(contentProvider).updateContent('New Content');
/// ```
///
/// @return A [ContentProvider] instance that can be used
/// to manage content state.
final contentProvider = ChangeNotifierProvider<ContentProvider>((ref) {
  return ContentProvider();
});
