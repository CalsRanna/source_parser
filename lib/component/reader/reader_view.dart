import 'package:flutter/material.dart' hide Theme;
import 'package:source_parser/component/reader/page_turn/none_page_turn_view.dart';
import 'package:source_parser/component/reader/page_turn/page_turn_controller.dart';
import 'package:source_parser/component/reader/page_turn/shader_page_turn_view.dart';
import 'package:source_parser/component/reader/reader_content_view.dart';
import 'package:source_parser/component/reader/reader_turning_mode.dart';
import 'package:source_parser/schema/theme.dart';

class ReaderView extends StatelessWidget {
  final String? errorText;
  final bool isLoading;
  final Theme theme;
  final int battery;
  final bool eInkMode;
  final PageTurnMode pageTurnMode;
  final int pageCount;
  final PageTurnController controller;
  final void Function(TapUpDetails) onTapUp;
  final ({
    String content,
    String header,
    String footer,
    bool isFirstPage,
    bool isLoading,
  }) Function(int) getPageData;

  const ReaderView({
    super.key,
    required this.errorText,
    required this.isLoading,
    required this.theme,
    required this.battery,
    required this.eInkMode,
    required this.pageTurnMode,
    required this.pageCount,
    required this.controller,
    required this.onTapUp,
    required this.getPageData,
  });

  @override
  Widget build(BuildContext context) {
    debugPrint('[ReaderView] build: error=${errorText != null}, isLoading=$isLoading, pageCount=$pageCount, mode=$pageTurnMode, eInk=$eInkMode');
    if (errorText != null) {
      return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapUp: onTapUp,
        child: IgnorePointer(
          child: ReaderContentView.error(
            errorText: errorText!,
            theme: theme,
          ),
        ),
      );
    }
    if (isLoading) {
      return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapUp: onTapUp,
        child: IgnorePointer(
          child: ReaderContentView.loading(theme: theme),
        ),
      );
    }

    controller.updatePageCount(pageCount);

    var mode = pageTurnMode;
    if (eInkMode) mode = PageTurnMode.none;

    Widget pageBuilder(int index) {
      var pageData = getPageData(index);
      if (pageData.isLoading) {
        return ReaderContentView.loading(theme: theme);
      }
      return ReaderContentView(
        battery: battery,
        contentText: pageData.content,
        headerText: pageData.header,
        pageProgressText: pageData.footer,
        theme: theme,
        isFirstPage: pageData.isFirstPage,
      );
    }

    if (mode == PageTurnMode.none) {
      return NonePageTurnView(
        controller: controller,
        pageBuilder: pageBuilder,
        onTapUp: onTapUp,
      );
    }

    final shaderAsset = switch (mode) {
      PageTurnMode.slide => 'shader/page_slide.frag',
      PageTurnMode.cover => 'shader/page_cover.frag',
      PageTurnMode.curl => 'shader/page_curl.frag',
      PageTurnMode.none => '',
    };

    return ShaderPageTurnView(
      shaderAsset: shaderAsset,
      controller: controller,
      pageBuilder: pageBuilder,
      onTapUp: onTapUp,
      mode: mode,
    );
  }
}
