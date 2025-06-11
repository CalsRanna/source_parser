import 'package:auto_route/auto_route.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:signals/signals_flutter.dart';
import 'package:source_parser/model/information_entity.dart';
import 'package:source_parser/page/information/information_archive_view.dart';
import 'package:source_parser/page/information/information_available_source_view.dart';
import 'package:source_parser/page/information/information_bottom_view.dart';
import 'package:source_parser/page/information/information_catalogue_view.dart';
import 'package:source_parser/page/information/information_description_view.dart';
import 'package:source_parser/page/information/information_meta_data_view.dart';
import 'package:source_parser/page/information/information_view_model.dart';

@RoutePage()
class InformationPage extends ConsumerStatefulWidget {
  final InformationEntity information;
  const InformationPage({super.key, required this.information});

  @override
  ConsumerState<InformationPage> createState() => _InformationPageState();
}

class _InformationPageState extends ConsumerState<InformationPage> {
  late final viewModel = GetIt.instance<InformationViewModel>(
    param1: widget.information,
  );

  @override
  Widget build(BuildContext context) {
    var body = EasyRefresh(
      // onRefresh: () => getInformation(ref),
      child: CustomScrollView(slivers: [_buildAppBar(), _buildList(context)]),
    );
    var bottomNavigationBar = Watch(
      (_) => InformationBottomView(
        book: viewModel.book.value,
        isInShelf: viewModel.isInShelf.value,
        onIsInShelfChanged: () => viewModel.changeIsInShelf(
          viewModel.book.value,
        ),
        onReaderOpened: () => viewModel.navigateReaderPage(
          context,
          viewModel.book.value,
        ),
      ),
    );
    return Scaffold(body: body, bottomNavigationBar: bottomNavigationBar);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      viewModel.initSignals();
    });
  }

  SliverAppBar _buildAppBar() {
    var metaView = Watch(
      (_) => InformationMetaDataView(book: viewModel.book.value),
    );
    var flexibleSpaceBar = FlexibleSpaceBar(
      background: metaView,
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
    var introduction = Watch(
      (_) => InformationDescriptionView(book: viewModel.book.value),
    );
    var catalogue = Watch(
      (_) => InformationCatalogueView(
        book: viewModel.book.value,
        chapters: viewModel.chapters.value,
        loading: viewModel.isLoading.value,
        onTap: () => viewModel.navigateCataloguePage(context),
      ),
    );
    var availableSource = Watch(
      (_) => InformationAvailableSourceView(
        availableSources: viewModel.availableSources.value,
        source: viewModel.source.value,
        onTap: () => viewModel.navigateAvailableSourcePage(context),
      ),
    );
    var archive = Watch(
      (_) => InformationArchiveView(
        isArchive: viewModel.book.value.archive,
        onTap: viewModel.toggleArchive,
      ),
    );
    var children = [
      introduction,
      const SizedBox(height: 8),
      catalogue,
      const SizedBox(height: 8),
      availableSource,
      const SizedBox(height: 8),
      archive
    ];
    return SliverList(delegate: SliverChildListDelegate(children));
  }
}
