import 'package:creator/creator.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:isar/isar.dart';
import 'package:source_parser/creator/book.dart';
import 'package:source_parser/creator/router.dart';
import 'package:source_parser/creator/source.dart';
import 'package:source_parser/model/source.dart';
import 'package:source_parser/schema/history.dart';
import 'package:source_parser/schema/isar.dart';
import 'package:source_parser/schema/source.dart';
import 'package:source_parser/util/message.dart';
import 'package:source_parser/util/parser.dart';

class AvailableSources extends StatefulWidget {
  const AvailableSources({super.key});

  @override
  State<AvailableSources> createState() => _AvailableSourcesState();
}

class _AvailableSourcesState extends State<AvailableSources> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('可用书源')),
      body: RefreshIndicator(
        onRefresh: handleRefresh,
        child: Watcher((context, ref, child) {
          final book = ref.watch(currentBookCreator);
          return ListView.builder(
            itemBuilder: (context, index) {
              final active = book.sources[index].id == book.sourceId;
              final primary = Theme.of(context).colorScheme.primary;
              return ListTile(
                subtitle: FutureBuilder(
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return const Text('加载失败');
                    } else if (snapshot.hasData) {
                      return Text(
                        snapshot.data!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      );
                    } else {
                      return const Text('正在加载');
                    }
                  },
                  future: getLatestChapter(book.sources[index]),
                ),
                title: Text(
                  book.sources[index].name,
                  style: TextStyle(color: active ? primary : null),
                ),
                trailing: active ? const Icon(Icons.check) : null,
                onTap: () => switchSource(index),
              );
            },
            itemCount: book.sources.length,
          );
        }),
      ),
    );
  }

  Future<String> getLatestChapter(AvailableSource source) async {
    final currentSource =
        await isar.sources.filter().idEqualTo(source.id).findFirst();
    if (currentSource != null) {
      return Parser().getLatestChapter(source.url, currentSource);
    } else {
      return '加载失败';
    }
  }

  Future<void> handleRefresh() async {
    final ref = context.ref;
    final currentBook = ref.read(currentBookCreator);
    final stream = await Parser.search(currentBook.name);
    List<AvailableSource> sources = [];
    stream.listen(
      (book) async {
        final sameAuthor = book.author == currentBook.author;
        final sameName = book.name == currentBook.name;
        if (sameAuthor && sameName) {
          final source =
              await isar.sources.filter().idEqualTo(book.sourceId).findFirst();
          if (source != null) {
            sources.add(
              AvailableSource(id: source.id, name: source.name, url: book.url),
            );
            ref.set(currentBookCreator, currentBook.copyWith(sources: sources));
            var history = await isar.histories
                .filter()
                .nameEqualTo(book.name)
                .authorEqualTo(book.author)
                .findFirst();
            if (history != null) {
              history.sources = sources.map((source) {
                return SourceSwitcher.fromJson(source.toJson());
              }).toList();
              await isar.writeTxn(() async {
                isar.histories.put(history);
              });
            }
          }
        }
      },
    );
  }

  void switchSource(int index) async {
    final message = Message.of(context);
    final router = GoRouter.of(context);
    final navigator = Navigator.of(context);
    final ref = context.ref;
    final book = ref.read(currentBookCreator);
    final sourceId = book.sources[index].id;
    if (sourceId == book.sourceId) {
      message.show('已在当前源');
      return;
    }
    showDialog(
      barrierDismissible: false,
      builder: (_) {
        return const UnconstrainedBox(
          child: SizedBox(
            height: 160,
            width: 160,
            child: Dialog(
              insetPadding: EdgeInsets.zero,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('正在加载'),
                ],
              ),
            ),
          ),
        );
      },
      context: context,
    );
    final source = await isar.sources.filter().idEqualTo(sourceId).findFirst();
    if (source != null) {
      ref.set(currentSourceCreator, source);
      final url = book.sources[index].url;
      final information = await Parser().getInformation(url, source);
      final catalogueUrl = information.catalogueUrl;
      final chapters = await Parser().getChapters(catalogueUrl, source);
      ref.set(
        currentBookCreator,
        book.copyWith(
          catalogueUrl: catalogueUrl,
          chapters: chapters,
          sourceId: sourceId,
          url: url,
        ),
      );
      navigator.pop();
      final from = ref.read(fromCreator);
      router.pop();
      if (from == '/book-reader') {
        router.pushReplacement('/book-reader');
        message.show('切换成功');
      }
      var history = await isar.histories
          .filter()
          .nameEqualTo(book.name)
          .authorEqualTo(book.author)
          .findFirst();
      if (history != null) {
        history.url = url;
        history.catalogueUrl = catalogueUrl;
        history.chapters = chapters.map((chapter) {
          return Catalogue.fromJson(chapter.toJson());
        }).toList();
        history.sourceId = sourceId;
        await isar.writeTxn(() async {
          isar.histories.put(history);
        });
      }
    } else {
      navigator.pop();
      message.show('未找到源');
    }
  }
}
