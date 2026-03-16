import 'package:flutter/material.dart' hide Theme;
import 'package:source_parser/component/reader/layout/reader_render_config.dart';
import 'package:source_parser/component/reader/page_turn/none_page_turn_view.dart';
import 'package:source_parser/component/reader/page_turn/page_turn_controller.dart';
import 'package:source_parser/component/reader/page_turn/shader_page_turn_view.dart';
import 'package:source_parser/component/reader/reader_content_view.dart';
import 'package:source_parser/component/reader/reader_turning_mode.dart';

class ReaderView extends StatelessWidget {
  final String? errorText;
  final bool isLoading;
  final int battery;
  final bool eInkMode;
  final ReaderRenderConfig renderConfig;
  final bool selectionEnabled;
  final PageTurnMode pageTurnMode;
  final int pageCount;
  final PageTurnController controller;
  final VoidCallback onLongPress;
  final void Function(TapUpDetails) onTapUp;
  final ({
    String content,
    String header,
    String footer,
    bool isFirstPage,
    bool isLoading,
  })
      Function(int) getPageData;

  const ReaderView({
    super.key,
    required this.errorText,
    required this.isLoading,
    required this.battery,
    required this.eInkMode,
    required this.renderConfig,
    required this.selectionEnabled,
    required this.pageTurnMode,
    required this.pageCount,
    required this.controller,
    required this.onLongPress,
    required this.onTapUp,
    required this.getPageData,
  });

  @override
  Widget build(BuildContext context) {
    controller.updatePageCount(pageCount);
    if (errorText != null) {
      return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapUp: onTapUp,
        child: IgnorePointer(
          child: ReaderContentView.error(
            errorText: errorText!,
            renderConfig: renderConfig,
          ),
        ),
      );
    }
    if (isLoading) {
      return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapUp: onTapUp,
        child: IgnorePointer(
          child: ReaderContentView.loading(
            renderConfig: renderConfig,
          ),
        ),
      );
    }

    var mode = pageTurnMode;
    if (eInkMode) mode = PageTurnMode.none;

    Widget pageBuilder(int index) {
      var pageData = getPageData(index);
      if (pageData.isLoading) {
        return ReaderContentView.loading(
          renderConfig: renderConfig,
        );
      }
      return ReaderContentView(
        battery: battery,
        contentText: pageData.content,
        headerText: pageData.header,
        pageProgressText: pageData.footer,
        renderConfig: renderConfig,
        isFirstPage: pageData.isFirstPage,
        selectionEnabled: selectionEnabled,
      );
    }

    if (mode == PageTurnMode.none) {
      return NonePageTurnView(
        controller: controller,
        gesturesEnabled: !selectionEnabled,
        onLongPress: onLongPress,
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
      gesturesEnabled: !selectionEnabled,
      onLongPress: onLongPress,
      pageBuilder: pageBuilder,
      onTapUp: onTapUp,
      mode: mode,
    );
  }
}
