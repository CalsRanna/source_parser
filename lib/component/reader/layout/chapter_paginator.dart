import 'package:flutter/material.dart' hide Theme;
import 'package:source_parser/component/reader/layout/chapter_layout_result.dart';
import 'package:source_parser/component/reader/layout/reader_page_text_builder.dart';
import 'package:source_parser/component/reader/layout/reader_render_config.dart';

class ChapterPaginator {
  final ReaderRenderConfig renderConfig;
  final Size size;
  late final ReaderPageTextBuilder _textBuilder;
  late final TextPainter _painter;

  ChapterPaginator({
    required this.size,
    required this.renderConfig,
  })  : _textBuilder = ReaderPageTextBuilder(renderConfig: renderConfig),
        _painter = TextPainter(
          locale: renderConfig.locale,
          textDirection: renderConfig.textDirection,
          textHeightBehavior: renderConfig.textHeightBehavior,
          textScaler: renderConfig.textScaler,
          textWidthBasis: renderConfig.textWidthBasis,
        );

  ChapterLayoutResult paginate(String content) {
    if (content.isEmpty) return ChapterLayoutResult.empty();

    final pages = <ReaderPageRange>[];
    var start = 0;
    var previousPageLength = 0;

    while (start < content.length) {
      final isFirstPage = start == 0;
      final remainingLength = content.length - start;
      if (previousPageLength > 0 &&
          remainingLength <= (previousPageLength * 1.25).ceil()) {
        final fullRemaining = _measurePage(
          content.substring(start),
          isFirstPage: isFirstPage,
        );
        if (fullRemaining.height <= size.height) {
          pages.add(
            ReaderPageRange(
              start: start,
              end: content.length,
              isFirstPage: isFirstPage,
            ),
          );
          break;
        }
      }

      final result = _findBestPageBreak(
        content,
        start,
        isFirstPage,
        previousPageLength,
      );
      var end = result.end;
      if (end <= start) {
        end = _advanceContentIndex(content, start);
        if (end <= start) {
          end = content.length;
        }
      }

      if (end >= content.length) {
        pages.add(
          ReaderPageRange(
            start: start,
            end: content.length,
            isFirstPage: isFirstPage,
          ),
        );
        break;
      }

      pages.add(
        ReaderPageRange(
          start: start,
          end: end,
          isFirstPage: isFirstPage,
        ),
      );
      previousPageLength = end - start;
      start = end;
    }

    return ChapterLayoutResult(
      fullText: content,
      pages: pages,
      renderConfig: renderConfig,
    );
  }

  ({int end, _PageMeasurement measurement}) _findBestPageBreak(
    String content,
    int start,
    bool isFirstPage,
    int previousPageLength,
  ) {
    final remainingLength = content.length - start;
    final cache = <int, _PageMeasurement>{};

    _PageMeasurement measureTo(int end) {
      return cache.putIfAbsent(
        end,
        () => _measurePage(
          content.substring(start, end),
          isFirstPage: isFirstPage,
        ),
      );
    }

    final estimatedLength = _estimatePageLength(
      previousPageLength: previousPageLength,
      remainingLength: remainingLength,
      isFirstPage: isFirstPage,
    );
    var probeEnd = (start + estimatedLength).clamp(start + 1, content.length);
    var probeMeasurement = measureTo(probeEnd);

    var bestEnd = start;
    var bestMeasurement = const _PageMeasurement.empty();
    int low;
    int high;

    if (probeMeasurement.height <= size.height) {
      bestEnd = probeEnd;
      bestMeasurement = probeMeasurement;
      var step = _nextStep(estimatedLength);
      var overflowEnd = content.length;
      while (bestEnd < content.length) {
        final candidateEnd =
            (bestEnd + step).clamp(bestEnd + 1, content.length);
        final candidateMeasurement = measureTo(candidateEnd);
        if (candidateMeasurement.height <= size.height) {
          bestEnd = candidateEnd;
          bestMeasurement = candidateMeasurement;
          if (candidateEnd == content.length) {
            return (end: bestEnd, measurement: bestMeasurement);
          }
          step *= 2;
          continue;
        }
        overflowEnd = candidateEnd;
        break;
      }
      low = bestEnd + 1;
      high = overflowEnd - 1;
    } else {
      var step = _nextStep(estimatedLength);
      var fitEnd = start;
      while (probeEnd > start + 1) {
        final candidateEnd = (probeEnd - step).clamp(start + 1, probeEnd - 1);
        final candidateMeasurement = measureTo(candidateEnd);
        if (candidateMeasurement.height <= size.height) {
          fitEnd = candidateEnd;
          bestEnd = candidateEnd;
          bestMeasurement = candidateMeasurement;
          break;
        }
        if (candidateEnd == start + 1) break;
        probeEnd = candidateEnd;
        step *= 2;
      }
      if (fitEnd == start) {
        return (end: start, measurement: bestMeasurement);
      }
      low = fitEnd + 1;
      high = probeEnd - 1;
    }

    while (low <= high) {
      final mid = low + ((high - low) >> 1);
      final measurement = measureTo(mid);
      if (measurement.height <= size.height) {
        bestEnd = mid;
        bestMeasurement = measurement;
        low = mid + 1;
      } else {
        high = mid - 1;
      }
    }

    return (end: bestEnd, measurement: bestMeasurement);
  }

  int _advanceContentIndex(String content, int contentOffset) {
    if (contentOffset >= content.length) return content.length;
    if (contentOffset + 1 >= content.length) return content.length;
    final current = content.codeUnitAt(contentOffset);
    final next = content.codeUnitAt(contentOffset + 1);
    final isHighSurrogate = current >= 0xD800 && current <= 0xDBFF;
    final isLowSurrogate = next >= 0xDC00 && next <= 0xDFFF;
    return contentOffset + (isHighSurrogate && isLowSurrogate ? 2 : 1);
  }

  _PageMeasurement _measurePage(
    String text, {
    required bool isFirstPage,
  }) {
    _painter.text = _textBuilder.buildTextSpan(text, isFirstPage: isFirstPage);
    _painter.layout(maxWidth: size.width);
    final lines = _painter.computeLineMetrics();
    return _PageMeasurement(
      height: _painter.height,
      lineCount: lines.length,
      lastLineHeight: lines.isEmpty ? 0 : lines.last.height,
    );
  }

  int _estimatePageLength({
    required int previousPageLength,
    required int remainingLength,
    required bool isFirstPage,
  }) {
    if (previousPageLength > 0) {
      return previousPageLength.clamp(1, remainingLength);
    }
    final seed = isFirstPage ? 240 : 300;
    return seed.clamp(1, remainingLength);
  }

  int _nextStep(int estimatedLength) {
    return (estimatedLength ~/ 2).clamp(64, 512);
  }
}

class _PageMeasurement {
  final double height;
  final int lineCount;
  final double lastLineHeight;

  const _PageMeasurement({
    required this.height,
    required this.lineCount,
    required this.lastLineHeight,
  });

  const _PageMeasurement.empty()
      : height = 0,
        lineCount = 0,
        lastLineHeight = 0;
}
