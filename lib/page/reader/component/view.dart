import 'package:battery_plus/battery_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:source_parser/provider/setting.dart';
import 'package:source_parser/provider/theme.dart';
import 'package:source_parser/schema/theme.dart' as schema;
import 'package:source_parser/util/merger.dart';

class ReaderView extends ConsumerWidget {
  final Widget Function()? builder;
  final String chapterText;
  final String contentText;
  final schema.Theme? customTheme;
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
    var theme = _assembleTheme(ref);
    var header = _Header(text: headerText, theme: theme);
    Widget content = _Content(text: contentText, theme: theme);
    if (builder != null) content = builder!.call();
    var footer = _Footer(
      chapterText: chapterText,
      progressText: progressText,
      theme: theme,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [header, Expanded(child: content), footer],
    );
  }

  schema.Theme _assembleTheme(WidgetRef ref) {
    if (customTheme != null) return customTheme!;
    var state = ref.watch(themeNotifierProvider).valueOrNull;
    var currentTheme = state ?? schema.Theme();
    int backgroundColor = currentTheme.backgroundColor;
    int contentColor = currentTheme.contentColor;
    int footerColor = currentTheme.footerColor;
    int headerColor = currentTheme.headerColor;
    var setting = ref.watch(settingNotifierProvider).valueOrNull;
    if (setting?.darkMode == true) {
      backgroundColor = Colors.black.value;
      contentColor = Colors.white.withOpacity(0.75).value;
      footerColor = Colors.white.withOpacity(0.5).value;
      headerColor = Colors.white.withOpacity(0.5).value;
    }
    return currentTheme.copyWith(
      backgroundColor: backgroundColor,
      contentColor: contentColor,
      footerColor: footerColor,
      headerColor: headerColor,
    );
  }
}

class _Content extends StatelessWidget {
  final String text;
  final schema.Theme theme;
  const _Content({required this.text, required this.theme});

  @override
  Widget build(BuildContext context) {
    var merger = Merger(theme: theme);
    var span = merger.merge(text);
    return Container(
      padding: _getContentPadding(),
      width: double.infinity,
      child: RichText(text: span),
    );
  }

  EdgeInsets _getContentPadding() {
    return EdgeInsets.only(
      bottom: theme.contentPaddingBottom,
      left: theme.contentPaddingLeft,
      right: theme.contentPaddingRight,
      top: theme.contentPaddingTop,
    );
  }
}

class _Footer extends StatefulWidget {
  final String chapterText;
  final String progressText;
  final schema.Theme theme;

  const _Footer({
    required this.chapterText,
    required this.progressText,
    required this.theme,
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
    var left = Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [pageIndicator, spacer, progressIndicator],
    );
    var timeIndicator = _buildTime();
    var batteryIndicator = _buildBattery();
    var right = Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [timeIndicator, spacer, batteryIndicator],
    );
    var row = Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [left, const Spacer(), right],
    );
    return Padding(padding: _getPadding(), child: row);
  }

  @override
  void initState() {
    super.initState();
    _calculateBattery();
  }

  Widget _buildBattery() {
    final materialTheme = Theme.of(context);
    final colorScheme = materialTheme.colorScheme;
    final primary = colorScheme.primary;
    final onBackground = colorScheme.outline;
    var height = widget.theme.footerFontSize * widget.theme.footerHeight;
    var width = height * 2;
    var innerContainer = Container(
      color: primary.withOpacity(0.5),
      height: height,
      width: width * (battery / 100),
    );
    var outerContainer = Container(
      alignment: Alignment.centerLeft,
      color: onBackground.withOpacity(0.25),
      height: height,
      width: width,
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
    var cap = Container(
      decoration: capDecoration,
      height: height / 2,
      width: 1,
    );
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [body, cap],
    );
  }

  Widget _buildPage() {
    return Text(widget.chapterText, style: _getStyle());
  }

  Widget _buildProgress() {
    return Text(widget.progressText, style: _getStyle());
  }

  Widget _buildTime() {
    var time = DateTime.now().toString().substring(11, 16);
    return Text(time, style: _getStyle());
  }

  Future<void> _calculateBattery() async {
    var level = await Battery().batteryLevel;
    setState(() {
      battery = level;
    });
  }

  EdgeInsets _getPadding() {
    return EdgeInsets.only(
      bottom: widget.theme.footerPaddingBottom,
      left: widget.theme.footerPaddingLeft,
      right: widget.theme.footerPaddingRight,
      top: widget.theme.footerPaddingTop,
    );
  }

  TextStyle _getStyle() {
    return TextStyle(
      color: Color(widget.theme.footerColor),
      decoration: TextDecoration.none,
      fontSize: widget.theme.footerFontSize,
      fontWeight: FontWeight.values[widget.theme.footerFontWeight],
      height: widget.theme.footerHeight,
      letterSpacing: widget.theme.footerLetterSpacing,
      wordSpacing: widget.theme.footerWordSpacing,
    );
  }
}

class _Header extends StatelessWidget {
  final String text;
  final schema.Theme theme;

  const _Header({required this.text, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: _getPadding(),
      child: Text(text, style: _getStyle(), textAlign: TextAlign.start),
    );
  }

  EdgeInsets _getPadding() {
    return EdgeInsets.only(
      bottom: theme.headerPaddingBottom,
      left: theme.headerPaddingLeft,
      right: theme.headerPaddingRight,
      top: theme.headerPaddingTop,
    );
  }

  TextStyle _getStyle() {
    return TextStyle(
      color: Color(theme.headerColor),
      decoration: TextDecoration.none,
      fontSize: theme.headerFontSize,
      fontWeight: FontWeight.values[theme.headerFontWeight],
      height: theme.headerHeight,
      letterSpacing: theme.headerLetterSpacing,
      wordSpacing: theme.headerWordSpacing,
    );
  }
}
