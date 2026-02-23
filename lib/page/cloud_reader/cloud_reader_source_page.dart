import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:signals/signals_flutter.dart';
import 'package:source_parser/model/cloud_search_book_entity.dart';
import 'package:source_parser/page/cloud_reader/cloud_reader_source_view_model.dart';
import 'package:source_parser/util/dialog_util.dart';

@RoutePage()
class CloudReaderSourcePage extends StatefulWidget {
  final String bookUrl;
  final String currentOrigin;

  const CloudReaderSourcePage({
    super.key,
    required this.bookUrl,
    required this.currentOrigin,
  });

  @override
  State<CloudReaderSourcePage> createState() => _CloudReaderSourcePageState();
}

class _CloudReaderSourcePageState extends State<CloudReaderSourcePage> {
  final viewModel = GetIt.instance.get<CloudReaderSourceViewModel>();

  @override
  void initState() {
    super.initState();
    viewModel.searchSources(widget.bookUrl);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('换源'),
        actions: [
          Watch((context) {
            if (viewModel.isSearching.value &&
                viewModel.sources.value.isNotEmpty) {
              return const Padding(
                padding: EdgeInsets.all(12),
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              );
            }
            if (viewModel.isLoadingMore.value) {
              return const Padding(
                padding: EdgeInsets.all(12),
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              );
            }
            if (!viewModel.hasMore.value) return const SizedBox.shrink();
            return IconButton(
              icon: const Icon(HugeIcons.strokeRoundedArrowDown01),
              onPressed: () => viewModel.loadMore(widget.bookUrl),
            );
          }),
        ],
      ),
      body: Watch((context) {
        if (viewModel.isSearching.value && viewModel.sources.value.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }
        if (viewModel.sources.value.isEmpty) {
          return const Center(child: Text('没有找到可用的书源'));
        }
        return ListView.builder(
          itemBuilder: (context, index) => _buildSourceTile(context, index),
          itemCount: viewModel.sources.value.length,
        );
      }),
    );
  }

  Widget _buildSourceTile(BuildContext context, int index) {
    var source = viewModel.sources.value[index];
    var isActive = source.origin == widget.currentOrigin;
    var activeColor = Theme.of(context).colorScheme.primary;
    return ListTile(
      title: Text(
        source.originName,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: isActive ? TextStyle(color: activeColor) : null,
      ),
      subtitle: Text(
        source.latestChapterTitle,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: isActive ? TextStyle(color: activeColor) : null,
      ),
      trailing: isActive ? Icon(HugeIcons.strokeRoundedTick02, color: activeColor) : null,
      onTap: () => _switchSource(source),
    );
  }

  void _switchSource(CloudSearchBookEntity source) async {
    DialogUtil.loading();
    var success = await viewModel.switchSource(widget.bookUrl, source);
    DialogUtil.dismiss();
    if (!mounted) return;
    if (success) {
      Navigator.pop(context, source.bookUrl);
    } else {
      DialogUtil.snackBar('换源失败');
    }
  }
}
