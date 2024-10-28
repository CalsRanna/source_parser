import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:battery_plus/battery_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_android_volume_keydown/flutter_android_volume_keydown.dart';
import 'package:source_parser/page/reader/component/background.dart';
import 'package:source_parser/page/reader/component/overlay.dart';
import 'package:source_parser/page/reader/component/page.dart';

/// [BookReader] is a widget used to read book. It provide some way to
/// paginate and can be customized by you own choice since we provide
/// many params to do that.
class BookReader extends StatefulWidget {
  /// Author of book, can be null if you weren't sure about it.
  final String author;

  /// Basically a cover of book, should be an image.
  final Widget cover;

  /// The value of [cursor] is the index of pages paginated with style
  /// given. If it is null then the default value is 0.
  final int? cursor;

  /// Current dark mode of app.
  final bool darkMode;

  /// Duration for animation, include app and bottom bar slide transition,
  /// and page transition automated.
  final Duration? duration;

  final bool eInkMode;

  /// Used to fetch content from internet or some other way.**[NOTICE]**
  /// This function can not use ***[setState]*** in it because this
  /// should be called in [build] function.
  final Future<String> Function(int) future;

  /// Current index of chapters.
  final int? index;

  /// Name of book, used to displayed in header and detail modal.
  final String name;

  /// Determine how to trigger page change
  final List<ReaderPageTurningMode> modes;

  final ReaderTheme? theme;

  /// Title of chapter, used to displayed in header while is not first page.
  final String? title;

  /// Amount of chapters, if [total] is null then the default value **[1]**
  /// would be used.
  final int? total;

  /// If [onBookPressed] is null, then the button of detail should not be
  /// available. And this function is used to navigate to a new page to
  /// show detail of book and something else you wanna display.
  final void Function()? onBookPressed;

  /// This is used to cache data from internet or some other way, and the
  /// param is the amount of chapters should be cached.
  final void Function(int amount)? onCached;

  /// If this function is null then the button of catalogue should not be
  /// available. And this is used to navigate to the new page to display
  /// custom catalogue page.
  final void Function()? onCataloguePressed;

  /// This function will be called when change chapter. And use [future] to
  /// fetch data instead of here.
  final void Function(int index)? onChapterChanged;

  /// When exit the reader page, use this to do something you ever want to.
  /// The first param should be the current [index] of chapters and the
  /// second param should be the [cursor] of pages.
  final void Function(int index, int cursor)? onPop;

  final void Function()? onDarkModePressed;

  final void Function(String)? onMessage;

  final Future<String> Function(int)? onRefresh;
  final void Function(int)? onProgressChanged;

  /// This is used to navigate to the new page to display settings.
  final void Function()? onSettingPressed;

  final void Function()? onSourcePressed;

  final void Function()? onDetailPressed;

  /// [author], [cover], [name] should not be null.
  /// [future] is used to fetch content from internet or some other way.
  const BookReader({
    super.key,
    required this.author,
    required this.cover,
    this.cursor,
    this.darkMode = false,
    this.duration,
    this.eInkMode = false,
    required this.future,
    this.index,
    this.modes = ReaderPageTurningMode.values,
    required this.name,
    this.theme,
    this.title,
    this.total,
    this.onBookPressed,
    this.onCached,
    this.onCataloguePressed,
    this.onChapterChanged,
    this.onDarkModePressed,
    this.onDetailPressed,
    this.onMessage,
    this.onPop,
    this.onProgressChanged,
    this.onRefresh,
    this.onSettingPressed,
    this.onSourcePressed,
  });

  @override
  State<BookReader> createState() => _BookReaderState();
}

/// Pagination exception.
class PaginationException implements Exception {
  final String message;

  PaginationException(this.message);
}

/// Paginator is a class used to paginate the content into different pages.
class Paginator {
  final Size size;
  final ReaderTheme theme;
  final TextPainter _painter;

  /// Paginator is a class used to paginate the content into different pages.
  ///
  /// [size] is the available size of the content, and [theme] has some default styles.
  Paginator({required this.size, required this.theme})
      : _painter = TextPainter(
          strutStyle: StrutStyle(
            fontSize: theme.pageStyle.fontSize,
            forceStrutHeight: true,
            height: theme.pageStyle.height,
          ),
        );

  /// Paginate the content into different pages, each page is a [TextSpan].
  List<String> paginate(String content) {
    try {
      // 零宽字符填充内容，用于覆盖默认换行逻辑，会导致分页时长提高5-6倍
      // content = content.split('').join('\u200B');
      // 填充全角空格，用于首行缩进
      // content = content.split('\n').join('\n\u2003\u2003');
      var offset = 0;
      List<String> pages = [];
      while (offset < content.length - 1) {
        var start = offset;
        var end = content.length - 1;
        var middle = ((start + end) / 2).ceil();
        while (end - start > 1) {
          var page = content.substring(offset, middle);
          // 如果新的一页以换行符开始，删除这个换行符
          if (page.startsWith('\n')) {
            offset += 1;
          }
          if (_layout(page)) {
            start = middle;
            middle = ((start + end) / 2).ceil();
          } else {
            end = middle;
            middle = ((start + end) / 2).ceil();
          }
        }
        if (middle == content.length - 1) {
          // substring不包含end，所以当需要截取后面所有字符串时，end应设为null
          var page = content.substring(offset);
          // 最后一页填充换行符以撑满整个屏幕
          while (_layout('$page\n')) {
            page += '\n';
          }
          pages.add(page);
        } else {
          var page = content.substring(offset, middle);
          // 如果最后一次分页溢出，则减少一个字符，因为计算到后面已经在相邻位置进行截取了。
          if (!_layout(page)) {
            middle--;
            page = content.substring(offset, middle);
          }
          pages.add(page);
        }
        offset = middle;
      }
      return pages;
    } catch (error) {
      throw PaginationException(error.toString());
    }
  }

  /// Build a [TextSpan] from the given text. Which will split into multi paragraphs.
  TextSpan _build(String text) {
    try {
      // 通过换行实现段间距，会导致分页时长提高1倍左右，会有较明显的卡顿感
      // final paragraphs = text.split('\n');
      // final length = paragraphs.length;
      // List<InlineSpan> children = [];
      // final style = theme.pageStyle;
      // final height = style.height! * 0.25;
      // final paragraphStyle = style.copyWith(height: height);
      // for (var i = 0; i < length; i++) {
      //   children.add(TextSpan(text: '${paragraphs[i]}\n', style: style));
      //   if (i < length - 1) {
      //     children.add(TextSpan(text: '\n', style: paragraphStyle));
      //   }
      // }
      // return TextSpan(children: children);
      return TextSpan(text: text, style: theme.pageStyle);
    } catch (error) {
      throw PaginationException(error.toString());
    }
  }

  /// Whether the text can be paint properly in the available area. If
  /// the return value is [true], means still in the available size,
  /// and [false] means not.
  bool _layout(String text) {
    try {
      final direction = theme.textDirection;
      final span = _build(text);
      _painter.text = span;
      _painter.textDirection = direction;
      _painter.layout(maxWidth: size.width);
      return _painter.size.height <= size.height;
    } on Exception catch (error) {
      throw PaginationException(error.toString());
    }
  }
}

class _BookReaderState extends State<BookReader>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late int cursor;
  late Duration duration;
  String? error;
  Map<int, String?> errors = {};
  late int index;
  bool loading = true;
  List<String> pages = [];
  Map<int, List<String>> preloads = {};
  late double progress;
  bool showCache = false;
  bool showOverlay = false;
  late ReaderTheme theme;
  late int total;
  Size size = Size.zero;
  late StreamSubscription<HardwareButton>? subscription;
  int batteryLevel = 100;

  @override
  Widget build(BuildContext context) {
    var background = ReaderBackground(theme: theme);
    var page = ReaderPage(
      batteryLevel: batteryLevel,
      cursor: min(cursor, pages.length - 1),
      eInkMode: widget.eInkMode,
      error: error,
      loading: loading,
      modes: widget.modes,
      name: widget.name,
      pages: pages,
      progress: progress,
      theme: theme,
      title: widget.title ?? widget.name,
      onOverlayInserted: handleOverlayInserted,
      onPageDown: handlePageDown,
      onPageUp: handlePageUp,
      onRefresh: handleRefresh,
      onSourcePressed: widget.onSourcePressed,
    );
    var overlay = ReaderOverlay(
      onCached: handleCached,
      onRemoved: handleOverlayRemoved,
    );
    var children = [background, page, if (showOverlay) overlay];
    return Stack(children: children);
  }

  Future<void> calculateBattery() async {
    int level;
    try {
      level = await Battery().batteryLevel;
    } catch (error) {
      level = 100;
    }
    setState(() {
      batteryLevel = level;
    });
  }

  void calculateProgress() {
    double value;
    if (pages.isEmpty) {
      value = index / total;
    } else {
      value = (index + (cursor + 1) / pages.length) * 1.0 / total;
    }
    setState(() {
      progress = value.clamp(0.0, 1.0);
    });
  }

  Size calculateSize() {
    final mediaQuery = MediaQuery.of(context);
    final globalSize = mediaQuery.size;
    var height = globalSize.height;
    if (Platform.isAndroid) {
      final padding = mediaQuery.padding;
      height = height + padding.vertical;
    }
    // final viewPadding = mediaQuery.viewPadding;
    // final viewInsets = mediaQuery.viewInsets;
    // height = height + viewPadding.vertical;
    // height = height + viewInsets.vertical;
    height = height - theme.headerPadding.vertical;
    height = height - theme.headerStyle.fontSize! * theme.headerStyle.height!;
    height = height - theme.pagePadding.vertical;
    height = height - theme.footerPadding.vertical;
    height = height - theme.footerStyle.fontSize! * theme.footerStyle.height!;
    final width = globalSize.width - theme.pagePadding.horizontal;
    return Size(width, height);
  }

  void copy() {
    setState(() {
      pages = preloads[index] ?? [];
      error = errors[index];
    });
  }

  @override
  void didChangeDependencies() {
    if (size == Size.zero) {
      size = calculateSize();
      fetchContent();
    }
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(covariant BookReader oldWidget) {
    theme = widget.theme ?? ReaderTheme();
    final pageStyle = theme.pageStyle;
    final oldPageStyle = oldWidget.theme?.pageStyle;
    final conditionA = pageStyle.fontSize != oldPageStyle?.fontSize;
    final conditionB = pageStyle.height != oldPageStyle?.height;
    if (conditionA || conditionB) {
      fetchContent(force: true);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: SystemUiOverlay.values,
    );
    controller.dispose();
    super.dispose();
  }

  Future<void> fetch(int index) async {
    setState(() {
      loading = true;
    });
    try {
      var content = await widget.future(index);
      final paginator = Paginator(size: size, theme: theme);
      final pages = paginator.paginate(content);
      setState(() {
        error = null;
        loading = false;
        this.pages = pages;
      });
    } on TimeoutException {
      setState(() {
        error = '出错了，请稍后再试';
        loading = false;
        pages = [];
      });
    } on SocketException {
      setState(() {
        error = '出错了，请稍后再试';
        loading = false;
        pages = [];
      });
    } on RangeError {
      setState(() {
        cursor = 0;
        error = '出错了，请稍后再试';
        loading = false;
        pages = [];
      });
      calculateProgress();
    } catch (error) {
      setState(() {
        this.error = error.runtimeType.toString();
        loading = false;
        pages = [];
      });
    }
  }

  Future<void> fetchContent({bool force = false}) async {
    final cached = preloads.keys.contains(index);
    if (!cached || force) {
      await fetch(index);
    } else {
      copy();
    }
    calculateProgress(); // Calculate progress here to ensure pages is paginated already.
    preload(index);
  }

  void handleCached(int amount) {
    setState(() {
      showCache = false;
      showOverlay = false;
    });
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    widget.onCached?.call(amount);
    widget.onMessage?.call('缓存开始');
  }

  void handleCataloguePressed() {
    widget.onCataloguePressed?.call();
  }

  void handleChapterDown() {
    if (index < total - 1) {
      setState(() {
        cursor = 0;
        index = index + 1;
      });
      fetchContent();
      widget.onChapterChanged?.call(index);
    } else {
      widget.onMessage?.call('已经是最后一章');
    }
    widget.onProgressChanged?.call(cursor);
  }

  void handleChapterUp() {
    if (index > 0) {
      setState(() {
        cursor = 0;
        index = index - 1;
      });
      fetchContent();
      widget.onChapterChanged?.call(index);
    } else {
      widget.onMessage?.call('已经是第一章');
    }
    widget.onProgressChanged?.call(cursor);
  }

  void handleOverlayInserted() {
    setState(() {
      showOverlay = true;
    });
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: SystemUiOverlay.values,
    );
  }

  void handleOverlayRemoved() {
    setState(() {
      showCache = false;
      showOverlay = false;
    });
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
  }

  void handlePageDown() async {
    final length = pages.length;
    if (cursor + 1 < length) {
      setState(() {
        cursor = cursor + 1;
      });
      calculateProgress();
    } else if (cursor + 1 >= length && index + 1 < total) {
      setState(() {
        cursor = 0;
        index = index + 1;
      });
      widget.onChapterChanged?.call(index);
      await fetchContent();
    } else {
      widget.onMessage?.call('已经是最后一页');
    }
    calculateBattery();
    widget.onProgressChanged?.call(cursor);
  }

  void handlePageUp() async {
    if (cursor > 0) {
      setState(() {
        cursor = cursor - 1;
      });
      calculateProgress();
    } else if (cursor == 0 && index > 0) {
      setState(() {
        index = index - 1;
      });
      widget.onChapterChanged?.call(index);
      await fetchContent();
      final length = pages.length;
      setState(() {
        cursor = length - 1;
      });
      calculateProgress();
    } else {
      widget.onMessage?.call('已经是第一页');
    }
    calculateBattery();
    widget.onProgressChanged?.call(cursor);
  }

  void handlePop() {
    widget.onPop?.call(index, cursor);
  }

  void handleRefresh() async {
    if (widget.onRefresh != null) {
      setState(() {
        error = null;
        loading = true;
        showCache = false;
        showOverlay = false;
      });
      try {
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
        var content = await widget.onRefresh!.call(index);
        final paginator = Paginator(size: size, theme: theme);
        setState(() {
          cursor = 0;
          error = null;
          loading = false;
          pages = paginator.paginate(content);
        });
        calculateProgress();
      } on TimeoutException {
        setState(() {
          cursor = 0;
          error = '出错了，请稍后再试';
          loading = false;
          pages = [];
        });
        calculateProgress();
      } on SocketException {
        setState(() {
          cursor = 0;
          error = '出错了，请稍后再试';
          loading = false;
          pages = [];
        });
        calculateProgress();
      } on RangeError {
        setState(() {
          cursor = 0;
          error = '出错了，请稍后再试';
          loading = false;
          pages = [];
        });
        calculateProgress();
      } catch (error) {
        setState(() {
          cursor = 0;
          this.error = error.runtimeType.toString();
          loading = false;
          pages = [];
        });
        calculateProgress();
      }
    }
  }

  void handleSliderChanged(double value) {
    setState(() {
      progress = value;
    });
  }

  void handleSliderChangeEnd(double value) {
    setState(() {
      cursor = 0;
    });
    var current = (value * total).toInt();
    if (current <= 0) {
      setState(() {
        index = 0;
      });
    } else if (current >= total) {
      setState(() {
        index = total - 1;
      });
    } else {
      setState(() {
        index = current;
      });
    }
    fetchContent();
    widget.onChapterChanged?.call(index);
    widget.onProgressChanged?.call(cursor);
  }

  @override
  void initState() {
    super.initState();
    cursor = widget.cursor ?? 0;
    duration = widget.duration ?? const Duration(milliseconds: 200);
    index = widget.index ?? 0;
    progress = 0;
    theme = widget.theme ?? ReaderTheme();
    total = widget.total ?? 1;
    controller = AnimationController(duration: duration, vsync: this);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    if (Platform.isAndroid) {
      subscription = FlutterAndroidVolumeKeydown.stream.listen((event) {
        if (mounted) {
          if (event == HardwareButton.volume_down) {
            handlePageDown();
          } else if (event == HardwareButton.volume_up) {
            handlePageUp();
          }
        }
      });
    }
    calculateBattery();
  }

  void preload(int index) async {
    preloads.clear();
    errors.clear();
    final paginator = Paginator(size: size, theme: theme);
    final next = index + 1;
    final previous = index - 1;
    if (next < total) {
      _preload(paginator, next);
    }
    if (index - 1 >= 0) {
      _preload(paginator, previous);
    }
  }

  void _preload(Paginator paginator, int index) async {
    try {
      final content = await widget.future(index);
      preloads[index] = paginator.paginate(content);
      errors[index] = null;
    } on TimeoutException {
      errors[index] = '出错了，请稍后再试';
      preloads[index] = [];
    } on SocketException {
      errors[index] = '出错了，请稍后再试';
      preloads[index] = [];
    } on RangeError {
      errors[index] = '出错了，请稍后再试';
      preloads[index] = [];
    } catch (error) {
      errors[index] = error.runtimeType.toString();
      preloads[index] = [];
    }
  }
}
