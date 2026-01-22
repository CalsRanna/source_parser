import 'package:flutter/material.dart';
import 'package:signals/signals.dart';
import 'package:source_parser/database/source_service.dart';
import 'package:source_parser/model/source_entity.dart';
import 'package:source_parser/router/router.gr.dart';
import 'package:source_parser/util/dialog_util.dart';

class SourceFormViewModel {
  final source = signal(SourceEntity());

  late final title = computed(() => source.value.id == 0 ? '新建书源' : '编辑书源');

  Future<void> destroySource(BuildContext context) async {
    var result = await DialogUtil.confirm('确认删除该书源？', title: '删除书源');
    if (result == true) {
      SourceService().destroySource(source.value.id);
    }
  }

  void initSignals(SourceEntity? source) {
    if (source == null) return;
    this.source.value = source;
  }

  void navigateSourceDetailAdvancedPage(BuildContext context) {
    SourceAdvancedConfigurationRoute().push(context);
  }

  void navigateSourceDetailCataloguePage(BuildContext context) {
    SourceCatalogueConfigurationRoute().push(context);
  }

  void navigateSourceDetailContentPage(BuildContext context) {
    SourceContentConfigurationRoute().push(context);
  }

  void navigateSourceDetailInformationPage(BuildContext context) {
    SourceInformationConfigurationRoute().push(context);
  }

  void navigateSourceDetailSearchPage(BuildContext context) {
    SourceSearchConfigurationRoute().push(context);
  }

  Future<void> storeSource() async {
    var service = SourceService();
    if (source.value.id == 0) {
      await service.addSources([source.value]);
      var updatedSource = await service.getSourceByNameAndUrl(
        source.value.name,
        source.value.url,
      );
      source.value = source.value.copyWith(id: updatedSource.id);
    } else {
      await service.updateSource(source.value);
    }
  }

  void updateExploreJson(String exploreJson) {
    source.value = source.value.copyWith(exploreJson: exploreJson);
  }

  void updateName(String name) {
    source.value = source.value.copyWith(name: name);
  }

  void updateUrl(String url) {
    source.value = source.value.copyWith(url: url);
  }

  void navigateSourceFormDebugPage(BuildContext context) {
    SourceFormDebugRoute(source: source.value).push(context);
  }

  void toggleEnabled() {
    source.value = source.value.copyWith(enabled: !source.value.enabled);
  }

  void toggleExploreEnabled() {
    source.value =
        source.value.copyWith(exploreEnabled: !source.value.exploreEnabled);
  }

  void updateComment(String comment) {
    source.value = source.value.copyWith(comment: comment);
  }

  void updateHeader(String header) {
    source.value = source.value.copyWith(header: header);
  }

  void updateCharset(String charset) {
    source.value = source.value.copyWith(charset: charset);
  }

  void updateSearchUrl(String value) {
    source.value = source.value.copyWith(searchUrl: value);
  }

  void updateSearchMethod(String value) {
    source.value = source.value.copyWith(searchMethod: value);
  }

  void updateSearchBooks(String value) {
    source.value = source.value.copyWith(searchBooks: value);
  }

  void updateSearchAuthor(String value) {
    source.value = source.value.copyWith(searchAuthor: value);
  }

  void updateSearchCategory(String value) {
    source.value = source.value.copyWith(searchCategory: value);
  }

  void updateSearchCover(String value) {
    source.value = source.value.copyWith(searchCover: value);
  }

  void updateSearchIntroduction(String value) {
    source.value = source.value.copyWith(searchIntroduction: value);
  }

  void updateSearchLatestChapter(String value) {
    source.value = source.value.copyWith(searchLatestChapter: value);
  }

  void updateSearchName(String value) {
    source.value = source.value.copyWith(searchName: value);
  }

  void updateSearchInformationUrl(String value) {
    source.value = source.value.copyWith(searchInformationUrl: value);
  }

  void updateSearchWordCount(String value) {
    source.value = source.value.copyWith(searchWordCount: value);
  }

  void updateInformationMethod(String value) {
    source.value = source.value.copyWith(informationMethod: value);
  }

  void updateInformationAuthor(String value) {
    source.value = source.value.copyWith(informationAuthor: value);
  }

  void updateInformationCatalogueUrl(String value) {
    source.value = source.value.copyWith(informationCatalogueUrl: value);
  }

  void updateInformationCategory(String value) {
    source.value = source.value.copyWith(informationCategory: value);
  }

  void updateInformationCover(String value) {
    source.value = source.value.copyWith(informationCover: value);
  }

  void updateInformationIntroduction(String value) {
    source.value = source.value.copyWith(informationIntroduction: value);
  }

  void updateInformationLatestChapter(String value) {
    source.value = source.value.copyWith(informationLatestChapter: value);
  }

  void updateInformationName(String value) {
    source.value = source.value.copyWith(informationName: value);
  }

  void updateInformationWordCount(String value) {
    source.value = source.value.copyWith(informationWordCount: value);
  }

  void updateContentMethod(String value) {
    source.value = source.value.copyWith(contentMethod: value);
  }

  void updateContentContent(String value) {
    source.value = source.value.copyWith(contentContent: value);
  }

  void updateContentPagination(String value) {
    source.value = source.value.copyWith(contentPagination: value);
  }

  void updateContentPaginationValidation(String value) {
    source.value = source.value.copyWith(contentPaginationValidation: value);
  }

  void updateCatalogueMethod(String value) {
    source.value = source.value.copyWith(catalogueMethod: value);
  }

  void updateCataloguePreset(String value) {
    source.value = source.value.copyWith(cataloguePreset: value);
  }

  void updateCatalogueChapters(String value) {
    source.value = source.value.copyWith(catalogueChapters: value);
  }

  void updateCatalogueName(String value) {
    source.value = source.value.copyWith(catalogueName: value);
  }

  void updateCatalogueUpdatedAt(String value) {
    source.value = source.value.copyWith(catalogueUpdatedAt: value);
  }

  void updateCatalogueUrl(String value) {
    source.value = source.value.copyWith(catalogueUrl: value);
  }

  void updateCataloguePagination(String value) {
    source.value = source.value.copyWith(cataloguePagination: value);
  }

  void updateCataloguePaginationValidation(String value) {
    source.value = source.value.copyWith(cataloguePaginationValidation: value);
  }
}
