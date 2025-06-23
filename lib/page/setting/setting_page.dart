import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:signals/signals_flutter.dart';
import 'package:source_parser/page/setting/setting_view_model.dart';
import 'package:source_parser/provider/cache.dart';
import 'package:source_parser/provider/setting.dart';
import 'package:source_parser/util/message.dart';

@RoutePage()
class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _ClearCacheTile extends ConsumerWidget {
  const _ClearCacheTile();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = ref.watch(cacheSizeProvider).valueOrNull ?? '';
    return ListTile(
      onTap: () => handleTap(context, ref),
      title: const Text('清理缓存'),
      trailing: Text(size),
    );
  }

  Future<void> dismissDialog(BuildContext context, bool confirm) async {
    Navigator.of(context).pop(confirm);
  }

  void handleTap(BuildContext context, WidgetRef ref) async {
    final cancelButton = TextButton(
      onPressed: () => dismissDialog(context, false),
      child: const Text('取消'),
    );
    final confirmButton = TextButton(
      onPressed: () => dismissDialog(context, true),
      child: const Text('确认'),
    );
    final dialog = AlertDialog(
      actions: [cancelButton, confirmButton],
      content: const Text('确定清空所有已缓存的内容？'),
      title: const Text('清空缓存'),
    );
    final result = await showDialog(builder: (_) => dialog, context: context);
    if (result != true) return;
    if (!context.mounted) return;
    final message = Message.of(context);
    final notifier = ref.read(cacheSizeProvider.notifier);
    final succeed = await notifier.clear();
    message.show(succeed ? '已清空缓存' : '清空缓存失败');
  }
}

class _EInkModeTile extends ConsumerWidget {
  const _EInkModeTile();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (!Platform.isAndroid) return const SizedBox();
    final setting = ref.watch(settingNotifierProvider).valueOrNull;
    final eInkMode = setting?.eInkMode ?? false;
    return SwitchListTile(
      subtitle: const Text('减少动画，更适合低刷新率的设备'),
      title: const Text('墨水屏模式'),
      value: eInkMode,
      onChanged: (value) => updateEInkMode(ref, value),
    );
  }

  void updateEInkMode(WidgetRef ref, bool value) async {
    final notifier = ref.read(settingNotifierProvider.notifier);
    notifier.updateEInkMode(value);
  }
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
      _EInkModeTile(),
      _ClearCacheTile(),
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
}
