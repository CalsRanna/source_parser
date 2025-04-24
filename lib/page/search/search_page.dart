import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:signals/signals_flutter.dart';
import 'package:source_parser/model/book_entity.dart';
import 'package:source_parser/page/search/component/search_result_view.dart';
import 'package:source_parser/page/search/component/search_trending_view.dart';
import 'package:source_parser/page/search/search_view_model.dart';
import 'package:source_parser/provider/book.dart';

@RoutePage()
class SearchPage extends StatefulWidget {
  final String? credential;
  const SearchPage({super.key, this.credential});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _ClearButton extends ConsumerWidget {
  final String credential;
  final void Function()? onTap;
  const _ClearButton({required this.credential, this.onTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var theme = Theme.of(context);
    var colorScheme = theme.colorScheme;
    var onSurface = colorScheme.onSurface;
    var icon = Icon(
      HugeIcons.strokeRoundedCancelCircle,
      color: onSurface.withValues(alpha: 0.25),
      size: 20,
    );
    var detector = GestureDetector(onTap: onTap, child: icon);
    var provider = searchLoadingProvider(credential);
    var loading = ref.watch(provider);
    if (!loading) return detector;
    var indicator = SizedBox(
      height: 20,
      width: 20,
      child: CircularProgressIndicator(strokeWidth: 1),
    );
    return Stack(children: [indicator, detector]);
  }
}

class _Input extends ConsumerWidget {
  final TextEditingController controller;
  final String credential;
  final void Function()? onClear;
  final void Function(String)? onSubmitted;
  const _Input({
    required this.controller,
    required this.credential,
    this.onClear,
    this.onSubmitted,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var textField = TextField(
      controller: controller,
      decoration: InputDecoration.collapsed(hintText: '搜索'),
      style: const TextStyle(fontSize: 14),
      textInputAction: TextInputAction.search,
      onSubmitted: onSubmitted,
      onTapOutside: (_) => handleTapOutside(context),
    );
    var suffix = ListenableBuilder(
      listenable: controller,
      builder: _builder,
    );
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final surfaceContainer = colorScheme.surfaceContainer;
    var shapeDecoration = ShapeDecoration(
      shape: StadiumBorder(),
      color: surfaceContainer,
    );
    var container = Container(
      decoration: shapeDecoration,
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(children: [Expanded(child: textField), suffix]),
    );
    return ListenableBuilder(
      listenable: controller,
      builder: (_, __) => container,
    );
  }

  void handleTap() {
    onClear?.call();
  }

  void handleTapOutside(BuildContext context) {
    FocusScope.of(context).unfocus();
  }

  Widget _builder(BuildContext context, Widget? child) {
    if (controller.text.isEmpty) return const SizedBox();
    return _ClearButton(credential: credential, onTap: handleTap);
  }
}

class _SearchPageState extends State<SearchPage> {
  String credential = '';
  final viewModel = GetIt.instance<SearchViewModel>();

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var medium = theme.textTheme.bodyMedium;
    var cancel = TextButton(
      onPressed: () => pop(context),
      child: Text('取消', style: medium),
    );
    var input = _Input(
      controller: viewModel.controller,
      credential: credential,
      onClear: () => viewModel.clearController(context),
      onSubmitted: (_) => viewModel.search(context),
    );
    var appBar = AppBar(
      actions: [cancel],
      centerTitle: false,
      leading: const SizedBox(),
      leadingWidth: 16,
      title: input,
      titleSpacing: 0,
    );
    return PopScope(
      canPop: false,
      child: Scaffold(appBar: appBar, body: Watch(_buildBody)),
    );
  }

  @override
  void dispose() {
    viewModel.dispose();
    super.dispose();
  }

  void handleClear() {
    viewModel.controller.clear();
    setState(() {
      credential = '';
    });
  }

  void handlePressed(BookEntity book) {
    viewModel.controller.text = book.name;
    viewModel.search(context);
  }

  @override
  void initState() {
    super.initState();
    viewModel.initSignals();
    viewModel.controller.text = widget.credential ?? '';
    viewModel.controller.addListener(_listenController);
  }

  void pop(BuildContext context) {
    viewModel.removeCurrentMaterialBanner(context);
    Navigator.of(context).pop();
  }

  Widget _buildBody(BuildContext context) {
    var trending = SearchTrendingView(
      books: viewModel.trendingBooks.value,
      onPressed: handlePressed,
    );
    var result = SearchResultView(
      books: viewModel.searchedBooks.value,
      isSearching: viewModel.isSearching.value,
      onTap: (book) => viewModel.navigateInformationPage(context, book),
    );
    return viewModel.view.value == 'trending' ? trending : result;
  }

  void _listenController() {
    if (viewModel.controller.text.isNotEmpty) return;
    viewModel.clearController(context);
  }
}
