import 'dart:ui';

extension ColorExtension on Color? {
  String? toHex() {
    if (this == null) return null;
    var alpha = (this!.a * 255).toInt().toRadixString(16).padLeft(2, '0');
    var red = (this!.r * 255).toInt().toRadixString(16).padLeft(2, '0');
    var green = (this!.g * 255).toInt().toRadixString(16).padLeft(2, '0');
    var blue = (this!.b * 255).toInt().toRadixString(16).padLeft(2, '0');
    return '#$alpha$red$green$blue'.toUpperCase();
  }
}
