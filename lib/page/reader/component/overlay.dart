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
  final void Function()? onRemoved;
  const ReaderOverlay({
    super.key,
    required this.book,
    this.onCached,
    this.onNext,
    this.onPrevious,
    this.onRemoved,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final layout = ref.watch(readerLayoutNotifierProviderProvider).valueOrNull;
    if (layout == null) return const SizedBox();
    final appBarButtons = layout.appBarButtons.map(_toElement).toList();
    var body = GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onRemoved,
      child: SizedBox(height: double.infinity, width: double.infinity),
    );
    final bottomBarButtons = _buildBottomButtons(layout.bottomBarButtons);
    return Scaffold(
      appBar: AppBar(actions: appBarButtons, title: Text(book.name)),
      backgroundColor: Colors.transparent,
      body: body,
      bottomNavigationBar: BottomAppBar(child: Row(children: bottomBarButtons)),
      floatingActionButton: _FloatingButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endContained,
    );
  }

  List<Widget> _buildBottomButtons(List<ButtonPosition> positions) {
    var buttons = positions.map(_toElement).toList();
    buttons.insert(0, _MenuButton());
    return buttons;
  }

  Widget _toElement(ButtonPosition position) {
    return switch (position) {
      ButtonPosition.audio => _FloatingButton(),
      ButtonPosition.cache => _CacheButton(onTap: onCached),
      ButtonPosition.catalogue => _CatalogueButton(),
      ButtonPosition.darkMode => _DarkModeButton(),
      ButtonPosition.information => _InformationButton(),
      ButtonPosition.nextChapter => _NextChapterButton(onTap: onNext),
      ButtonPosition.previousChapter =>
        _PreviousChapterButton(onTap: onPrevious),
      ButtonPosition.source => _SourceButton(),
      ButtonPosition.theme => _ThemeButton(),
    };
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
  const _MenuButton();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var menuChildren = [
      MenuItemButton(
        leadingIcon: const Icon(HugeIcons.strokeRoundedBook01),
        onPressed: () => navigateBookInformation(context),
        child: const Text('书籍信息'),
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
