import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:signals/signals_flutter.dart';
import 'package:source_parser/page/reader_replacement_form_page/reader_replacement_form_view_model.dart';

@RoutePage()
class ReaderReplacementFormPage extends StatefulWidget {
  const ReaderReplacementFormPage({super.key});

  @override
  State<ReaderReplacementFormPage> createState() =>
      _ReaderReplacementFormPageState();
}

class _ReaderReplacementFormPageState extends State<ReaderReplacementFormPage> {
  final viewModel = GetIt.instance.get<ReaderReplacementFormViewModel>();

  @override
  Widget build(BuildContext context) {
    var iconButton = IconButton(
      onPressed: () => viewModel.complete(context),
      icon: Icon(HugeIcons.strokeRoundedTick02),
    );
    return Scaffold(
      appBar: AppBar(actions: [iconButton], title: const Text('新增替换')),
      body: ListView(
        children: [
          Watch(
            (_) => ListTile(
              onTap: () => viewModel.navigateReaderReplacementFormInputPage(
                  context,
                  field: 'from'),
              title: const Text('原文'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(viewModel.from.value),
                  const Icon(HugeIcons.strokeRoundedArrowRight01),
                ],
              ),
            ),
          ),
          Watch(
            (_) => ListTile(
              onTap: () => viewModel
                  .navigateReaderReplacementFormInputPage(context, field: 'to'),
              title: const Text('替换后'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(viewModel.to.value),
                  const Icon(HugeIcons.strokeRoundedArrowRight01),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
