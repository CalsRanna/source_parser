import 'package:creator/creator.dart';
import 'package:flutter/material.dart';

import '../../entity/book_source.dart';
import '../../state/source.dart';
import '../../widget/bordered_card.dart';
import '../../widget/rule_tile.dart';

class BookSourceAdvancedConfiguration extends StatelessWidget {
  const BookSourceAdvancedConfiguration({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('高级配置')),
      body: Watcher(
        (context, ref, _) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
                        value: ref.watch(bookSourceCreator)?.enabled ?? false,
                        onChanged: (value) => ref.update<BookSource?>(
                          bookSourceCreator,
                          (source) => source?.copyWith(enabled: value),
                        ),
                      ),
                    ),
                  ),
                  RuleTile(
                    bordered: false,
                    title: '发现',
                    trailing: SizedBox(
                      height: 14,
                      child: Switch.adaptive(
                        value: ref.watch(bookSourceCreator)?.exploreEnabled ??
                            false,
                        onChanged: (value) => ref.update<BookSource?>(
                          bookSourceCreator,
                          (source) => source?.copyWith(exploreEnabled: value),
                        ),
                      ),
                    ),
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
                    value: ref.watch(bookSourceCreator)?.group,
                    onChange: (value) => ref.update<BookSource?>(
                      bookSourceCreator,
                      (source) => source?.copyWith(group: value),
                    ),
                  ),
                  RuleTile(
                    title: '备注',
                    value: ref.watch(bookSourceCreator)?.comment,
                    onChange: (value) => ref.update<BookSource?>(
                      bookSourceCreator,
                      (source) => source?.copyWith(comment: value),
                    ),
                  ),
                  RuleTile(
                    title: '登陆URL',
                    value: ref.watch(bookSourceCreator)?.loginUrl,
                    onChange: (value) => ref.update<BookSource?>(
                      bookSourceCreator,
                      (source) => source?.copyWith(loginUrl: value),
                    ),
                  ),
                  RuleTile(
                    title: '书籍URL正则',
                    value: ref.watch(bookSourceCreator)?.urlPattern,
                    onChange: (value) => ref.update<BookSource?>(
                      bookSourceCreator,
                      (source) => source?.copyWith(urlPattern: value),
                    ),
                  ),
                  RuleTile(
                    title: '请求头',
                    value: ref.watch(bookSourceCreator)?.header,
                    onChange: (value) => ref.update<BookSource?>(
                      bookSourceCreator,
                      (source) => source?.copyWith(header: value),
                    ),
                  ),
                  RuleTile(
                    bordered: false,
                    title: '编码',
                    value: ref.watch(bookSourceCreator)?.charset,
                    onChange: (value) => ref.update<BookSource?>(
                      bookSourceCreator,
                      (source) => source?.copyWith(charset: value),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
