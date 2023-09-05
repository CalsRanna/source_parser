import 'package:creator/creator.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:isar/isar.dart';
import 'package:lpinyin/lpinyin.dart';
import 'package:source_parser/creator/book.dart';
import 'package:source_parser/creator/chapter.dart';
import 'package:source_parser/creator/source.dart';
import 'package:source_parser/schema/book.dart';
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
      final books = ref.watch(booksCreator);
      return RefreshIndicator(
        onRefresh: refresh,
        child: ListView.builder(
          itemBuilder: (context, index) {
            return _ShelfTile(book: books.elementAt(index));
          },
          itemCount: books.length,
        ),
      );
    });
  }

  Future<void> refresh() async {
    final ref = context.ref;
    final books = await isar.books.where().findAll();
    books.sort((a, b) {
      final first = PinyinHelper.getPinyin(a.name);
      final second = PinyinHelper.getPinyin(b.name);
      return first.compareTo(second);
    });
    final parser = Parser();
    for (var book in books) {
      final source =
          await isar.sources.filter().idEqualTo(book.sourceId).findFirst();
      if (source != null) {
        final chapters = await parser.getChapters(book.catalogueUrl, source);
        book.chapters = chapters;
        await isar.writeTxn(() async {
          isar.books.put(book);
        });
      }
    }
    ref.set(booksCreator, books);
  }
}

class _ShelfTile extends StatelessWidget {
  const _ShelfTile({Key? key, required this.book}) : super(key: key);

  final Book book;

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
            BookCover(url: book.cover, height: 64, width: 48),
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
                      book.name,
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
      await isar.books.delete(book.id);
    });
    navigator.pop();
    final books = await isar.books.where().findAll();
    books.sort((a, b) {
      final first = PinyinHelper.getPinyin(a.name);
      final second = PinyinHelper.getPinyin(b.name);
      return first.compareTo(second);
    });
    ref.set(booksCreator, books);
  }

  void _handleTap(BuildContext context) async {
    final ref = context.ref;
    final router = GoRouter.of(context);
    final message = Message.of(context);
    ref.set(currentBookCreator, book);
    ref.set(currentChapterIndexCreator, book.index);
    ref.set(currentCursorCreator, book.cursor);
    final source =
        await isar.sources.filter().idEqualTo(book.sourceId).findFirst();
    if (source != null) {
      ref.set(currentSourceCreator, source);
      final parser = Parser();
      final chapters = await parser.getChapters(book.catalogueUrl, source);
      if (chapters.isEmpty) {
        message.show('未找到章节');
        return;
      }
    }
    router.push('/book-reader');
  }

  int _calculateUnreadChapters() {
    final chapters = book.chapters.length;
    final current = book.index;
    return chapters - current - 1;
  }

  String? _buildSubtitle() {
    final spans = <String>[];
    if (book.author.isNotEmpty) {
      spans.add(book.author);
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
    if (book.updatedAt.isNotEmpty) {
      spans.add(book.updatedAt);
    }

    if (book.chapters.isNotEmpty) {
      spans.add(book.chapters.last.name);
    }
    return spans.isNotEmpty ? spans.join(' · ') : null;
  }
}
