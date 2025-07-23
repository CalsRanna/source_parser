import 'dart:ui';

extension NullableStringExtension on String? {
  String? plain() {
    return this?.replaceAll(RegExp(r'\n *'), '').trim();
  }

  String? pure() {
    return this?.replaceAll(RegExp(r'\s'), '').trim();
  }

  Color? toColor() {
    if (this == null) return null;
    var hex = this!.replaceFirst('#', '');
    hex = hex.padLeft(8, 'F');
    var alpha = int.tryParse(hex.substring(0, 2), radix: 16) ?? 255;
    var red = int.tryParse(hex.substring(2, 4), radix: 16) ?? 255;
    var green = int.tryParse(hex.substring(4, 6), radix: 16) ?? 255;
    var blue = int.tryParse(hex.substring(6, 8), radix: 16) ?? 255;
    return Color.fromARGB(alpha, red, green, blue);
  }
}

extension StringExtension on String {
  String format(List<Object> patterns) {
    var formattedString = this;
    for (var pattern in patterns) {
      formattedString = formattedString.replaceFirst('%s', pattern.toString());
    }
    return formattedString;
  }
}
