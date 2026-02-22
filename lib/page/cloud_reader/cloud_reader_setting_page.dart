import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:signals/signals_flutter.dart';
import 'package:source_parser/page/cloud_reader/cloud_reader_setting_view_model.dart';

@RoutePage()
class CloudReaderSettingPage extends StatefulWidget {
  const CloudReaderSettingPage({super.key});

  @override
  State<CloudReaderSettingPage> createState() => _CloudReaderSettingPageState();
}

class _CloudReaderSettingPageState extends State<CloudReaderSettingPage> {
  final viewModel = GetIt.instance.get<CloudReaderSettingViewModel>();
  late final serverUrlController = TextEditingController();
  late final usernameController = TextEditingController();
  late final passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    viewModel.initSignals().then((_) {
      serverUrlController.text = viewModel.serverUrl.value;
      usernameController.text = viewModel.username.value;
      passwordController.text = viewModel.password.value;
    });
  }

  @override
  void dispose() {
    serverUrlController.dispose();
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('云阅读设置')),
      body: Watch((context) {
        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextField(
              controller: serverUrlController,
              decoration: const InputDecoration(
                labelText: '服务器地址',
                hintText: 'http://43.139.61.244:4396',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) => viewModel.serverUrl.value = value,
            ),
            const SizedBox(height: 16),
            FilledButton.tonal(
              onPressed: () {
                viewModel.saveServerUrl(serverUrlController.text);
                viewModel.testConnection();
              },
              child: viewModel.isTesting.value
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('测试连接'),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: usernameController,
              decoration: const InputDecoration(
                labelText: '用户名',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) => viewModel.username.value = value,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(
                labelText: '密码',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
              onChanged: (value) => viewModel.password.value = value,
            ),
            const SizedBox(height: 16),
            if (viewModel.isLoggedIn.value)
              FilledButton(
                onPressed: () => viewModel.logout(),
                child: const Text('登出'),
              )
            else
              FilledButton(
                onPressed: () => viewModel.login(),
                child: const Text('登录'),
              ),
            if (viewModel.message.value.isNotEmpty) ...[
              const SizedBox(height: 16),
              Text(
                viewModel.message.value,
                style: TextStyle(
                  color: viewModel.message.value.contains('成功')
                      ? Colors.green
                      : Colors.red,
                ),
              ),
            ],
          ],
        );
      }),
    );
  }
}
