import 'dart:io';

import 'package:creator/creator.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:source_parser/model/book.dart';
import 'package:source_parser/state/book.dart';
import 'package:source_parser/state/global.dart';
import 'package:source_parser/util/parser.dart';
import 'package:source_parser/widget/book_list_tile.dart';
import 'package:source_parser/widget/message.dart';

class Search extends StatelessWidget {
  const Search({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final cancel = TextButton(
      onPressed: () => pop(context),
      child: Text(
        '取消',
        style: TextStyle(color: Theme.of(context).colorScheme.secondary),
      ),
    );
    // var cancel = Padding(
    //   padding: const EdgeInsets.only(right: 16),
    //   child: InkWell(
    //     onTap: () => pop(context),
    //     child: Center(
    //       child: Text(
    //         '取消',
    //         style: TextStyle(color: Theme.of(context).colorScheme.secondary),
    //       ),
    //     ),
    //   ),
    // );

    // var visibleOfSearchHistories = state.searchHistories.isNotEmpty;
    // var chipsOfSearchHistory = <Widget>[];
    // for (var i = 0; i < state.searchHistories.length; i++) {
    //   var chip = ActionChip(
    //     label: Text(state.searchHistories[i].name!),
    //     onPressed: () => search(context, ref, state.searchHistories[i].name!),
    //   );
    //   chipsOfSearchHistory.add(chip);
    // }

    // var chips = <Widget>[];
    // for (var i = 0; i < state.topSearchBooks.length; i++) {
    //   var chip = ActionChip(
    //     label: Text(state.topSearchBooks[i].name!),
    //     onPressed: () => search(context, ref, state.topSearchBooks[i].name!),
    //   );
    //   chips.add(chip);
    // }

    // if (state.topSearchBooks.isEmpty) {
    //   Parser.topSearch().then((books) {
    //     ref.read(searchState.notifier).updateTopSearchBooks(books);
    //   });
    // }

    // var showSearchResult = state.showSearchResult;

    Widget body = SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Watcher((context, ref, _) {
              var books = ref.watch(topSearchBooksCreator.asyncData).data;
              late bool visible;
              List<Widget> children = [];
              if (books != null && books.isNotEmpty) {
                visible = true;
                for (var i = 0; i < books.length; i++) {
                  var name = books[i].name ?? '';
                  children.add(ActionChip(
                    label: Text(name),
                    shape: const StadiumBorder(),
                    onPressed: () => search(context, name),
                  ));
                }
              } else {
                visible = false;
              }
              return Visibility(
                visible: visible,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('热门搜索'),
                    Wrap(spacing: 16, children: children),
                  ],
                ),
              );
            }),
            // Visibility(
            //   visible: !showSearchResult,
            //   child: Column(
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     children: [
            //       const Text('热门搜索'),
            //       SizedBox(
            //         width: double.infinity,
            //         child: Wrap(spacing: 8, runSpacing: -8, children: chips),
            //       ),
            //     ],
            //   ),
            // ),
          ],
        ),
      ),
    );

    // if (showSearchResult) {
    //   body = const _SearchResult();
    // }

    return Scaffold(
      appBar: AppBar(
        actions: [cancel],
        centerTitle: false,
        leading: const SizedBox(),
        leadingWidth: 16,
        title: _SearchInput(),
        titleSpacing: 0,
      ),
      body: Watcher((context, ref, _) {
        final books = ref.watch(searchBooksCreator);
        if (books != null && books.isNotEmpty) {
          return _SearchResult(books: books);
        } else {
          return body;
        }
      }),
    );
  }

  void pop(BuildContext context) {
    context.go('/shelf');
  }

  void search(BuildContext context, String credential) async {
    // ref.read(searchState.notifier).updateCredential(credential);
    // ref.read(searchState.notifier).updateShowSearchResult(true);
    final database = context.ref.read(databaseEmitter.asyncData).data;
    final cacheDirectory =
        context.ref.read(cacheDirectoryEmitter.asyncData).data;
    final folder = Directory(cacheDirectory!);
    try {
      var result = await Parser.search(database!, credential, folder);
      final books = <Book>[];
      result.listen((book) {
        books.add(book);
        context.ref.set(searchBooksCreator, books);
      });
      // result.isolate.kill();
    } catch (e) {
      Message.of(context).show(e.toString());
    }
  }
}

class _SearchInput extends StatelessWidget {
  _SearchInput({Key? key}) : super(key: key);

  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.white,
      ),
      height: 30,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          const Icon(Icons.search, color: Colors.grey, size: 14),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: controller,
              cursorHeight: 14,
              decoration: const InputDecoration(
                border: InputBorder.none,
                isCollapsed: true,
                hintText: '输入书名/作者，进行模糊搜索',
                hintStyle: TextStyle(fontSize: 14, height: 1),
              ),
              style: const TextStyle(fontSize: 14),
              textInputAction: TextInputAction.search,
              onEditingComplete: () => search(context),
            ),
          ),
        ],
      ),
    );
  }

  void search(BuildContext context) async {
    context.ref.set(searchBooksCreator, null);
    final database = context.ref.read(databaseEmitter.asyncData).data;
    final cacheDirectory =
        context.ref.read(cacheDirectoryEmitter.asyncData).data;
    final folder = Directory(cacheDirectory!);
    try {
      var result = await Parser.search(database!, controller.text, folder);
      final books = <Book>[];
      result.listen((book) {
        books.add(book);
        context.ref.set(searchBooksCreator, books);
      });
    } catch (e) {
      Message.of(context).show(e.toString());
    }
  }
}

class _SearchResult extends StatelessWidget {
  const _SearchResult({Key? key, required this.books}) : super(key: key);

  final List<Book> books;

  @override
  Widget build(BuildContext context) {
    var divider = Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Theme.of(context).colorScheme.primaryContainer,
          ),
        ),
      ),
    );
    return ListView.separated(
      itemBuilder: (context, index) => BookListTile(book: books[index]),
      itemCount: books.length,
      padding: const EdgeInsets.all(16),
      separatorBuilder: (context, index) => divider,
    );
  }
}
