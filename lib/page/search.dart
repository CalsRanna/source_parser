import 'package:creator/creator.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:source_parser/creator/book.dart';
import 'package:source_parser/creator/history.dart';
import 'package:source_parser/model/book.dart';
import 'package:source_parser/util/parser.dart';
import 'package:source_parser/widget/book_cover.dart';
import 'package:source_parser/util/message.dart';

class Search extends StatefulWidget {
  const Search({Key? key}) : super(key: key);

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  var books = <Book>[];
  final controller = TextEditingController();
  final FocusNode node = FocusNode();
  bool showResult = false;
  bool loading = false;

  @override
  void initState() {
    super.initState();
    controller.addListener(() {
      setState(() {
        showResult = controller.text.isNotEmpty;
      });
    });
  }

  @override
  void dispose() {
    controller.dispose();
    node.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final onSurface = colorScheme.onSurface;
    final outline = colorScheme.outline;
    final medium = theme.textTheme.bodyMedium;

    final cancel = TextButton(
      onPressed: () => pop(context),
      child: Text('取消', style: medium),
    );
    final Widget body = SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Watcher((context, ref, child) {
              final histories =
                  ref.watch(hotHistoriesEmitter.asyncData).data ?? [];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('热门搜索'),
                  const SizedBox(height: 8),
                  Wrap(
                    runSpacing: 8,
                    spacing: 8,
                    children: histories
                        .map((history) => ActionChip(
                              label: Text(history.name),
                              labelPadding: EdgeInsets.zero,
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              onPressed: () => search(context, history.name),
                            ))
                        .toList(),
                  ),
                ],
              );
            })
          ],
        ),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        actions: [cancel],
        centerTitle: false,
        leading: const SizedBox(),
        leadingWidth: 16,
        title: TextField(
          focusNode: node,
          controller: controller,
          decoration: InputDecoration(
            fillColor: onSurface.withOpacity(0.05),
            filled: true,
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(20),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            isCollapsed: true,
            isDense: true,
            hintText: '输入查询关键字',
          ),
          style: const TextStyle(fontSize: 14),
          textInputAction: TextInputAction.search,
          onSubmitted: (value) => search(context, value),
          onTapOutside: (event) => node.unfocus(),
        ),
        titleSpacing: 0,
      ),
      body: !showResult
          ? body
          : Column(
              children: [
                if (loading) const LinearProgressIndicator(),
                if (books.isNotEmpty && !node.hasFocus)
                  Expanded(
                    child: ListView.separated(
                      itemBuilder: (context, index) {
                        return _SearchTile(book: books[index]);
                      },
                      itemCount: books.length,
                      separatorBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          child: Divider(
                            color: outline.withOpacity(0.05),
                            height: 1,
                          ),
                        );
                      },
                    ),
                  ),
                if (books.isEmpty && !loading && !node.hasFocus)
                  const Expanded(
                    child: Center(
                      child: Text('空空如也'),
                    ),
                  ),
              ],
            ),
    );
  }

  void pop(BuildContext context) {
    context.pop();
  }

  void search(BuildContext context, String credential) async {
    setState(() {
      loading = true;
      books = [];
    });
    node.unfocus();
    controller.text = credential;
    try {
      final stream = await Parser.search(credential);
      stream.listen(
        (book) async {
          final index = books.indexWhere((item) {
            return item.name == book.name && item.author == book.author;
          });
          if (index >= 0) {
            var exist = books.elementAt(index);
            if (exist.introduction.length < book.introduction.length) {
              exist.introduction = book.introduction;
            }
            exist.sources.add(book.sourceId);
            books[index] = exist;
            setState(() {
              books = [...books];
            });
          } else {
            setState(() {
              books.add(book);
            });
          }
        },
        onDone: () {
          setState(() {
            loading = false;
          });
        },
      );
    } catch (e) {
      Message.of(context).show(e.toString());
    }
  }
}

class _SearchTile extends StatelessWidget {
  const _SearchTile({Key? key, required this.book}) : super(key: key);

  final Book book;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final bodyMedium = textTheme.bodyMedium;
    final bodySmall = textTheme.bodySmall;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => _handleTap(context),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BookCover(url: book.cover),
            const SizedBox(width: 16),
            Expanded(
              child: SizedBox(
                height: 96,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      book.name,
                      style: bodyMedium,
                    ),
                    Text(_buildSubtitle() ?? '', style: bodySmall),
                    const Spacer(),
                    Text(
                      book.introduction
                          .replaceAll('\n', '')
                          .replaceAll(' ', ''),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: bodyMedium,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleTap(BuildContext context) {
    context.ref.set(currentBookCreator, book);
    context.push('/book-information');
  }

  String? _buildSubtitle() {
    final spans = <String>[];
    if (book.author.isNotEmpty) {
      spans.add(book.author);
    }
    if (book.category.isNotEmpty) {
      spans.add(book.category);
    }
    if (book.status.isNotEmpty) {
      spans.add(book.status);
    }
    if (book.words.isNotEmpty) {
      spans.add(book.words);
    }
    return spans.isNotEmpty ? spans.join(' · ') : null;
  }
}
