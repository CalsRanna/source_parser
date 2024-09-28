import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:source_parser/provider/book.dart';
import 'package:source_parser/provider/search.dart';
import 'package:source_parser/router/router.dart';
import 'package:source_parser/schema/book.dart';
import 'package:source_parser/widget/book_cover.dart';

class SearchPage extends StatefulWidget {
  final String? credential;

  const SearchPage({super.key, this.credential});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  var books = <Book>[];
  final controller = TextEditingController();
  final FocusNode node = FocusNode();
  bool showResult = false;
  bool showSuffix = false;
  bool loading = false;
  String query = '';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final onSurface = colorScheme.onSurface;
    final surfaceContainerHighest = colorScheme.surfaceContainerHighest;
    final medium = theme.textTheme.bodyMedium;
    final suffixIcon = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: GestureDetector(
        onTap: clear,
        child: Icon(Icons.cancel, color: onSurface.withOpacity(0.25)),
      ),
    );
    final cancel = TextButton(
      onPressed: () => pop(context),
      child: Text('取消', style: medium),
    );
    final Widget body = SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Consumer(builder: (context, ref, child) {
              final provider = ref.watch(topSearchBooksProvider);
              final books = switch (provider) {
                AsyncData(:final value) => value,
                _ => [],
              };
              List<Widget> children = books.map((book) {
                return ActionChip(
                  label: Text(book.name),
                  labelPadding: EdgeInsets.zero,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  onPressed: () => search(ref, book.name),
                );
              }).toList();
              if (children.isEmpty) return const SizedBox();
              final theme = Theme.of(context);
              final textTheme = theme.textTheme;
              final titleMedium = textTheme.titleMedium;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('热门搜索', style: titleMedium),
                  const SizedBox(height: 8),
                  Wrap(runSpacing: 8, spacing: 8, children: children),
                ],
              );
            }),
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
        title: Consumer(builder: (context, ref, child) {
          return TextField(
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
              suffixIcon: showSuffix ? suffixIcon : null,
              suffixIconConstraints: const BoxConstraints(maxHeight: 30),
            ),
            style: const TextStyle(fontSize: 14),
            textInputAction: TextInputAction.search,
            onSubmitted: (value) => search(ref, value),
            onTapOutside: (event) => node.unfocus(),
          );
        }),
        titleSpacing: 0,
      ),
      body: Consumer(builder: (context, ref, child) {
        if (!showResult) return body;
        final provider = ref.watch(searchBooksProvider(query));
        return StreamBuilder(
          stream: provider.value,
          builder: (context, snapshot) {
            Widget indicator = const LinearProgressIndicator();
            if (snapshot.connectionState == ConnectionState.done) {
              indicator = const SizedBox();
            }
            Widget list = const SizedBox();
            if (!provider.isLoading && snapshot.data != null) {
              list = const Center(child: Text('没有搜索结果'));
              final books = snapshot.data!;
              if (books.isNotEmpty) {
                list = ListView.separated(
                  itemBuilder: (context, index) =>
                      _SearchTile(book: books[index]),
                  separatorBuilder: (context, index) => Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: Divider(
                      color: surfaceContainerHighest.withOpacity(0.25),
                      height: 1,
                    ),
                  ),
                  itemCount: books.length,
                );
              }
            }
            return Column(children: [
              indicator,
              const SizedBox(height: 8),
              Expanded(child: list)
            ]);
          },
        );
      }),
    );
  }

  void clear() {
    controller.text = '';
    setState(() {
      query = '';
    });
  }

  @override
  void dispose() {
    controller.dispose();
    node.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    query = widget.credential ?? '';
    showResult = query.isNotEmpty;
    controller.addListener(() {
      setState(() {
        if (controller.text.isEmpty) {
          showResult = false;
        }
        showSuffix = controller.text.isNotEmpty;
      });
    });
    controller.text = query;
  }

  void pop(BuildContext context) {
    Navigator.of(context).pop();
  }

  void search(WidgetRef ref, String credential) async {
    setState(() {
      query = credential;
      showResult = true;
    });
    node.unfocus();
    controller.text = credential;
  }
}

class _SearchTile extends StatelessWidget {
  final Book book;

  const _SearchTile({required this.book});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final bodyMedium = textTheme.bodyMedium;
    final bodySmall = textTheme.bodySmall;
    return Consumer(builder: (context, ref, child) {
      return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => _handleTap(context, ref),
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
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: bodyMedium,
                      ),
                      Text(_buildSubtitle() ?? '', style: bodySmall),
                      const Spacer(),
                      Text(
                        book.introduction.replaceAll(RegExp(r'\s'), ''),
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
    });
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

  void _handleTap(BuildContext context, WidgetRef ref) {
    const BookInformationPageRoute().push(context);
    final notifier = ref.read(bookNotifierProvider.notifier);
    notifier.update(book);
  }
}
