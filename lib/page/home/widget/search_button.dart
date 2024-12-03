import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:source_parser/router/router.gr.dart';

class SearchButton extends StatelessWidget {
  const SearchButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => handleTap(context),
      icon: const Icon(HugeIcons.strokeRoundedSearch01),
    );
  }

  void handleTap(BuildContext context) {
    AutoRouter.of(context).push(SearchRoute());
  }
}
