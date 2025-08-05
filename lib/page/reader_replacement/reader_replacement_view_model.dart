import 'package:flutter/widgets.dart';
import 'package:signals/signals.dart';
import 'package:source_parser/database/replacement_service.dart';
import 'package:source_parser/model/replacement_entity.dart';
import 'package:source_parser/router/router.gr.dart';

class ReaderReplacementViewModel {
  final replacements = signal<List<ReplacementEntity>>([]);

  Future<void> initSignals(int bookId) async {
    replacements.value =
        await ReplacementService().getReplacementsByBookId(bookId);
  }

  Future<void> addReplacement(BuildContext context, int bookId) async {
    var replacement =
        await ReaderReplacementFormRoute().push<ReplacementEntity>(context);
    if (replacement == null) return;
    var copiedReplacement = replacement.copyWith(bookId: bookId);
    await ReplacementService().addReplacement(copiedReplacement);
    replacements.value = await ReplacementService().getReplacementsByBookId(
      bookId,
    );
  }
}
