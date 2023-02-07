import 'package:creator/creator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:source_parser/state/explore.dart';
import 'package:source_parser/widget/bottom_bar.dart';

class Explore extends StatelessWidget {
  const Explore({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Watcher(((context, ref, child) {
            final sources = ref.watch(exploreBookSourcesEmitter.asyncData).data;
            final items = List.generate(
              sources?.length ?? 0,
              (index) => PopupMenuItem(
                value: sources![index].id.toString(),
                child: Row(children: [
                  Text(sources[index].name),
                ]),
              ),
            );

            return PopupMenuButton<String>(
              icon: const Icon(Icons.filter_alt_outlined),
              itemBuilder: (context) => items,
              offset: const Offset(0, 64),
              onSelected: (value) {},
            );
          })),
        ],
        centerTitle: true,
        title: const Text('发现'),
      ),
      body: Watcher(((context, ref, child) {
        final modules = ref.watch(exploreModulesEmitter.asyncData).data;
        if (modules == null) {
          return const Center(child: CupertinoActivityIndicator());
        } else {
          if (modules.isEmpty) {
            return const Center(child: Text('空空如也'));
          } else {
            return Text(modules.length.toString());
          }
        }
      })),
      bottomNavigationBar: const BottomBar(),
    );
  }
}
