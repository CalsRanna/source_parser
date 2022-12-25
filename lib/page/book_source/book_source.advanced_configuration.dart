import 'package:creator/creator.dart';
import 'package:flutter/material.dart';
import 'package:source_parser/model/book_source.dart';
import 'package:source_parser/state/source.dart';
import 'package:source_parser/widget/bordered_card.dart';
import 'package:source_parser/widget/debug_button.dart';
import 'package:source_parser/widget/rule_tile.dart';

class BookSourceAdvancedConfiguration extends StatefulWidget {
  const BookSourceAdvancedConfiguration({Key? key}) : super(key: key);

  @override
  State<BookSourceAdvancedConfiguration> createState() {
    return _BookSourceAdvancedConfigurationState();
  }
}

class _BookSourceAdvancedConfigurationState
    extends State<BookSourceAdvancedConfiguration> {
  late BookSource source;

  @override
  void didChangeDependencies() {
    source = context.ref.read(bookSourceCreator);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: store,
      child: Scaffold(
        appBar:
            AppBar(actions: const [DebugButton()], title: const Text('高级配置')),
        body: ListView(
          children: [
            BorderedCard(
              title: '控制',
              child: Column(
                children: [
                  RuleTile(
                    title: '启用',
                    trailing: SizedBox(
                      height: 14,
                      child: Switch.adaptive(
                        value: source.enabled,
                        onChanged: (value) =>
                            setState(() => source.enabled = value),
                      ),
                    ),
                    onTap: () =>
                        setState(() => source.enabled = !source.enabled),
                  ),
                  RuleTile(
                    bordered: false,
                    title: '发现',
                    trailing: SizedBox(
                      height: 14,
                      child: Switch.adaptive(
                        value: source.exploreEnabled,
                        onChanged: (value) =>
                            setState(() => source.exploreEnabled = value),
                      ),
                    ),
                    onTap: () => setState(
                        () => source.exploreEnabled = !source.exploreEnabled),
                  ),
                ],
              ),
            ),
            BorderedCard(
              title: '配置',
              child: Column(
                children: [
                  RuleTile(
                    title: '分组',
                    value: source.group,
                    onChange: (value) => setState(() => source.group = value),
                  ),
                  RuleTile(
                    title: '备注',
                    value: source.comment,
                    onChange: (value) => setState(() => source.comment = value),
                  ),
                  RuleTile(
                    title: '登陆URL',
                    value: source.loginUrl,
                    onChange: (value) =>
                        setState(() => source.loginUrl = value),
                  ),
                  RuleTile(
                    title: '书籍URL正则',
                    value: source.urlPattern,
                    onChange: (value) =>
                        setState(() => source.urlPattern = value),
                  ),
                  RuleTile(
                    title: '请求头',
                    value: source.header,
                    onChange: (value) => setState(() => source.header = value),
                  ),
                  RuleTile(
                    title: '编码',
                    value: source.charset,
                    onChange: (value) => setState(() => source.charset = value),
                    onTap: selectCharset,
                  ),
                  RuleTile(
                    bordered: false,
                    title: '权重',
                    value: source.weight.toString(),
                    onChange: (value) => setState(() => source.weight = value),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> store() {
    context.ref.set(bookSourceCreator, source);
    return Future.value(true);
  }

  void selectCharset() {
    const charsets = ['utf8', 'gbk'];
    showModalBottomSheet(
      context: context,
      builder: (context) => SizedBox(
        height: 56 * 2 + MediaQuery.of(context).padding.bottom,
        child: Column(
          children: List.generate(
            charsets.length,
            (index) => ListTile(
              title: Text(charsets[index]),
              onTap: () => confirmSelect(charsets[index]),
            ),
          ),
        ),
      ),
    );
  }

  void confirmSelect(String charset) {
    setState(() => source.charset = charset);
    Navigator.of(context).pop();
  }
}
