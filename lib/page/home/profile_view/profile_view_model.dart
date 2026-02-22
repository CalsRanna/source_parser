import 'package:flutter/material.dart';
import 'package:openai_dart/openai_dart.dart';
import 'package:signals/signals.dart';
import 'package:signals/signals_flutter.dart' hide signal;
import 'package:source_parser/config/config.dart';
import 'package:source_parser/config/string_config.dart';
import 'package:source_parser/database/book_service.dart';
import 'package:source_parser/page/developer_page/analysis_bottom_sheet.dart';
import 'package:source_parser/router/router.gr.dart';
import 'package:source_parser/util/shared_preference_util.dart';

class ProfileViewModel {
  final enableDeveloperMode = signal(false);
  final analyzing = signal(false);
  final analysis = signal('');
  final analyzed = signal(false);

  Future<void> initSignals() async {
    enableDeveloperMode.value = await SharedPreferenceUtil.getDeveloperMode();
  }

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
      var prompt = StringConfig.aiAnalyzePrompt;
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

  Future<void> navigateAboutPage(BuildContext context) async {
    var developerModel = await AboutRoute().push<bool>(context);
    if (developerModel == true) {
      enableDeveloperMode.value = true;
      await SharedPreferenceUtil.setDeveloperMode(true);
    }
  }

  Future<void> navigateDeveloperPage(BuildContext context) async {
    var developerModel = await DeveloperRoute().push<bool>(context);
    if (developerModel == false) {
      enableDeveloperMode.value = false;
      await SharedPreferenceUtil.setDeveloperMode(false);
    }
  }
}
