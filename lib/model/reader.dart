import 'package:flutter/material.dart';
import 'package:source_parser/util/theme.dart';

class ReaderState {
  List<Widget> pages = [];
  ReaderTheme theme = ReaderTheme();

  ReaderState copyWith({List<Widget>? pages, ReaderTheme? theme}) {
    return ReaderState()
      ..pages = pages ?? this.pages
      ..theme = theme ?? this.theme;
  }
}
