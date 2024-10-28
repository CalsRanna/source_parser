import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:source_parser/provider/book.dart';

class SearchIndicator extends ConsumerWidget {
  final String credential;
  const SearchIndicator(this.credential, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var loadingProvider = searchLoadingProvider(credential);
    var loading = ref.watch(loadingProvider);
    if (loading) return const Center(child: CircularProgressIndicator());
    return Center(child: Text('没有找到相关书籍'));
  }
}
