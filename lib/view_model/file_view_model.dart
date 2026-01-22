import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:signals/signals_flutter.dart';

class FileViewModel {
  final selectedFilePath = signal<String?>(null);

  FileViewModel();

  Future<String?> pickFile({
    List<String>? allowedExtensions,
    bool allowMultiple = false,
  }) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: allowedExtensions,
        allowMultiple: allowMultiple,
      );
      selectedFilePath.value = result?.files.firstOrNull?.path;
      return selectedFilePath.value;
    } catch (e) {
      return null;
    }
  }

  Future<String?> saveFile({
    required String content,
    required String fileName,
    String? directory,
  }) async {
    try {
      final appDirectory = directory != null
          ? Directory(directory)
          : await getApplicationSupportDirectory();
      final file = File('${appDirectory.path}/$fileName');
      await file.writeAsString(content);
      return file.path;
    } catch (e) {
      return null;
    }
  }
}
