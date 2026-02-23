import 'package:auto_route/auto_route.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:signals/signals_flutter.dart';
import 'package:source_parser/component/bookshelf_list_view.dart';
import 'package:source_parser/model/book_entity.dart';
import 'package:source_parser/page/home/bookshelf_view/bookshelf_view_model.dart';
import 'package:source_parser/page/home/search_button.dart';
import 'package:source_parser/router/router.gr.dart';
import 'package:source_parser/widget/loading.dart';

class BookshelfView extends StatefulWidget {
  const BookshelfView({super.key});

  @override
  State<BookshelfView> createState() => _BookshelfViewState();
}

class _BookshelfViewState extends State<BookshelfView>
    with AutomaticKeepAliveClientMixin {
  final viewModel = GetIt.instance.get<BookshelfViewModel>();

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
    final books = viewModel.books.value;
    return BookshelfListView(
      itemCount: books.length,
      mode: viewModel.shelfMode.value,
      getName: (i) => books[i].name,
      getCover: (i) => books[i].cover,
      getSubtitle: (i) => _buildSubtitle(books[i]),
      getTrailing: (i) => _buildTrailing(books[i]),
      onTap: (i) => viewModel.navigateReaderPage(context, books[i]),
      onLongPress: (i) => viewModel.openBookBottomSheet(context, books[i]),
    );
  }

  String? _buildSubtitle(BookEntity book) {
    final chapters = book.chapterCount - (book.chapterIndex + 1);
    if (chapters > 0) return '$chapters章未读';
    if (chapters == 0) return '已读完';
    return '未找到章节';
  }

  String? _buildTrailing(BookEntity book) {
    if (book.updatedAt.isNotEmpty) return book.updatedAt;
    return null;
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
