import 'package:flutter/material.dart';
import 'package:source_parser/model/reader_theme.dart';
import 'package:source_parser/page/reader/component/page.dart';

class BookReaderPageRevisited extends StatelessWidget {
  final Widget Function()? builder;
  final bool eInkMode;
  final List<ReaderPageTurningMode> modes;
  final TextSpan textSpan;
  final int pageIndex;
  final String title;
  final ReaderTheme theme;

  const BookReaderPageRevisited({
    super.key,
    this.builder,
    required this.eInkMode,
    required this.modes,
    required this.textSpan,
    required this.pageIndex,
    required this.title,
    required this.theme,
  });

  const BookReaderPageRevisited.builder({
    super.key,
    required this.builder,
    required this.eInkMode,
    required this.modes,
    required this.pageIndex,
    required this.title,
    required this.theme,
  }) : textSpan = const TextSpan();

  @override
  Widget build(BuildContext context) {
    var header = _Header(
      padding: theme.headerPadding,
      style: theme.headerStyle,
      title: title,
    );
    Widget content = _Content(
      padding: theme.pagePadding,
      style: theme.pageStyle,
      textSpan: textSpan,
    );
    if (builder != null) content = builder!.call();
    var footer = _Footer(
      cursor: pageIndex,
      length: 10,
      padding: theme.footerPadding,
      style: theme.footerStyle,
    );
    var column = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [header, Expanded(child: content), footer],
    );
    return column;
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
    var text = RichText(text: textSpan);
    return Padding(padding: padding, child: text);
  }
}

class _Footer extends StatefulWidget {
  final int cursor;
  final int length;
  final EdgeInsets padding;
  final TextStyle style;

  const _Footer({
    required this.cursor,
    required this.length,
    required this.padding,
    required this.style,
  });

  @override
  State<_Footer> createState() => _FooterState();
}

class _FooterState extends State<_Footer> {
  int _batteryLevel = 100;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.padding,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '${(widget.cursor + 1)}/${widget.length}',
            style: widget.style,
          ),
          Text(
            '$_batteryLevel%',
            style: widget.style,
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _updateBatteryLevel();
  }

  Future<void> _updateBatteryLevel() async {
    try {
      // This is just a placeholder, in real app you should use proper battery API
      // For now we'll just use a mock value
      if (mounted) {
        setState(() {
          _batteryLevel = 100;
        });
      }
    } catch (e) {
      // Ignore battery errors
    }
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
