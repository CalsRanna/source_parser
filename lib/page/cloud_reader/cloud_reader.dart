import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:signals/signals_flutter.dart';
import 'package:source_parser/page/cloud_reader/cloud_reader_view_model.dart';

@RoutePage()
class CloudReaderPage extends StatefulWidget {
  const CloudReaderPage({super.key});

  @override
  State<CloudReaderPage> createState() => _CloudReaderPageState();
}

class _CloudReaderPageState extends State<CloudReaderPage> {
  final viewModel = GetIt.instance.get<CloudReaderViewModel>();

  @override
  void initState() {
    super.initState();
    viewModel.initSignals();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('云阅读')),
      body: Watch(
        (context) => ListView.builder(
          itemBuilder: (context, index) => ListTile(
            onTap: () => viewModel.openBook(context, index),
            title: Text(viewModel.books.value[index].name),
          ),
          itemCount: viewModel.books.value.length,
        ),
      ),
    );
  }
}
