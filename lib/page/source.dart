import 'package:creator/creator.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:isar/isar.dart';
import 'package:source_parser/creator/book.dart';
import 'package:source_parser/creator/router.dart';
import 'package:source_parser/creator/setting.dart';
import 'package:source_parser/schema/book.dart';
import 'package:source_parser/schema/isar.dart';
import 'package:source_parser/schema/source.dart';
import 'package:source_parser/util/message.dart';
import 'package:source_parser/util/parser.dart';
import 'package:source_parser/widget/loading.dart';
import 'package:source_parser/widget/source_tag.dart';

class AvailableSources extends StatefulWidget {
  const AvailableSources({super.key});

  @override
  State<AvailableSources> createState() => _AvailableSourcesState();
}

class _AvailableSourcesState extends State<AvailableSources> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [TextButton(onPressed: reset, child: const Text('重置'))],
        title: const Text('可用书源'),
      ),
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
                  future: getLatestChapter(book.name, book.sources[index]),
                ),
                title: FutureBuilder(
                  future: getSource(book.sources[index].id),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      final source = snapshot.data;
                      final name = source?.name ?? '没找到源';
                      final comment = source?.comment ?? '';
                      return Text.rich(
                        TextSpan(
                          text: name,
                          children: [WidgetSpan(child: SourceTag(comment))],
                        ),
                        style: TextStyle(color: active ? primary : null),
                      );
                    }
                    return const SizedBox();
                  },
                ),
                trailing: active ? const Icon(Icons.check) : null,
                onTap: () => switchSource(index),
              );
            },
            itemCount: book.sources.length,
            itemExtent: 72,
          );
        }),
      ),
    );
  }

  void reset() async {
    final ref = context.ref;
    final book = ref.read(currentBookCreator);
    List<AvailableSource> sources = [];
    ref.set(currentBookCreator, book.copyWith(sources: sources));
    final filter = isar.books.filter();
    var builder = filter.nameEqualTo(book.name);
    builder = builder.authorEqualTo(book.author);
    var exist = await builder.findFirst();
    if (exist != null) {
      exist.sources = sources;
      await isar.writeTxn(() async {
        isar.books.put(exist);
      });
    }
  }

  Future<String> getLatestChapter(String name, AvailableSource source) async {
    final ref = context.ref;
    final currentSource = await getSource(source.id);
    if (currentSource != null) {
      final duration = ref.read(cacheDurationCreator);
      return Parser.getLatestChapter(
        name,
        source.url,
        currentSource,
        Duration(hours: duration.floor()),
      );
    } else {
      return '加载失败';
    }
  }

  Future<Source?> getSource(int id) async {
    final builder = isar.sources.filter();
    final source = await builder.idEqualTo(id).findFirst();
    return source;
  }

  Future<void> handleRefresh() async {
    final message = Message.of(context);
    try {
      final ref = context.ref;
      final currentBook = ref.read(currentBookCreator);
      final maxConcurrent = ref.read(maxConcurrentCreator);
      final duration = ref.read(cacheDurationCreator);
      List<AvailableSource> sources = [];
      for (var source in currentBook.sources) {
        final exist = await getSource(source.id);
        if (exist != null) {
          sources.add(source);
        }
      }
      var stream = await Parser.search(
        currentBook.name,
        maxConcurrent.floor(),
        Duration(hours: duration.floor()),
      );
      stream = stream.asBroadcastStream();
      stream.listen((book) async {
        final sameAuthor = book.author == currentBook.author;
        final sameName = book.name == currentBook.name;
        final sameSource = sources.where((source) {
          return source.id == book.sourceId;
        }).isNotEmpty;
        if (sameAuthor && sameName && !sameSource) {
          final source = await getSource(book.sourceId);
          if (source != null) {
            var availableSource = AvailableSource();
            availableSource.id = source.id;
            availableSource.url = book.url;
            sources.add(availableSource);
            ref.set(currentBookCreator, currentBook.copyWith(sources: sources));
          }
        }
      });
      await stream.last;
      final filter = isar.books.filter();
      var builder = filter.nameEqualTo(currentBook.name);
      builder = builder.authorEqualTo(currentBook.author);
      var exist = await builder.findFirst();
      if (exist != null) {
        exist.sources = sources;
        await isar.writeTxn(() async {
          isar.books.put(exist);
        });
      }
    } catch (error) {
      message.show(error.toString());
    }
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
      builder: (context) {
        return const UnconstrainedBox(
          child: SizedBox(
            height: 160,
            width: 160,
            child: Dialog(
              insetPadding: EdgeInsets.zero,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  LoadingIndicator(),
                  SizedBox(height: 16),
                  Text('正在切换书源'),
                ],
              ),
            ),
          ),
        );
      },
      context: context,
    );
    final builder = isar.sources.filter();
    final source = await builder.idEqualTo(sourceId).findFirst();
    if (source != null) {
      try {
        final name = book.name;
        final url = book.sources[index].url;
        final duration = ref.read(cacheDurationCreator);
        final information = await Parser.getInformation(
          name,
          url,
          source,
          Duration(hours: duration.floor()),
        );
        final catalogueUrl = information.catalogueUrl;
        var stream = await Parser.getChapters(
          name,
          catalogueUrl,
          source,
          Duration(hours: duration.floor()),
        );
        stream = stream.asBroadcastStream();
        List<Chapter> chapters = [];
        stream.listen(
          (chapter) {
            chapters.add(chapter);
          },
        );
        await stream.last;
        final length = chapters.length;
        var chapterIndex = book.index;
        var cursor = book.cursor;
        if (length <= chapterIndex) {
          chapterIndex = length - 1;
          cursor = 0;
        }
        final updatedBook = book.copyWith(
          catalogueUrl: catalogueUrl,
          chapters: chapters,
          cursor: cursor,
          index: chapterIndex,
          sourceId: sourceId,
          url: url,
        );
        ref.set(currentBookCreator, updatedBook);
        var exist = await isar.books
            .filter()
            .nameEqualTo(book.name)
            .authorEqualTo(book.author)
            .findFirst();
        if (exist != null) {
          await isar.writeTxn(() async {
            isar.books.put(updatedBook);
          });
        }
        navigator.pop();
        final from = ref.read(fromCreator);
        router.pop();
        if (from == '/book-reader') {
          router.pushReplacement('/book-reader');
          message.show('切换成功');
        }
      } catch (error) {
        navigator.pop();
        message.show('切换失败');
      }
    } else {
      navigator.pop();
      message.show('源不存在');
    }
  }
}
