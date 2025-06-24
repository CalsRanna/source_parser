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
}
