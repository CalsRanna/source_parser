import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:signals/signals_flutter.dart';
import 'package:source_parser/model/book_entity.dart';
import 'package:source_parser/page/reader_replacement/reader_replacement_view_model.dart';

@RoutePage()
class ReaderReplacementPage extends StatefulWidget {
  final BookEntity book;
  const ReaderReplacementPage({super.key, required this.book});

  @override
  State<ReaderReplacementPage> createState() => _ReaderReplacementPageState();
}

class _ReaderReplacementPageState extends State<ReaderReplacementPage> {
  final viewModel = GetIt.instance.get<ReaderReplacementViewModel>();

  @override
  void initState() {
    super.initState();
    viewModel.initSignals(widget.book.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('替换')),
      body: Watch(
        (_) => ListView.builder(
          itemBuilder: (context, index) => ListTile(
            onLongPress: () => viewModel.openBottomSheet(context, index),
            title: Text(
                '${viewModel.replacements.value[index].source} -> ${viewModel.replacements.value[index].target}'),
          ),
          itemCount: viewModel.replacements.value.length,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => viewModel.addReplacement(context, widget.book.id),
        child: const Icon(HugeIcons.strokeRoundedAdd01),
      ),
    );
  }
}
