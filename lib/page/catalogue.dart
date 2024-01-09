import 'package:cached_network/cached_network.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:source_parser/provider/book.dart';
import 'package:source_parser/provider/cache.dart';
import 'package:source_parser/router/router.dart';
import 'package:source_parser/util/message.dart';

class CataloguePage extends StatefulWidget {
  const CataloguePage({super.key, required this.index});

  final int index;
  @override
  State<CataloguePage> createState() => _CataloguePageState();
}

class _CataloguePageState extends State<CataloguePage> {
  late ScrollController controller;
  bool atTop = true;
  GlobalKey globalKey = GlobalKey();

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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    final onSurface = theme.colorScheme.onSurface;
    return Scaffold(
      appBar: AppBar(
        key: globalKey,
        title: const Text('目录'),
        actions: [
          TextButton(
            onPressed: handlePressed,
            child: Text(atTop ? '底部' : '顶部'),
          )
        ],
      ),
      body: Consumer(builder: (context, ref, child) {
        final book = ref.watch(bookNotifierProvider);
        final network = CachedNetwork(prefix: book.name);
        return RefreshIndicator(
          onRefresh: () => handleRefresh(ref),
          child: Scrollbar(
            controller: controller,
            child: ListView.builder(
              controller: controller,
              itemBuilder: (context, index) {
                return ListTile(
                  title: FutureBuilder(
                    builder: (context, snapshot) {
                      Color color;
                      FontWeight? weight;
                      if (book.index == index) {
                        color = primary;
                        weight = FontWeight.bold;
                      } else {
                        color = onSurface.withOpacity(0.5);
                        if (snapshot.hasData) {
                          final cached = snapshot.data!;
                          color = onSurface.withOpacity(cached ? 1 : 0.5);
                        }
                      }
                      return Text(
                        book.chapters[index].name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: color, fontWeight: weight),
                      );
                    },
                    future: network.cached(book.chapters[index].url),
                  ),
                  onTap: () => startReader(ref, index),
                );
              },
              itemCount: book.chapters.length,
              itemExtent: 56,
            ),
          ),
        );
      }),
    );
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

  void startReader(WidgetRef ref, int index) async {
    Navigator.of(context).pop();
    const BookReaderPageRoute().push(context);
    final bookNotifier = ref.read(bookNotifierProvider.notifier);
    bookNotifier.startReader(index);
    final cacheProgressNotifier =
        ref.read(cacheProgressNotifierProvider.notifier);
    cacheProgressNotifier.cacheChapters();
  }
}
