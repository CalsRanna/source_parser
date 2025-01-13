import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:source_parser/page/reader/component/cache.dart';
import 'package:source_parser/provider/layout.dart';
import 'package:source_parser/provider/setting.dart';
import 'package:source_parser/router/router.gr.dart';
import 'package:source_parser/schema/book.dart';
import 'package:source_parser/schema/layout.dart';
import 'package:source_parser/util/message.dart';

class ReaderOverlay extends ConsumerWidget {
  final Book book;
  final void Function()? onBarrierTap;
  final void Function(int)? onCached;
  final void Function()? onNext;
  final void Function()? onPrevious;
  final void Function()? onRefresh;
  const ReaderOverlay({
    super.key,
    required this.book,
    this.onBarrierTap,
    this.onCached,
    this.onNext,
    this.onPrevious,
    this.onRefresh,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final layout = ref.watch(readerLayoutNotifierProviderProvider).valueOrNull;
    if (layout == null) return const SizedBox();
    var barrier = GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onBarrierTap,
      child: SizedBox(height: double.infinity, width: double.infinity),
    );
    return Scaffold(
      appBar: _buildAppBar(layout),
      backgroundColor: Colors.transparent,
      body: barrier,
      bottomNavigationBar: _buildBottomBar(layout),
      floatingActionButton: _buildFloatingButton(layout),
      floatingActionButtonLocation: FloatingActionButtonLocation.endContained,
    );
  }

  AppBar _buildAppBar(Layout layout) {
    var actions = [
      _OverlaySlot(book: book, slot: layout.slot0),
      _OverlaySlot(book: book, slot: layout.slot1),
    ];
    return AppBar(actions: actions, title: Text(book.name));
  }

  Widget _buildBottomBar(Layout layout) {
    var children = [
      _OverlaySlot(book: book, slot: layout.slot2),
      _OverlaySlot(book: book, slot: layout.slot3),
      _OverlaySlot(book: book, slot: layout.slot4),
      _OverlaySlot(book: book, slot: layout.slot5),
    ];
    return BottomAppBar(child: Row(children: children));
  }

  Widget _buildFloatingButton(Layout layout) {
    return _OverlayFloatingSlot(book: book, slot: layout.slot6);
  }
}

class _OverlayFloatingSlot extends StatelessWidget {
  final Book book;
  final String slot;
  const _OverlayFloatingSlot({required this.book, required this.slot});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => handleTap(context),
      child: Icon(_getIconData()),
    );
  }

  void handleTap(BuildContext context) {
    if (slot == LayoutSlot.audio.name) _showMessage(context);
    if (slot == LayoutSlot.cache.name) _showCacheSheet(context);
    if (slot == LayoutSlot.catalogue.name) _navigateBookCatalogue(context);
    if (slot == LayoutSlot.darkMode.name) _toggleDarkMode(context);
    if (slot == LayoutSlot.forceRefresh.name) _forceRefresh(context);
    if (slot == LayoutSlot.information.name) _navigateBookInformation(context);
    if (slot == LayoutSlot.nextChapter.name) _showMessage(context);
    if (slot == LayoutSlot.previousChapter.name) _showMessage(context);
    if (slot == LayoutSlot.source.name) _navigateAvailableSource(context);
    if (slot == LayoutSlot.theme.name) _navigateReaderTheme(context);
  }

  void _forceRefresh(BuildContext context) {
    Message.of(context).show('开发中，但很有可能会移除该功能');
  }

  IconData _getIconData() {
    var values = LayoutSlot.values;
    var layoutSlot = values.firstWhere((value) => value.name == slot);
    return switch (layoutSlot) {
      LayoutSlot.audio => HugeIcons.strokeRoundedHeadphones,
      LayoutSlot.cache => HugeIcons.strokeRoundedDownload04,
      LayoutSlot.catalogue => HugeIcons.strokeRoundedMenu01,
      LayoutSlot.darkMode => HugeIcons.strokeRoundedMoon02,
      LayoutSlot.forceRefresh => HugeIcons.strokeRoundedRefresh,
      LayoutSlot.information => HugeIcons.strokeRoundedBook01,
      LayoutSlot.more => HugeIcons.strokeRoundedMoreVertical,
      LayoutSlot.nextChapter => HugeIcons.strokeRoundedNext,
      LayoutSlot.previousChapter => HugeIcons.strokeRoundedPrevious,
      LayoutSlot.source => HugeIcons.strokeRoundedExchange01,
      LayoutSlot.theme => HugeIcons.strokeRoundedTextFont,
    };
  }

  void _navigateAvailableSource(BuildContext context) {
    AvailableSourceListRoute().push(context);
  }

  void _navigateBookCatalogue(BuildContext context) {
    CatalogueRoute(index: book.index).push(context);
  }

  void _navigateBookInformation(BuildContext context) {
    InformationRoute().push(context);
  }

  void _navigateReaderTheme(BuildContext context) {
    ReaderThemeRoute().push(context);
  }

  void _showCacheSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => ReaderCacheSheet(onCached: (value) {}),
      showDragHandle: true,
    );
  }

  void _showMessage(BuildContext context) {
    Message.of(context).show('开发中，但很有可能会移除该功能');
  }

  void _toggleDarkMode(BuildContext context) {
    var container = ProviderScope.containerOf(context);
    var provider = settingNotifierProvider;
    var notifier = container.read(provider.notifier);
    notifier.toggleDarkMode();
  }
}

class _OverlayMoreSlot extends ConsumerWidget {
  final Book book;
  final String slot;
  const _OverlayMoreSlot({required this.book, required this.slot});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var provider = readerLayoutNotifierProviderProvider;
    var layout = ref.watch(provider).valueOrNull;
    return MenuAnchor(
      alignmentOffset: Offset(0, 28),
      builder: (_, controller, __) => _builder(controller),
      menuChildren: _buildMenuChildren(layout),
      style: MenuStyle(alignment: Alignment.topLeft),
    );
  }

  Widget _builder(MenuController controller) {
    return IconButton(
      onPressed: () => _toggleMenu(controller),
      icon: const Icon(HugeIcons.strokeRoundedMoreVertical),
    );
  }

  List<Widget> _buildMenuChildren(Layout? layout) {
    if (layout == null) return [];
    // Ignore `more` itself
    var values = LayoutSlot.values.where((value) => value != LayoutSlot.more);
    var usedSlots = [
      layout.slot0,
      layout.slot1,
      layout.slot2,
      layout.slot3,
      layout.slot4,
      layout.slot5,
      layout.slot6,
    ];
    var remainingSlots = values.toSet().difference(usedSlots.toSet());
    return remainingSlots.map((value) {
      return _OverlayMoreSlotItem(book: book, slot: value.name);
    }).toList();
  }

  void _toggleMenu(MenuController controller) {
    if (controller.isOpen) return controller.close();
    controller.open();
  }
}

class _OverlayMoreSlotItem extends StatelessWidget {
  final Book book;
  final String slot;
  const _OverlayMoreSlotItem({required this.book, required this.slot});

  @override
  Widget build(BuildContext context) {
    return MenuItemButton(
      leadingIcon: Icon(_getIconData()),
      onPressed: () => handleTap(context),
      child: Text(_getButtonLabel()),
    );
  }

  void handleTap(BuildContext context) {
    if (slot == LayoutSlot.audio.name) _showMessage(context);
    if (slot == LayoutSlot.cache.name) _showCacheSheet(context);
    if (slot == LayoutSlot.catalogue.name) _navigateBookCatalogue(context);
    if (slot == LayoutSlot.darkMode.name) _toggleDarkMode(context);
    if (slot == LayoutSlot.forceRefresh.name) _forceRefresh(context);
    if (slot == LayoutSlot.information.name) _navigateBookInformation(context);
    if (slot == LayoutSlot.nextChapter.name) _showMessage(context);
    if (slot == LayoutSlot.previousChapter.name) _showMessage(context);
    if (slot == LayoutSlot.source.name) _navigateAvailableSource(context);
    if (slot == LayoutSlot.theme.name) _navigateReaderTheme(context);
  }

  void _forceRefresh(BuildContext context) {
    Message.of(context).show('开发中，但很有可能会移除该功能');
  }

  String _getButtonLabel() {
    var values = LayoutSlot.values;
    var layoutSlot = values.firstWhere((value) => value.name == slot);
    return switch (layoutSlot) {
      LayoutSlot.audio => '朗读',
      LayoutSlot.cache => '缓存',
      LayoutSlot.catalogue => '目录',
      LayoutSlot.darkMode => '夜间模式',
      LayoutSlot.forceRefresh => '强制刷新',
      LayoutSlot.information => '书籍信息',
      LayoutSlot.more => '更多',
      LayoutSlot.nextChapter => '下一章',
      LayoutSlot.previousChapter => '上一章',
      LayoutSlot.source => '切换书源',
      LayoutSlot.theme => '主题',
    };
  }

  IconData _getIconData() {
    var values = LayoutSlot.values;
    var layoutSlot = values.firstWhere((value) => value.name == slot);
    return switch (layoutSlot) {
      LayoutSlot.audio => HugeIcons.strokeRoundedHeadphones,
      LayoutSlot.cache => HugeIcons.strokeRoundedDownload04,
      LayoutSlot.catalogue => HugeIcons.strokeRoundedMenu01,
      LayoutSlot.darkMode => HugeIcons.strokeRoundedMoon02,
      LayoutSlot.forceRefresh => HugeIcons.strokeRoundedRefresh,
      LayoutSlot.information => HugeIcons.strokeRoundedBook01,
      // Will never be called cause we exclude `more` in `_OverlayMoreSlot`
      LayoutSlot.more => HugeIcons.strokeRoundedMoreVertical,
      LayoutSlot.nextChapter => HugeIcons.strokeRoundedNext,
      LayoutSlot.previousChapter => HugeIcons.strokeRoundedPrevious,
      LayoutSlot.source => HugeIcons.strokeRoundedExchange01,
      LayoutSlot.theme => HugeIcons.strokeRoundedTextFont,
    };
  }

  void _navigateAvailableSource(BuildContext context) {
    AvailableSourceListRoute().push(context);
  }

  void _navigateBookCatalogue(BuildContext context) {
    CatalogueRoute(index: book.index).push(context);
  }

  void _navigateBookInformation(BuildContext context) {
    InformationRoute().push(context);
  }

  void _navigateReaderTheme(BuildContext context) {
    ReaderThemeRoute().push(context);
  }

  void _showCacheSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => ReaderCacheSheet(onCached: (value) {}),
      showDragHandle: true,
    );
  }

  void _showMessage(BuildContext context) {
    Message.of(context).show('开发中，但很有可能会移除该功能');
  }

  void _toggleDarkMode(BuildContext context) {
    var container = ProviderScope.containerOf(context);
    var provider = settingNotifierProvider;
    var notifier = container.read(provider.notifier);
    notifier.toggleDarkMode();
  }
}

class _OverlaySlot extends StatelessWidget {
  final Book book;
  final String slot;
  const _OverlaySlot({required this.book, required this.slot});

  @override
  Widget build(BuildContext context) {
    if (slot.isEmpty) return const SizedBox();
    if (slot == LayoutSlot.more.name) {
      return _OverlayMoreSlot(book: book, slot: slot);
    }
    return IconButton(
      onPressed: () => handleTap(context),
      icon: Icon(_getIconData()),
    );
  }

  void handleTap(BuildContext context) {
    if (slot == LayoutSlot.audio.name) _showMessage(context);
    if (slot == LayoutSlot.cache.name) _showCacheSheet(context);
    if (slot == LayoutSlot.catalogue.name) _navigateBookCatalogue(context);
    if (slot == LayoutSlot.darkMode.name) _toggleDarkMode(context);
    if (slot == LayoutSlot.forceRefresh.name) _forceRefresh(context);
    if (slot == LayoutSlot.information.name) _navigateBookInformation(context);
    if (slot == LayoutSlot.nextChapter.name) _showMessage(context);
    if (slot == LayoutSlot.previousChapter.name) _showMessage(context);
    if (slot == LayoutSlot.source.name) _navigateAvailableSource(context);
    if (slot == LayoutSlot.theme.name) _navigateReaderTheme(context);
  }

  void _forceRefresh(BuildContext context) {
    Message.of(context).show('开发中，但很有可能会移除该功能');
  }

  IconData _getIconData() {
    var values = LayoutSlot.values;
    var layoutSlot = values.firstWhere((value) => value.name == slot);
    return switch (layoutSlot) {
      LayoutSlot.audio => HugeIcons.strokeRoundedHeadphones,
      LayoutSlot.cache => HugeIcons.strokeRoundedDownload04,
      LayoutSlot.catalogue => HugeIcons.strokeRoundedMenu01,
      LayoutSlot.darkMode => HugeIcons.strokeRoundedMoon02,
      LayoutSlot.forceRefresh => HugeIcons.strokeRoundedRefresh,
      LayoutSlot.information => HugeIcons.strokeRoundedBook01,
      // Will never be called cause we use `_OverlayMoreSlot` instead
      LayoutSlot.more => HugeIcons.strokeRoundedMoreVertical,
      LayoutSlot.nextChapter => HugeIcons.strokeRoundedNext,
      LayoutSlot.previousChapter => HugeIcons.strokeRoundedPrevious,
      LayoutSlot.source => HugeIcons.strokeRoundedExchange01,
      LayoutSlot.theme => HugeIcons.strokeRoundedTextFont,
    };
  }

  void _navigateAvailableSource(BuildContext context) {
    AvailableSourceListRoute().push(context);
  }

  void _navigateBookCatalogue(BuildContext context) {
    CatalogueRoute(index: book.index).push(context);
  }

  void _navigateBookInformation(BuildContext context) {
    InformationRoute().push(context);
  }

  void _navigateReaderTheme(BuildContext context) {
    ReaderThemeRoute().push(context);
  }

  void _showCacheSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => ReaderCacheSheet(onCached: (value) {}),
      showDragHandle: true,
    );
  }

  void _showMessage(BuildContext context) {
    Message.of(context).show('开发中，但很有可能会移除该功能');
  }

  void _toggleDarkMode(BuildContext context) {
    var container = ProviderScope.containerOf(context);
    var provider = settingNotifierProvider;
    var notifier = container.read(provider.notifier);
    notifier.toggleDarkMode();
  }
}
