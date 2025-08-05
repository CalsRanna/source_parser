import 'package:flutter/widgets.dart';
import 'package:signals/signals.dart';
import 'package:source_parser/model/replacement_entity.dart';
import 'package:source_parser/router/router.gr.dart';

class ReaderReplacementFormViewModel {
  final from = signal<String>('');
  final to = signal<String>('');

  void complete(BuildContext context) {
    var replacement = ReplacementEntity()
      ..source = from.value
      ..target = to.value;
    Navigator.of(context).pop(replacement);
  }

  Future<void> navigateReaderReplacementFormInputPage(
    BuildContext context, {
    required String field,
  }) async {
    var title = switch (field) {
      'from' => '原文',
      'to' => '替换后',
      _ => '原文',
    };
    var value = switch (field) {
      'from' => from.value,
      'to' => to.value,
      _ => '',
    };
    var result =
        await ReaderReplacementFormInputRoute(title: title, value: value)
            .push(context);
    if (result == null) return;
    if (field == 'from') from.value = result;
    if (field == 'to') to.value = result;
  }
}
