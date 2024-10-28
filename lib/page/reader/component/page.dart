import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:source_parser/provider/setting.dart';
import 'package:source_parser/router/router.gr.dart';

class ReaderPage extends StatelessWidget {
  final int batteryLevel;
  final int cursor;
  final bool eInkMode;
  final String? error;
  final bool loading;
  final List<ReaderPageTurningMode> modes;
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
  const ReaderPage({
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
    var bookPageHeader = _Header(
      cursor: cursor,
      name: name,
      padding: theme.headerPadding,
      style: theme.headerStyle,
      title: title,
    );
    var page = Expanded(child: _buildPage());
    var bookPageFooter = _Footer(
      batteryLevel: batteryLevel,
      cursor: cursor,
      length: pages.length,
      loading: loading,
      padding: theme.footerPadding,
      progress: progress,
      style: theme.footerStyle,
    );
    var children = [bookPageHeader, page, bookPageFooter];
    var column = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children,
    );
    var gestureDetector = GestureDetector(
      behavior: HitTestBehavior.opaque,
      onHorizontalDragEnd: (details) => handleHorizontalDrag(context, details),
      onTapUp: (details) => handleTap(context, details),
      child: column,
    );
    return Scaffold(body: gestureDetector);
  }

  void handleHorizontalDrag(BuildContext context, DragEndDetails details) {
    if (!modes.contains(ReaderPageTurningMode.drag)) return;
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
      if (!modes.contains(ReaderPageTurningMode.tap)) return;
      onPageUp?.call();
    } else if (position.dx > width / 3 * 2) {
      if (!modes.contains(ReaderPageTurningMode.tap)) return;
      onPageDown?.call();
    } else {
      if (position.dy < height / 4) {
        if (!modes.contains(ReaderPageTurningMode.tap)) return;
        onPageUp?.call();
      } else if (position.dy > height / 4 * 3) {
        if (!modes.contains(ReaderPageTurningMode.tap)) return;
        onPageDown?.call();
      } else {
        onOverlayInserted?.call();
      }
    }
  }

  Widget _buildPage() {
    if (error != null) return _Error(error, onRefresh: onRefresh);
    if (loading) return const _Loading();
    if (pages.isEmpty) return _Error('没有内容', onRefresh: onRefresh);
    var strutStyle = StrutStyle(
      fontSize: theme.pageStyle.fontSize,
      forceStrutHeight: true,
      height: theme.pageStyle.height,
    );
    var text = Text.rich(
      TextSpan(text: pages[cursor], style: theme.pageStyle),
      strutStyle: strutStyle,
      textDirection: theme.textDirection,
    );
    return Container(
      padding: theme.pagePadding,
      width: double.infinity, // 确保文字很少的情况下也要撑开整个屏幕
      child: text,
    );
  }
}

enum ReaderPageTurningMode { drag, tap }

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

class _Error extends StatelessWidget {
  final String? error;

  final void Function()? onRefresh;
  const _Error(this.error, {required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    var children = [
      TextButton(onPressed: () => handleTap(context), child: const Text('换源')),
      ElevatedButton(onPressed: onRefresh, child: const Text('重试')),
    ];
    var columnChildren = [
      Text(error!),
      const SizedBox(height: 8),
      Row(mainAxisAlignment: MainAxisAlignment.center, children: children),
    ];
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: columnChildren,
    );
  }

  void handleTap(BuildContext context) {
    AutoRouter.of(context).push(AvailableSourceListRoute());
  }
}

class _Footer extends StatelessWidget {
  final int batteryLevel;
  final int cursor;
  final int length;
  final bool loading;
  final EdgeInsets padding;
  final double progress;
  final TextStyle style;
  const _Footer({
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
    final onBackground = colorScheme.outline;
    final battery = _buildBattery(context);
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

  Widget _buildBattery(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final primary = colorScheme.primary;
    final onBackground = colorScheme.outline;
    var outerDecoration = BoxDecoration(
      borderRadius: BorderRadius.circular(2),
      color: onBackground.withOpacity(0.25),
    );
    var innerDecoration = BoxDecoration(
      borderRadius: BorderRadius.circular(2),
      color: primary.withOpacity(0.5),
    );
    var container = Container(
      decoration: innerDecoration,
      height: 8,
      width: 16 * (batteryLevel / 100),
    );
    var body = Container(
      alignment: Alignment.centerLeft,
      decoration: outerDecoration,
      height: 8,
      width: 16,
      child: container,
    );
    const borderRadius = BorderRadius.only(
      topRight: Radius.circular(1),
      bottomRight: Radius.circular(1),
    );
    var capDecoration = BoxDecoration(
      borderRadius: borderRadius,
      color: onBackground.withOpacity(0.25),
    );
    var cap = Container(decoration: capDecoration, height: 4, width: 1);
    return Row(children: [body, cap]);
  }
}

class _Header extends StatelessWidget {
  final int cursor;
  final String name;
  final EdgeInsets padding;
  final TextStyle style;
  final String title;
  const _Header({
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
    var text = Text(
      cursor > 0 ? title : name,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: style.copyWith(color: style.color ?? onSurface.withOpacity(0.5)),
    );
    return Container(
      color: Colors.transparent,
      padding: padding,
      child: text,
    );
  }
}

class _Loading extends ConsumerWidget {
  const _Loading();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var provider = settingNotifierProvider;
    var setting = ref.watch(provider).valueOrNull;
    var eInkMode = setting?.eInkMode ?? false;
    var theme = ReaderTheme();
    if (eInkMode) return Center(child: Text('正在加载', style: theme.pageStyle));
    return const Center(child: CircularProgressIndicator());
  }
}
