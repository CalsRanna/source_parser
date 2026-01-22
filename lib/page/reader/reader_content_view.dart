import 'package:flutter/material.dart';
import 'package:source_parser/config/string_config.dart';
import 'package:source_parser/schema/theme.dart' as schema;
import 'package:source_parser/util/merger.dart';
import 'package:source_parser/util/string_extension.dart';
import 'package:source_parser/widget/loading.dart';

class ReaderContentView extends StatelessWidget {
  final int? battery;
  final String contentText;
  final String headerText;
  final String pageProgressText;
  final bool isLoading;
  final bool isFirstPage;
  final schema.Theme theme;
  final String? errorText;

  const ReaderContentView({
    super.key,
    this.battery,
    required this.contentText,
    required this.theme,
    required this.headerText,
    required this.pageProgressText,
    required this.isFirstPage,
  })  : isLoading = false,
        errorText = null;

  const ReaderContentView.loading({
    super.key,
    required this.theme,
  })  : battery = null,
        contentText = '',
        headerText = StringConfig.loading,
        pageProgressText = '',
        isLoading = true,
        isFirstPage = false,
        errorText = null;

  const ReaderContentView.error({
    super.key,
    required this.theme,
    required this.errorText,
  })  : battery = null,
        contentText = '',
        headerText = StringConfig.loadingFailed,
        pageProgressText = '',
        isLoading = false,
        isFirstPage = false;

  @override
  Widget build(BuildContext context) {
    var background = _buildBackground(theme);
    var content = _buildContent(theme);
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(children: [background, content]),
    );
  }

  Widget _buildBackground(schema.Theme theme) {
    var backgroundContainer = _buildBackgroundContainer(theme.backgroundColor);
    var backgroundImage = _buildBackgroundImage(theme.backgroundImage);
    return Stack(children: [backgroundContainer, backgroundImage]);
  }

  Widget _buildBackgroundContainer(String backgroundColorHex) {
    return Container(
      color: backgroundColorHex.toColor(),
      height: double.infinity,
      width: double.infinity,
    );
  }

  Widget _buildBackgroundImage(String backgroundImage) {
    if (backgroundImage.isEmpty) return const SizedBox();
    return Image.asset(
      backgroundImage,
      fit: BoxFit.cover,
      height: double.infinity,
      width: double.infinity,
    );
  }

  Widget _buildContent(schema.Theme theme) {
    var header = _Header(text: headerText, theme: theme);
    Widget contentWidget = _Content(
      content: contentText,
      theme: theme,
      isLoading: isLoading,
      isFirstPage: isFirstPage,
      errorMessage: errorText,
    );
    var footer = _Footer(
      battery: battery,
      pageProgressText: pageProgressText,
      theme: theme,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [header, Expanded(child: contentWidget), footer],
    );
  }
}

class _Battery extends StatelessWidget {
  final int battery;
  final Size size;
  const _Battery({required this.battery, required this.size});

  @override
  Widget build(BuildContext context) {
    final materialTheme = Theme.of(context);
    final colorScheme = materialTheme.colorScheme;
    final primary = colorScheme.primary;
    final onBackground = colorScheme.outline;
    var height = size.height;
    var width = size.width;
    var innerContainer = Container(
      color: primary.withValues(alpha: 0.5),
      height: height,
      width: width * (battery / 100),
    );
    var outerContainer = Container(
      alignment: Alignment.centerLeft,
      color: onBackground.withValues(alpha: 0.25),
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
      color: onBackground.withValues(alpha: 0.25),
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
}

class _Content extends StatelessWidget {
  final String content;
  final schema.Theme theme;
  final bool isFirstPage;
  final bool isLoading;
  final String? errorMessage;

  const _Content({
    required this.content,
    required this.theme,
    required this.isFirstPage,
    required this.isLoading,
    this.errorMessage,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: LoadingIndicator());
    }

    if (errorMessage != null) {
      var textStyle = TextStyle(
        color: theme.contentColor.toColor(),
        fontSize: theme.contentFontSize,
      );
      var text = Text(
        errorMessage!.isEmpty ? StringConfig.loadingFailed : errorMessage!,
        style: textStyle,
      );
      return Center(child: text);
    }

    if (content.isEmpty) {
      return const SizedBox();
    }

    final merger = Merger(theme: theme);
    return Container(
      padding: _getPadding(),
      width: double.infinity,
      child:
          SelectableText.rich(merger.merge(content, isFirstPage: isFirstPage)),
    );
  }

  EdgeInsets _getPadding() {
    return EdgeInsets.only(
      bottom: theme.contentPaddingBottom,
      left: theme.contentPaddingLeft,
      right: theme.contentPaddingRight,
      top: theme.contentPaddingTop,
    );
  }
}

class _Footer extends StatelessWidget {
  final int? battery;
  final String pageProgressText;
  final schema.Theme theme;

  const _Footer({
    this.battery,
    required this.pageProgressText,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    var children = [
      Text(pageProgressText, style: _getStyle()),
      const Spacer(),
      _buildTime(),
      const SizedBox(width: 4),
      _buildBattery(),
    ];
    var row = Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: children,
    );
    return Padding(padding: _getPadding(), child: row);
  }

  Widget _buildBattery() {
    if (battery == null) return const SizedBox();
    var height = theme.footerFontSize * theme.footerHeight;
    var width = height * 2;
    return _Battery(battery: battery!, size: Size(width, height));
  }

  Widget _buildTime() {
    var time = DateTime.now().toString().substring(11, 16);
    return Text(time, style: _getStyle());
  }

  EdgeInsets _getPadding() {
    return EdgeInsets.only(
      bottom: theme.footerPaddingBottom,
      left: theme.footerPaddingLeft,
      right: theme.footerPaddingRight,
      top: theme.footerPaddingTop,
    );
  }

  TextStyle _getStyle() {
    return TextStyle(
      color: theme.footerColor.toColor(),
      decoration: TextDecoration.none,
      fontSize: theme.footerFontSize,
      fontWeight: FontWeight.values[theme.footerFontWeight],
      height: theme.footerHeight,
      letterSpacing: theme.footerLetterSpacing,
      wordSpacing: theme.footerWordSpacing,
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
      color: theme.headerColor.toColor(),
      decoration: TextDecoration.none,
      fontSize: theme.headerFontSize,
      fontWeight: FontWeight.values[theme.headerFontWeight],
      height: theme.headerHeight,
      letterSpacing: theme.headerLetterSpacing,
      wordSpacing: theme.headerWordSpacing,
    );
  }
}
