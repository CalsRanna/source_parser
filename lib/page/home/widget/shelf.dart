import 'package:creator/creator.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:isar/isar.dart';
import 'package:source_parser/creator/book.dart';
import 'package:source_parser/creator/chapter.dart';
import 'package:source_parser/creator/history.dart';
import 'package:source_parser/creator/source.dart';
import 'package:source_parser/main.dart';
import 'package:source_parser/model/book.dart';
import 'package:source_parser/schema/history.dart';
import 'package:source_parser/schema/source.dart';
import 'package:source_parser/util/parser.dart';
import 'package:source_parser/widget/book_cover.dart';

class ShelfView extends StatefulWidget {
  const ShelfView({super.key});

  @override
  State<ShelfView> createState() => _ShelfViewState();
}

class _ShelfViewState extends State<ShelfView> {
  @override
  void didChangeDependencies() {
    getHistories();
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

  Future<void> getHistories() async {
    final ref = context.ref;
    final histories = await isar.historys.where().findAll();
    ref.set(historiesCreator, histories);
  }

  Future<void> refresh() async {
    final histories = await isar.historys.where().findAll();
    final parser = Parser();
    for (var history in histories) {
      final source =
          await isar.sources.filter().idEqualTo(history.sourceId).findFirst();
      if (source != null) {
        final chapters = await parser.getChapters(
          url: history.url,
          source: source,
        );
        history.chapters = chapters.length;
        await isar.writeTxn(() async {
          isar.historys.put(history);
        });
      }
    }
    await getHistories();
  }
}

class _ShelfTile extends StatelessWidget {
  const _ShelfTile({Key? key, required this.history}) : super(key: key);

  final History history;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final onSurface = colorScheme.onSurface;
    final textTheme = theme.textTheme;
    final bodyMedium = textTheme.bodyMedium;
    final bodySmall = textTheme.bodySmall;
    return GestureDetector(
      onLongPress: () => _handleLongPress(context),
      onTap: () => _handleTap(context),
      child: Container(
        color: onSurface.withOpacity(0.05),
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(8),
        child: Row(
          children: [
            BookCover(
              // borderRadius: 16,
              url: history.cover,
              height: 80,
              width: 60,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: SizedBox(
                height: 80,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text(
                      history.name,
                      style: bodyMedium?.copyWith(fontWeight: FontWeight.w500),
                    ),
                    Text(_buildSubtitle() ?? '', style: bodySmall),
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
      await isar.historys.delete(history.id);
    });
    navigator.pop();
    final histories = await isar.historys.where().findAll();
    ref.set(historiesCreator, histories);
  }

  void _handleTap(BuildContext context) async {
    final ref = context.ref;
    final router = GoRouter.of(context);
    ref.set(currentBookCreator, Book.fromJson(history.toJson()));
    ref.set(currentChapterIndexCreator, history.index);
    ref.set(currentCursorCreator, history.cursor);
    final book = ref.read(currentBookCreator);
    final source =
        await isar.sources.filter().idEqualTo(history.sourceId).findFirst();
    if (source != null) {
      ref.set(currentSourceCreator, source);
      final parser = Parser();
      final chapters = await parser.getChapters(source: source, url: book.url);
      ref.set(currentChaptersCreator, chapters);
    }
    router.push('/book-reader');
  }

  int _calculateUnreadChapters() {
    final chapters = history.chapters;
    final current = history.index;
    return chapters - current - 1;
  }

  String? _buildSubtitle() {
    final spans = <String>[];
    if (history.author.isNotEmpty) {
      spans.add(history.author);
    }
    final chapters = _calculateUnreadChapters();
    spans.add('$chapters章未读');
    return spans.isNotEmpty ? spans.join(' · ') : null;
  }
}
