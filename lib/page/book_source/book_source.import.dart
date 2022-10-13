import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../provider/book_source.dart';
import '../../provider/global.dart';
import '../../util/importer.dart';

class BookSourceImport extends ConsumerWidget {
  BookSourceImport({Key? key, required this.by}) : super(key: key);

  final String by;

  final Map<String, String> titles = {
    'internet': '网络导入',
    'locale': '本地导入',
    'qr-code': '二维码导入',
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Widget body = const _InternetImport();
    if (by == 'locale') {
      body = const _LocalImport();
    } else if (by == 'qr-code') {
      body = const _QrCodeImport();
    }

    return body;
  }
}

class _InternetImport extends ConsumerWidget {
  const _InternetImport({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var loading = ref.watch(bookSourceState.select((value) => value.importing));
    var controller = TextEditingController();

    Widget body = const Center(child: CircularProgressIndicator());

    if (!loading) {
      body = ListView(
        padding: const EdgeInsets.all(8),
        children: [
          TextField(
            controller: controller,
            decoration: const InputDecoration(
              border: InputBorder.none,
              hintText: '请输入书源的网络地址，兼容阅读3.0的书源',
            ),
            focusNode: FocusNode()..requestFocus(),
          ),
        ],
      );
    }

    return Scaffold(
      appBar: AppBar(
        actions: [
          InkWell(
            onTap: () => handleTap(context, ref, controller.text),
            child: const Center(
              child: Text('完成'),
            ),
          )
        ],
        title: const Text('网络导入'),
      ),
      body: body,
    );
  }

  void handleTap(BuildContext context, WidgetRef ref, String url) async {
    ref.read(bookSourceState.notifier).updateImporting(true);

    var database = ref.watch(globalState.select((value) => value.database))!;

    var naviagator = Navigator.of(context);
    try {
      var count = await SourceImporter().internet(database, url);

      // compute 只能传递值，不能传递引用

      // var count = await compute(SourceImporter.internet, url);

      var importedSources = await database.bookSourceDao.getAllBookSources();
      ref.read(bookSourceState.notifier).updateBookSources(importedSources);
      ref.read(bookSourceState.notifier).updateImporting(false);

      naviagator.pop(count);
    } catch (e) {
      ref.read(bookSourceState.notifier).updateImporting(false);
      var error = e as DioError;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Theme.of(context).primaryColor,
        behavior: SnackBarBehavior.floating,
        content: Text(error.message),
        duration: const Duration(seconds: 3),
      ));
    }
  }
}

class _LocalImport extends ConsumerWidget {
  const _LocalImport({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container();
  }
}

class _QrCodeImport extends ConsumerWidget {
  const _QrCodeImport({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container();
  }
}
