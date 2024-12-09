import 'package:battery_plus/battery_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:source_parser/model/reader_theme.dart';
import 'package:source_parser/provider/reader.dart';

class ReaderView extends ConsumerWidget {
  final Widget Function()? builder;
  final bool eInkMode;
  final String chapterText;
  final String headerText;
  final TextSpan textSpan;
  final String progressText;

  const ReaderView({
    super.key,
    this.builder,
    required this.chapterText,
    required this.eInkMode,
    required this.headerText,
    required this.textSpan,
    required this.progressText,
  });

  const ReaderView.builder({
    super.key,
    required this.chapterText,
    required this.builder,
    required this.eInkMode,
    required this.headerText,
    required this.progressText,
  }) : textSpan = const TextSpan();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var state = ref.watch(readerThemeNotifierProvider).valueOrNull;
    print(state?.pageStyle);
    var theme = state ?? ReaderTheme();
    var header = _Header(
      padding: theme.headerPadding,
      style: theme.headerStyle,
      title: headerText,
    );
    Widget content = _Content(
      padding: theme.pagePadding,
      style: theme.pageStyle,
      textSpan: textSpan,
    );
    if (builder != null) content = builder!.call();
    var footer = _Footer(
      chapterText: chapterText,
      padding: theme.footerPadding,
      progressText: progressText,
      style: theme.footerStyle,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [header, Expanded(child: content), footer],
    );
  }
}

class _Content extends StatelessWidget {
  final EdgeInsets padding;
  final TextStyle style;
  final TextSpan textSpan;
  const _Content({
    required this.padding,
    required this.style,
    required this.textSpan,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(padding: padding, child: RichText(text: textSpan));
  }
}

class _Footer extends StatefulWidget {
  final String chapterText;
  final EdgeInsets padding;
  final String progressText;
  final TextStyle style;

  const _Footer({
    required this.chapterText,
    required this.padding,
    required this.progressText,
    required this.style,
  });

  @override
  State<_Footer> createState() => _FooterState();
}

class _FooterState extends State<_Footer> {
  int battery = 100;

  @override
  Widget build(BuildContext context) {
    const spacer = SizedBox(width: 4);
    var pageIndicator = _buildPage();
    var progressIndicator = _buildProgress();
    var left = Row(children: [pageIndicator, spacer, progressIndicator]);
    var timeIndicator = _buildTime();
    var batteryIndicator = _buildBattery();
    var right = Row(children: [timeIndicator, spacer, batteryIndicator]);
    var row = Row(children: [left, const Spacer(), right]);
    return Padding(padding: widget.padding, child: row);
  }

  @override
  void initState() {
    super.initState();
    _calculateBattery();
  }

  Widget _buildBattery() {
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
      width: 16 * (battery / 100),
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

  Widget _buildPage() {
    return Text(widget.chapterText, style: widget.style);
  }

  Widget _buildProgress() {
    return Text(widget.progressText, style: widget.style);
  }

  Widget _buildTime() {
    var time = DateTime.now().toString().substring(11, 16);
    return Text(time, style: widget.style);
  }

  Future<void> _calculateBattery() async {
    var level = await Battery().batteryLevel;
    setState(() {
      battery = level;
    });
  }
}

class _Header extends StatelessWidget {
  final EdgeInsets padding;
  final TextStyle style;
  final String title;

  const _Header({
    required this.padding,
    required this.style,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    var text = Text(title, style: style, textAlign: TextAlign.start);
    return Padding(padding: padding, child: text);
  }
}
