import 'package:flutter/material.dart';

class About extends StatelessWidget {
  const About({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('关于我们')),
      body: const Center(
        child: Text('凤箫声动，玉壶光转，一夜鱼龙舞。'),
      ),
    );
  }
}
