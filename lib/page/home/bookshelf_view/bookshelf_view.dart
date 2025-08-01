import 'package:auto_route/auto_route.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:signals/signals_flutter.dart';
import 'package:source_parser/model/book_entity.dart';
import 'package:source_parser/page/home/bookshelf_view/bookshelf_view_model.dart';
import 'package:source_parser/page/home/search_button.dart';
import 'package:source_parser/router/router.gr.dart';
import 'package:source_parser/widget/book_cover.dart';
import 'package:source_parser/widget/loading.dart';

class BookshelfView extends StatefulWidget {
  const BookshelfView({super.key});

  @override
  State<BookshelfView> createState() => _BookshelfViewState();
}

class _BookshelfViewState extends State<BookshelfView>
    with AutomaticKeepAliveClientMixin {
  final viewModel = GetIt.instance<BookshelfViewModel>();

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    var modeSelector = Watch(
      (_) => _ShelfModeSelector(
        mode: viewModel.shelfMode.value,
        onModeChanged: viewModel.updateShelfMode,
      ),
    );
    var actions = [SearchButton(), modeSelector];
    var appBar = AppBar(actions: actions, centerTitle: true, title: Text('书架'));
    var easyRefresh = EasyRefresh(
      onRefresh: () => viewModel.refreshSignals(context),
      child: Watch((_) => _buildView()),
    );
    var scaffold = Scaffold(appBar: appBar, body: easyRefresh);
    return ScaffoldMessenger(child: scaffold);
  }

  @override
  void initState() {
    super.initState();
    viewModel.initSignals();
  }

  Widget _buildView() {
    if (viewModel.books.value.isEmpty) return const Center(child: Text('空空如也'));
    var listView = _ListView(
      books: viewModel.books.value,
      onLongPress: (book) => viewModel.openBookBottomSheet(context, book),
      onTap: (book) => viewModel.navigateReaderPage(context, book),
    );
    var gridView = _GridView(
      books: viewModel.books.value,
      onLongPress: (book) => viewModel.openBookBottomSheet(context, book),
      onTap: (book) => viewModel.navigateReaderPage(context, book),
    );
    return switch (viewModel.shelfMode.value) {
      'list' => listView,
      _ => gridView,
    };
  }
}

class _GridTile extends StatelessWidget {
  final BookEntity book;
  final double coverHeight;
  final double coverWidth;
  final void Function()? onLongPress;
  final void Function()? onTap;

  const _GridTile({
    required this.book,
    required this.coverHeight,
    required this.coverWidth,
    this.onLongPress,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
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
      onLongPress: onLongPress,
      onTap: onTap,
      child: column,
    );
  }

  String? _buildSubtitle() {
    final spans = <String>[];
    final chapters = book.chapterCount - (book.chapterIndex + 1);
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

class _GridView extends StatelessWidget {
  final List<BookEntity> books;
  final void Function(BookEntity)? onLongPress;
  final void Function(BookEntity)? onTap;

  const _GridView({required this.books, this.onLongPress, this.onTap});

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
      onLongPress: () => onLongPress?.call(books[index]),
      onTap: () => onTap?.call(books[index]),
    );
  }
}

class _ListTile extends StatelessWidget {
  final BookEntity book;
  final void Function()? onLongPress;
  final void Function()? onTap;

  const _ListTile({required this.book, this.onLongPress, this.onTap});

  @override
  Widget build(BuildContext context) {
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
      onLongPress: onLongPress,
      onTap: onTap,
      child: padding,
    );
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
    final chapters = book.chapterCount - (book.chapterIndex + 1);
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

class _ListView extends StatelessWidget {
  final List<BookEntity> books;
  final void Function(BookEntity)? onLongPress;
  final void Function(BookEntity)? onTap;

  const _ListView({required this.books, this.onLongPress, this.onTap});

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
      onLongPress: () => onLongPress?.call(books[index]),
      onTap: () => onTap?.call(books[index]),
    );
  }
}

class _ShelfModeSelector extends StatelessWidget {
  final String mode;
  final void Function(String)? onModeChanged;
  const _ShelfModeSelector({required this.mode, this.onModeChanged});

  Future<void> addBook(BuildContext context) async {
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
      child: LoadingIndicator(),
    );
    var materialBanner = MaterialBanner(
      actions: [TextButton(onPressed: null, child: Text('取消'))],
      content: Text('正在添加书籍'),
      leading: sizedBox,
    );
    messenger.showMaterialBanner(materialBanner);
    try {
      // var provider = booksProvider;
      // var notifier = ref.read(provider.notifier);
      // await notifier.addBook(url);
      messenger.hideCurrentMaterialBanner();
    } on Exception catch (e) {
      messenger.hideCurrentMaterialBanner();
      var snackBar = SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Text(e.toString()),
        duration: const Duration(seconds: 1),
      );
      messenger.showSnackBar(snackBar);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MenuAnchor(
      alignmentOffset: Offset(-132, 12),
      builder: (_, controller, __) => _builder(controller),
      menuChildren: _buildMenuChildren(context),
      style: MenuStyle(alignment: Alignment.bottomRight),
    );
  }

  void handleTap(MenuController controller) {
    if (controller.isOpen) return controller.close();
    controller.open();
  }

  Widget _builder(MenuController controller) {
    return IconButton(
      onPressed: () => handleTap(controller),
      icon: const Icon(HugeIcons.strokeRoundedMoreVertical),
    );
  }

  List<Widget> _buildMenuChildren(BuildContext context) {
    var modeIcon = Icon(HugeIcons.strokeRoundedMenuCircle);
    if (mode == 'grid') modeIcon = Icon(HugeIcons.strokeRoundedMenu01);
    var text = Text(mode == 'grid' ? '列表模式' : '网格模式');
    var modeButton = MenuItemButton(
      leadingIcon: modeIcon,
      onPressed: () => onModeChanged?.call(mode == 'grid' ? 'list' : 'grid'),
      child: text,
    );
    var additionIcon = Icon(HugeIcons.strokeRoundedAdd01);
    var additionButton = MenuItemButton(
      leadingIcon: additionIcon,
      onPressed: () => addBook(context),
      child: Text('新增书籍'),
    );
    return [modeButton, additionButton];
  }
}
