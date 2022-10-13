import 'package:book_reader/book_reader.dart';
import 'package:flutter/material.dart';

import '../model/book.dart';

class ShelfItem extends StatelessWidget {
  const ShelfItem({Key? key, required this.book, this.onTap}) : super(key: key);

  final Book book;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    var screen = MediaQuery.of(context).size;
    var width = screen.width - 64;
    return GestureDetector(
      onTap: () => handleTap(context),
      child: SizedBox(
        width: width / 3,
        child: Column(
          children: [
            SizedBox(
              height: width * 4 / 9,
              child: Image.asset('asset/image/default_cover.jpg'),
            ),
            const SizedBox(height: 8),
            Text(book.name ?? '')
          ],
        ),
      ),
    );
  }

  void handleTap(BuildContext context) {
    onTap?.call();
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => BookReader(
        future: (index) => Future.value('123'),
        name: book.name!,
      ),
    ));
  }
}
