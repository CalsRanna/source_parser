import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../entity/book.dart';
import '../../widget/bottom_bar.dart';
import '../../widget/shelf_item.dart';

class Shelf extends ConsumerWidget {
  const Shelf({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            children: [
              ShelfItem(
                book: Book(
                  author: '作者',
                  cover: '',
                  name: '名称',
                  url: '',
                ),
              ),
            ],
          )
        ],
      ),
      bottomNavigationBar: BottomBar(),
    );
  }

  void goSearch(BuildContext context) {
    context.push('/search');
  }
}
