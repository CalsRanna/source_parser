class Layout {
  int? id;

  String slot0;
  String slot1;
  String slot2;
  String slot3;
  String slot4;
  String slot5;
  String slot6;

  Layout({
    this.id,
    this.slot0 = '',
    this.slot1 = '',
    this.slot2 = '',
    this.slot3 = '',
    this.slot4 = '',
    this.slot5 = '',
    this.slot6 = '',
  });

  Map<String, dynamic> toJson() {
    return {
      'slot_0': slot0,
      'slot_1': slot1,
      'slot_2': slot2,
      'slot_3': slot3,
      'slot_4': slot4,
      'slot_5': slot5,
      'slot_6': slot6,
    };
  }
}

enum LayoutSlot {
  audio,
  cache,
  catalogue,
  darkMode,
  forceRefresh,
  information,
  more,
  previousChapter,
  nextChapter,
  source,
  theme,
  replacement
}
