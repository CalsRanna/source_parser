import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:signals/signals_flutter.dart';
import 'package:source_parser/router/router.dart';
import 'package:source_parser/page/source_parser/source_parser_view_model.dart';

class SourceParser extends StatefulWidget {
  const SourceParser({super.key});

  @override
  State<SourceParser> createState() => _SourceParserState();
}

class _SourceParserState extends State<SourceParser> {
  final viewModel = GetIt.instance.get<SourceParserViewModel>();

  @override
  Widget build(BuildContext context) {
    return Watch(
      (_) => MaterialApp.router(
        routerConfig: routerConfig,
        theme: viewModel.themeData.value,
        title: '元夕',
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    viewModel.initSignals();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      viewModel.updateScreenSize(MediaQuery.sizeOf(context));
    });
  }
}
