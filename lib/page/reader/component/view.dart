import 'package:battery_plus/battery_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:source_parser/model/reader_theme.dart';
import 'package:source_parser/provider/reader.dart';
import 'package:source_parser/util/merger.dart';

class ReaderView extends ConsumerWidget {
  final Widget Function()? builder;
  final String chapterText;
  final String contentText;
  final ReaderTheme? customTheme;
  final bool eInkMode;
  final String headerText;
  final String progressText;

  const ReaderView({
    super.key,
    this.builder,
    required this.chapterText,
    required this.contentText,
    this.customTheme,
    required this.eInkMode,
    required this.headerText,
    required this.progressText,
  });

  const ReaderView.builder({
    super.key,
    required this.builder,
    required this.chapterText,
    this.customTheme,
    required this.eInkMode,
    required this.headerText,
    required this.progressText,
  }) : contentText = '';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var state = ref.watch(readerThemeNotifierProvider).valueOrNull;
    var currentTheme = state ?? ReaderTheme();
    var theme = customTheme ?? currentTheme;
    var header = _Header(
      padding: theme.headerPadding,
      style: theme.headerStyle,
      text: headerText,
    );
    Widget content = _Content(
      chapterStyle: theme.chapterStyle,
      contentStyle: theme.pageStyle,
      padding: theme.pagePadding,
      text: contentText,
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
  final TextStyle chapterStyle;
  final TextStyle contentStyle;
  final EdgeInsets padding;
  final String text;
  const _Content({
    required this.chapterStyle,
    required this.contentStyle,
    required this.padding,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    var merger = Merger(chapterStyle: chapterStyle, contentStyle: contentStyle);
    var span = merger.merge(text);
    return Container(
      padding: padding,
      width: double.infinity,
      child: RichText(text: span),
    );
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
    var innerContainer = Container(
      color: primary.withOpacity(0.5),
      height: 8,
      width: 16 * (battery / 100),
    );
    var outerContainer = Container(
      alignment: Alignment.centerLeft,
      color: onBackground.withOpacity(0.25),
      height: 8,
      width: 16,
      child: innerContainer,
    );
    var body = ClipRRect(
      borderRadius: BorderRadius.circular(2),
      child: outerContainer,
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
  final String text;

  const _Header({
    required this.padding,
    required this.style,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Text(text, style: style, textAlign: TextAlign.start),
    );
  }
}
