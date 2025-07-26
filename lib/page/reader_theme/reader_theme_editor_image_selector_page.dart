import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:source_parser/config/string_config.dart';

@RoutePage()
class ReaderThemeEditorImageSelectorPage extends StatelessWidget {
  const ReaderThemeEditorImageSelectorPage({super.key});

  @override
  Widget build(BuildContext context) {
    var images = ['asset/image/kraft_paper.jpg', 'asset/image/kraft_paper.jpg'];
    return Scaffold(
      appBar: AppBar(
        title: const Text(StringConfig.backgroundImage),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 4,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () => Navigator.of(context).pop(images[index]),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                images[index],
                fit: BoxFit.cover,
                height: double.infinity,
                width: double.infinity,
              ),
            ),
          );
        },
        itemCount: images.length,
      ),
    );
  }
}
