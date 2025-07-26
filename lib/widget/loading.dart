import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:signals/signals_flutter.dart';
import 'package:source_parser/config/string_config.dart';
import 'package:source_parser/page/source_parser/source_parser_view_model.dart';

class LoadingIndicator extends StatefulWidget {
  const LoadingIndicator({super.key});

  @override
  State<LoadingIndicator> createState() => _LoadingIndicatorState();
}

class _LoadingIndicatorState extends State<LoadingIndicator> {
  final viewModel = GetIt.instance.get<SourceParserViewModel>();

  @override
  Widget build(BuildContext context) {
    const indicator = CircularProgressIndicator();
    const text = Text(StringConfig.loading);
    return Watch((_) => viewModel.isEInkMode.value ? text : indicator);
  }
}
