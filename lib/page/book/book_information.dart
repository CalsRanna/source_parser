import 'dart:io';
import 'dart:ui';

import 'package:creator/creator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../model/book.dart';
import '../../state/book.dart';
import '../../state/global.dart';
import '../../util/parser.dart';
import '../../widget/book_cover.dart';

class BookInformation extends StatefulWidget {
  const BookInformation({Key? key}) : super(key: key);

  @override
  State<BookInformation> createState() => _BookInformationState();
}

class _BookInformationState extends State<BookInformation> {
  @override
  void didChangeDependencies() {
    fetchInformation();
    super.didChangeDependencies();
  }

  void fetchInformation() async {
    var database = context.ref.watch(databaseEmitter.asyncData).data;
    var book = context.ref.watch(bookCreator);
    final cacheDirectory =
        context.ref.read(cacheDirectoryEmitter.asyncData).data;
    final folder = Directory(cacheDirectory!);

    var result = await Parser.fetch(database!, book!, folder);
    result.listen((book) {
      context.ref.set(bookCreator, book);
    });
  }

  @override
  Widget build(BuildContext context) {
    var background = ImageFiltered(
      imageFilter: ImageFilter.blur(sigmaX: 96, sigmaY: 96),
      child: Watcher(
        (context, ref, _) => BookCover(
          borderRadius: null,
          height: 261,
          url: ref.watch(bookCreator)?.cover ?? '',
          width: double.infinity,
        ),
      ),
    );
    var information = Stack(
      children: [
        background,
        Positioned(
          left: 16,
          right: 16,
          top: 135,
          child: Row(
            children: [
              Watcher(
                (context, ref, _) =>
                    BookCover(url: ref.watch(bookCreator)?.cover ?? ''),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Watcher(
                  (context, ref, _) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ref.watch(bookCreator)?.name ?? '',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                      Text(ref.watch(bookCreator)?.author ?? ''),
                      Text(_buildSpan(ref.watch(bookCreator)!)),
                    ],
                  ),
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
      title: Watcher(
        (context, ref, _) => Text(ref.watch(bookCreator)?.name ?? ''),
      ),
      titleSpacing: 0,
      pinned: true,
    );

    const boldTextStyle = TextStyle(fontSize: 16, fontWeight: FontWeight.w600);
    List<Widget> children = [
      const SizedBox(height: 16),
      Card(
        shape: const RoundedRectangleBorder(),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: const [Text('简介', style: boldTextStyle)],
              ),
              const SizedBox(height: 16),
              Watcher(
                (context, ref, _) => Text(
                  ref.watch(bookCreator)?.introduction ?? '',
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
      const SizedBox(height: 16),
      Watcher(
        (context, ref, _) => GestureDetector(
          onTap: () => context.push('/catalog'),
          child: Card(
            shape: const RoundedRectangleBorder(),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: const [
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
        shape: const RoundedRectangleBorder(),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
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
                    child: Watcher((context, ref, child) {
                      if (ref.watch(loadingOfBookCreator)) {
                        return const CupertinoActivityIndicator();
                      } else {
                        return const Icon(Icons.chevron_right_outlined);
                      }
                    }),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
      const SizedBox(height: 16),
      Card(
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
            child: Row(
              children: const [Icon(Icons.headphones_outlined), Text('听书')],
            ),
          ),
          const SizedBox(width: 8),
          TextButton(
            onPressed: () {},
            child: Row(
              children: const [Icon(Icons.library_add_outlined), Text('加入书架')],
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
    if (book.category != null) {
      spans.add(book.category!);
    }
    if (book.status != null) {
      spans.add(book.status!);
    }
    return spans.join(' · ');
  }
}
