import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class BookCover extends StatelessWidget {
  const BookCover({
    Key? key,
    this.borderRadius = 4,
    this.height = 120,
    this.width = 90,
    required this.url,
  }) : super(key: key);

  final double? borderRadius;
  final double height;
  final double width;
  final String url;

  @override
  Widget build(BuildContext context) {
    BoxDecoration? decoration;
    if (borderRadius != null) {
      decoration = BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius!),
      );
    }
    return Container(
      decoration: decoration,
      child: CachedNetworkImage(
        width: width,
        height: height,
        fit: BoxFit.cover,
        imageUrl: url,
        errorWidget: (context, url, error) => Image.asset(
          'asset/image/default_cover.jpg',
          fit: BoxFit.cover,
        ),
        placeholder: (context, url) => Image.asset(
          'asset/image/default_cover.jpg',
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
