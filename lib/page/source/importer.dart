import 'package:flutter/material.dart';
import 'package:source_parser/widget/loading.dart';

class BookSourceImport extends StatefulWidget {
  const BookSourceImport({Key? key, required this.by}) : super(key: key);

  final String by;

  @override
  State<BookSourceImport> createState() {
    return _BookSourceImportState();
  }
}

class _BookSourceImportState extends State<BookSourceImport> {
  // static const Map<String, String> titles = {
  //   'internet': '网络导入',
  //   'locale': '本地导入',
  //   'qr-code': '二维码导入',
  // };

  @override
  Widget build(BuildContext context) {
    Widget body = const _InternetImport();
    if (widget.by == 'locale') {
      body = const _LocalImport();
    } else if (widget.by == 'qr-code') {
      body = const _QrCodeImport();
    }

    return body;
  }
}

class _InternetImport extends StatefulWidget {
  const _InternetImport({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _InternetImportState();
  }
}

class _InternetImportState extends State<_InternetImport> {
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    var controller = TextEditingController();

    Widget body = const Center(child: LoadingIndicator());

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
          IconButton(
            onPressed: () => handleTap(context, controller.text),
            icon: const Icon(Icons.check_outlined),
          ),
        ],
        title: const Text('网络导入'),
      ),
      body: body,
    );
  }

  void handleTap(BuildContext context, String url) async {
    // // ref.read(bookSourceState.notifier).updateImporting(true);

    // var database = ref.watch(globalState.select((value) => value.database))!;

    // var naviagator = Navigator.of(context);
    // try {
    //   var count = await SourceImporter().internet(database, url);

    //   // compute 只能传递值，不能传递引用

    //   // var count = await compute(SourceImporter.internet, url);

    //   var importedSources = await database.bookSourceDao.getAllBookSources();
    //   ref.read(bookSourceState.notifier).updateBookSources(importedSources);
    //   ref.read(bookSourceState.notifier).updateImporting(false);

    //   naviagator.pop(count);
    // } catch (e) {
    //   ref.read(bookSourceState.notifier).updateImporting(false);
    //   var error = e as DioError;
    //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    //     backgroundColor: Theme.of(context).primaryColor,
    //     behavior: SnackBarBehavior.floating,
    //     content: Text(error.message),
    //     duration: const Duration(seconds: 3),
    //   ));
    // }
  }
}

class _LocalImport extends StatelessWidget {
  const _LocalImport({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class _QrCodeImport extends StatelessWidget {
  const _QrCodeImport({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
