import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:source_parser/model/book_entity.dart';
import 'package:source_parser/page/home/bookshelf_view/bookshelf_remove_book_dialog.dart';
import 'package:source_parser/widget/book_cover.dart';

class BookshelfBottomSheet extends StatefulWidget {
  final BookEntity book;
  final void Function()? onArchive;
  final void Function()? onCache;
  final void Function()? onClearCache;
  final void Function()? onCoverSelect;
  final void Function()? onDestroyed;
  final void Function()? onDetail;

  const BookshelfBottomSheet({
    super.key,
    required this.book,
    this.onArchive,
    this.onCache,
    this.onClearCache,
    this.onCoverSelect,
    this.onDestroyed,
    this.onDetail,
  });

  @override
  State<BookshelfBottomSheet> createState() => _BookBottomSheet();
}

class _BookBottomSheet extends State<BookshelfBottomSheet> {
  var isArchived = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final surface = colorScheme.surface;
    final onSurface = colorScheme.onSurface;
    var title = Text(
      widget.book.name,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(fontSize: 14, height: 1.2),
    );
    var authorStyle = TextStyle(
      fontSize: 12,
      height: 1.2,
      color: onSurface.withValues(alpha: 0.5),
    );
    var author = Text(widget.book.author, style: authorStyle);
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
      BookCover(height: 80, url: widget.book.cover, width: 60),
      const SizedBox(width: 16),
      Expanded(child: column),
    ];
    var icon = HugeIcons.strokeRoundedQuillWrite01;
    if (isArchived) icon = HugeIcons.strokeRoundedArchive02;
    final text = isArchived ? '已完结' : '连载中';
    var informationAction = _SheetAction(
      icon: const Icon(HugeIcons.strokeRoundedInformationCircle),
      text: '详情',
      onTap: _navigateInformationPage,
    );
    var coverAction = _SheetAction(
      icon: const Icon(HugeIcons.strokeRoundedImage02),
      text: '更改封面',
      onTap: _selectCover,
    );
    var archiveAction = _SheetAction(
      icon: Icon(icon),
      text: text,
      onTap: _archiveBook,
    );
    var removeAction = _SheetAction(
      icon: const Icon(HugeIcons.strokeRoundedDelete02),
      text: '移出书架',
      onTap: _openRemoveDialog,
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
      onTap: _cache,
    );
    var clearAction = _SheetAction(
      icon: const Icon(HugeIcons.strokeRoundedClean),
      text: '清除缓存',
      onTap: _clearCache,
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

  @override
  void initState() {
    super.initState();
    isArchived = widget.book.archive;
  }

  void _archiveBook() {
    widget.onArchive?.call();
    setState(() {
      isArchived = !isArchived;
    });
  }

  String _buildSpan() {
    final spans = <String>[];
    if (widget.book.category.isNotEmpty) {
      spans.add(widget.book.category);
    }
    if (widget.book.status.isNotEmpty) {
      spans.add(widget.book.status);
    }
    return spans.join(' · ');
  }

  void _cache() async {
    Navigator.of(context).pop();
    widget.onCache?.call();
  }

  void _clearCache() async {
    Navigator.of(context).pop();
    widget.onClearCache?.call();
  }

  void _navigateInformationPage() {
    Navigator.of(context).pop();
    widget.onDetail?.call();
  }

  void _openRemoveDialog() {
    Navigator.of(context).pop();
    var dialog = BookshelfRemoveBookDialog(
      book: widget.book,
      onConfirmed: widget.onDestroyed,
    );
    showDialog(builder: (_) => dialog, context: context);
  }

  void _selectCover() {
    Navigator.of(context).pop();
    widget.onCoverSelect?.call();
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
