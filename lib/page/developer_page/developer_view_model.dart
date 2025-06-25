import 'package:flutter/material.dart';
import 'package:openai_dart/openai_dart.dart';
import 'package:signals/signals.dart';
import 'package:signals/signals_flutter.dart' hide signal;
import 'package:source_parser/config/config.dart';
import 'package:source_parser/database/book_service.dart';
import 'package:source_parser/database/service.dart';
import 'package:source_parser/page/developer_page/analysis_bottom_sheet.dart';
import 'package:source_parser/page/theme/color_picker.dart';
import 'package:source_parser/router/router.gr.dart';
import 'package:source_parser/util/message.dart';
import 'package:source_parser/util/shared_preference_util.dart';

class DeveloperViewModel {
  final enableDeveloperMode = signal(true);
  final analyzing = signal(false);
  final analysis = signal('');
  final analyzed = signal(false);

  Future<void> analyze(BuildContext context) async {
    var sheet = Watch(
      (_) => AnalysisBottomSheet(
        content: analysis.value,
        loading: analyzing.value,
      ),
    );
    showModalBottomSheet(
      builder: (_) => sheet,
      context: context,
      showDragHandle: true,
    );
    if (analyzed.value) return;
    analyzing.value = true;
    var books = await BookService().getBooks();
    var content = books.map((book) => book.toJson()).toList();
    try {
      var prompt = '根据我网文书架的内容，分析我的读书喜好并生成报告。下面是我的书架数据：{content}';
      var client = OpenAIClient(apiKey: Config.apiKey, baseUrl: Config.baseUrl);
      var message = ChatCompletionMessage.user(
        content: ChatCompletionUserMessageContent.string(
          prompt.replaceAll('{content}', content.toString()),
        ),
      );
      var request = CreateChatCompletionRequest(
        model: ChatCompletionModel.modelId(Config.model),
        messages: [message],
      );
      var response = await client.createChatCompletion(request: request);
      analyzing.value = false;
      analysis.value = response.choices.first.message.content ?? '';
      analyzed.value = true;
    } catch (e) {
      analyzing.value = false;
      analysis.value = e.toString();
    }
  }

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

  void navigateCloudReaderPage(BuildContext context) {
    CloudReaderRoute().push(context);
  }

  void navigateColor(BuildContext context) {
    ColorPicker.pick(context);
  }

  void navigateDatabasePage(BuildContext context) {
    DatabaseRoute().push(context);
  }

  void navigateFileManagerPage(BuildContext context) {
    FileManagerRoute().push(context);
  }

  void navigateSimpleCloudReaderPage(BuildContext context) {
    SimpleCloudReaderRoute().push(context);
  }
}
