import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

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
