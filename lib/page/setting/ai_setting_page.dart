import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:source_parser/config/config.dart';
import 'package:source_parser/util/shared_preference_util.dart';

@RoutePage()
class AiSettingPage extends StatefulWidget {
  const AiSettingPage({super.key});

  @override
  State<AiSettingPage> createState() => _AiSettingPageState();
}

class _AiSettingPageState extends State<AiSettingPage> {
  final baseUrlController = TextEditingController();
  final apiKeyController = TextEditingController();
  final modelController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadConfig();
  }

  Future<void> _loadConfig() async {
    baseUrlController.text = await SharedPreferenceUtil.getAiBaseUrl();
    apiKeyController.text = await SharedPreferenceUtil.getAiApiKey();
    modelController.text = await SharedPreferenceUtil.getAiModel();
  }

  @override
  void dispose() {
    baseUrlController.dispose();
    apiKeyController.dispose();
    modelController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AI 设置')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            controller: baseUrlController,
            decoration: const InputDecoration(
              labelText: 'Base URL',
              hintText: 'https://openrouter.ai/api/v1',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: apiKeyController,
            decoration: const InputDecoration(
              labelText: 'API Key',
              border: OutlineInputBorder(),
            ),
            obscureText: true,
          ),
          const SizedBox(height: 16),
          TextField(
            controller: modelController,
            decoration: const InputDecoration(
              labelText: 'Model',
              hintText: 'google/gemini-2.5-pro',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: _save,
            child: const Text('保存'),
          ),
        ],
      ),
    );
  }

  Future<void> _save() async {
    await SharedPreferenceUtil.setAiBaseUrl(baseUrlController.text);
    await SharedPreferenceUtil.setAiApiKey(apiKeyController.text);
    await SharedPreferenceUtil.setAiModel(modelController.text);
    Config.baseUrl = baseUrlController.text;
    Config.apiKey = apiKeyController.text;
    Config.model = modelController.text;
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Text('保存成功'),
        duration: Duration(seconds: 1),
      ),
    );
  }
}
