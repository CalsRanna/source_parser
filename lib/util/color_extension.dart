import 'dart:ui';

extension ColorExtension on Color? {
  String? toHex() {
    if (this == null) return null;
    var alpha = (this!.a * 255).toInt().toRadixString(16);
    var red = (this!.r * 255).toInt().toRadixString(16);
    var green = (this!.g * 255).toInt().toRadixString(16);
    var blue = (this!.b * 255).toInt().toRadixString(16);
    return '#$alpha$red$green$blue';
  }
}
