import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:source_parser/provider/book.dart';
import 'package:source_parser/provider/layout.dart';
import 'package:source_parser/provider/setting.dart';
import 'package:source_parser/router/router.gr.dart';
import 'package:source_parser/schema/layout.dart';
import 'package:source_parser/util/message.dart';

class ReaderOverlay extends ConsumerWidget {
  final void Function(int)? onCached;
  final void Function()? onRemoved;
  const ReaderOverlay({super.key, this.onCached, this.onRemoved});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final layout = ref.watch(readerLayoutNotifierProviderProvider).valueOrNull;
    if (layout == null) return const Center(child: CircularProgressIndicator());
    final appBarButtons = _buildButtons(layout.appBarButtons);
    final bottomBarButtons = _buildButtons(layout.bottomBarButtons);
    var body = GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onRemoved,
      child: SizedBox(height: double.infinity, width: double.infinity),
    );
    return Scaffold(
      appBar: AppBar(actions: appBarButtons),
      backgroundColor: Colors.transparent,
      body: body,
      bottomNavigationBar: BottomAppBar(child: Row(children: bottomBarButtons)),
      floatingActionButton: _FloatingButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endContained,
    );
  }

  List<Widget> _buildButtons(List<ButtonPosition> types) {
    return types.map((type) {
      switch (type) {
        case ButtonPosition.cache:
          return _CacheButton(onCached: onCached);
        case ButtonPosition.darkMode:
          return _DarkModeButton();
        case ButtonPosition.catalogue:
          return _CatalogueButton();
        case ButtonPosition.source:
          return _SourceButton();
        case ButtonPosition.theme:
          return _ThemeButton();
        case ButtonPosition.previousChapter:
          return _PreviousChapterButton();
        case ButtonPosition.nextChapter:
          return _NextChapterButton();
        case ButtonPosition.menu:
          return _MenuButton();
        case ButtonPosition.audio:
          return _FloatingButton();
      }
    }).toList();
  }
}

class _CacheSheet extends StatelessWidget {
  final void Function(int)? onCached;
  const _CacheSheet({super.key, this.onCached});

  @override
  Widget build(BuildContext context) {
    var edgeInsets = MediaQuery.of(context).padding;
    var children = [
      TextButton(onPressed: () => handleTap(context, 50), child: Text('后面五十章')),
      TextButton(
          onPressed: () => handleTap(context, 100), child: Text('后面100章')),
      TextButton(
          onPressed: () => handleTap(context, 200), child: Text('后面200章')),
      TextButton(onPressed: () => handleTap(context, 0), child: Text('全部剩余章节')),
    ];
    return GridView.count(
      childAspectRatio: 4,
      crossAxisCount: 2,
      crossAxisSpacing: 8,
      mainAxisSpacing: 8,
      padding: EdgeInsets.fromLTRB(16, 0, 16, edgeInsets.bottom + 16),
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      children: children,
    );
  }

  void handleTap(BuildContext context, int count) {
    onCached?.call(count);
    Navigator.of(context).pop();
  }
}

class _CacheButton extends StatelessWidget {
  final void Function(int)? onCached;
  const _CacheButton({super.key, this.onCached});

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
      builder: (context) => _CacheSheet(onCached: onCached),
      showDragHandle: true,
    );
  }
}

class _InformationButton extends StatelessWidget {
  const _InformationButton({super.key});

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

class _CatalogueButton extends ConsumerWidget {
  const _CatalogueButton({super.key});

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

class _SourceButton extends StatelessWidget {
  const _SourceButton({super.key});

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
  const _ThemeButton({super.key});

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

class _DarkModeButton extends ConsumerWidget {
  const _DarkModeButton({super.key});

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

class _PreviousChapterButton extends ConsumerWidget {
  const _PreviousChapterButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IconButton(
      onPressed: () => goPreviousChapter(context, ref),
      icon: const Icon(HugeIcons.strokeRoundedPrevious),
    );
  }

  void goPreviousChapter(BuildContext context, WidgetRef ref) {
    var provider = bookNotifierProvider;
    var notifier = ref.read(provider.notifier);
    notifier.previousChapter();
  }
}

class _NextChapterButton extends ConsumerWidget {
  const _NextChapterButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IconButton(
      onPressed: () => goNextChapter(context, ref),
      icon: const Icon(HugeIcons.strokeRoundedNext),
    );
  }

  void goNextChapter(BuildContext context, WidgetRef ref) {
    var provider = bookNotifierProvider;
    var notifier = ref.read(provider.notifier);
    notifier.nextChapter();
  }
}

class _FloatingButton extends StatelessWidget {
  const _FloatingButton({super.key});

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

class _MenuButton extends ConsumerWidget {
  const _MenuButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MenuAnchor(
      menuChildren: [
        MenuItemButton(
          leadingIcon: const Icon(HugeIcons.strokeRoundedBook01),
          onPressed: () => navigateBookInformation(context),
          child: const Text('书籍信息'),
        ),
        MenuItemButton(
          leadingIcon: const Icon(HugeIcons.strokeRoundedMenu01),
          onPressed: () => navigateBookCatalogue(context, ref),
          child: const Text('章节目录'),
        ),
        MenuItemButton(
          leadingIcon: const Icon(HugeIcons.strokeRoundedTextFont),
          onPressed: () => navigateReaderTheme(context),
          child: const Text('阅读主题'),
        ),
      ],
      builder: (_, controller, __) => IconButton(
        onPressed: () => handleTap(controller),
        icon: const Icon(HugeIcons.strokeRoundedMoreVertical),
      ),
    );
  }

  void handleTap(MenuController controller) {
    controller.open();
  }

  void navigateBookCatalogue(BuildContext context, WidgetRef ref) {
    var provider = bookNotifierProvider;
    var book = ref.read(provider);
    AutoRouter.of(context).push(CatalogueRoute(index: book.index));
  }

  void navigateBookInformation(BuildContext context) {
    AutoRouter.of(context).push(InformationRoute());
  }

  void navigateReaderTheme(BuildContext context) {
    AutoRouter.of(context).push(ReaderThemeRoute());
  }
}
