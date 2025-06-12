import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:signals/signals_flutter.dart';
import 'package:source_parser/model/source_entity.dart';
import 'package:source_parser/page/source_page/source_view_model.dart';

@RoutePage()
class SourcePage extends StatefulWidget {
  const SourcePage({super.key});

  @override
  State<SourcePage> createState() => _SourcePageState();
}

class _SourcePageState extends State<SourcePage> {
  final viewModel = GetIt.instance.get<SourceViewModel>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () => viewModel.openSourceBottomSheet(context),
            icon: const Icon(HugeIcons.strokeRoundedMoreVertical),
          )
        ],
        title: const Text('书源管理'),
      ),
      body: Watch((_) {
        if (viewModel.sources.value.isEmpty) {
          return const Center(child: Text('空空如也'));
        }
        return ListView.builder(
          itemCount: viewModel.sources.value.length,
          itemBuilder: (context, index) {
            return _SourceTile(
              key: ValueKey('source-$index'),
              source: viewModel.sources.value[index],
              onTap: (id) => viewModel.editSource(context, id),
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => viewModel.createSource(context),
        child: const Icon(HugeIcons.strokeRoundedAdd01),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    viewModel.initSignals();
  }
}

class _SourceTile extends StatelessWidget {
  final SourceEntity source;

  final void Function(int)? onTap;
  const _SourceTile({super.key, required this.source, this.onTap});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var colorScheme = theme.colorScheme;
    var secondaryContainer = colorScheme.secondaryContainer;
    var circleAvatar = CircleAvatar(
      backgroundColor: source.enabled ? null : secondaryContainer,
      child: Text(source.name.substring(0, 1)),
    );
    return ListTile(
      leading: circleAvatar,
      onTap: handleTap,
      title: Text(source.name),
      subtitle: Text(source.url),
    );
  }

  void handleTap() {
    onTap?.call(source.id);
  }
}
