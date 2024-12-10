import 'package:flutter/material.dart' hide Theme;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:source_parser/provider/theme.dart';
import 'package:source_parser/schema/theme.dart';

class ReaderBackground extends ConsumerWidget {
  const ReaderBackground({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var theme = ref.watch(themeNotifierProvider).valueOrNull;
    theme ??= Theme();
    var container = _buildContainer(theme.backgroundColor);
    var image = _buildImage(theme.backgroundImage);
    return Stack(children: [container, image]);
  }

  Widget _buildContainer(int backgroundColorValue) {
    return Container(
      color: Color(backgroundColorValue),
      height: double.infinity,
      width: double.infinity,
    );
  }

  Widget _buildImage(String backgroundImage) {
    if (backgroundImage.isEmpty) return const SizedBox();
    return Image.asset(
      backgroundImage,
      fit: BoxFit.cover,
      height: double.infinity,
      width: double.infinity,
    );
  }
}
