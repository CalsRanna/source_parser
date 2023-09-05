import 'package:cached_network/cached_network.dart';
import 'package:creator/creator.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:isar/isar.dart';
import 'package:lpinyin/lpinyin.dart';
import 'package:source_parser/creator/book.dart';
import 'package:source_parser/creator/chapter.dart';
import 'package:source_parser/creator/history.dart';
import 'package:source_parser/creator/source.dart';
import 'package:source_parser/model/book.dart';
import 'package:source_parser/model/source.dart';
import 'package:source_parser/schema/history.dart';
import 'package:source_parser/schema/isar.dart';
import 'package:source_parser/schema/source.dart';
import 'package:source_parser/util/parser.dart';
import 'package:source_parser/widget/book_cover.dart';
import 'package:source_parser/util/message.dart';

class ShelfView extends StatefulWidget {
  const ShelfView({super.key});

  @override
  State<ShelfView> createState() => _ShelfViewState();
}

class _ShelfViewState extends State<ShelfView> {
  @override
  void didChangeDependencies() {
    refresh();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Watcher((context, ref, child) {
      final histories = ref.watch(historiesCreator);
      return RefreshIndicator(
        onRefresh: refresh,
        child: ListView.builder(
          itemBuilder: (context, index) {
            return _ShelfTile(history: histories.elementAt(index));
          },
          itemCount: histories.length,
        ),
      );
    });
  }

  Future<void> refresh() async {
    final ref = context.ref;
    final histories = await isar.histories.where().findAll();
    histories.sort((a, b) {
      final first = PinyinHelper.getPinyin(a.name);
      final second = PinyinHelper.getPinyin(b.name);
      return first.compareTo(second);
    });
    final parser = Parser();
    for (var history in histories) {
      final source =
          await isar.sources.filter().idEqualTo(history.sourceId).findFirst();
      if (source != null) {
        final chapters = await parser.getChapters(history.catalogueUrl, source);
        List<Catalogue> catalogues = [];
        for (var chapter in chapters) {
          chapter.cached = await CachedNetwork().cached(chapter.url);
          catalogues.add(Catalogue.fromJson(chapter.toJson()));
        }
        history.chapters = catalogues;
        await isar.writeTxn(() async {
          isar.histories.put(history);
        });
      }
    }
    ref.set(historiesCreator, histories);
  }
}

class _ShelfTile extends StatelessWidget {
  const _ShelfTile({Key? key, required this.history}) : super(key: key);

  final History history;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final bodyMedium = textTheme.bodyMedium;
    final bodySmall = textTheme.bodySmall;
    final colorScheme = theme.colorScheme;
    final onBackground = colorScheme.onBackground;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onLongPress: () => _handleLongPress(context),
      onTap: () => _handleTap(context),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
        child: Row(
          children: [
            BookCover(url: history.cover, height: 64, width: 48),
            const SizedBox(width: 16),
            Expanded(
              child: SizedBox(
                height: 64,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text(
                      history.name,
                      style: bodyMedium?.copyWith(fontWeight: FontWeight.w500),
                    ),
                    Text(
                      _buildSubtitle() ?? '',
                      style: bodySmall?.copyWith(
                        color: onBackground.withOpacity(0.5),
                      ),
                    ),
                    Text(
                      _buildLatestChapter() ?? '',
                      style: bodySmall?.copyWith(
                        color: onBackground.withOpacity(0.5),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleLongPress(BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('移出书架'),
          content: const Text('确认将本书移出书架？'),
          actions: [
            TextButton(
              onPressed: () => cancel(context),
              child: const Text('取消'),
            ),
            TextButton(
              onPressed: () => confirm(context),
              child: const Text('确认'),
            ),
          ],
        );
      },
    );
  }

  void cancel(BuildContext context) {
    Navigator.of(context).pop();
  }

  void confirm(BuildContext context) async {
    final ref = context.ref;
    final navigator = Navigator.of(context);
    await isar.writeTxn(() async {
      await isar.histories.delete(history.id);
    });
    navigator.pop();
    final histories = await isar.histories.where().findAll();
    histories.sort((a, b) {
      final first = PinyinHelper.getPinyin(a.name);
      final second = PinyinHelper.getPinyin(b.name);
      return first.compareTo(second);
    });
    ref.set(historiesCreator, histories);
  }

  void _handleTap(BuildContext context) async {
    final ref = context.ref;
    final router = GoRouter.of(context);
    final message = Message.of(context);
    ref.set(currentBookCreator, Book.fromJson(history.toJson()));
    ref.set(currentChapterIndexCreator, history.index);
    ref.set(currentCursorCreator, history.cursor);
    final book = ref.read(currentBookCreator);
    final source =
        await isar.sources.filter().idEqualTo(history.sourceId).findFirst();
    if (source != null) {
      ref.set(currentSourceCreator, source);
      final parser = Parser();
      final chapters = await parser.getChapters(book.catalogueUrl, source);
      if (chapters.isEmpty) {
        message.show('未找到章节');
        return;
      }
    }
    if (book.sources.isEmpty) {
      final currentSource = ref.read(currentSourceCreator);
      final availableSource = AvailableSource();
      availableSource.id = currentSource.id;
      availableSource.name = currentSource.name;
      availableSource.url = currentSource.url;
      ref.set(currentBookCreator, book.copyWith(sources: [availableSource]));
    }
    router.push('/book-reader');
  }

  int _calculateUnreadChapters() {
    final chapters = history.chapters.length;
    final current = history.index;
    return chapters - current - 1;
  }

  String? _buildSubtitle() {
    final spans = <String>[];
    if (history.author.isNotEmpty) {
      spans.add(history.author);
    }
    final chapters = _calculateUnreadChapters();
    if (chapters > 0) {
      spans.add('$chapters章未读');
    } else if (chapters == 0) {
      spans.add('已读完');
    } else {
      spans.add('未找到章节');
    }
    return spans.isNotEmpty ? spans.join(' · ') : null;
  }

  String? _buildLatestChapter() {
    final spans = <String>[];
    if (history.updatedAt.isNotEmpty) {
      spans.add(history.updatedAt);
    }

    if (history.chapters.isNotEmpty) {
      spans.add(history.chapters.last.name);
    }
    return spans.isNotEmpty ? spans.join(' · ') : null;
  }
}
