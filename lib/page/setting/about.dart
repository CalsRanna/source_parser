import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class About extends ConsumerWidget {
  const About({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('关于我们')),
      body: const Center(
        child: Text('凤箫声动，玉壶光转，一夜鱼龙舞。'),
      ),
    );
  }
}
