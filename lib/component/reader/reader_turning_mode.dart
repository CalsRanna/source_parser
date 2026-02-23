enum PageTurnMode {
  slide,
  cover,
  curl,
  none;

  static PageTurnMode fromString(String value) {
    return PageTurnMode.values.firstWhere(
      (mode) => mode.name == value,
      orElse: () => PageTurnMode.slide,
    );
  }
}
