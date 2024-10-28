import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:source_parser/page/search/component/result.dart';
import 'package:source_parser/page/search/component/trending.dart';
import 'package:source_parser/provider/book.dart';

@RoutePage()
class SearchPage extends StatefulWidget {
  final String? credential;
  const SearchPage({super.key, this.credential});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final controller = TextEditingController();
  String credential = '';

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var medium = theme.textTheme.bodyMedium;
    var cancel = TextButton(
      onPressed: () => pop(context),
      child: Text('取消', style: medium),
    );
    var input = _Input(
      controller: controller,
      credential: credential,
      onClear: handleClear,
      onSubmitted: search,
    );
    var appBar = AppBar(
      actions: [cancel],
      centerTitle: false,
      leading: const SizedBox(),
      leadingWidth: 16,
      title: input,
      titleSpacing: 0,
    );
    var trending = SearchTrending(onPressed: handlePressed);
    if (credential.isEmpty) return Scaffold(appBar: appBar, body: trending);
    var result = SearchResult(credential, key: ValueKey(credential));
    return Scaffold(appBar: appBar, body: result);
  }

  void handleClear() {
    controller.clear();
    setState(() {
      credential = '';
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void handlePressed(String name) {
    controller.text = name;
    search(name);
  }

  @override
  void initState() {
    super.initState();
    controller.text = widget.credential ?? '';
    credential = widget.credential ?? '';
    controller.addListener(_listenController);
  }

  void _listenController() {
    if (controller.text.isNotEmpty) return;
    setState(() {
      credential = '';
    });
  }

  void pop(BuildContext context) {
    Navigator.of(context).pop();
  }

  void search(String credential) async {
    setState(() {
      this.credential = credential;
    });
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
    return Container(
      decoration: ShapeDecoration(
        shape: StadiumBorder(),
        color: surfaceContainer,
      ),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(children: [Expanded(child: textField), suffix]),
    );
  }

  Widget _builder(BuildContext context, Widget? child) {
    if (controller.text.isEmpty) return const SizedBox();
    return _ClearButton(credential: credential, onTap: handleTap);
  }

  void handleTap() {
    onClear?.call();
  }

  void handleTapOutside(BuildContext context) {
    FocusScope.of(context).unfocus();
  }
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
      Icons.cancel,
      color: onSurface.withOpacity(0.25),
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
