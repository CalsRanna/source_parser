import 'package:flutter/material.dart';
import 'package:signals/signals.dart';
import 'package:source_parser/database/service.dart';
import 'package:source_parser/page/theme/color_picker.dart';
import 'package:source_parser/router/router.gr.dart';
import 'package:source_parser/util/message.dart';
import 'package:source_parser/util/shared_preference_util.dart';

class DeveloperViewModel {
  final enableDeveloperMode = signal(true);

  Future<void> cleanDatabase(BuildContext context) async {
    var laconic = DatabaseService.instance.laconic;
    await laconic.table('book_sources').where('id', 0).delete();
    await laconic.table('books').where('id', 0).delete();
    // await laconic.table('books').where('source_id', 0).delete();
    await laconic.table('chapters').where('id', 0).delete();
    await laconic.table('chapters').where('book_id', 0).delete();
    await laconic.table('covers').where('id', 0).delete();
    await laconic.table('covers').where('book_id', 0).delete();
    await laconic.table('available_sources').where('id', 0).delete();
    await laconic.table('available_sources').where('book_id', 0).delete();
    await laconic.table('available_sources').where('source_id', 0).delete();
    if (!context.mounted) return;
    Message.of(context).show('数据库清理完成');
  }

  void disableDeveloperMode(BuildContext context) {
    enableDeveloperMode.value = false;
    SharedPreferenceUtil.setDeveloperMode(false);
    Navigator.of(context).pop(false);
  }

  void navigateDatabasePage(BuildContext context) {
    DatabaseRoute().push(context);
  }

  void navigateCloudReaderPage(BuildContext context) {
    CloudReaderRoute().push(context);
  }

  void navigateColor(BuildContext context) {
    ColorPicker.pick(context);
  }

  void navigateFileManagerPage(BuildContext context) {
    FileManagerRoute().push(context);
  }

  void navigateSimpleCloudReaderPage(BuildContext context) {
    SimpleCloudReaderRoute().push(context);
  }
}
