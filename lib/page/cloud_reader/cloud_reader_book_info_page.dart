import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:source_parser/component/information_list_view.dart';
import 'package:source_parser/model/cloud_search_book_entity.dart';
import 'package:source_parser/page/cloud_reader/cloud_reader_search_view_model.dart';
import 'package:source_parser/service/cloud_reader_api_client.dart';
import 'package:source_parser/util/dialog_util.dart';
import 'package:get_it/get_it.dart';

@RoutePage()
class CloudReaderBookInfoPage extends StatelessWidget {
  final CloudSearchBookEntity book;

  const CloudReaderBookInfoPage({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    var children = <Widget>[];
    if (book.latestChapterTitle.isNotEmpty) {
      children.add(ListTile(
        leading: const Icon(HugeIcons.strokeRoundedBook02),
        title: const Text('最新章节'),
        subtitle: Text(
          book.latestChapterTitle,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ));
    }
    if (book.wordCount.isNotEmpty) {
      children.add(ListTile(
        leading: const Icon(HugeIcons.strokeRoundedTextFont),
        title: const Text('字数'),
        subtitle: Text(book.wordCount),
      ));
    }
    if (book.originName.isNotEmpty) {
      children.add(ListTile(
        leading: const Icon(HugeIcons.strokeRoundedLink01),
        title: const Text('来源'),
        subtitle: Text(book.originName),
      ));
    }
    return InformationListView(
      name: book.name,
      author: book.author,
      cover: CloudReaderApiClient().getCoverUrl(book.coverUrl),
      category: book.kind,
      introduction: book.intro,
      bottomBar: _buildBottomBar(context),
      children: children,
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: FilledButton.icon(
          onPressed: () => _addToShelf(context),
          icon: const Icon(HugeIcons.strokeRoundedAdd01),
          label: const Text('加入书架'),
        ),
      ),
    );
  }

  void _addToShelf(BuildContext context) async {
    var viewModel = GetIt.instance.get<CloudReaderSearchViewModel>();
    var success = await viewModel.addToShelf(book);
    if (!context.mounted) return;
    if (success) {
      DialogUtil.snackBar('已加入书架');
      Navigator.pop(context, true);
    } else {
      DialogUtil.snackBar('加入书架失败');
    }
  }
}
