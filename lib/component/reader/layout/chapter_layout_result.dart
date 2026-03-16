import 'package:source_parser/component/reader/layout/reader_render_config.dart';

class ReaderPageRange {
  final int start;
  final int end;
  final bool isFirstPage;

  const ReaderPageRange({
    required this.start,
    required this.end,
    required this.isFirstPage,
  });
}

class ChapterLayoutResult {
  final String fullText;
  final List<ReaderPageRange> pages;
  final ReaderRenderConfig renderConfig;

  const ChapterLayoutResult({
    required this.fullText,
    required this.pages,
    required this.renderConfig,
  });

  ChapterLayoutResult.empty()
      : fullText = '',
        pages = const [],
        renderConfig = ReaderRenderConfig();

  bool get isEmpty => pages.isEmpty;
  bool get isNotEmpty => pages.isNotEmpty;
  int get pageCount => pages.length;

  String pageTextAt(int index) {
    final page = pages[index];
    return fullText.substring(page.start, page.end);
  }

  ReaderPageRange pageRangeAt(int index) {
    return pages[index];
  }

  List<String> asPageTexts() {
    return List<String>.generate(pageCount, pageTextAt);
  }
}
