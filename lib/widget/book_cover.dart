import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:source_parser/provider/book.dart';
import 'package:source_parser/schema/book.dart';
import 'package:source_parser/widget/loading.dart';

class BookCover extends StatelessWidget {
  final double borderRadius;
  final double height;
  final double width;
  final String url;

  const BookCover({
    super.key,
    this.borderRadius = 4,
    this.height = 96,
    this.width = 72,
    required this.url,
  });

  @override
  Widget build(BuildContext context) {
    final defaultCover = Image.asset(
      'asset/image/default_cover.jpg',
      fit: BoxFit.cover,
    );
    final cachedNetworkImage = CachedNetworkImage(
      errorWidget: (context, url, error) => defaultCover,
      fit: BoxFit.cover,
      height: height,
      imageUrl: url,
      placeholder: (context, url) => defaultCover,
      width: width,
    );
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: cachedNetworkImage,
    );
  }
}

class BookCoverSelector extends ConsumerStatefulWidget {
  final Book book;

  const BookCoverSelector({super.key, required this.book});

  @override
  ConsumerState<BookCoverSelector> createState() => _BookCoverSelectorState();
}

class _BookCoverSelectorState extends ConsumerState<BookCoverSelector> {
  bool loading = true;
  List<String> covers = [];

  @override
  Widget build(BuildContext context) {
    final provider = ref.watch(bookCoversProvider);
    return switch (provider) {
      AsyncData(:final value) => _buildAsyncData(value),
      AsyncError(:final error) => Center(child: Text(error.toString())),
      AsyncLoading() => const Center(child: LoadingIndicator()),
      _ => const SizedBox(),
    };
  }

  void getCovers(WidgetRef ref) async {
    setState(() {
      loading = true;
    });
    final notifier = ref.read(bookNotifierProvider.notifier);
    final covers = await notifier.getCovers();
    setState(() {
      this.covers = covers;
      loading = false;
    });
  }

  void handleTap(WidgetRef ref, String cover) async {
    final notifier = ref.read(bookNotifierProvider.notifier);
    notifier.refreshCover(cover);
    Navigator.of(context).pop();
  }

  @override
  void initState() {
    super.initState();
    getCovers(ref);
  }

  GridView _buildAsyncData(List<String> covers) {
    const delegate = SliverGridDelegateWithFixedCrossAxisCount(
      childAspectRatio: 3 / 4,
      crossAxisCount: 3,
      crossAxisSpacing: 8,
      mainAxisSpacing: 8,
    );
    return GridView.builder(
      gridDelegate: delegate,
      itemBuilder: (context, index) => _itemBuilder(covers, index),
      itemCount: covers.length,
      padding: const EdgeInsets.all(16),
    );
  }

  Widget _itemBuilder(List<String> covers, int index) {
    return GestureDetector(
      onTap: () => handleTap(ref, covers[index]),
      child: BookCover(height: 120, url: covers[index], width: 90),
    );
  }
}
