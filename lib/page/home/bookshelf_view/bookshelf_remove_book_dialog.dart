import 'package:flutter/material.dart';
import 'package:source_parser/model/book_entity.dart';

class BookshelfRemoveBookDialog extends StatelessWidget {
  final BookEntity book;
  final void Function()? onConfirmed;
  const BookshelfRemoveBookDialog({
    super.key,
    required this.book,
    this.onConfirmed,
  });

  @override
  Widget build(BuildContext context) {
    var cancelButton = TextButton(
      onPressed: () => cancel(context),
      child: const Text('取消'),
    );
    var confirmButton = TextButton(
      onPressed: () => confirm(context),
      child: const Text('确认'),
    );
    return AlertDialog(
      actions: [cancelButton, confirmButton],
      content: const Text('确认将本书移出书架？'),
      title: const Text('移出书架'),
    );
  }

  void cancel(BuildContext context) {
    Navigator.of(context).pop();
  }

  void confirm(BuildContext context) async {
    Navigator.of(context).pop();
    onConfirmed?.call();
  }
}
