import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:signals/signals_flutter.dart';
import 'package:source_parser/component/bookshelf_list_view.dart';
import 'package:source_parser/page/cloud_reader/cloud_reader_bookshelf_view_model.dart';
import 'package:source_parser/router/router.gr.dart';
import 'package:source_parser/service/cloud_reader_api_client.dart';
import 'package:source_parser/widget/book_cover.dart';

@RoutePage()
class CloudReaderBookshelfPage extends StatefulWidget {
  const CloudReaderBookshelfPage({super.key});

  @override
  State<CloudReaderBookshelfPage> createState() =>
      _CloudReaderBookshelfPageState();
}

class _CloudReaderBookshelfPageState extends State<CloudReaderBookshelfPage> {
  final viewModel = GetIt.instance.get<CloudReaderBookshelfViewModel>();

  @override
  void initState() {
    super.initState();
    viewModel.initSignals();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('云阅读'),
          actions: [
            IconButton(
              icon: const Icon(HugeIcons.strokeRoundedSearch01),
              onPressed: () => viewModel.openSearch(context),
            ),
            IconButton(
              icon: const Icon(HugeIcons.strokeRoundedCompass),
              onPressed: () => _openExplore(context),
            ),
            Watch(
              (_) => _ShelfModeSelector(
                mode: viewModel.shelfMode.value,
                onModeChanged: viewModel.updateShelfMode,
              ),
            ),
          ],
          leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(HugeIcons.strokeRoundedCancel01)),
        ),
        body: Watch((context) {
          if (viewModel.isLoading.value && viewModel.books.value.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
          if (viewModel.error.value.isNotEmpty &&
              viewModel.books.value.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(viewModel.error.value),
                  const SizedBox(height: 16),
                  FilledButton.tonal(
                    onPressed: () => viewModel.refreshBooks(),
                    child: const Text('重试'),
                  ),
                ],
              ),
            );
          }
          return RefreshIndicator(
            onRefresh: viewModel.refreshBooks,
            child: BookshelfListView(
              itemCount: viewModel.books.value.length,
              mode: viewModel.shelfMode.value,
              getName: (i) => viewModel.books.value[i].name,
              getCover: (i) => CloudReaderApiClient()
                  .getCoverUrl(viewModel.books.value[i].coverUrl),
              getSubtitle: (i) {
                var book = viewModel.books.value[i];
                var chapters = book.totalChapterNum - (book.durChapterIndex + 1);
                if (chapters > 0) return '$chapters章未读';
                if (chapters == 0) return '已读完';
                return '未找到章节';
              },
              getTrailing: (i) {
                var time = viewModel.books.value[i].latestChapterTime;
                if (time <= 0) return null;
                var date = DateTime.fromMillisecondsSinceEpoch(time);
                return '${date.month}-${date.day} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
              },
              onTap: (i) => viewModel.openReader(context, i),
              onLongPress: (i) => _showBottomSheet(context, i),
            ),
          );
        }),
      ),
    );
  }

  void _openExplore(BuildContext context) {
    CloudReaderExploreRoute().push(context);
  }

  void _showBottomSheet(BuildContext context, int index) {
    HapticFeedback.heavyImpact();
    var book = viewModel.books.value[index];
    var coverUrl = CloudReaderApiClient().getCoverUrl(book.coverUrl);
    var bottomSheet = _CloudBookBottomSheet(
      name: book.name,
      author: book.author,
      coverUrl: coverUrl,
      onDelete: () {
        Navigator.pop(context);
        _showDeleteDialog(context, index);
      },
    );
    showModalBottomSheet(builder: (_) => bottomSheet, context: context);
  }

  void _showDeleteDialog(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('删除书籍'),
        content: Text('确定要从书架中删除《${viewModel.books.value[index].name}》吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              viewModel.deleteBook(index);
            },
            child: const Text('确定'),
          ),
        ],
      ),
    );
  }
}

class _ShelfModeSelector extends StatelessWidget {
  final String mode;
  final void Function(String)? onModeChanged;

  const _ShelfModeSelector({
    required this.mode,
    this.onModeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return MenuAnchor(
      alignmentOffset: Offset(-132, 12),
      builder: (_, controller, __) => _builder(controller),
      menuChildren: _buildMenuChildren(),
      style: MenuStyle(alignment: Alignment.bottomRight),
    );
  }

  void _handleTap(MenuController controller) {
    if (controller.isOpen) return controller.close();
    controller.open();
  }

  Widget _builder(MenuController controller) {
    return IconButton(
      onPressed: () => _handleTap(controller),
      icon: const Icon(HugeIcons.strokeRoundedMoreVertical),
    );
  }

  List<Widget> _buildMenuChildren() {
    var modeIcon = Icon(HugeIcons.strokeRoundedMenuCircle);
    if (mode == 'grid') modeIcon = Icon(HugeIcons.strokeRoundedMenu01);
    var modeButton = MenuItemButton(
      leadingIcon: modeIcon,
      onPressed: () => onModeChanged?.call(mode == 'grid' ? 'list' : 'grid'),
      child: Text(mode == 'grid' ? '列表模式' : '网格模式'),
    );
    return [modeButton];
  }
}

class _CloudBookBottomSheet extends StatelessWidget {
  final String name;
  final String author;
  final String coverUrl;
  final void Function()? onDelete;

  const _CloudBookBottomSheet({
    required this.name,
    required this.author,
    required this.coverUrl,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final surface = colorScheme.surface;
    final onSurface = colorScheme.onSurface;
    var title = Text(
      name,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(fontSize: 14, height: 1.2),
    );
    var authorStyle = TextStyle(
      fontSize: 12,
      height: 1.2,
      color: onSurface.withValues(alpha: 0.5),
    );
    var authorWidget = Text(author, style: authorStyle);
    var column = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [title, const SizedBox(height: 8), authorWidget],
    );
    var rowChildren = [
      BookCover(height: 80, url: coverUrl, width: 60),
      const SizedBox(width: 16),
      Expanded(child: column),
    ];
    var deleteAction = _SheetAction(
      icon: const Icon(HugeIcons.strokeRoundedDelete02),
      text: '移出书架',
      onTap: onDelete,
    );
    var actionChildren = [
      deleteAction,
      const Expanded(flex: 3, child: SizedBox()),
    ];
    var boxDecoration = BoxDecoration(
      borderRadius: BorderRadius.circular(8),
      color: surface,
    );
    var container = Container(
      decoration: boxDecoration,
      child: Row(children: actionChildren),
    );
    var listChildren = [
      Row(children: rowChildren),
      const SizedBox(height: 16),
      container,
    ];
    return ListView(padding: const EdgeInsets.all(16), children: listChildren);
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
