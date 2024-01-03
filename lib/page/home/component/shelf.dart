import 'package:cached_network/cached_network.dart';
import 'package:creator/creator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:go_router/go_router.dart';
import 'package:isar/isar.dart';
import 'package:lpinyin/lpinyin.dart';
import 'package:source_parser/creator/book.dart';
import 'package:source_parser/creator/setting.dart';
import 'package:source_parser/schema/book.dart';
import 'package:source_parser/schema/isar.dart';
import 'package:source_parser/schema/source.dart';
import 'package:source_parser/util/message.dart';
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
    getBooks();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Watcher((context, ref, child) {
      final books = ref.watch(booksCreator);
      final mode = ref.watch(shelfModeCreator);
      Widget child;
      if (mode == 'list') {
        child = _ShelfListView(books: books);
      } else {
        child = _ShelfGridView(books: books);
      }
      return RefreshIndicator(
        onRefresh: refresh,
        child: child,
      );
    });
  }

  void getBooks() async {
    final ref = context.ref;
    var books = ref.read(booksCreator);
    if (books.isNotEmpty) return;
    books = await isar.books.where().findAll();
    books.sort((a, b) {
      final first = PinyinHelper.getPinyin(a.name);
      final second = PinyinHelper.getPinyin(b.name);
      return first.compareTo(second);
    });
    ref.set(booksCreator, books);
    FlutterNativeSplash.remove();
    refresh();
  }

  Future<void> refresh() async {
    final message = Message.of(context);
    try {
      final ref = context.ref;
      final books = ref.read(booksCreator);
      for (var book in books) {
        if (book.archive) continue;
        final builder = isar.sources.filter();
        final source = await builder.idEqualTo(book.sourceId).findFirst();
        if (source != null) {
          final duration = ref.read(cacheDurationCreator);
          final timeout = ref.read(timeoutCreator);
          var stream = await Parser.getChapters(
            book.name,
            book.catalogueUrl,
            source,
            Duration(hours: duration.floor()),
            Duration(milliseconds: timeout),
          );
          stream = stream.asBroadcastStream();
          List<Chapter> chapters = [];
          stream.listen(
            (chapter) => chapters.add(chapter),
            onDone: () async {
              if (chapters.isEmpty) return;
              book.chapters = chapters;
              await isar.writeTxn(() async {
                isar.books.put(book);
              });
            },
          );
          await stream.last;
        }
      }
      ref.set(booksCreator, [...books]);
    } catch (error) {
      message.show(error.toString());
    }
  }
}

class _ShelfListView extends StatelessWidget {
  const _ShelfListView({required this.books});

  final List<Book> books;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) {
        return _ShelfTile(book: books.elementAt(index));
      },
      itemCount: books.length,
      itemExtent: 72,
    );
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
      builder: (context) {
        return AlertDialog(
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
          content: const Text('确认将本书移出书架？'),
          title: const Text('移出书架'),
        );
      },
      context: context,
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
    CachedNetwork(prefix: book.name).clearCache();
  }

  void _handleTap(BuildContext context) async {
    final ref = context.ref;
    final router = GoRouter.of(context);
    ref.set(currentBookCreator, book);
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

class _ShelfGridView extends StatelessWidget {
  const _ShelfGridView({required this.books});

  final List<Book> books;

  @override
  Widget build(BuildContext context) {
    final mediaQueryData = MediaQuery.of(context);
    final coverWidth = (mediaQueryData.size.width - 96) / 3;
    final coverHeight = coverWidth * 4 / 3;
    const labelHeight = (8 + 14 * 1.2 * 2 + 12 * 1.2);
    return GridView.custom(
      childrenDelegate: SliverChildBuilderDelegate(
        (context, index) {
          return _ShelfGridTile(
            book: books[index],
            coverHeight: coverHeight,
            coverWidth: coverWidth,
          );
        },
        childCount: books.length,
      ),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        childAspectRatio: coverWidth / (coverHeight + labelHeight),
        crossAxisCount: 3,
        mainAxisSpacing: 8,
        crossAxisSpacing: 32,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
    );
  }
}

class _ShelfGridTile extends StatelessWidget {
  const _ShelfGridTile({
    required this.book,
    required this.coverHeight,
    required this.coverWidth,
  });

  final Book book;
  final double coverHeight;
  final double coverWidth;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final onBackground = colorScheme.onBackground;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onLongPress: () => _handleLongPress(context),
      onTap: () => _handleTap(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BookCover(url: book.cover, height: coverHeight, width: coverWidth),
          const SizedBox(height: 8),
          Text(
            book.name,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 14, height: 1.2),
          ),
          Text(
            _buildSubtitle() ?? '',
            style: TextStyle(
              fontSize: 12,
              height: 1.2,
              color: onBackground.withOpacity(0.5),
            ),
          ),
        ],
      ),
    );
  }

  void _handleLongPress(BuildContext context) async {
    showDialog(
      builder: (context) {
        return AlertDialog(
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
          content: const Text('确认将本书移出书架？'),
          title: const Text('移出书架'),
        );
      },
      context: context,
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
    CachedNetwork(prefix: book.name).clearCache();
  }

  void _handleTap(BuildContext context) async {
    final ref = context.ref;
    final router = GoRouter.of(context);
    ref.set(currentBookCreator, book);
    router.push('/book-reader');
  }

  int _calculateUnreadChapters() {
    final chapters = book.chapters.length;
    final current = book.index;
    return chapters - current - 1;
  }

  String? _buildSubtitle() {
    final spans = <String>[];
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
}
