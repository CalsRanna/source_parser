import 'package:auto_route/auto_route.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:source_parser/provider/book.dart';
import 'package:source_parser/router/router.gr.dart';
import 'package:source_parser/schema/book.dart';
import 'package:source_parser/util/cache_network.dart';
import 'package:source_parser/util/message.dart';

@RoutePage()
class CataloguePage extends ConsumerStatefulWidget {
  final int index;

  const CataloguePage({super.key, required this.index});

  @override
  ConsumerState<CataloguePage> createState() => _CataloguePageState();
}

class _CataloguePageState extends ConsumerState<CataloguePage> {
  late ScrollController controller;
  bool atTop = true;
  GlobalKey globalKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final textButton = TextButton(
      onPressed: handlePressed,
      child: Text(atTop ? '底部' : '顶部'),
    );
    final appBar = AppBar(
      key: globalKey,
      title: const Text('目录'),
      actions: [textButton],
    );
    final book = ref.watch(bookNotifierProvider);
    final listView = ListView.builder(
      controller: controller,
      itemBuilder: (_, index) => _itemBuilder(ref, book, index),
      itemCount: book.chapters.length,
      itemExtent: 56,
    );
    final easyRefresh = EasyRefresh(
      onRefresh: () => handleRefresh(ref),
      child: listView,
    );
    final scrollbar = Scrollbar(
      controller: controller,
      child: easyRefresh,
    );
    return Scaffold(appBar: appBar, body: scrollbar);
  }

  void handlePressed() {
    var position = controller.position.maxScrollExtent;
    if (!atTop) {
      position = controller.position.minScrollExtent;
    }
    controller.animateTo(
      position,
      curve: Curves.linear,
      duration: const Duration(milliseconds: 200),
    );
    setState(() {
      atTop = !atTop;
    });
  }

  Future<void> handleRefresh(WidgetRef ref) async {
    final message = Message.of(context);
    final notifier = ref.read(bookNotifierProvider.notifier);
    try {
      await notifier.refreshCatalogue();
    } catch (error) {
      message.show(error.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    controller = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final height = MediaQuery.of(context).size.height;
      final padding = MediaQuery.of(context).padding;
      final maxScrollExtent = controller.position.maxScrollExtent;
      final appBarContext = globalKey.currentContext;
      final appBarRenderBox = appBarContext!.findRenderObject() as RenderBox;
      var listViewHeight = height - padding.vertical;
      listViewHeight = listViewHeight - appBarRenderBox.size.height;
      final halfHeight = listViewHeight / 2;
      var offset = 56.0 * widget.index;
      offset = (offset - halfHeight);
      offset = offset.clamp(0, maxScrollExtent);
      controller.jumpTo(offset);
    });
  }

  void startReader(WidgetRef ref, int index) async {
    final navigator = Navigator.of(context);
    navigator.pop();
    var book = ref.read(bookNotifierProvider);
    AutoRouter.of(context).replace(ReaderRoute(book: book));
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    final bookNotifier = ref.read(bookNotifierProvider.notifier);
    bookNotifier.startReader(cursor: 0, index: index);
  }

  Widget _futureBuilder(
    WidgetRef ref,
    Book book,
    int index,
    AsyncSnapshot<bool> snapshot,
  ) {
    final chapter = book.chapters.elementAt(index);
    final active = book.index == index;
    final cached = snapshot.data ?? false;
    return _Tile(
      chapter,
      active: active,
      cached: cached,
      onTap: () => startReader(ref, index),
    );
  }

  Widget _itemBuilder(WidgetRef ref, Book book, int index) {
    final network = CachedNetwork(prefix: book.name);
    final chapter = book.chapters.elementAt(index);
    final future = network.cached(chapter.url);
    return FutureBuilder(
      builder: (_, snapshot) => _futureBuilder(ref, book, index, snapshot),
      future: future,
    );
  }
}

class _Tile extends StatelessWidget {
  final bool active;
  final bool cached;
  final Chapter chapter;
  final void Function()? onTap;

  const _Tile(
    this.chapter, {
    this.active = false,
    this.cached = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = _getColor(context);
    final weight = _getFontWeight();
    final textStyle = TextStyle(color: color, fontWeight: weight);
    final title = Text(
      chapter.name,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: textStyle,
    );
    return ListTile(title: title, onTap: onTap);
  }

  Color _getColor(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    if (active) return colorScheme.primary;
    if (cached) return colorScheme.onSurface;
    return colorScheme.onSurface.withOpacity(0.5);
  }

  FontWeight _getFontWeight() {
    if (active) return FontWeight.bold;
    return FontWeight.normal;
  }
}
