import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:signals/signals_flutter.dart';
import 'package:source_parser/model/book_entity.dart';
import 'package:source_parser/page/cover_selector/cover_selector_view_model.dart';
import 'package:source_parser/widget/book_cover.dart';

@RoutePage()
class CoverSelectorPage extends StatefulWidget {
  final BookEntity book;
  const CoverSelectorPage({super.key, required this.book});

  @override
  State<CoverSelectorPage> createState() => _CoverSelectorPageState();
}

class _CoverSelectorPageState extends State<CoverSelectorPage> {
  late final viewModel = GetIt.instance<CoverSelectorViewModel>(
    param1: widget.book.id,
  );

  @override
  void initState() {
    super.initState();
    viewModel.initSignals();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('更改封面')),
      body: Watch(_buildBody),
    );
  }

  Widget _buildBody(BuildContext context) {
    if (viewModel.isLoading.value) {
      return const Center(child: CircularProgressIndicator());
    }
    if (viewModel.covers.value.isEmpty) {
      return const Center(child: Text('空空如也'));
    }
    return GridView.builder(
      gridDelegate:
          SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
      itemBuilder: (context, index) =>
          BookCover(url: viewModel.covers.value[index].url),
      itemCount: viewModel.covers.value.length,
    );
  }
}
