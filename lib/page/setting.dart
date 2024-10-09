import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:source_parser/provider/cache.dart';
import 'package:source_parser/provider/setting.dart';
import 'package:source_parser/util/message.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final children = [
      _TurningModeTile(),
      _SearchFilterTile(),
      _TimeoutTile(),
      _MaxConcurrent(),
      _CacheDurationTile(),
      _EInkModeTile(),
      _ClearCacheTile(),
    ];
    return Scaffold(
      appBar: AppBar(title: const Text('设置')),
      body: ListView(children: children),
    );
  }
}

class _CacheDurationTile extends ConsumerWidget {
  const _CacheDurationTile();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final setting = ref.watch(settingNotifierProvider).valueOrNull;
    final hour = setting?.cacheDuration.floor() ?? 8;
    return ListTile(
      onTap: () => handleTap(context, ref),
      subtitle: const Text('网络请求缓存的有效时长，不影响缓存的封面和章节'),
      title: const Text('缓存时长'),
      trailing: Text(_buildText(hour)),
    );
  }

  Future<void> dismissSheet(BuildContext context, int hour) async {
    Navigator.of(context).pop(hour);
  }

  Future<void> handleTap(BuildContext context, WidgetRef ref) async {
    final listView = ListView.builder(itemBuilder: _itemBuilder, itemCount: 7);
    final hour = await showModalBottomSheet(
      builder: (_) => listView,
      context: context,
      showDragHandle: true,
    );
    if (hour == null) return;
    final notifier = ref.read(settingNotifierProvider.notifier);
    notifier.updateCacheDuration(hour.toDouble());
  }

  String _buildText(int hour) {
    return switch (hour) {
      0 => '不缓存',
      24 => '1天',
      _ => '$hour小时',
    };
  }

  Widget _itemBuilder(BuildContext context, int index) {
    final hour = index * 4;
    return ListTile(
      title: Text(_buildText(hour), textAlign: TextAlign.center),
      onTap: () => dismissSheet(context, hour),
    );
  }
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

class _MaxConcurrent extends ConsumerWidget {
  const _MaxConcurrent();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final setting = ref.watch(settingNotifierProvider).valueOrNull;
    final maxConcurrent = setting?.maxConcurrent.floor() ?? 16;
    return ListTile(
      onTap: () => handleTap(context, ref),
      subtitle: const Text('搜索书籍和缓存章节内容时，最大并发请求数量'),
      title: const Text('最大线程数量'),
      trailing: Text('$maxConcurrent线程'),
    );
  }

  Future<void> dismissSheet(BuildContext context, int concurrent) async {
    Navigator.of(context).pop(concurrent);
  }

  Future<void> handleTap(BuildContext context, WidgetRef ref) async {
    final listView = ListView.builder(itemBuilder: _itemBuilder, itemCount: 4);
    final concurrent = await showModalBottomSheet(
      builder: (_) => listView,
      context: context,
      showDragHandle: true,
    );
    if (concurrent == null) return;
    final notifier = ref.read(settingNotifierProvider.notifier);
    notifier.updateMaxConcurrent(concurrent.toDouble());
  }

  Widget _itemBuilder(BuildContext context, int index) {
    final concurrent = (index + 1) * 4;
    return ListTile(
      title: Text('$concurrent线程', textAlign: TextAlign.center),
      onTap: () => dismissSheet(context, concurrent),
    );
  }
}

class _SearchFilterTile extends ConsumerWidget {
  const _SearchFilterTile();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final setting = ref.watch(settingNotifierProvider).valueOrNull;
    final searchFilter = setting?.searchFilter ?? false;
    return SwitchListTile(
      subtitle: const Text('过滤书名或作者不包含关键字的搜索结果'),
      title: const Text('搜索过滤'),
      value: searchFilter,
      onChanged: (value) => updateSearchFilter(ref, value),
    );
  }

  Future<void> updateSearchFilter(WidgetRef ref, bool value) async {
    final notifier = ref.read(settingNotifierProvider.notifier);
    notifier.updateSearchFilter(value);
  }
}

class _TimeoutTile extends ConsumerWidget {
  const _TimeoutTile();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final setting = ref.watch(settingNotifierProvider).valueOrNull;
    final timeout = setting?.timeout ?? 30 * 1000;
    return ListTile(
      onTap: () => handleTap(context, ref),
      subtitle: const Text('网络请求最大等待时长，超时将取消请求'),
      title: const Text('请求超时'),
      trailing: Text(_buildText(timeout)),
    );
  }

  Future<void> dismissSheet(BuildContext context, int timeout) async {
    Navigator.of(context).pop(timeout);
  }

  Future<void> handleTap(BuildContext context, WidgetRef ref) async {
    final listView = ListView.builder(itemBuilder: _itemBuilder, itemCount: 4);
    final timeout = await showModalBottomSheet(
      builder: (_) => listView,
      context: context,
      showDragHandle: true,
    );
    if (timeout == null) return;
    final notifier = ref.read(settingNotifierProvider.notifier);
    notifier.updateTimeout(timeout);
  }

  String _buildText(int timeout) {
    final seconds = timeout ~/ 1000;
    return '$seconds秒';
  }

  Widget _itemBuilder(BuildContext context, int index) {
    final timeout = (index + 1) * 15 * 1000;
    return ListTile(
      title: Text(_buildText(timeout), textAlign: TextAlign.center),
      onTap: () => dismissSheet(context, timeout),
    );
  }
}

class _TurningModeListTile extends ConsumerWidget {
  final int mode;
  final String title;
  const _TurningModeListTile({required this.mode, required this.title});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final setting = ref.watch(settingNotifierProvider).valueOrNull;
    final turningMode = setting?.turningMode ?? 3;
    return ListTile(
      title: Text(title),
      trailing: turningMode & mode == mode ? Icon(Icons.check) : null,
      onTap: () => updateTurningMode(ref, mode),
    );
  }

  void updateTurningMode(WidgetRef ref, int value) async {
    final notifier = ref.read(settingNotifierProvider.notifier);
    notifier.updateTurningMode(value);
  }
}

class _TurningModeTile extends ConsumerWidget {
  const _TurningModeTile();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final setting = ref.watch(settingNotifierProvider).valueOrNull;
    final turningMode = setting?.turningMode ?? 3;
    List<String> modes = [];
    if (turningMode & 1 == 1) modes.add('滑动翻页');
    if (turningMode & 2 == 2) modes.add('点击翻页');
    return ListTile(
      onTap: () => handleTap(context),
      title: const Text('翻页方式'),
      subtitle: const Text('阅读界面的翻页方式'),
      trailing: Text(modes.join('，')),
    );
  }

  Future<void> handleTap(BuildContext context) async {
    final children = [
      _TurningModeListTile(mode: 1, title: '滑动翻页'),
      _TurningModeListTile(mode: 2, title: '点击翻页'),
    ];
    await showModalBottomSheet(
      builder: (_) => ListView(children: children),
      context: context,
      showDragHandle: true,
    );
  }

  void updateTurningMode(WidgetRef ref, int value) async {
    final notifier = ref.read(settingNotifierProvider.notifier);
    notifier.updateTurningMode(value);
  }
}
