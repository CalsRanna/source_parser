import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:source_parser/provider/book.dart';
import 'package:source_parser/provider/setting.dart';
import 'package:source_parser/router/router.gr.dart';
import 'package:source_parser/util/message.dart';

class ReaderOverlay extends ConsumerWidget {
  final void Function(int)? onCached;
  final void Function()? onRemoved;
  const ReaderOverlay({super.key, this.onCached, this.onRemoved});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var provider = settingNotifierProvider;
    var setting = ref.watch(provider).valueOrNull;
    var darkMode = setting?.darkMode ?? false;
    var cacheButton = IconButton(
      onPressed: () => openBottomSheet(context),
      icon: const Icon(HugeIcons.strokeRoundedDownload04),
    );
    var informationButton = IconButton(
      onPressed: () => navigateBookInformation(context),
      icon: const Icon(HugeIcons.strokeRoundedBook01),
    );
    var catalogueButton = IconButton(
      onPressed: () => navigateBookCatalogue(context),
      icon: const Icon(HugeIcons.strokeRoundedMenu01),
    );
    var sourceButton = IconButton(
      onPressed: () => navigateSourceSwitcher(context),
      icon: const Icon(HugeIcons.strokeRoundedExchange01),
    );
    var modeIcon = HugeIcons.strokeRoundedMoon02;
    if (darkMode) modeIcon = HugeIcons.strokeRoundedSun03;
    var modeButton = IconButton(
      onPressed: () => toggleDarkMode(ref),
      icon: Icon(modeIcon),
    );
    var themeButton = IconButton(
      onPressed: () => navigateReaderTheme(context),
      icon: const Icon(HugeIcons.strokeRoundedTextFont),
    );
    var children = [
      catalogueButton,
      sourceButton,
      modeButton,
      themeButton,
    ];
    var actionButton = FloatingActionButton(
      onPressed: () => navigateBookListener(context),
      child: const Icon(HugeIcons.strokeRoundedHeadphones),
    );
    var body = GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onRemoved,
      child: SizedBox(height: double.infinity, width: double.infinity),
    );
    return Scaffold(
      appBar: AppBar(actions: [cacheButton, informationButton]),
      backgroundColor: Colors.transparent,
      body: body,
      bottomNavigationBar: BottomAppBar(child: Row(children: children)),
      floatingActionButton: actionButton,
      floatingActionButtonLocation: FloatingActionButtonLocation.endContained,
    );
  }

  void navigateBookCatalogue(BuildContext context) {
    var container = ProviderScope.containerOf(context);
    var provider = bookNotifierProvider;
    var book = container.read(provider);
    AutoRouter.of(context).push(CatalogueRoute(index: book.index));
  }

  void navigateBookInformation(BuildContext context) {
    AutoRouter.of(context).push(InformationRoute());
  }

  void navigateBookListener(BuildContext context) {
    Message.of(context).show('开发中，但很有可能会移除该功能');
  }

  void navigateReaderTheme(BuildContext context) {
    AutoRouter.of(context).push(ReaderThemeRoute());
  }

  void navigateSourceSwitcher(BuildContext context) {
    AutoRouter.of(context).push(AvailableSourceListRoute());
  }

  void openBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => _CacheSheet(onCached: onCached),
      showDragHandle: true,
    );
  }

  void toggleDarkMode(WidgetRef ref) {
    var provider = settingNotifierProvider;
    var notifier = ref.read(provider.notifier);
    notifier.toggleDarkMode();
  }
}

class _CacheSheet extends StatelessWidget {
  final void Function(int)? onCached;
  const _CacheSheet({this.onCached});

  @override
  Widget build(BuildContext context) {
    var edgeInsets = MediaQuery.paddingOf(context);
    var children = [
      TextButton(onPressed: () => handleTap(context, 50), child: Text('50章')),
      TextButton(onPressed: () => handleTap(context, 100), child: Text('100章')),
      TextButton(onPressed: () => handleTap(context, 200), child: Text('200章')),
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
    Navigator.pop(context);
    onCached?.call(count);
  }
}
