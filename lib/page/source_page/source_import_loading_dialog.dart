import 'package:flutter/material.dart';
import 'package:source_parser/widget/loading.dart';

class SourceImportLoadingDialog extends StatelessWidget {
  const SourceImportLoadingDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return const UnconstrainedBox(
      child: SizedBox(
        height: 160,
        width: 160,
        child: Dialog(
          insetPadding: EdgeInsets.zero,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              LoadingIndicator(),
              SizedBox(height: 16),
              Text('正在加载'),
            ],
          ),
        ),
      ),
    );
  }
}
