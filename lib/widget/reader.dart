import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:battery_plus/battery_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_android_volume_keydown/flutter_android_volume_keydown.dart';

class BookOverlay extends StatefulWidget {
  final String author;

  final Widget cover;
  final bool darkMode;
  final String name;
  final double progress;
  final void Function(int)? onCache;
  final void Function()? onCataloguePressed;
  final void Function()? onChapterDown;
  final void Function()? onChapterUp;
  final void Function()? onDarkModePressed;
  final void Function()? onDetailPressed;
  final void Function()? onOverlayRemoved;
  final void Function()? onPop;
  final void Function()? onRefresh;
  final void Function()? onSettingPressed;
  final void Function(double)? onSliderChanged;
  final void Function(double)? onSliderChangedEnd;
  final void Function()? onSourcePressed;
  const BookOverlay({
    super.key,
    required this.author,
    required this.cover,
    required this.darkMode,
    required this.name,
    this.progress = 0,
    this.onCache,
    this.onCataloguePressed,
    this.onChapterDown,
    this.onChapterUp,
    this.onDarkModePressed,
    this.onDetailPressed,
    this.onOverlayRemoved,
    this.onPop,
    this.onRefresh,
    this.onSettingPressed,
    this.onSliderChanged,
    this.onSliderChangedEnd,
    this.onSourcePressed,
  });

  @override
  State<BookOverlay> createState() => _BookOverlayState();
}

class BookPage extends StatelessWidget {
  final int batteryLevel;

  final int cursor;
  final bool eInkMode;
  final String? error;
  final bool loading;
  final List<PageTurningMode> modes;
  final String name;
  final List<String> pages;
  final double progress;
  final ReaderTheme theme;
  final String title;
  final void Function()? onOverlayInserted;
  final void Function()? onPageDown;
  final void Function()? onPageUp;
  final void Function()? onRefresh;
  final void Function()? onSourcePressed;
  const BookPage({
    super.key,
    required this.batteryLevel,
    required this.cursor,
    required this.eInkMode,
    this.error,
    required this.loading,
    required this.modes,
    required this.name,
    required this.pages,
    required this.progress,
    required this.theme,
    required this.title,
    this.onOverlayInserted,
    this.onPageDown,
    this.onPageUp,
    this.onRefresh,
    this.onSourcePressed,
  });

  @override
  Widget build(BuildContext context) {
    Widget child;
    if (eInkMode) {
      child = Center(child: Text('正在加载', style: theme.pageStyle));
    } else {
      child = const Center(child: CircularProgressIndicator());
    }
    final textTheme = Theme.of(context).textTheme;
    final bodyLarge = textTheme.bodyLarge;
    if (error != null) {
      child = Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(error!, style: bodyLarge),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(onPressed: onSourcePressed, child: const Text('换源')),
                ElevatedButton(onPressed: onRefresh, child: const Text('重试')),
              ],
            ),
          ],
        ),
      );
    } else if (!loading) {
      if (pages.isNotEmpty) {
        child = Container(
          padding: theme.pagePadding,
          width: double.infinity, // 确保文字很少的情况下也要撑开整个屏幕
          child: Text.rich(
            TextSpan(text: pages[cursor], style: theme.pageStyle),
            strutStyle: StrutStyle(
              fontSize: theme.pageStyle.fontSize,
              forceStrutHeight: true,
              height: theme.pageStyle.height,
            ),
            textDirection: theme.textDirection,
          ),
        );
      } else {
        child = Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('暂无内容', style: theme.pageStyle),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                      onPressed: onSourcePressed, child: const Text('换源')),
                  ElevatedButton(onPressed: onRefresh, child: const Text('重试')),
                ],
              ),
            ],
          ),
        );
      }
    }

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onHorizontalDragEnd: (details) => handleHorizontalDrag(context, details),
      onTapUp: (details) => handleTap(context, details),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _BookPageHeader(
            cursor: cursor,
            name: name,
            padding: theme.headerPadding,
            style: theme.headerStyle,
            title: title,
          ),
          Expanded(child: child),
          _BookPageFooter(
            batteryLevel: batteryLevel,
            cursor: cursor,
            length: pages.length,
            loading: loading,
            padding: theme.footerPadding,
            progress: progress,
            style: theme.footerStyle,
          ),
        ],
      ),
    );
  }

  void handleHorizontalDrag(BuildContext context, DragEndDetails details) {
    if (!modes.contains(PageTurningMode.drag)) return;
    final velocity = details.primaryVelocity;
    if (velocity == null) return;
    if (velocity < 0) {
      onPageDown?.call();
    } else if (velocity > 0) {
      onPageUp?.call();
    }
  }

  void handleTap(BuildContext context, TapUpDetails details) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final position = details.localPosition;
    if (position.dx < width / 3) {
      if (!modes.contains(PageTurningMode.tap)) return;
      onPageUp?.call();
    } else if (position.dx > width / 3 * 2) {
      if (!modes.contains(PageTurningMode.tap)) return;
      onPageDown?.call();
    } else {
      if (position.dy < height / 4) {
        if (!modes.contains(PageTurningMode.tap)) return;
        onPageUp?.call();
      } else if (position.dy > height / 4 * 3) {
        if (!modes.contains(PageTurningMode.tap)) return;
        onPageDown?.call();
      } else {
        onOverlayInserted?.call();
      }
    }
  }
}

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
  final List<PageTurningMode> modes;

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
    this.modes = PageTurningMode.values,
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

class BookReaderIntroduction {
  final String author;
  final Image cover;
  final String name;
  final String title;

  BookReaderIntroduction({
    required this.author,
    required this.cover,
    required this.name,
    required this.title,
  });

  BookReaderIntroduction copyWith({
    String? author,
    Image? cover,
    String? name,
    String? title,
  }) {
    return BookReaderIntroduction(
      author: author ?? this.author,
      cover: cover ?? this.cover,
      name: name ?? this.name,
      title: title ?? this.title,
    );
  }
}

class BookReaderProgress {
  final int chapterIndex;
  final int chapterTotal;
  final int pageIndex;
  final int pageTotal;

  BookReaderProgress({
    required this.chapterIndex,
    required this.chapterTotal,
    required this.pageIndex,
    required this.pageTotal,
  });

  double get progress {
    if (chapterTotal == 0) {
      return 0;
    }
    double progressPerChapter = 1 / chapterTotal;
    double progressPerPage = 1 / pageTotal;
    final chapterProgress = chapterIndex * progressPerChapter;
    final pageProgress = pageIndex * progressPerPage;
    return chapterProgress + pageProgress * progressPerChapter;
  }

  BookReaderProgress copyWith({
    int? chapterIndex,
    int? chapterTotal,
    int? pageIndex,
    int? pageTotal,
  }) {
    return BookReaderProgress(
      chapterIndex: chapterIndex ?? this.chapterIndex,
      chapterTotal: chapterTotal ?? this.chapterTotal,
      pageIndex: pageIndex ?? this.pageIndex,
      pageTotal: pageTotal ?? this.pageTotal,
    );
  }
}

class BookReaderTheme {
  Color backgroundColor = Colors.white;
  String backgroundImage = '';
  EdgeInsets footerPadding = const EdgeInsets.symmetric(
    horizontal: 16,
    vertical: 4,
  );
  TextStyle footerStyle = const TextStyle(
    fontSize: 10,
    height: 1,
  );
  EdgeInsets headerPadding = const EdgeInsets.symmetric(
    horizontal: 16,
    vertical: 4,
  );
  TextStyle headerStyle = const TextStyle(
    fontSize: 10,
    height: 1,
  );
  EdgeInsets pagePadding = const EdgeInsets.symmetric(
    horizontal: 16,
  );
  TextStyle pageStyle = const TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w400,
    height: 1.0 + 0.618 * 2,
    letterSpacing: 0.618,
    wordSpacing: 0.618,
  );
  TextDirection textDirection = TextDirection.ltr;

  BookReaderTheme copyWith({
    Color? backgroundColor,
    String? backgroundImage,
    EdgeInsets? footerPadding,
    TextStyle? footerStyle,
    EdgeInsets? headerPadding,
    TextStyle? headerStyle,
    EdgeInsets? pagePadding,
    TextStyle? pageStyle,
    TextDirection? textDirection,
  }) {
    return BookReaderTheme()
      ..backgroundColor = backgroundColor ?? this.backgroundColor
      ..backgroundImage = backgroundImage ?? this.backgroundImage
      ..footerPadding = footerPadding ?? this.footerPadding
      ..footerStyle = footerStyle ?? this.footerStyle
      ..headerPadding = headerPadding ?? this.headerPadding
      ..headerStyle = headerStyle ?? this.headerStyle
      ..pagePadding = pagePadding ?? this.pagePadding
      ..pageStyle = pageStyle ?? this.pageStyle
      ..textDirection = textDirection ?? this.textDirection;
  }
}

enum PageTurningMode { drag, tap }

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

class ReaderTheme {
  Color backgroundColor = Colors.white;
  String backgroundImage = '';
  EdgeInsets footerPadding = const EdgeInsets.symmetric(
    horizontal: 16,
    vertical: 4,
  );
  TextStyle footerStyle = const TextStyle(
    fontSize: 10,
    height: 1,
  );
  EdgeInsets headerPadding = const EdgeInsets.symmetric(
    horizontal: 16,
    vertical: 4,
  );
  TextStyle headerStyle = const TextStyle(
    fontSize: 10,
    height: 1,
  );
  EdgeInsets pagePadding = const EdgeInsets.symmetric(
    horizontal: 16,
  );
  TextStyle pageStyle = const TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w400,
    height: 1.0 + 0.618 * 2,
    letterSpacing: 0.618,
    wordSpacing: 0.618,
  );
  TextDirection textDirection = TextDirection.ltr;

  ReaderTheme copyWith({
    Color? backgroundColor,
    String? backgroundImage,
    EdgeInsets? footerPadding,
    TextStyle? footerStyle,
    EdgeInsets? headerPadding,
    TextStyle? headerStyle,
    EdgeInsets? pagePadding,
    TextStyle? pageStyle,
    TextDirection? textDirection,
  }) {
    return ReaderTheme()
      ..backgroundColor = backgroundColor ?? this.backgroundColor
      ..backgroundImage = backgroundImage ?? this.backgroundImage
      ..footerPadding = footerPadding ?? this.footerPadding
      ..footerStyle = footerStyle ?? this.footerStyle
      ..headerPadding = headerPadding ?? this.headerPadding
      ..headerStyle = headerStyle ?? this.headerStyle
      ..pagePadding = pagePadding ?? this.pagePadding
      ..pageStyle = pageStyle ?? this.pageStyle
      ..textDirection = textDirection ?? this.textDirection;
  }
}

class _BookOverlayState extends State<BookOverlay> {
  bool showCache = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _BookPageOverlayAppBar(
          author: widget.author,
          cover: widget.cover,
          name: widget.name,
          onCachePressed: handleCachePressed,
          onDetailPressed: widget.onDetailPressed,
          onPop: widget.onPop,
          onRefresh: widget.onRefresh,
        ),
        _BookReaderOverlayMask(onTap: widget.onOverlayRemoved),
        if (showCache) _BookPageOverlayCache(onCache: handleCache),
        _BookPageOverlayBottomBar(
          darkMode: widget.darkMode,
          progress: widget.progress,
          onCataloguePressed: widget.onCataloguePressed,
          onChapterDown: widget.onChapterDown,
          onChapterUp: widget.onChapterUp,
          onDarkModePressed: widget.onDarkModePressed,
          onSettingPressed: widget.onSettingPressed,
          onSliderChanged: widget.onSliderChanged,
          onSliderChangedEnd: widget.onSliderChangedEnd,
          onSourcePressed: widget.onSourcePressed,
        ),
      ],
    );
  }

  void handleCache(int amount) {
    setState(() {
      showCache = false;
    });
    widget.onCache?.call(amount);
  }

  void handleCachePressed() {
    setState(() {
      showCache = !showCache;
    });
  }
}

class _BookPageFooter extends StatelessWidget {
  final int batteryLevel;

  final int cursor;
  final int length;
  final bool loading;
  final EdgeInsets padding;
  final double progress;
  final TextStyle style;
  const _BookPageFooter({
    required this.batteryLevel,
    required this.cursor,
    required this.length,
    required this.loading,
    required this.padding,
    required this.progress,
    required this.style,
  });

  @override
  Widget build(BuildContext context) {
    List<Widget> left = [const Text('获取中')];
    if (!loading && length > 0) {
      left = [
        Text('${cursor + 1}/$length'),
        const SizedBox(width: 16),
        Text('${(progress * 100).toStringAsFixed(2)}%'),
      ];
    }
    final now = DateTime.now().toString().substring(11, 16);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final primary = colorScheme.primary;
    final onBackground = colorScheme.outline;
    final battery = Row(
      children: [
        Container(
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(2),
            color: style.color ?? onBackground.withOpacity(0.25),
          ),
          height: 8,
          width: 16,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(2),
              color: primary.withOpacity(0.5),
            ),
            height: 8,
            width: 16 * (batteryLevel / 100),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(1),
              bottomRight: Radius.circular(1),
            ),
            color: style.color ?? onBackground.withOpacity(0.25),
          ),
          height: 4,
          width: 1,
        ),
      ],
    );
    List<Widget> right = [Text(now), const SizedBox(width: 8), battery];
    return Container(
      color: Colors.transparent,
      padding: padding,
      child: DefaultTextStyle.merge(
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: style.copyWith(
          color: style.color ?? onBackground.withOpacity(0.5),
          height: 1,
        ),
        child: Row(children: [...left, const Spacer(), ...right]),
      ),
    );
  }
}

class _BookPageHeader extends StatelessWidget {
  final int cursor;

  final String name;
  final EdgeInsets padding;
  final TextStyle style;
  final String title;
  const _BookPageHeader({
    required this.cursor,
    required this.name,
    required this.padding,
    required this.style,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final onSurface = colorScheme.onSurface;
    return Container(
      color: Colors.transparent,
      padding: padding,
      child: Text(
        cursor > 0 ? title : name,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: style.copyWith(
          color: style.color ?? onSurface.withOpacity(0.5),
        ),
      ),
    );
  }
}

class _BookPageOverlayAppBar extends StatefulWidget {
  final String author;

  final Widget cover;
  final String name;
  final void Function()? onCachePressed;
  final void Function()? onDetailPressed;
  final void Function()? onPop;
  final void Function()? onRefresh;
  const _BookPageOverlayAppBar({
    required this.author,
    required this.cover,
    required this.name,
    this.onCachePressed,
    this.onDetailPressed,
    this.onPop,
    this.onRefresh,
  });

  @override
  State<_BookPageOverlayAppBar> createState() => _BookPageOverlayAppBarState();
}

class _BookPageOverlayAppBarState extends State<_BookPageOverlayAppBar> {
  OverlayEntry? entry;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.surface,
      child: Container(
        color: Theme.of(context).colorScheme.surfaceTint.withOpacity(0.1),
        padding: const EdgeInsets.all(4),
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).padding.top),
            Row(
              children: [
                IconButton(
                  onPressed: widget.onPop,
                  icon: const Icon(Icons.arrow_back_ios),
                ),
                const Expanded(child: SizedBox()),
                TextButton(
                  onPressed: widget.onCachePressed,
                  child: const Row(
                    children: [Icon(Icons.file_download_outlined), Text('缓存')],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.more_horiz_outlined),
                  onPressed: () => handlePressed(context),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void handleDetailPressed() {
    if (entry != null) {
      entry?.remove();
      entry = null;
    }
    widget.onDetailPressed?.call();
  }

  void handlePressed(BuildContext context) {
    final overlay = Overlay.of(context);
    if (entry == null) {
      final theme = Theme.of(context);
      final colorScheme = theme.colorScheme;
      final surface = colorScheme.surface;
      final shadow = colorScheme.shadow;
      final textTheme = theme.textTheme;
      final bodyMedium = textTheme.bodyMedium;
      final bodySmall = textTheme.bodySmall;
      entry = OverlayEntry(builder: (context) {
        return Positioned.fill(
          child: Container(
            color: Colors.transparent,
            child: Column(
              children: [
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: handleTap,
                  child: SizedBox(
                    height: MediaQuery.of(context).padding.top + 56,
                    width: double.infinity,
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: surface,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: shadow.withOpacity(0.25),
                        offset: const Offset(0, 8),
                        blurRadius: 16,
                      )
                    ],
                  ),
                  margin: const EdgeInsets.all(8),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          widget.cover,
                          const SizedBox(width: 8),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(widget.name, style: bodyMedium),
                              Text(widget.author, style: bodySmall)
                            ],
                          ),
                          const Spacer(),
                          OutlinedButton(
                            style: const ButtonStyle(
                              minimumSize: WidgetStatePropertyAll(Size.zero),
                              padding: WidgetStatePropertyAll(
                                EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 4,
                                ),
                              ),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            onPressed: handleDetailPressed,
                            child: const Text('详情'),
                          )
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Divider(height: 1),
                      const SizedBox(height: 8),
                      TextButton(
                        onPressed: handleRefresh,
                        child: const Column(
                          children: [
                            Icon(Icons.refresh_outlined),
                            Text('强制刷新'),
                          ],
                        ),
                      ),
                      // Row(
                      //   children: [
                      //     Expanded(
                      //       child: TextButton(
                      //         onPressed: handleRefresh,
                      //         child: const Column(
                      //           children: [
                      //             Icon(Icons.refresh_outlined),
                      //             Text('强制刷新'),
                      //           ],
                      //         ),
                      //       ),
                      //     ),
                      //     Expanded(
                      //       child: TextButton(
                      //         onPressed: handleRefresh,
                      //         child: const Column(
                      //           children: [
                      //             Icon(Icons.lock_outline),
                      //             Text('归档'),
                      //           ],
                      //         ),
                      //       ),
                      //     ),
                      //     Expanded(
                      //       child: TextButton(
                      //         onPressed: handleRefresh,
                      //         child: const Column(
                      //           children: [
                      //             Icon(Icons.public_outlined),
                      //             Text('原始网页'),
                      //           ],
                      //         ),
                      //       ),
                      //     ),
                      //     const Expanded(child: SizedBox()),
                      //   ],
                      // ),
                    ],
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: handleTap,
                    child: const SizedBox(
                      height: double.infinity,
                      width: double.infinity,
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      });
      overlay.insert(entry!);
    } else {
      entry?.remove();
      entry = null;
    }
  }

  void handleRefresh() {
    if (entry != null) {
      entry?.remove();
      entry = null;
    }
    widget.onRefresh?.call();
  }

  void handleTap() {
    if (entry != null) {
      entry?.remove();
      entry = null;
    }
  }
}

class _BookPageOverlayBottomBar extends StatelessWidget {
  final bool darkMode;

  final double progress;
  final void Function()? onCataloguePressed;
  final void Function()? onChapterDown;
  final void Function()? onChapterUp;
  final void Function()? onDarkModePressed;
  final void Function()? onSettingPressed;
  final void Function(double)? onSliderChanged;
  final void Function(double)? onSliderChangedEnd;
  final void Function()? onSourcePressed;
  const _BookPageOverlayBottomBar({
    this.darkMode = false,
    this.progress = 0,
    this.onCataloguePressed,
    this.onChapterDown,
    this.onChapterUp,
    this.onDarkModePressed,
    this.onSettingPressed,
    this.onSliderChanged,
    this.onSliderChangedEnd,
    this.onSourcePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.surface,
      child: Container(
        color: Theme.of(context).colorScheme.surfaceTint.withOpacity(0.1),
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        child: Column(
          children: [
            Row(
              children: [
                TextButton(
                  onPressed: onChapterUp,
                  child: const Text('上一章'),
                ),
                Expanded(
                  child: Material(
                    color: Colors.transparent,
                    child: Slider(
                      value: progress,
                      onChanged: onSliderChanged,
                      onChangeEnd: onSliderChangedEnd,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: onChapterDown,
                  child: const Text('下一章'),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: onCataloguePressed,
                  child: const Column(
                    children: [
                      Icon(Icons.list),
                      Text('目录'),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: onSourcePressed,
                  child: const Column(
                    children: [
                      Icon(Icons.change_circle_outlined),
                      Text('换源'),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () => handleDarkModePressed(context),
                  child: Column(
                    children: [
                      Icon(darkMode
                          ? Icons.light_mode_outlined
                          : Icons.dark_mode_outlined),
                      Text(darkMode ? '白天' : '夜间'),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: onSettingPressed,
                  child: const Column(
                    children: [
                      Icon(Icons.settings),
                      Text('设置'),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void handleDarkModePressed(BuildContext context) {
    onDarkModePressed?.call();
    final brightness = Theme.of(context).brightness;
    SystemUiOverlayStyle style;
    if (brightness == Brightness.dark) {
      style = SystemUiOverlayStyle.dark;
    } else {
      style = SystemUiOverlayStyle.light;
    }
    SystemChrome.setSystemUIOverlayStyle(style);
  }
}

class _BookPageOverlayCache extends StatelessWidget {
  final void Function(int)? onCache;

  const _BookPageOverlayCache({this.onCache});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.surface,
      child: Container(
        color: Theme.of(context).colorScheme.surfaceTint.withOpacity(0.1),
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => handleCached(100),
                child: const Text('100章'),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: OutlinedButton(
                onPressed: () => handleCached(200),
                child: const Text('200章'),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: OutlinedButton(
                onPressed: () => handleCached(0),
                child: const Text('全部'),
              ),
            )
          ],
        ),
      ),
    );
  }

  void handleCached(int amount) {
    onCache?.call(amount);
  }
}

class _BookReaderOverlayMask extends StatelessWidget {
  final void Function()? onTap;

  const _BookReaderOverlayMask({this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(color: Colors.transparent),
      ),
    );
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
    return Scaffold(
      body: Stack(
        children: [
          if (theme.backgroundImage.isEmpty)
            Container(color: theme.backgroundColor),
          if (theme.backgroundImage.isNotEmpty)
            Image.asset(
              theme.backgroundImage,
              fit: BoxFit.cover,
              height: double.infinity,
              width: double.infinity,
            ),
          BookPage(
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
          ),
          if (showOverlay)
            BookOverlay(
              author: widget.author,
              cover: widget.cover,
              darkMode: widget.darkMode,
              name: widget.name,
              progress: progress,
              onCache: handleCached,
              onCataloguePressed: handleCataloguePressed,
              onChapterDown: handleChapterDown,
              onChapterUp: handleChapterUp,
              onDarkModePressed: widget.onDarkModePressed,
              onDetailPressed: widget.onDetailPressed,
              onOverlayRemoved: handleOverlayRemoved,
              onPop: handlePop,
              onRefresh: handleRefresh,
              onSettingPressed: widget.onSettingPressed,
              onSliderChanged: handleSliderChanged,
              onSliderChangedEnd: handleSliderChangeEnd,
              onSourcePressed: widget.onSourcePressed,
            )
        ],
      ),
    );
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
