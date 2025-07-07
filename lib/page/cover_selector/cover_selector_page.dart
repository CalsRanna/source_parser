import 'package:auto_route/auto_route.dart';
import 'package:easy_refresh/easy_refresh.dart';
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
  final viewModel = GetIt.instance<CoverSelectorViewModel>();

  @override
  void initState() {
    super.initState();
    viewModel.initSignals(widget.book);
  }

  @override
  Widget build(BuildContext context) {
    var easyRefresh = EasyRefresh(
      onRefresh: viewModel.refreshCovers,
      child: Watch(_buildBody),
    );
    return Scaffold(
      appBar: AppBar(title: Text('更改封面')),
      body: easyRefresh,
    );
  }

  Widget _buildBody(BuildContext context) {
    if (viewModel.isLoading.value) {
      return const Center(child: CircularProgressIndicator());
    }
    if (viewModel.covers.value.isEmpty) {
      return Center(
          child: GestureDetector(
              onTap: viewModel.refreshCovers, child: Text('空空如也')));
    }
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 3 / 4,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
      ),
      itemBuilder: (context, index) =>
          BookCover(url: viewModel.covers.value[index].url),
      itemCount: viewModel.covers.value.length,
      padding: EdgeInsets.symmetric(horizontal: 16),
    );
  }
}
