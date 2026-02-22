import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:signals/signals_flutter.dart';
import 'package:source_parser/component/information_list_view.dart';
import 'package:source_parser/model/information_entity.dart';
import 'package:source_parser/page/information/information_archive_view.dart';
import 'package:source_parser/page/information/information_available_source_view.dart';
import 'package:source_parser/page/information/information_bottom_view.dart';
import 'package:source_parser/page/information/information_catalogue_view.dart';
import 'package:source_parser/page/information/information_view_model.dart';
import 'package:source_parser/router/router.gr.dart';

@RoutePage()
class InformationPage extends StatefulWidget {
  final InformationEntity information;
  const InformationPage({super.key, required this.information});

  @override
  State<InformationPage> createState() => _InformationPageState();
}

class _InformationPageState extends State<InformationPage> {
  late final viewModel = GetIt.instance<InformationViewModel>(
    param1: widget.information,
  );

  @override
  Widget build(BuildContext context) {
    return Watch((_) {
      var book = viewModel.book.value;
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
      var bottomBar = Watch(
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
      return InformationListView(
        name: book.name,
        author: book.author,
        cover: book.cover,
        category: book.category,
        status: book.status,
        onAuthorTap: () => SearchRoute(credential: book.author).push(context),
        onCoverLongPress: () {
          HapticFeedback.heavyImpact();
          CoverSelectorRoute(book: book).push(context);
        },
        introduction: book.introduction,
        bottomBar: bottomBar,
        children: [catalogue, availableSource, archive],
      );
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      viewModel.initSignals(widget.information);
    });
  }
}
