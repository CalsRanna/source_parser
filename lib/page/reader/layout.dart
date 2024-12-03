import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:source_parser/provider/layout.dart';
import 'package:source_parser/schema/layout.dart';

@RoutePage()
class ReaderLayoutPage extends ConsumerWidget {
  const ReaderLayoutPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final layout = ref.watch(readerLayoutNotifierProviderProvider).valueOrNull;
    if (layout == null) return const Center(child: CircularProgressIndicator());

    return Scaffold(
      appBar: AppBar(title: const Text('布局')),
      body: ListView(
        children: [
          _ButtonSection(
            title: 'AppBar按钮 (最多2个)',
            buttons: layout.appBarButtons,
            onChanged: (buttons) {
              ref
                  .read(readerLayoutNotifierProviderProvider.notifier)
                  .updateAppBarButtons(buttons);
            },
          ),
          _ButtonSection(
            title: 'BottomBar按钮 (最多4个)',
            buttons: layout.bottomBarButtons,
            onChanged: (buttons) {
              ref
                  .read(readerLayoutNotifierProviderProvider.notifier)
                  .updateBottomBarButtons(buttons);
            },
          ),
        ],
      ),
    );
  }
}

class _ButtonSection extends StatelessWidget {
  final String title;
  final List<ButtonPosition> buttons;
  final ValueChanged<List<ButtonPosition>> onChanged;

  const _ButtonSection({
    required this.title,
    required this.buttons,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SwitchListTile(
          title: Text(title),
          onChanged: (value) {
            onChanged(value ? ButtonPosition.values : []);
          },
          value: buttons.isNotEmpty,
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Wrap(
            spacing: 16,
            runSpacing: 16,
            children: ButtonPosition.values.map((type) {
              final selected = buttons.contains(type);
              return FilterChip(
                showCheckmark: false,
                selected: selected,
                label: Text(_getButtonLabel(type)),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                avatar: Icon(_getButtonIcon(type)),
                onSelected: (value) {
                  var newButtons = List<ButtonPosition>.from(buttons);
                  if (value) {
                    if (!selected) newButtons.add(type);
                  } else {
                    newButtons.remove(type);
                  }
                  newButtons.sort((a, b) {
                    return ButtonPosition.values.indexOf(a).compareTo(
                          ButtonPosition.values.indexOf(b),
                        );
                  });
                  onChanged(newButtons);
                },
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  String _getButtonLabel(ButtonPosition type) {
    switch (type) {
      case ButtonPosition.cache:
        return '缓存';
      case ButtonPosition.darkMode:
        return '夜间模式';
      case ButtonPosition.menu:
        return '菜单';
      case ButtonPosition.catalogue:
        return '目录';
      case ButtonPosition.source:
        return '书源';
      case ButtonPosition.theme:
        return '主题';
      case ButtonPosition.audio:
        return '朗读';
      case ButtonPosition.previousChapter:
        return '上一章';
      case ButtonPosition.nextChapter:
        return '下一章';
    }
  }

  IconData _getButtonIcon(ButtonPosition type) {
    switch (type) {
      case ButtonPosition.cache:
        return HugeIcons.strokeRoundedDownload04;
      case ButtonPosition.darkMode:
        return HugeIcons.strokeRoundedMoon02;
      case ButtonPosition.menu:
        return HugeIcons.strokeRoundedMoreVertical;
      case ButtonPosition.catalogue:
        return HugeIcons.strokeRoundedMenu01;
      case ButtonPosition.source:
        return HugeIcons.strokeRoundedExchange01;
      case ButtonPosition.theme:
        return HugeIcons.strokeRoundedTextFont;
      case ButtonPosition.audio:
        return HugeIcons.strokeRoundedHeadphones;
      case ButtonPosition.previousChapter:
        return HugeIcons.strokeRoundedPrevious;
      case ButtonPosition.nextChapter:
        return HugeIcons.strokeRoundedNext;
    }
  }
}
