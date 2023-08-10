import 'dart:ui';

import 'package:creator/creator.dart';
import 'package:creator_watcher/creator_watcher.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:source_parser/creator/book.dart';
import 'package:source_parser/creator/history.dart';
import 'package:source_parser/model/book.dart';
import 'package:source_parser/schema/history.dart';
import 'package:source_parser/widget/book_cover.dart';

class BookInformation extends StatefulWidget {
  const BookInformation({super.key});

  @override
  State<BookInformation> createState() {
    return _BookInformationState();
  }
}

class _BookInformationState extends State<BookInformation> {
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    final book = context.ref.watch(currentBookCreator);
    var background = ImageFiltered(
        imageFilter: ImageFilter.blur(sigmaX: 96, sigmaY: 96),
        child: BookCover(
          borderRadius: null,
          height: 261,
          url: book.cover,
          width: double.infinity,
        ));
    var information = Stack(
      children: [
        background,
        Positioned(
          left: 16,
          right: 16,
          top: 135,
          child: Row(
            children: [
              BookCover(url: book.cover),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      book.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                    Text(book.author),
                    Text(_buildSpan(book)),
                  ],
                ),
              )
            ],
          ),
        ),
      ],
    );

    var header = SliverAppBar(
      centerTitle: false,
      expandedHeight: 240,
      flexibleSpace: FlexibleSpaceBar(
        background: information,
        collapseMode: CollapseMode.pin,
      ),
      title: CreatorWatcher<History>(
        builder: (context, history) => Text(history.name ?? ''),
        creator: historyCreator,
      ),
      titleSpacing: 0,
      pinned: true,
    );

    const boldTextStyle = TextStyle(fontSize: 16, fontWeight: FontWeight.w600);
    List<Widget> children = [
      const SizedBox(height: 16),
      Card(
        color: Theme.of(context).colorScheme.surfaceTint.withOpacity(0.15),
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: const RoundedRectangleBorder(),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [Text('简介', style: boldTextStyle)],
              ),
              const SizedBox(height: 16),
              Text(
                book.introduction,
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
              )
            ],
          ),
        ),
      ),
      const SizedBox(height: 16),
      Watcher(
        (context, ref, _) => GestureDetector(
          onTap: () => context.push('/catalog'),
          child: Card(
            color: Theme.of(context).colorScheme.surfaceTint.withOpacity(0.15),
            elevation: 0,
            margin: EdgeInsets.zero,
            shape: const RoundedRectangleBorder(),
            child: const Padding(
              padding: EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Text('目录', style: boldTextStyle),
                  Expanded(
                    child: Text(
                      '530章·最新章节',
                      textAlign: TextAlign.right,
                    ),
                  ),
                  Icon(Icons.chevron_right_outlined)
                ],
              ),
            ),
          ),
        ),
      ),
      const SizedBox(height: 16),
      Card(
        color: Theme.of(context).colorScheme.surfaceTint.withOpacity(0.15),
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: const RoundedRectangleBorder(),
        child: const Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('评论', style: boldTextStyle),
                  Icon(Icons.chevron_right_outlined)
                ],
              ),
            ],
          ),
        ),
      ),
      const SizedBox(height: 16),
      Card(
        color: Theme.of(context).colorScheme.surfaceTint.withOpacity(0.15),
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: const RoundedRectangleBorder(),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text('书源', style: boldTextStyle),
                  const Expanded(
                    child: Text(
                      '62个·3Z中文网',
                      textAlign: TextAlign.right,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: loading
                        ? const CupertinoActivityIndicator()
                        : const Icon(Icons.chevron_right_outlined),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
      const SizedBox(height: 16),
      Card(
        color: Theme.of(context).colorScheme.surfaceTint.withOpacity(0.15),
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: const RoundedRectangleBorder(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
          child: Row(
            children: [
              const Expanded(child: Text('停止更新本书')),
              Switch.adaptive(value: false, onChanged: (value) {})
            ],
          ),
        ),
      ),
    ];

    Widget bottomBar = Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Theme.of(context).colorScheme.primaryContainer,
          ),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      child: Row(
        children: [
          TextButton(
            onPressed: () {},
            child: const Row(
              children: [Icon(Icons.headphones_outlined), Text('听书')],
            ),
          ),
          const SizedBox(width: 8),
          TextButton(
            onPressed: () {},
            child: const Row(
              children: [Icon(Icons.library_add_outlined), Text('加入书架')],
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: ElevatedButton(
              onPressed: () => context.push('/book-reader'),
              child: const Text('立即阅读'),
            ),
          ),
        ],
      ),
    );

    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, __) => [
          SliverOverlapAbsorber(
            handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
            sliver: header,
          )
        ],
        body: Builder(
          builder: (context) => CustomScrollView(
            slivers: [
              SliverOverlapInjector(
                handle:
                    NestedScrollView.sliverOverlapAbsorberHandleFor(context),
              ),
              SliverList(delegate: SliverChildListDelegate(children))
            ],
          ),
        ),
      ),
      bottomNavigationBar: bottomBar,
    );
  }

  String _buildSpan(Book book) {
    final spans = <String>[];
    // if (book.category != null) {
    //   spans.add(book.category!);
    // }
    // if (book.status != null) {
    //   spans.add(book.status!);
    // }
    return spans.join(' · ');
  }
}
