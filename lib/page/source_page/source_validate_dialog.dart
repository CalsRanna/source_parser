import 'package:flutter/material.dart';
import 'package:source_parser/widget/loading.dart';

class SourceValidateDialog extends StatelessWidget {
  const SourceValidateDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return const UnconstrainedBox(
      child: SizedBox(
        height: 160,
        width: 320,
        child: Dialog(
          insetPadding: EdgeInsets.zero,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              LoadingIndicator(),
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Text('校验书源需要的时间比较长，请耐心等待'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
