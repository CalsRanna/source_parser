import 'package:auto_route/auto_route.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:signals/signals_flutter.dart';
import 'package:source_parser/model/book_information_wrapper_entity.dart';
import 'package:source_parser/page/information/information_archive_view.dart';
import 'package:source_parser/page/information/information_available_source_view.dart';
import 'package:source_parser/page/information/information_bottom_view.dart';
import 'package:source_parser/page/information/information_catalogue_view.dart';
import 'package:source_parser/page/information/information_description_view.dart';
import 'package:source_parser/page/information/information_meta_data_view.dart';
import 'package:source_parser/page/information/information_view_model.dart';
import 'package:source_parser/provider/book.dart';
import 'package:source_parser/util/message.dart';

@RoutePage()
class InformationPage extends ConsumerStatefulWidget {
  final BookInformationWrapperEntity information;
  const InformationPage({super.key, required this.information});

  @override
  ConsumerState<InformationPage> createState() => _InformationPageState();
}

class _InformationPageState extends ConsumerState<InformationPage> {
  bool loading = false;

  late final viewModel = GetIt.instance<InformationViewModel>(
    param1: widget.information,
  );

  @override
  Widget build(BuildContext context) {
    var body = EasyRefresh(
      onRefresh: () => getInformation(ref),
      child: CustomScrollView(slivers: [_buildAppBar(), _buildList(context)]),
    );
    var bottomNavigationBar = Watch(
      (_) => InformationBottomView(
        book: widget.information.book,
        isInShelf: viewModel.isInShelf.value,
        onIsInShelfChanged: () => viewModel.changeIsInShelf(
          widget.information.book,
        ),
        onReaderOpened: () => viewModel.navigateReaderPage(
          context,
          widget.information.book,
        ),
      ),
    );
    return Scaffold(body: body, bottomNavigationBar: bottomNavigationBar);
  }

  Future<void> getInformation(WidgetRef ref) async {
    final message = Message.of(context);
    setState(() {
      loading = true;
    });
    try {
      final notifier = ref.read(bookNotifierProvider.notifier);
      await notifier.refreshInformation();
      setState(() {
        loading = false;
      });
    } catch (error) {
      message.show(error.toString());
      setState(() {
        loading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getInformation(ref);
    viewModel.initSignals();
  }

  SliverAppBar _buildAppBar() {
    var flexibleSpaceBar = FlexibleSpaceBar(
      background: InformationMetaDataView(book: widget.information.book),
      collapseMode: CollapseMode.pin,
    );
    return SliverAppBar(
      expandedHeight: 200,
      flexibleSpace: flexibleSpaceBar,
      pinned: true,
      stretch: true,
    );
  }

  SliverList _buildList(BuildContext context) {
    var catalogue = Watch(
      (_) => InformationCatalogueView(
        book: widget.information.book,
        chapters: viewModel.chapters.value,
        loading: loading,
        onTap: () => viewModel.navigateCataloguePage(context),
      ),
    );
    var availableSource = Watch(
      (_) => InformationAvailableSourceView(
        availableSources: viewModel.availableSources.value,
        currentSource: viewModel.currentSource.value,
        onTap: () => viewModel.navigateAvailableSourcePage(context),
      ),
    );
    var children = [
      InformationDescriptionView(book: widget.information.book),
      const SizedBox(height: 8),
      catalogue,
      const SizedBox(height: 8),
      availableSource,
      const SizedBox(height: 8),
      InformationArchiveView(isArchive: widget.information.book.archive),
    ];
    return SliverList(delegate: SliverChildListDelegate(children));
  }
}
