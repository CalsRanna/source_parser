import 'package:flutter/widgets.dart';
import 'package:signals/signals.dart';
import 'package:source_parser/database/replacement_service.dart';
import 'package:source_parser/model/replacement_entity.dart';
import 'package:source_parser/page/reader_replacement/reader_replacement_bottom_sheet.dart';
import 'package:source_parser/router/router.gr.dart';
import 'package:source_parser/util/dialog_util.dart';

class ReaderReplacementViewModel {
  final replacements = signal<List<ReplacementEntity>>([]);

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

  Future<void> deleteReplacement(ReplacementEntity replacement) async {
    await ReplacementService().deleteReplacement(replacement);
    replacements.value = await ReplacementService().getReplacementsByBookId(
      replacement.bookId,
    );
  }

  Future<void> initSignals(int bookId) async {
    replacements.value =
        await ReplacementService().getReplacementsByBookId(bookId);
  }

  void openBottomSheet(BuildContext context, int index) {
    var replacement = replacements.value[index];
    var bottomSheet = ReaderReplacementBottomSheet(
      onDelete: () => deleteReplacement(replacement),
      replacement: replacement,
    );
    DialogUtil.openBottomSheet(bottomSheet);
  }
}
