import 'package:isar/isar.dart';

part 'layout.g.dart';

@collection
@Name('layouts')
class Layout {
  Id? id;

  @Name('slot_0')
  String slot0;

  @Name('slot_1')
  String slot1;

  @Name('slot_2')
  String slot2;

  @Name('slot_3')
  String slot3;

  @Name('slot_4')
  String slot4;

  @Name('slot_5')
  String slot5;

  @Name('slot_6')
  String slot6;

  Layout({
    this.slot0 = '',
    this.slot1 = '',
    this.slot2 = '',
    this.slot3 = '',
    this.slot4 = '',
    this.slot5 = '',
    this.slot6 = '',
  });
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
}
