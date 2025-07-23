import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:signals/signals.dart';
import 'package:source_parser/database/source_service.dart';
import 'package:source_parser/model/source_entity.dart';
import 'package:source_parser/page/source_page/source_bottom_sheet.dart';
import 'package:source_parser/page/source_page/source_import_alert_dialog.dart';
import 'package:source_parser/page/source_page/source_import_bottom_sheet.dart';
import 'package:source_parser/page/source_page/source_import_loading_dialog.dart';
import 'package:source_parser/page/source_page/source_validate_dialog.dart';
import 'package:source_parser/router/router.gr.dart';
import 'package:source_parser/util/dialog_util.dart';
import 'package:source_parser/util/parser.dart';

class SourceViewModel {
  final sources = signal(<SourceEntity>[]);
  final newSources = signal(<SourceEntity>[]);
  final oldSources = signal(<SourceEntity>[]);

  void createSource(BuildContext context) {
    SourceFormRoute().push(context);
  }

  void editSource(BuildContext context, SourceEntity source) async {
    SourceFormRoute(source: source).push(context);
  }

  Future<void> initSignals() async {
    sources.value = await SourceService().getAllSources();
    sources.value.sort((a, b) {
      final weightA = a.enabled ? -9999 : 9999;
      final weightB = b.enabled ? -9999 : 9999;
      return weightA.compareTo(weightB);
    });
  }

  void openSourceBottomSheet(BuildContext context) async {
    var sourceBottomSheet = SourceBottomSheet(
      onImportNetworkSource: () => _importNetworkSource(context),
      onImportLocalSource: () => _importLocalSource(context),
      onExportSource: () => _exportSource(context),
      onValidateSources: () => _validateSources(context),
    );
    showModalBottomSheet(
      showDragHandle: true,
      builder: (_) => sourceBottomSheet,
      context: context,
    );
  }

  void _exportSource(BuildContext context) async {
    Navigator.of(context).pop();
    final json = sources.value.map((source) {
      final string = source.toJson();
      string.remove('id');
      return string;
    }).toList();
    final directory = await getApplicationDocumentsDirectory();
    final filePath = join(directory.path, 'sources.json');
    await File(filePath).writeAsString(jsonEncode(json));
    if (Platform.isMacOS || Platform.isWindows || Platform.isLinux) {
      final bytes = await File(filePath).readAsBytes();
      final output = await FilePicker.platform.saveFile(
        dialogTitle: '导出书源',
        fileName: 'sources.json',
      );
      if (output == null) return;
      File(output).writeAsBytes(bytes);
    } else {
      Share.shareXFiles([XFile(filePath)], subject: 'sources.json');
    }
  }

  void _getSourceContent(
    BuildContext context,
    String value, {
    String from = 'local',
  }) async {
    final router = Navigator.of(context);
    if (from == 'network') {
      router.pop();
    }
    showDialog(
      barrierDismissible: false,
      builder: (context) => SourceImportLoadingDialog(),
      context: context,
    );

    try {
      final timeout = Duration(milliseconds: 30000);
      List<SourceEntity> sources = [];
      if (from == 'network') {
        sources = await Parser.importNetworkSource(value, timeout);
      } else {
        sources = await Parser.importLocalSource(value);
      }
      List<SourceEntity> newSources = [];
      List<SourceEntity> oldSources = [];
      for (var source in sources) {
        if (sources.where((element) {
          final hasSameName = element.name == source.name;
          final hasSameUrl = element.url == source.url;
          return hasSameName && hasSameUrl;
        }).isNotEmpty) {
          oldSources.add(source);
        } else {
          newSources.add(source);
        }
      }
      this.newSources.value = newSources;
      this.oldSources.value = oldSources;
      router.pop();
      if (oldSources.isNotEmpty) {
        var sourceImportAlertDialog = SourceImportAlertDialog(
          message: '发现${oldSources.length}个同名书源书源',
          onConfirm: (override) async {
            final router = Navigator.of(context);
            await _importSources(override);
            router.pop();
          },
        );
        if (!context.mounted) return;
        showDialog(
          builder: (_) => sourceImportAlertDialog,
          context: context,
        );
      } else {
        await _importSources(false);
      }
    } catch (error) {
      router.pop();
      DialogUtil.snackBar(error.toString());
    }
  }

  void _importLocalSource(BuildContext context) async {
    final result = await FilePicker.platform.pickFiles();
    if (result != null) {
      final file = File(result.files.single.path!);
      final content = await file.readAsString();
      if (!context.mounted) return;
      _getSourceContent(context, content, from: 'local');
    }
    if (!context.mounted) return;
    Navigator.of(context).pop();
  }

  void _importNetworkSource(BuildContext context) async {
    Navigator.of(context).pop();
    var sourceImportBottomSheet = SourceImportBottomSheet(
      onConfirm: (value) => _getSourceContent(context, value, from: 'network'),
    );
    showModalBottomSheet(
      showDragHandle: true,
      builder: (_) => sourceImportBottomSheet,
      context: context,
    );
    // router.pop();
  }

  Future<void> _importSources(bool override) async {
    if (override) {
      for (var oldSource in oldSources.value) {
        var source = await SourceService()
            .getSourceByNameAndUrl(oldSource.name, oldSource.url);
        await SourceService().updateSource(oldSource.copyWith(id: source.id));
      }
    }
    await SourceService().addSources(newSources.value);
    initSignals();
  }

  Future<Stream<int>> _validate() async {
    final controller = StreamController<int>();
    var service = SourceService();
    for (var source in sources.value) {
      await service.updateSource(source.copyWith(enabled: false));
    }
    final duration = Duration(seconds: 1200);
    final timeout = Duration(milliseconds: 30000);
    final stream = await Parser.validate('都市', 16, duration, timeout);
    List<int> valid = [];
    stream.listen(
      (id) {
        if (valid.contains(id)) return;
        valid.add(id);
        controller.add(id);
        final source = sources.value.where((element) => element.id == id).first;
        service.updateSource(source.copyWith(enabled: true));
      },
      onDone: () => controller.close(),
      onError: (_) => controller.close(),
    );
    return controller.stream;
  }

  void _validateSources(BuildContext context) async {
    Navigator.of(context).pop();
    showDialog(
      barrierDismissible: false,
      builder: (context) => SourceValidateDialog(),
      context: context,
    );
    final stream = await _validate();
    stream.listen(
      (event) {
        if (!context.mounted) return;
      },
      onDone: () {
        if (!context.mounted) return;
        Navigator.of(context).pop();
        initSignals();
      },
    );
  }
}
