import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:source_parser/config/string_config.dart';
import 'package:source_parser/model/book_entity.dart';
import 'package:source_parser/page/reader/reader_cache_sheet_view.dart';
import 'package:source_parser/page/reader/reader_overlay_cache_slot.dart';
import 'package:source_parser/page/reader/reader_overlay_dark_mode_slot.dart';
import 'package:source_parser/provider/layout.dart';
import 'package:source_parser/router/router.dart';
import 'package:source_parser/router/router.gr.dart';
import 'package:source_parser/schema/layout.dart';
import 'package:source_parser/util/dialog_util.dart';

abstract class ReaderOverlayBaseSlot extends StatelessWidget {
  final BookEntity book;
  final void Function({int? count})? onTap;
  final String slot;

  const ReaderOverlayBaseSlot({
    super.key,
    required this.book,
    this.onTap,
    required this.slot,
  });

  void handleTap(BuildContext context) {
    if (slot == LayoutSlot.audio.name) _showMessage(context);
    if (slot == LayoutSlot.cache.name) _showCacheSheet(context);
    if (slot == LayoutSlot.catalogue.name) onTap?.call();
    if (slot == LayoutSlot.darkMode.name) onTap?.call();
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
      LayoutSlot.audio => StringConfig.readAloud,
      LayoutSlot.cache => StringConfig.cache,
      LayoutSlot.catalogue => StringConfig.catalogue,
      LayoutSlot.darkMode => StringConfig.darkMode,
      LayoutSlot.forceRefresh => StringConfig.forceRefresh,
      LayoutSlot.information => StringConfig.information,
      LayoutSlot.more => StringConfig.more,
      LayoutSlot.nextChapter => StringConfig.nextChapter,
      LayoutSlot.previousChapter => StringConfig.previousChapter,
      LayoutSlot.source => StringConfig.changeSource,
      LayoutSlot.theme => StringConfig.theme,
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
      LayoutSlot.more => HugeIcons.strokeRoundedMoreVertical,
      LayoutSlot.nextChapter => HugeIcons.strokeRoundedNext,
      LayoutSlot.previousChapter => HugeIcons.strokeRoundedPrevious,
      LayoutSlot.source => HugeIcons.strokeRoundedExchange01,
      LayoutSlot.theme => HugeIcons.strokeRoundedTextFont,
    };
  }

  void _navigateAvailableSource(BuildContext context) {
    // AvailableSourceListRoute().push(context);
  }

  void _navigateBookInformation(BuildContext context) {
    // InformationRoute().push(context);
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
    DialogUtil.snackBar(StringConfig.developing);
  }
}

class ReaderOverlayView extends ConsumerWidget {
  final BookEntity book;
  final bool isDarkMode;
  final void Function()? onAvailableSource;
  final void Function()? onBarrierTap;
  final void Function(int)? onCached;
  final void Function()? onCatalogue;
  final void Function()? onDarkMode;
  final void Function()? onNext;
  final void Function()? onPrevious;
  final void Function()? onRefresh;
  const ReaderOverlayView({
    super.key,
    required this.book,
    required this.isDarkMode,
    this.onAvailableSource,
    this.onBarrierTap,
    this.onCached,
    this.onCatalogue,
    this.onDarkMode,
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
    if (slot == LayoutSlot.catalogue.name) return onCatalogue?.call();
    if (slot == LayoutSlot.forceRefresh.name) return onRefresh?.call();
    if (slot == LayoutSlot.nextChapter.name) return onNext?.call();
    if (slot == LayoutSlot.previousChapter.name) return onPrevious?.call();
    if (slot == LayoutSlot.source.name) return onAvailableSource?.call();
    if (slot == LayoutSlot.darkMode.name) return onDarkMode?.call();
    if (slot == LayoutSlot.cache.name) return onCached?.call(count ?? 0);
  }

  AppBar _buildAppBar(Layout layout) {
    return AppBar(
      actions: [_buildSlot(layout.slot0), _buildSlot(layout.slot1)],
      title: Text(book.name),
    );
  }

  Widget _buildBottomBar(Layout layout) {
    var children = [
      _buildSlot(layout.slot2),
      _buildSlot(layout.slot3),
      _buildSlot(layout.slot4),
      _buildSlot(layout.slot5)
    ];
    return BottomAppBar(child: Row(children: children));
  }

  Widget _buildFloatingButton(Layout layout) {
    return FloatingActionButton(
      onPressed: ({int? count}) => handleTap(layout.slot6, count: count),
      child: Icon(_getIconData(layout.slot6)),
    );
  }

  Widget _buildSlot(String slot) {
    if (slot.isEmpty) return const SizedBox();
    if (slot == LayoutSlot.more.name) {
      return _OverlayMoreSlot(
        book: book,
        onTap: (slot, {int? count}) => handleTap(slot, count: count),
        slot: slot,
      );
    }
    if (slot == LayoutSlot.darkMode.name) {
      return ReaderOverlayDarkModeSlot(
        isDarkMode: isDarkMode,
        onTap: onDarkMode,
      );
    }
    if (slot == LayoutSlot.cache.name) {
      return ReaderOverlayCacheSlot(onTap: onCached);
    }
    return IconButton(
      onPressed: ({int? count}) => handleTap(slot, count: count),
      icon: Icon(_getIconData(slot)),
    );
  }

  IconData _getIconData(String slot) {
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
}

class _OverlayMoreSlot extends ConsumerWidget {
  final BookEntity book;
  final void Function(String slot, {int? count})? onTap;
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
    var slots = LayoutSlot.values.where((value) => value != LayoutSlot.more);
    var values = slots.map((value) => value.name);
    var usedValues = {
      layout.slot0,
      layout.slot1,
      layout.slot2,
      layout.slot3,
      layout.slot4,
      layout.slot5,
      layout.slot6,
    };
    var remainingValues = values.toSet().difference(usedValues);
    return remainingValues.map((value) {
      return _OverlayMoreSlotItem(
        book: book,
        onTap: ({int? count}) => onTap?.call(value, count: count),
        slot: value,
      );
    }).toList();
  }

  void _toggleMenu(MenuController controller) {
    if (controller.isOpen) return controller.close();
    controller.open();
  }
}

class _OverlayMoreSlotItem extends ReaderOverlayBaseSlot {
  const _OverlayMoreSlotItem({
    required super.book,
    required super.onTap,
    required super.slot,
  });

  @override
  Widget build(BuildContext context) {
    return MenuItemButton(
      leadingIcon: Icon(_getIconData()),
      // current context will be disposed while trigger the onPressed callback
      onPressed: () => handleTap(globalKey.currentContext!),
      child: Text(_getButtonLabel()),
    );
  }
}
