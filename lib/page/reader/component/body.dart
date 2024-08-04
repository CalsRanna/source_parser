import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:source_parser/util/theme.dart';

class ReaderBody extends StatefulWidget {
  const ReaderBody({super.key, required this.theme, required this.child});

  final ReaderTheme theme;
  final Widget child;

  @override
  State<ReaderBody> createState() => _ReaderBodyState();
}

class _ReaderBodyState extends State<ReaderBody> {
  Offset offset = Offset.zero;
  AxisDirection? direction;
  double speed = 8;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragUpdate: handleHorizontalDragUpdate,
      onHorizontalDragEnd: handleHorizontalDragEnd,
      child: Transform.translate(
        offset: offset,
        child: Stack(children: [
          Container(
            color: widget.theme.backgroundColor,
            height: double.infinity,
            width: double.infinity,
          ),
          if (widget.theme.backgroundImage.isNotEmpty)
            Image.file(
              File(widget.theme.backgroundImage),
              fit: BoxFit.fill,
              height: double.infinity,
              width: double.infinity,
            ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _ReaderBodyHeader(text: 'header', theme: widget.theme),
              Expanded(
                child: Padding(
                  padding: widget.theme.pagePadding,
                  child: widget.child,
                ),
              ),
              _ReaderBodyFooter(text: 'footer', theme: widget.theme),
            ],
          ),
        ]),
      ),
    );
  }

  void handleHorizontalDragUpdate(DragUpdateDetails details) async {
    if (details.primaryDelta == null) return;
    direction =
        details.primaryDelta! < 0 ? AxisDirection.left : AxisDirection.right;
    var dx = offset.dx + details.primaryDelta!;
    setState(() {
      offset = Offset(dx, 0);
    });
  }

  void handleHorizontalDragEnd(DragEndDetails details) {
    final size = MediaQuery.of(context).size;
    if (direction == null) return;
    if (direction == AxisDirection.left) {
      if (offset.dx < size.width / 3 * -1) {
        Timer.periodic(const Duration(milliseconds: 16), (timer) {
          setState(() {
            offset = Offset(offset.dx - 1 * speed, 0);
          });
          if (offset.dx <= -1 * size.width) {
            timer.cancel();
          }
        });
      } else {
        Timer.periodic(const Duration(milliseconds: 16), (timer) {
          setState(() {
            offset = Offset(offset.dx + 1 * speed, 0);
          });
          if (offset.dx >= 0) {
            timer.cancel();
          }
        });
      }
    } else {
      if (offset.dx > size.width / 3) {
        Timer.periodic(const Duration(milliseconds: 16), (timer) {
          setState(() {
            offset = Offset(offset.dx + 1 * speed, 0);
          });
          if (offset.dx >= size.width) {
            timer.cancel();
          }
        });
      } else {
        Timer.periodic(const Duration(milliseconds: 16), (timer) {
          setState(() {
            offset = Offset(offset.dx - 1 * speed, 0);
          });
          if (offset.dx <= 0) {
            timer.cancel();
          }
        });
      }
    }
  }
}

class _ReaderBodyHeader extends StatelessWidget {
  const _ReaderBodyHeader({super.key, required this.text, required this.theme});

  final String text;
  final ReaderTheme theme;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: theme.headerPadding,
      child: Text(text, style: theme.headerStyle),
    );
  }
}

class _ReaderBodyFooter extends StatelessWidget {
  const _ReaderBodyFooter({super.key, required this.text, required this.theme});

  final String text;
  final ReaderTheme theme;

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    return Padding(
      padding: theme.footerPadding,
      child: Row(
        children: [
          Text(text, style: theme.footerStyle),
          const Spacer(),
          Text(now.toString().substring(11, 16), style: theme.headerStyle),
          const SizedBox(width: 8),
          _BatteryIndicator(theme: theme),
        ],
      ),
    );
  }
}

class _BatteryIndicator extends StatelessWidget {
  const _BatteryIndicator({super.key, required this.theme});
  final ReaderTheme theme;

  @override
  Widget build(BuildContext context) {
    var height = theme.footerStyle.fontSize! * theme.footerStyle.height!;
    final colorScheme = Theme.of(context).colorScheme;
    final tertiary = colorScheme.tertiary;
    final outline = colorScheme.outline;
    return Container(
      height: height,
      width: height * 3 / 2,
      decoration: BoxDecoration(
          border: Border.all(
            color: theme.footerStyle.color ?? outline,
          ),
          borderRadius: BorderRadius.circular(2)),
      padding: const EdgeInsets.all(1),
      child: Container(color: tertiary),
    );
  }
}
