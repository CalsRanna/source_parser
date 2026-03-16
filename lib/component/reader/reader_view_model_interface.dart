import 'package:flutter/material.dart' hide Theme;
import 'package:signals/signals.dart';
import 'package:source_parser/component/reader/layout/chapter_layout_result.dart';
import 'package:source_parser/component/reader/page_turn/page_turn_controller.dart';
import 'package:source_parser/component/reader/reader_turning_mode.dart';
import 'package:source_parser/schema/theme.dart';

abstract class ReaderViewModelInterface {
  Signal<String> get error;
  Signal<ChapterLayoutResult> get currentChapterLayout;
  Signal<Theme> get theme;
  Signal<int> get battery;
  Signal<bool> get eInkMode;
  Signal<PageTurnMode> get pageTurnMode;
  Signal<bool> get showOverlay;
  Signal<bool> get isSelectionMode;
  Computed<bool> get isDarkMode;
  Computed<int> get pageCount;
  PageTurnController get pageTurnController;

  void enterSelectionMode();
  void exitSelectionMode();
  void turnPage(TapUpDetails details);

  ({
    String content,
    String header,
    String footer,
    bool isFirstPage,
    bool isLoading,
  }) getPageData(int flatIndex);
}
