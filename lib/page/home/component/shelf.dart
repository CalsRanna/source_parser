import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:source_parser/provider/book.dart';
import 'package:source_parser/provider/cache.dart';
import 'package:source_parser/provider/setting.dart';
import 'package:source_parser/router/router.dart';
import 'package:source_parser/schema/book.dart';
import 'package:source_parser/schema/setting.dart';
import 'package:source_parser/util/message.dart';
import 'package:source_parser/widget/book_cover.dart';

class ShelfView extends StatefulWidget {
  const ShelfView({super.key});

  @override
  State<ShelfView> createState() => _ShelfViewState();
}

class _ShelfViewState extends State<ShelfView> {
  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      final provider = ref.watch(settingNotifierProvider);
      final setting = switch (provider) {
        AsyncData(:final value) => value,
        _ => Setting(),
      };
      final mode = setting.shelfMode;
      final books = ref.watch(booksProvider);
      final value = switch (books) {
        AsyncData(:final value) => value,
        _ => <Book>[],
      };
      Widget child;
      if (mode == 'list') {
        child = _ShelfListView(books: value);
      } else {
        child = _ShelfGridView(books: value);
      }
      return RefreshIndicator(
        onRefresh: () => refresh(ref),
        child: child,
      );
    });
  }

  Future<void> refresh(WidgetRef ref) async {
    final message = Message.of(context);
    try {
      final notifier = ref.read(booksProvider.notifier);
      await notifier.refresh();
    } catch (error) {
      message.show(error.toString());
    }
  }
}

class _ShelfGridTile extends StatelessWidget {
  final Book book;

  final double coverHeight;
  final double coverWidth;
  const _ShelfGridTile({
    required this.book,
    required this.coverHeight,
    required this.coverWidth,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final onBackground = colorScheme.onBackground;
    return Consumer(builder: (context, ref, child) {
      return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onLongPress: () => _handleLongPress(context, ref),
        onTap: () => _handleTap(context, ref),
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
    });
  }

  void cancel(BuildContext context) {
    Navigator.of(context).pop();
  }

  void confirm(BuildContext context, WidgetRef ref) async {
    final navigator = Navigator.of(context);
    final notifier = ref.read(booksProvider.notifier);
    await notifier.delete(book);
    navigator.pop();
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

  int _calculateUnreadChapters() {
    final chapters = book.chapters.length;
    final current = book.index;
    return chapters - current - 1;
  }

  void _handleLongPress(BuildContext context, WidgetRef ref) async {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return _ShelfTileBottomSheet(book: book);
      },
    );
    final notifier = ref.read(bookNotifierProvider.notifier);
    notifier.update(book);
  }

  void _handleTap(BuildContext context, WidgetRef ref) {
    const BookReaderPageRoute().push(context);
    final notifier = ref.read(bookNotifierProvider.notifier);
    notifier.update(book);
  }
}

class _ShelfGridView extends StatelessWidget {
  final List<Book> books;

  const _ShelfGridView({required this.books});

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

class _ShelfListTile extends StatelessWidget {
  final Book book;

  const _ShelfListTile({required this.book});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final bodyMedium = textTheme.bodyMedium;
    final bodySmall = textTheme.bodySmall;
    final colorScheme = theme.colorScheme;
    final onBackground = colorScheme.onBackground;

    return Consumer(builder: (context, ref, child) {
      return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onLongPress: () => _handleLongPress(context, ref),
        onTap: () => _handleTap(context, ref),
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
                        style:
                            bodyMedium?.copyWith(fontWeight: FontWeight.w500),
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
    });
  }

  void cancel(BuildContext context) {
    Navigator.of(context).pop();
  }

  void confirm(BuildContext context, WidgetRef ref) async {
    final navigator = Navigator.of(context);
    final notifier = ref.read(booksProvider.notifier);
    await notifier.delete(book);
    navigator.pop();
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

  int _calculateUnreadChapters() {
    final chapters = book.chapters.length;
    final current = book.index;
    return chapters - current - 1;
  }

  void _handleLongPress(BuildContext context, WidgetRef ref) async {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return _ShelfTileBottomSheet(book: book);
      },
    );
    final notifier = ref.read(bookNotifierProvider.notifier);
    notifier.update(book);
  }

  void _handleTap(BuildContext context, WidgetRef ref) {
    const BookReaderPageRoute().push(context);
    final notifier = ref.read(bookNotifierProvider.notifier);
    notifier.update(book);
  }
}

class _ShelfListView extends StatelessWidget {
  final List<Book> books;

  const _ShelfListView({required this.books});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) {
        return _ShelfListTile(book: books.elementAt(index));
      },
      itemCount: books.length,
      itemExtent: 72,
    );
  }
}

class _ShelfTileBottomSheet extends StatelessWidget {
  final Book book;

  const _ShelfTileBottomSheet({required this.book});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final onSurface = colorScheme.onSurface;
    final subtitle = _buildSpan();
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Row(
          children: [
            BookCover(url: book.cover),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    book.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 14, height: 1.2),
                  ),
                  Text(
                    book.author,
                    style: TextStyle(
                      fontSize: 12,
                      height: 1.2,
                      color: onSurface.withOpacity(0.5),
                    ),
                  ),
                  if (subtitle.isNotEmpty)
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 12,
                        height: 1.2,
                        color: onSurface.withOpacity(0.5),
                      ),
                    )
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Consumer(builder: (context, ref, child) {
          final book = ref.watch(bookNotifierProvider);
          final archived = book.archive;
          final icon =
              archived ? Icons.unarchive_outlined : Icons.archive_outlined;
          final text = archived ? '继续更新' : '不再更新';
          return GridView.count(
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 5,
            shrinkWrap: true,
            children: [
              IconButton(
                onPressed: () => showInformation(context, ref),
                icon: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [Icon(Icons.info_outline), Text('查看详情')],
                ),
              ),
              IconButton(
                onPressed: () => selectCover(context, ref),
                icon: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [Icon(Icons.image_search_outlined), Text('修改封面')],
                ),
              ),
              IconButton(
                onPressed: () => toggleArchive(context, ref),
                icon: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [Icon(icon), Text(text)],
                ),
              ),
              IconButton(
                onPressed: () => cache(context, ref),
                icon: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [Icon(Icons.file_download_outlined), Text('缓存')],
                ),
              ),
              IconButton(
                onPressed: () => clearCache(context, ref),
                icon: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.file_download_off_outlined),
                    Text('清除缓存')
                  ],
                ),
              ),
              IconButton(
                onPressed: () => remove(context, ref),
                icon: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [Icon(Icons.delete_forever_outlined), Text('移出书架')],
                ),
              ),
            ],
          );
        })
      ],
    );
  }

  void cache(BuildContext context, WidgetRef ref) async {
    Navigator.pop(context);
    Message.of(context).show('开始缓存');
    final notifier = ref.read(cacheProgressNotifierProvider.notifier);
    await notifier.cacheChapters(amount: 0);
    if (!context.mounted) return;
    final message = Message.of(context);
    final progress = ref.read(cacheProgressNotifierProvider);
    message.show('缓存完毕，${progress.succeed}章成功，${progress.failed}章失败');
    await Future.delayed(const Duration(seconds: 1));
  }

  void cancel(BuildContext context) {
    Navigator.of(context).pop();
  }

  void clearCache(BuildContext context, WidgetRef ref) async {
    Navigator.pop(context);
    final notifier = ref.read(bookNotifierProvider.notifier);
    notifier.clearCache();
    Message.of(context).show('缓存已清除');
  }

  void confirm(BuildContext context, WidgetRef ref) async {
    final navigator = Navigator.of(context);
    final notifier = ref.read(booksProvider.notifier);
    notifier.delete(book);
    navigator.popUntil(ModalRoute.withName('home'));
  }

  void remove(BuildContext context, WidgetRef ref) {
    showDialog(
      builder: (context) {
        return AlertDialog(
          actions: [
            TextButton(
              onPressed: () => cancel(context),
              child: const Text('取消'),
            ),
            TextButton(
              onPressed: () => confirm(context, ref),
              child: const Text('确认'),
            )
          ],
          content: const Text('确认将本书移出书架？'),
          title: const Text('移出书架'),
        );
      },
      context: context,
    );
  }

  void selectCover(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return BookCoverSelector(book: book);
      },
    );
  }

  void showInformation(BuildContext context, WidgetRef ref) {
    Navigator.of(context).pop();
    const BookInformationPageRoute().push(context);
  }

  void toggleArchive(BuildContext context, WidgetRef ref) async {
    final message = Message.of(context);
    final notifier = ref.read(bookNotifierProvider.notifier);
    await notifier.toggleArchive();
    final book = ref.read(bookNotifierProvider);
    message.show(book.archive ? '不再更新' : '继续更新');
  }

  String _buildSpan() {
    final spans = <String>[];
    if (book.category.isNotEmpty) {
      spans.add(book.category);
    }
    if (book.status.isNotEmpty) {
      spans.add(book.status);
    }
    return spans.join(' · ');
  }
}
