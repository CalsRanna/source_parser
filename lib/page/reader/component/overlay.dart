import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:source_parser/page/reader/component/cache.dart';
import 'package:source_parser/provider/book.dart';
import 'package:source_parser/provider/layout.dart';
import 'package:source_parser/provider/setting.dart';
import 'package:source_parser/router/router.gr.dart';
import 'package:source_parser/schema/book.dart';
import 'package:source_parser/schema/layout.dart';
import 'package:source_parser/util/message.dart';

class ReaderOverlay extends ConsumerWidget {
  final Book book;
  final void Function(int)? onCached;
  final void Function()? onNext;
  final void Function()? onPrevious;
  final void Function()? onRefresh;
  final void Function()? onRemoved;
  const ReaderOverlay({
    super.key,
    required this.book,
    this.onCached,
    this.onNext,
    this.onPrevious,
    this.onRefresh,
    this.onRemoved,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final layout = ref.watch(readerLayoutNotifierProviderProvider).valueOrNull;
    if (layout == null) return const SizedBox();
    var body = GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onRemoved,
      child: SizedBox(height: double.infinity, width: double.infinity),
    );
    return Scaffold(
      appBar: _buildAppBar(layout),
      backgroundColor: Colors.transparent,
      body: body,
      bottomNavigationBar: _buildBottomAppBar(layout),
      floatingActionButton: _FloatingButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endContained,
    );
  }

  AppBar _buildAppBar(Layout layout) {
    return AppBar(title: Text(book.name));
  }

  Widget _buildBottomAppBar(Layout layout) {
    // final children = _buildBottomButtons(layout.bottomBarButtons);
    return BottomAppBar(child: Row(children: []));
  }

  List<Widget> _buildBottomButtons(List<LayoutSlot> positions) {
    var buttons = positions.map(_toElement).toList();
    buttons.insert(0, _MenuButton(onRefresh: onRefresh));
    return buttons;
  }

  Widget _toElement(LayoutSlot position) {
    return switch (position) {
      LayoutSlot.audio => _FloatingButton(),
      LayoutSlot.cache => _CacheButton(onTap: onCached),
      LayoutSlot.catalogue => _CatalogueButton(),
      LayoutSlot.darkMode => _DarkModeButton(),
      LayoutSlot.forceRefresh => _ForceRefreshButton(onTap: onRefresh),
      LayoutSlot.information => _InformationButton(),
      LayoutSlot.more => _MenuButton(onRefresh: onRefresh),
      LayoutSlot.nextChapter => _NextChapterButton(onTap: onNext),
      LayoutSlot.previousChapter => _PreviousChapterButton(onTap: onPrevious),
      LayoutSlot.source => _SourceButton(),
      LayoutSlot.theme => _ThemeButton(),
    };
  }
}

class _ForceRefreshButton extends StatelessWidget {
  final void Function()? onTap;
  const _ForceRefreshButton({this.onTap});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(HugeIcons.strokeRoundedRefresh),
      onPressed: onTap,
    );
  }
}

class _CacheButton extends StatelessWidget {
  final void Function(int)? onTap;
  const _CacheButton({this.onTap});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => openBottomSheet(context),
      icon: const Icon(HugeIcons.strokeRoundedDownload04),
    );
  }

  void openBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => ReaderCacheSheet(onCached: onTap),
      showDragHandle: true,
    );
  }
}

class _CatalogueButton extends ConsumerWidget {
  const _CatalogueButton();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IconButton(
      onPressed: () => navigateBookCatalogue(context, ref),
      icon: const Icon(HugeIcons.strokeRoundedMenu01),
    );
  }

  void navigateBookCatalogue(BuildContext context, WidgetRef ref) {
    var provider = bookNotifierProvider;
    var book = ref.read(provider);
    AutoRouter.of(context).push(CatalogueRoute(index: book.index));
  }
}

class _DarkModeButton extends ConsumerWidget {
  const _DarkModeButton();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var provider = settingNotifierProvider;
    var setting = ref.watch(provider).valueOrNull;
    var darkMode = setting?.darkMode ?? false;
    var icon = HugeIcons.strokeRoundedMoon02;
    if (darkMode) icon = HugeIcons.strokeRoundedSun03;
    return IconButton(
      onPressed: () => toggleDarkMode(ref),
      icon: Icon(icon),
    );
  }

  void toggleDarkMode(WidgetRef ref) {
    var provider = settingNotifierProvider;
    var notifier = ref.read(provider.notifier);
    notifier.toggleDarkMode();
  }
}

class _FloatingButton extends StatelessWidget {
  const _FloatingButton();
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => navigateBookListener(context),
      child: const Icon(HugeIcons.strokeRoundedHeadphones),
    );
  }

  void navigateBookListener(BuildContext context) {
    Message.of(context).show('开发中，但很有可能会移除该功能');
  }
}

class _InformationButton extends StatelessWidget {
  const _InformationButton();

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => navigateBookInformation(context),
      icon: const Icon(HugeIcons.strokeRoundedBook01),
    );
  }

  void navigateBookInformation(BuildContext context) {
    AutoRouter.of(context).push(InformationRoute());
  }
}

class _MenuButton extends ConsumerWidget {
  final void Function()? onRefresh;

  const _MenuButton({this.onRefresh});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var menuChildren = [
      MenuItemButton(
        leadingIcon: const Icon(HugeIcons.strokeRoundedBook01),
        onPressed: () => navigateBookInformation(context),
        child: const Text('书籍信息'),
      ),
      MenuItemButton(
        leadingIcon: const Icon(HugeIcons.strokeRoundedRefresh),
        onPressed: onRefresh,
        child: const Text('强制刷新'),
      ),
      MenuItemButton(
        leadingIcon: const Icon(HugeIcons.strokeRoundedExchange01),
        onPressed: () => navigateSourceSwitcher(context),
        child: const Text('切换书源'),
      ),
      MenuItemButton(
        leadingIcon: const Icon(HugeIcons.strokeRoundedTextFont),
        onPressed: () => navigateReaderTheme(context),
        child: const Text('阅读主题'),
      ),
    ];
    return MenuAnchor(
      alignmentOffset: Offset(0, 28),
      builder: (_, controller, __) => _builder(controller),
      menuChildren: menuChildren,
      style: MenuStyle(alignment: Alignment.topLeft),
    );
  }

  void handleTap(MenuController controller) {
    if (controller.isOpen) return controller.close();
    controller.open();
  }

  void navigateBookInformation(BuildContext context) {
    AutoRouter.of(context).push(InformationRoute());
  }

  void navigateReaderTheme(BuildContext context) {
    AutoRouter.of(context).push(ReaderThemeRoute());
  }

  void navigateSourceSwitcher(BuildContext context) {
    AutoRouter.of(context).push(AvailableSourceListRoute());
  }

  Widget _builder(MenuController controller) {
    return IconButton(
      onPressed: () => handleTap(controller),
      icon: const Icon(HugeIcons.strokeRoundedMoreVertical),
    );
  }
}

class _NextChapterButton extends StatelessWidget {
  final void Function()? onTap;
  const _NextChapterButton({this.onTap});
  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onTap,
      icon: const Icon(HugeIcons.strokeRoundedNext),
    );
  }
}

class _PreviousChapterButton extends StatelessWidget {
  final void Function()? onTap;
  const _PreviousChapterButton({this.onTap});
  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onTap,
      icon: const Icon(HugeIcons.strokeRoundedPrevious),
    );
  }
}

class _SourceButton extends StatelessWidget {
  const _SourceButton();

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => navigateSourceSwitcher(context),
      icon: const Icon(HugeIcons.strokeRoundedExchange01),
    );
  }

  void navigateSourceSwitcher(BuildContext context) {
    AutoRouter.of(context).push(AvailableSourceListRoute());
  }
}

class _ThemeButton extends StatelessWidget {
  const _ThemeButton();

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => navigateReaderTheme(context),
      icon: const Icon(HugeIcons.strokeRoundedTextFont),
    );
  }

  void navigateReaderTheme(BuildContext context) {
    AutoRouter.of(context).push(ReaderThemeRoute());
  }
}
