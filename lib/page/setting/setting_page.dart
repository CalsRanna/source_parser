import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:signals/signals_flutter.dart';
import 'package:source_parser/page/setting/setting_view_model.dart';
import 'package:source_parser/router/router.gr.dart';

@RoutePage()
class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  final viewModel = GetIt.instance.get<SettingViewModel>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('设置')),
      body: Watch((_) => _buildBody()),
    );
  }

  @override
  void initState() {
    super.initState();
    viewModel.initSignals();
  }

  Widget _buildBody() {
    final children = [
      _buildTurningMode(),
      _buildSearchFilter(),
      _buildTimeout(),
      _buildMaxConcurrent(),
      _buildCacheDuration(),
      _buildEInkMode(),
      _buildClearCache(),
      const Divider(),
      _buildCloudReaderSetting(),
      _buildAiSetting(),
    ];
    return ListView(children: children);
  }

  Widget _buildCacheDuration() {
    return ListTile(
      onTap: () => viewModel.openCacheDurationBottomSheet(context),
      subtitle: const Text('网络请求缓存的有效时长，不影响缓存的封面和章节'),
      title: const Text('缓存时长'),
      trailing: Text('${viewModel.cacheDuration.value}小时'),
    );
  }

  Widget _buildClearCache() {
    return ListTile(
      onTap: () => viewModel.openClearCacheDialog(context),
      title: const Text('清理缓存'),
      trailing: Text(viewModel.cacheSize.value),
    );
  }

  Widget _buildEInkMode() {
    if (!Platform.isAndroid) return const SizedBox();
    return SwitchListTile(
      subtitle: const Text('减少动画，更适合低刷新率的设备'),
      title: const Text('墨水屏模式'),
      value: viewModel.eInkMode.value,
      onChanged: viewModel.updateEInkMode,
    );
  }

  Widget _buildMaxConcurrent() {
    return ListTile(
      onTap: () => viewModel.openMaxConcurrentBottomSheet(context),
      subtitle: const Text('搜索书籍和缓存章节内容时，最大并发请求数量'),
      title: const Text('最大线程数量'),
      trailing: Text('${viewModel.maxConcurrent.value}线程'),
    );
  }

  Widget _buildSearchFilter() {
    return SwitchListTile(
      subtitle: const Text('过滤书名或作者不包含关键字的搜索结果'),
      title: const Text('搜索过滤'),
      value: viewModel.searchFilter.value,
      onChanged: viewModel.updateSearchFilter,
    );
  }

  Widget _buildTimeout() {
    return ListTile(
      onTap: () => viewModel.openTimeoutBottomSheet(context),
      subtitle: const Text('网络请求最大等待时长，超时将取消请求'),
      title: const Text('请求超时'),
      trailing: Text('${viewModel.timeout.value}秒'),
    );
  }

  Widget _buildTurningMode() {
    List<String> modes = [];
    if (viewModel.turningMode.value & 1 == 1) modes.add('滑动翻页');
    if (viewModel.turningMode.value & 2 == 2) modes.add('点击翻页');
    return ListTile(
      onTap: () => viewModel.openTurningModeBottomSheet(context),
      title: const Text('翻页方式'),
      subtitle: const Text('阅读器的翻页方式'),
      trailing: Text(modes.join('，')),
    );
  }

  Widget _buildCloudReaderSetting() {
    return ListTile(
      onTap: () => const CloudReaderSettingRoute().push(context),
      title: const Text('云阅读'),
      subtitle: const Text('服务器地址、账号管理'),
    );
  }

  Widget _buildAiSetting() {
    return ListTile(
      onTap: () => const AiSettingRoute().push(context),
      title: const Text('AI 设置'),
      subtitle: const Text('配置 AI 服务的接口地址、密钥和模型'),
    );
  }
}
