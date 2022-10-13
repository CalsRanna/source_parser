extension PlainString on String? {
  String? plain() {
    return this?.replaceAll('\n', '').replaceAll(' ', '');
  }
}
