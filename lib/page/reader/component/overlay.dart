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

  void handleTap(String slot, {int? count}) {
    if (slot == LayoutSlot.cache.name && count != null) {
      return onCached?.call(count);
    }
    if (slot == LayoutSlot.forceRefresh.name) return onRefresh?.call();
    if (slot == LayoutSlot.nextChapter.name) return onNext?.call();
    if (slot == LayoutSlot.previousChapter.name) return onPrevious?.call();
  }

  AppBar _buildAppBar(Layout layout) {
    var slot0 = _OverlayRegularSlot(
      book: book,
      onTap: ({int? count}) => handleTap(layout.slot0, count: count),
      slot: layout.slot0,
    );
    var slot1 = _OverlayRegularSlot(
      book: book,
      onTap: ({int? count}) => handleTap(layout.slot1, count: count),
      slot: layout.slot1,
    );
    return AppBar(actions: [slot0, slot1], title: Text(book.name));
  }

  Widget _buildBottomBar(Layout layout) {
    var slot2 = _OverlayRegularSlot(
      book: book,
      onTap: ({int? count}) => handleTap(layout.slot2, count: count),
      slot: layout.slot2,
    );
    var slot3 = _OverlayRegularSlot(
      book: book,
      onTap: ({int? count}) => handleTap(layout.slot3, count: count),
      slot: layout.slot3,
    );
    var slot4 = _OverlayRegularSlot(
      book: book,
      onTap: ({int? count}) => handleTap(layout.slot4, count: count),
      slot: layout.slot4,
    );
    var slot5 = _OverlayRegularSlot(
      book: book,
      onTap: ({int? count}) => handleTap(layout.slot5, count: count),
      slot: layout.slot5,
    );
    return BottomAppBar(child: Row(children: [slot2, slot3, slot4, slot5]));
  }

  Widget _buildFloatingButton(Layout layout) {
    return _OverlayFloatingSlot(
      book: book,
      onTap: ({int? count}) => handleTap(layout.slot6, count: count),
      slot: layout.slot6,
    );
  }
}

abstract class _OverlayBaseSlot extends StatelessWidget {
  final Book book;
  final void Function({int? count})? onTap;
  final String slot;

  const _OverlayBaseSlot({required this.book, this.onTap, required this.slot});

  void handleTap(BuildContext context) {
    if (slot == LayoutSlot.audio.name) _showMessage(context);
    if (slot == LayoutSlot.cache.name) _showCacheSheet(context);
    if (slot == LayoutSlot.catalogue.name) _navigateBookCatalogue(context);
    if (slot == LayoutSlot.darkMode.name) _toggleDarkMode(context);
    if (slot == LayoutSlot.forceRefresh.name) onTap?.call();
    if (slot == LayoutSlot.information.name) _navigateBookInformation(context);
    if (slot == LayoutSlot.nextChapter.name) onTap?.call();
    if (slot == LayoutSlot.previousChapter.name) onTap?.call();
    if (slot == LayoutSlot.source.name) _navigateAvailableSource(context);
    if (slot == LayoutSlot.theme.name) _navigateReaderTheme(context);
  }

  void _downloadChapter(int count) {
    onTap?.call(count: count);
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
      builder: (context) => ReaderCacheSheet(onCached: _downloadChapter),
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

class _OverlayFloatingSlot extends _OverlayBaseSlot {
  const _OverlayFloatingSlot({
    required super.book,
    super.onTap,
    required super.slot,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => handleTap(context),
      child: Icon(_getIconData()),
    );
  }
}

class _OverlayMoreSlot extends ConsumerWidget {
  final Book book;
  final void Function({int? count})? onTap;
  final String slot;
  const _OverlayMoreSlot({required this.book, this.onTap, required this.slot});

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
      return _OverlayMoreSlotItem(book: book, onTap: onTap, slot: value.name);
    }).toList();
  }

  void _toggleMenu(MenuController controller) {
    if (controller.isOpen) return controller.close();
    controller.open();
  }
}

class _OverlayMoreSlotItem extends StatelessWidget {
  final Book book;
  final void Function({int? count})? onTap;
  final String slot;
  const _OverlayMoreSlotItem({
    required this.book,
    required this.onTap,
    required this.slot,
  });

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
    if (slot == LayoutSlot.forceRefresh.name) onTap?.call();
    if (slot == LayoutSlot.information.name) _navigateBookInformation(context);
    if (slot == LayoutSlot.nextChapter.name) onTap?.call();
    if (slot == LayoutSlot.previousChapter.name) onTap?.call();
    if (slot == LayoutSlot.source.name) _navigateAvailableSource(context);
    if (slot == LayoutSlot.theme.name) _navigateReaderTheme(context);
  }

  void _downloadChapter(int count) {
    onTap?.call(count: count);
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
      builder: (context) => ReaderCacheSheet(onCached: _downloadChapter),
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

class _OverlayRegularSlot extends _OverlayBaseSlot {
  const _OverlayRegularSlot({
    required super.book,
    super.onTap,
    required super.slot,
  });

  @override
  Widget build(BuildContext context) {
    if (slot.isEmpty) return const SizedBox();
    if (slot == LayoutSlot.more.name) {
      return _OverlayMoreSlot(book: book, onTap: onTap, slot: slot);
    }
    return IconButton(
      onPressed: () => handleTap(context),
      icon: Icon(_getIconData()),
    );
  }
}
