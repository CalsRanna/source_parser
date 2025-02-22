import 'package:auto_route/auto_route.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:source_parser/page/home/widget/search_button.dart';
import 'package:source_parser/page/listener.dart';
import 'package:source_parser/provider/book.dart';
import 'package:source_parser/provider/cache.dart';
import 'package:source_parser/provider/setting.dart';
import 'package:source_parser/router/router.gr.dart';
import 'package:source_parser/schema/book.dart';
import 'package:source_parser/util/message.dart';
import 'package:source_parser/widget/book_cover.dart';

class BookshelfView extends ConsumerStatefulWidget {
  const BookshelfView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _BookshelfViewState();
}

class _BookshelfViewState extends ConsumerState<BookshelfView>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    var appBar = AppBar(
      actions: [SearchButton(), _ShelfModeSelector()],
      centerTitle: true,
      title: Text('书架'),
    );
    var easyRefresh = EasyRefresh(
      onRefresh: () => refresh(context, ref),
      child: _buildChild(ref),
    );
    var scaffold = Scaffold(appBar: appBar, body: easyRefresh);
    return ScaffoldMessenger(child: scaffold);
  }

  Future<void> refresh(BuildContext context, WidgetRef ref) async {
    final message = Message.of(context);
    try {
      final notifier = ref.read(booksProvider.notifier);
      await notifier.refresh();
    } catch (error) {
      message.show(error.toString());
    }
  }

  Widget _buildChild(WidgetRef ref) {
    final setting = ref.watch(settingNotifierProvider).valueOrNull;
    final mode = setting?.shelfMode ?? 'list';
    final books = ref.watch(booksProvider).valueOrNull ?? <Book>[];
    if (books.isEmpty) return const Center(child: Text('空空如也'));
    return switch (mode) {
      'list' => _ListView(books: books),
      _ => _GridView(books: books),
    };
  }
}

class _BottomSheet extends ConsumerWidget {
  final Book book;

  const _BottomSheet({required this.book});

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
      onTap: () => showInformation(context, ref),
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
    final notifier = ref.read(booksProvider.notifier);
    notifier.delete(book);
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
    showDialog(
      builder: (_) => _RemoveDialog(book: book),
      context: context,
    );
  }

  void selectCover(BuildContext context, WidgetRef ref) {
    Navigator.of(context).pop();
    showModalBottomSheet(
      builder: (context) => BookCoverSelector(book: book),
      context: context,
    );
  }

  void showInformation(BuildContext context, WidgetRef ref) {
    Navigator.of(context).pop();
    AutoRouter.of(context).push(InformationRoute());
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

class _GridTile extends ConsumerWidget {
  final Book book;

  final double coverHeight;
  final double coverWidth;
  const _GridTile({
    required this.book,
    required this.coverHeight,
    required this.coverWidth,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final onSurface = colorScheme.onSurface;
    const textStyle = TextStyle(fontSize: 14, height: 1.2);
    var title = Text(
      book.name,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: textStyle,
    );
    var subtitleStyle = TextStyle(
      fontSize: 12,
      height: 1.2,
      color: onSurface.withValues(alpha: 0.5),
    );
    var children = [
      BookCover(url: book.cover, height: coverHeight, width: coverWidth),
      const SizedBox(height: 8),
      title,
      Text(_buildSubtitle() ?? '', style: subtitleStyle),
    ];
    var column = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children,
    );
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onLongPress: () => _handleLongPress(context, ref),
      onTap: () => _handleTap(context, ref),
      child: column,
    );
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
    HapticFeedback.heavyImpact();
    showModalBottomSheet(
      context: context,
      builder: (_) => _BottomSheet(book: book),
    );
    final notifier = ref.read(bookNotifierProvider.notifier);
    notifier.update(book);
  }

  void _handleTap(BuildContext context, WidgetRef ref) {
    AutoRouter.of(context).push(ReaderRoute(book: book));
    final notifier = ref.read(bookNotifierProvider.notifier);
    notifier.update(book);
  }
}

class _GridView extends StatelessWidget {
  final List<Book> books;

  const _GridView({required this.books});

  @override
  Widget build(BuildContext context) {
    final mediaQueryData = MediaQuery.of(context);
    final coverWidth = (mediaQueryData.size.width - 96) / 3;
    final coverHeight = coverWidth * 4 / 3;
    const labelHeight = (8 + 14 * 1.2 * 2 + 12 * 1.2);
    var delegate = SliverGridDelegateWithFixedCrossAxisCount(
      childAspectRatio: coverWidth / (coverHeight + labelHeight),
      crossAxisCount: 3,
      mainAxisSpacing: 8,
      crossAxisSpacing: 32,
    );
    return GridView.builder(
      itemBuilder: _itemBuilder,
      itemCount: books.length,
      gridDelegate: delegate,
      padding: const EdgeInsets.symmetric(horizontal: 16),
    );
  }

  Widget _itemBuilder(BuildContext context, int index) {
    final size = MediaQuery.sizeOf(context);
    final coverWidth = (size.width - 96) / 3;
    final coverHeight = coverWidth * 4 / 3;
    return _GridTile(
      book: books[index],
      coverHeight: coverHeight,
      coverWidth: coverWidth,
    );
  }
}

class _ListTile extends ConsumerWidget {
  final Book book;

  const _ListTile({required this.book});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final bodyMedium = textTheme.bodyMedium;
    final bodySmall = textTheme.bodySmall;
    final colorScheme = theme.colorScheme;
    final onSurface = colorScheme.onSurface;
    var title = Text(
      book.name,
      style: bodyMedium?.copyWith(fontWeight: FontWeight.w500),
    );
    var subtitle = Text(
      _buildSubtitle() ?? '',
      style: bodySmall?.copyWith(color: onSurface.withValues(alpha: 0.5)),
    );
    var latestChapter = Text(
      _buildLatestChapter() ?? '',
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: bodySmall?.copyWith(color: onSurface.withValues(alpha: 0.5)),
    );
    var column = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      mainAxisSize: MainAxisSize.max,
      children: [title, subtitle, latestChapter],
    );
    var children = [
      BookCover(url: book.cover, height: 64, width: 48),
      const SizedBox(width: 16),
      Expanded(child: SizedBox(height: 64, child: column)),
    ];
    var padding = Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      child: Row(children: children),
    );
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onLongPress: () => _handleLongPress(context, ref),
      onTap: () => _handleTap(context, ref),
      child: padding,
    );
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
    HapticFeedback.heavyImpact();
    showModalBottomSheet(
      context: context,
      builder: (_) => _BottomSheet(book: book),
    );
    final notifier = ref.read(bookNotifierProvider.notifier);
    notifier.update(book);
  }

  void _handleTap(BuildContext context, WidgetRef ref) {
    AutoRouter.of(context).push(ReaderRoute(book: book));
    final notifier = ref.read(bookNotifierProvider.notifier);
    notifier.update(book);
  }
}

class _ListView extends StatelessWidget {
  final List<Book> books;

  const _ListView({required this.books});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (_, index) => _ListTile(book: books[index]),
      itemCount: books.length,
      itemExtent: 72,
    );
  }
}

class _RemoveDialog extends StatelessWidget {
  final Book book;
  const _RemoveDialog({required this.book});

  @override
  Widget build(BuildContext context) {
    var cancelButton = TextButton(
      onPressed: () => cancel(context),
      child: const Text('取消'),
    );
    var confirmButton = FilledButton(
      onPressed: () => confirm(context),
      child: const Text('确认'),
    );
    return AlertDialog(
      actions: [cancelButton, confirmButton],
      content: const Text('确认将本书移出书架？'),
      title: const Text('移出书架'),
    );
  }

  void cancel(BuildContext context) {
    Navigator.of(context).pop();
  }

  void confirm(BuildContext context) async {
    Navigator.of(context).pop();
    Navigator.of(context).pop();
    var container = ProviderScope.containerOf(context);
    final notifier = container.read(booksProvider.notifier);
    notifier.delete(book);
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

class _ShelfModeSelector extends ConsumerWidget {
  const _ShelfModeSelector();

  Future<void> addBook(BuildContext context, WidgetRef ref) async {
    var route = BookFormRoute();
    var url = await AutoRouter.of(context).push<String?>(route);
    if (url == null) return;
    if (url.isEmpty) return;
    if (!context.mounted) return;
    var messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentMaterialBanner();
    var sizedBox = SizedBox(
      height: 16,
      width: 16,
      child: CircularProgressIndicator(strokeWidth: 1),
    );
    var materialBanner = MaterialBanner(
      actions: [TextButton(onPressed: null, child: Text('取消'))],
      content: Text('正在添加书籍'),
      leading: sizedBox,
    );
    messenger.showMaterialBanner(materialBanner);
    try {
      var provider = booksProvider;
      var notifier = ref.read(provider.notifier);
      await notifier.addBook(url);
      messenger.hideCurrentMaterialBanner();
    } on Exception catch (e) {
      messenger.hideCurrentMaterialBanner();
      messenger.showSnackBar(Message.snackBar(e.toString()));
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MenuAnchor(
      alignmentOffset: Offset(-132, 12),
      builder: (_, controller, __) => _builder(controller),
      menuChildren: _buildMenuChildren(context, ref),
      style: MenuStyle(alignment: Alignment.bottomRight),
    );
  }

  void handleTap(MenuController controller) {
    if (controller.isOpen) return controller.close();
    controller.open();
  }

  void updateShelfMode(WidgetRef ref, String value) async {
    final notifier = ref.read(settingNotifierProvider.notifier);
    notifier.updateShelfMode(value);
  }

  Widget _builder(MenuController controller) {
    return IconButton(
      onPressed: () => handleTap(controller),
      icon: const Icon(HugeIcons.strokeRoundedMoreVertical),
    );
  }

  List<Widget> _buildMenuChildren(BuildContext context, WidgetRef ref) {
    final setting = ref.watch(settingNotifierProvider).valueOrNull;
    final shelfMode = setting?.shelfMode ?? 'list';
    var modeIcon = Icon(HugeIcons.strokeRoundedMenuCircle);
    if (shelfMode == 'grid') modeIcon = Icon(HugeIcons.strokeRoundedMenu01);
    var mode = shelfMode == 'grid' ? 'list' : 'grid';
    var text = Text(shelfMode == 'grid' ? '列表模式' : '网格模式');
    var modeButton = MenuItemButton(
      leadingIcon: modeIcon,
      onPressed: () => updateShelfMode(ref, mode),
      child: text,
    );
    var additionIcon = Icon(HugeIcons.strokeRoundedAdd01);
    var additionButton = MenuItemButton(
      leadingIcon: additionIcon,
      onPressed: () => addBook(context, ref),
      child: Text('新增书籍'),
    );
    return [modeButton, additionButton];
  }
}
