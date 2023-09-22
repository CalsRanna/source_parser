extension StringExtension on String? {
  String? plain() {
    return this?.replaceAll(RegExp(r'\n *'), '').trim();
  }

  String? pure() {
    return this?.replaceAll(RegExp(r'\s'), '').trim();
  }
}
