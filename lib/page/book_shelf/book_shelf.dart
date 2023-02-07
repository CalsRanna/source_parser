import 'package:creator/creator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:source_parser/state/book.dart';
import 'package:source_parser/state/global.dart';
import 'package:source_parser/widget/bottom_bar.dart';
import 'package:source_parser/widget/shelf_item.dart';

class BookShelf extends StatelessWidget {
  const BookShelf({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () => goSearch(context),
              icon: const Icon(Icons.search)),
          IconButton(
            onPressed: () {},
            icon: const Icon(CupertinoIcons.ellipsis_vertical),
          ),
        ],
        centerTitle: true,
        title: const Text('书架'),
      ),
      body: Watcher(
        (context, ref, _) {
          final books = ref.watch(shelfBooksEmitter.asyncData).data;
          final isar = ref.watch(isarEmitter.asyncData).data;
          if (books != null && books.isNotEmpty) {
            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3),
              itemBuilder: (context, index) => ShelfItem(book: books[index]),
              itemCount: books.length,
            );
          } else {
            return const Center(child: Text('空空如也'));
          }
        },
      ),
      bottomNavigationBar: const BottomBar(),
    );
  }

  void goSearch(BuildContext context) {
    context.push('/search');
  }
}
