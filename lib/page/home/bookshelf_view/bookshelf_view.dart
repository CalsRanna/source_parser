import 'package:auto_route/auto_route.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:signals/signals_flutter.dart';
import 'package:source_parser/model/book_entity.dart';
import 'package:source_parser/page/home/bookshelf_view/book_bottom_sheet.dart';
import 'package:source_parser/page/home/bookshelf_view/bookshelf_view_model.dart';
import 'package:source_parser/page/home/widget/search_button.dart';
import 'package:source_parser/provider/book.dart';
import 'package:source_parser/provider/setting.dart';
import 'package:source_parser/router/router.gr.dart';
import 'package:source_parser/util/message.dart';
import 'package:source_parser/widget/book_cover.dart';

class BookshelfView extends ConsumerStatefulWidget {
  const BookshelfView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _BookshelfViewState();
}

class _BookshelfViewState extends ConsumerState<BookshelfView>
    with AutomaticKeepAliveClientMixin {
  final viewModel = GetIt.instance<BookshelfViewModel>();

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    viewModel.initSignals();
  }

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
      child: Watch((_) => _buildView(ref)),
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

  Widget _buildView(WidgetRef ref) {
    final setting = ref.watch(settingNotifierProvider).valueOrNull;
    final mode = setting?.shelfMode ?? 'list';
    if (viewModel.books.value.isEmpty) return const Center(child: Text('空空如也'));
    var listView = _ListView(
      books: viewModel.books.value,
      onDestroyed: viewModel.destroyBook,
    );
    var gridView = _GridView(
      books: viewModel.books.value,
      onDestroyed: viewModel.destroyBook,
    );
    return switch (mode) { 'list' => listView, _ => gridView };
  }
}

class _GridTile extends ConsumerWidget {
  final BookEntity book;
  final double coverHeight;
  final double coverWidth;
  final void Function()? onDestroyed;

  const _GridTile({
    required this.book,
    required this.coverHeight,
    required this.coverWidth,
    this.onDestroyed,
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
    // final notifier = ref.read(booksProvider.notifier);
    // await notifier.delete(book);
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
    // final chapters = book.chapters.length;
    // final current = book.index;
    // return chapters - current - 1;
    return 0;
  }

  void _handleLongPress(BuildContext context, WidgetRef ref) async {
    HapticFeedback.heavyImpact();
    var bottomSheet = BookBottomSheet(book: book, onDestroyed: onDestroyed);
    showModalBottomSheet(builder: (_) => bottomSheet, context: context);
  }

  void _handleTap(BuildContext context, WidgetRef ref) {
    // AutoRouter.of(context).push(ReaderRoute(book: book));
    // final notifier = ref.read(bookNotifierProvider.notifier);
    // notifier.update(book);
    ReaderRoute(book: book).push(context);
  }
}

class _GridView extends StatelessWidget {
  final List<BookEntity> books;
  final void Function(BookEntity)? onDestroyed;

  const _GridView({required this.books, this.onDestroyed});

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
      onDestroyed: () => onDestroyed?.call(books[index]),
    );
  }
}

class _ListTile extends ConsumerWidget {
  final BookEntity book;
  final void Function()? onDestroyed;

  const _ListTile({required this.book, this.onDestroyed});

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
    // final notifier = ref.read(booksProvider.notifier);
    // await notifier.delete(book);
    navigator.pop();
  }

  String? _buildLatestChapter() {
    final spans = <String>[];
    if (book.updatedAt.isNotEmpty) {
      spans.add(book.updatedAt);
    }
    // if (book.chapters.isNotEmpty) {
    //   spans.add(book.chapters.last.name);
    // }
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
    // final chapters = book.chapters.length;
    // final current = book.index;
    // return chapters - current - 1;
    return 0;
  }

  void _handleLongPress(BuildContext context, WidgetRef ref) async {
    var bottomSheet = BookBottomSheet(book: book, onDestroyed: onDestroyed);
    showModalBottomSheet(builder: (_) => bottomSheet, context: context);
  }

  void _handleTap(BuildContext context, WidgetRef ref) {
    // AutoRouter.of(context).push(ReaderRoute(book: book));
    // final notifier = ref.read(bookNotifierProvider.notifier);
    // notifier.update(book);
  }
}

class _ListView extends StatelessWidget {
  final List<BookEntity> books;
  final void Function(BookEntity)? onDestroyed;

  const _ListView({required this.books, this.onDestroyed});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: _buildItem,
      itemCount: books.length,
      itemExtent: 72,
    );
  }

  Widget _buildItem(BuildContext context, int index) {
    return _ListTile(
      book: books[index],
      onDestroyed: () => onDestroyed?.call(books[index]),
    );
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
