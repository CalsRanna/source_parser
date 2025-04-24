import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:source_parser/model/book_entity.dart';
import 'package:source_parser/page/home/bookshelf_view/book_remove_dialog.dart';
import 'package:source_parser/page/listener.dart';
import 'package:source_parser/provider/book.dart';
import 'package:source_parser/provider/cache.dart';
import 'package:source_parser/router/router.gr.dart';
import 'package:source_parser/util/message.dart';
import 'package:source_parser/widget/book_cover.dart';

class BookBottomSheet extends ConsumerWidget {
  final BookEntity book;
  final void Function()? onDestroyed;

  const BookBottomSheet({super.key, required this.book, this.onDestroyed});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final surface = colorScheme.surface;
    final onSurface = colorScheme.onSurface;
    var title = Text(
      book.name,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(fontSize: 14, height: 1.2),
    );
    var authorStyle = TextStyle(
      fontSize: 12,
      height: 1.2,
      color: onSurface.withValues(alpha: 0.5),
    );
    var author = Text(book.author, style: authorStyle);
    var subtitleStyle = TextStyle(
      fontSize: 12,
      height: 1.2,
      color: onSurface.withValues(alpha: 0.5),
    );
    var subtitle = Text(_buildSpan(), style: subtitleStyle);
    var children = [
      title,
      const SizedBox(height: 8),
      author,
      if (_buildSpan().isNotEmpty) SizedBox(height: 8),
      if (_buildSpan().isNotEmpty) subtitle
    ];
    var column = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children,
    );
    var rowChildren = [
      BookCover(height: 80, url: book.cover, width: 60),
      const SizedBox(width: 16),
      Expanded(child: column),
    ];
    final newBook = ref.watch(bookNotifierProvider);
    final archived = newBook.archive;
    var icon = HugeIcons.strokeRoundedQuillWrite01;
    if (archived) icon = HugeIcons.strokeRoundedArchive02;
    final text = archived ? '已完结' : '连载中';
    var informationAction = _SheetAction(
      icon: const Icon(HugeIcons.strokeRoundedInformationCircle),
      text: '详情',
      onTap: () => navigateInformationPage(context),
    );
    var coverAction = _SheetAction(
      icon: const Icon(HugeIcons.strokeRoundedImage02),
      text: '更改封面',
      onTap: () => selectCover(context, ref),
    );
    var archiveAction = _SheetAction(
      icon: Icon(icon),
      text: text,
      onTap: () => toggleArchive(context, ref),
    );
    var removeAction = _SheetAction(
      icon: const Icon(HugeIcons.strokeRoundedDelete02),
      text: '移出书架',
      onTap: () => remove(context, ref),
    );
    var actionChildren = [
      informationAction,
      coverAction,
      archiveAction,
      removeAction,
    ];
    var cacheAction = _SheetAction(
      icon: const Icon(HugeIcons.strokeRoundedDownload04),
      text: '缓存',
      onTap: () => cache(context, ref),
    );
    var clearAction = _SheetAction(
      icon: const Icon(HugeIcons.strokeRoundedClean),
      text: '清除缓存',
      onTap: () => clearCache(context, ref),
    );
    var cacheChildren = [
      cacheAction,
      clearAction,
      const Expanded(flex: 2, child: SizedBox())
    ];
    var columnChildren = [
      Row(children: actionChildren),
      Row(children: cacheChildren),
    ];
    var boxDecoration = BoxDecoration(
      borderRadius: BorderRadius.circular(8),
      color: surface,
    );
    var container = Container(
      decoration: boxDecoration,
      child: Column(children: columnChildren),
    );
    var listChildren = [
      Row(children: rowChildren),
      const SizedBox(height: 16),
      container
    ];
    return ListView(padding: const EdgeInsets.all(16), children: listChildren);
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
    Navigator.pop(context);
    // final notifier = ref.read(booksProvider.notifier);
    // notifier.delete(book);
  }

  void navigate(BuildContext context, WidgetRef ref) {
    Navigator.pop(context);
    final book = ref.read(bookNotifierProvider);
    final navigator = Navigator.of(context);
    var page = ListenerPage(book: book);
    final route = MaterialPageRoute(builder: (context) => page);
    navigator.push(route);
  }

  void remove(BuildContext context, WidgetRef ref) {
    Navigator.of(context).pop();
    var dialog = BookRemoveDialog(book: book, onConfirmed: onDestroyed);
    showDialog(builder: (_) => dialog, context: context);
  }

  void selectCover(BuildContext context, WidgetRef ref) {
    Navigator.of(context).pop();
    CoverSelectorRoute(book: book).push(context);
  }

  void navigateInformationPage(BuildContext context) {
    Navigator.of(context).pop();
    InformationRoute().push(context);
  }

  void toggleArchive(BuildContext context, WidgetRef ref) async {
    final notifier = ref.read(bookNotifierProvider.notifier);
    await notifier.toggleArchive();
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

class _SheetAction extends StatelessWidget {
  final Icon icon;

  final String text;
  final void Function()? onTap;
  const _SheetAction({required this.icon, required this.text, this.onTap});

  @override
  Widget build(BuildContext context) {
    var children = [
      icon,
      const SizedBox(height: 8),
      Text(text, maxLines: 1, overflow: TextOverflow.ellipsis),
    ];
    var column = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: children,
    );
    var padding = Padding(
      padding: const EdgeInsets.all(16),
      child: column,
    );
    var gestureDetector = GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: padding,
    );
    return Expanded(child: gestureDetector);
  }
}
