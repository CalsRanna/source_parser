import 'package:flutter/material.dart';
import 'package:source_parser/router/router.dart';

/// A utility class for displaying various UI components such as dialogs, bottom sheets, and snack bars.
///
/// Provides a set of static methods to easily show common UI interaction components
/// throughout the application, including confirmation dialogs, loading indicators,
/// and bottom sheets. All methods use a global context, eliminating the need to manually
/// pass a context parameter.
class DialogUtil {
  /// Displays a confirmation dialog and returns the user's choice.
  ///
  /// [message] The main content text to display in the dialog.
  /// [title] Optional title text for the dialog.
  ///
  /// Returns a `Future<bool?>` that completes with true if the user confirms,
  /// false if they cancel, or null if the dialog is dismissed another way.
  static Future<bool?> confirm(String message, {String? title}) async {
    var cancelTextButton = TextButton(
      onPressed: () => Navigator.of(globalKey.currentContext!).pop(false),
      child: const Text('取消'),
    );
    var confirmTextButton = TextButton(
      onPressed: () => Navigator.of(globalKey.currentContext!).pop(true),
      child: const Text('确定'),
    );
    var actions = [cancelTextButton, confirmTextButton];
    var alertDialog = AlertDialog(
      actions: actions,
      content: Text(message),
      title: title != null ? Text(title) : null,
    );
    return showDialog<bool>(
      builder: (context) => alertDialog,
      context: globalKey.currentContext!,
    );
  }

  /// Dismisses the currently displayed dialog or bottom sheet.
  static void dismiss() {
    Navigator.of(globalKey.currentContext!).pop();
  }

  /// Displays a loading indicator dialog.
  ///
  /// Use this when waiting for an operation to complete to show a centered
  /// circular progress indicator. Call [dismiss] to close this loading dialog.
  static void loading() {
    showDialog(
      context: globalKey.currentContext!,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  /// Opens a bottom sheet displaying the specified widget.
  ///
  /// [child] The widget to display in the bottom sheet.
  /// The bottom sheet includes a drag handle that allows users to dismiss it by pulling down.
  static void openBottomSheet(Widget child) {
    showModalBottomSheet(
      builder: (context) => child,
      context: globalKey.currentContext!,
      showDragHandle: true,
    );
  }

  static void openDialog(Widget child, {bool barrierDismissible = true}) {
    showDialog(
      barrierDismissible: barrierDismissible,
      builder: (context) => child,
      context: globalKey.currentContext!,
    );
  }

  static void snackBar(String message) {
    final messenger = ScaffoldMessenger.of(globalKey.currentContext!);
    final snackBar = SnackBar(
      behavior: SnackBarBehavior.floating,
      content: Text(message),
      duration: const Duration(seconds: 1),
    );
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(snackBar);
  }
}
