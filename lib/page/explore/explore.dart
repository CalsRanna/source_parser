import 'package:creator/creator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../state/explore.dart';
import '../../widget/bottom_bar.dart';

class Explore extends ConsumerWidget {
  const Explore({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Watcher(((context, ref, child) {
            final sources = ref.watch(exploreBookSourcesCreator.asyncData).data;

            var items = <PopupMenuItem<String>>[];
            if (sources != null) {
              for (var i = 0; i < sources.length; i++) {
                items.add(PopupMenuItem(
                  value: sources[i].id.toString(),
                  child: Row(children: [
                    Text(sources[i].name),
                  ]),
                ));
              }
            }
            return PopupMenuButton<String>(
              icon: const Icon(Icons.filter_alt_outlined),
              itemBuilder: (context) => items,
              offset: const Offset(0, 64),
              onSelected: (value) {},
            );
          })),
        ],
        title: const Text('发现'),
      ),
      body: Watcher(((context, ref, child) {
        final modules = ref.watch(exploreModulesState.asyncData).data;
        if (modules == null) {
          return const Center(child: CupertinoActivityIndicator());
        } else {
          if (modules.isEmpty) {
            return const Center(child: Text('暂无内容'));
          } else {
            return Text(modules.length.toString());
          }
        }
      })),
      bottomNavigationBar: BottomBar(),
    );
  }
}
