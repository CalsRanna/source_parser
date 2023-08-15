import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:source_parser/main.dart';
import 'package:source_parser/model/book.dart';
import 'package:source_parser/schema/history.dart';
import 'package:source_parser/widget/book_list_tile.dart';

class ShelfView extends StatefulWidget {
  const ShelfView({super.key});

  @override
  State<ShelfView> createState() => _ShelfViewState();
}

class _ShelfViewState extends State<ShelfView> {
  List<History> histories = [];

  @override
  void initState() {
    super.initState();
    getHistories();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) {
        return BookListTile(
          book: Book(
            author: histories.elementAt(index).author!,
            catalogueUrl: '',
            category: '',
            cover: histories.elementAt(index).cover!,
            introduction: histories.elementAt(index).introduction!,
            name: histories.elementAt(index).name!,
            sourceId: histories.elementAt(index).sourceId!,
            sources: [0],
            url: histories.elementAt(index).url!,
          ),
        );
      },
      itemCount: histories.length,
    );
  }

  void getHistories() async {
    final histories = await isar.historys.where().findAll();
    setState(() {
      this.histories = histories;
    });
  }
}
