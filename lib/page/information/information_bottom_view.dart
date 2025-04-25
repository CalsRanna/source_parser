import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:source_parser/model/book_entity.dart';

class InformationBottomView extends StatelessWidget {
  final BookEntity book;
  final bool isInShelf;
  final void Function()? onIsInShelfChanged;
  final void Function()? onReaderOpened;
  const InformationBottomView({
    super.key,
    required this.book,
    required this.isInShelf,
    this.onIsInShelfChanged,
    this.onReaderOpened,
  });

  @override
  Widget build(BuildContext context) {
    final padding = MediaQuery.of(context).padding;
    var children = [
      _buildShelfButton(),
      // const SizedBox(width: 8),
      // const Expanded(child: _ListenBook()),
      const SizedBox(width: 8),
      Expanded(child: _buildReaderButton()),
    ];
    return Container(
      color: Theme.of(context).colorScheme.surfaceTint.withValues(alpha: 0.05),
      padding: EdgeInsets.fromLTRB(16, 8, 16, padding.bottom + 8),
      child: Row(children: children),
    );
  }

  Widget _buildReaderButton() {
    final hasProgress = book.pageIndex != 0 || book.chapterIndex != 0;
    String readerText = hasProgress ? '继续阅读' : '立即阅读';
    return FilledButton(
      onPressed: onReaderOpened,
      child: Text(readerText),
    );
  }

  Widget _buildShelfButton() {
    final icon = Icon(
      isInShelf
          ? HugeIcons.strokeRoundedTick02
          : HugeIcons.strokeRoundedLibrary,
    );
    final shelfText = Text(isInShelf ? '已在书架' : '加入书架');
    return TextButton(
      onPressed: onIsInShelfChanged,
      child: Row(children: [icon, shelfText]),
    );
  }
}


// class _ListenBook extends StatelessWidget {
//   const _ListenBook();

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     final colorScheme = theme.colorScheme;
//     final primaryContainer = colorScheme.primaryContainer;
//     final onPrimaryContainer = colorScheme.onPrimaryContainer;
//     return Consumer(builder: (context, ref, child) {
//       return ElevatedButton(
//         style: ButtonStyle(
//           backgroundColor: WidgetStatePropertyAll(primaryContainer),
//           foregroundColor: WidgetStatePropertyAll(onPrimaryContainer),
//         ),
//         onPressed: () => navigate(context, ref),
//         child: const Text('听书'),
//       );
//     });
//   }

//   void navigate(BuildContext context, WidgetRef ref) async {
//     final notifier = ref.read(bookNotifierProvider.notifier);
//     await notifier.refreshCatalogue();
//     final book = ref.read(bookNotifierProvider);
//     if (!context.mounted) return;
//     final navigator = Navigator.of(context);
//     final route = MaterialPageRoute(builder: (context) {
//       return ListenerPage(book: book);
//     });
//     navigator.push(route);
//   }
// }