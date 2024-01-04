import 'package:cached_network/cached_network.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'cache.g.dart';

@riverpod
class CacheSize extends _$CacheSize {
  @override
  Future<String> build() async {
    return await _getCacheSize();
  }

  Future<bool> clear() async {
    final cleared = await CacheManager().clearCache();
    ref.invalidateSelf();
    return cleared;
  }

  Future<String> _getCacheSize() async {
    final total = await CacheManager().getCacheSize();
    String string;
    if (total < 1024) {
      string = '$total Bytes';
    } else if (total >= 1024 && total < 1024 * 1024) {
      string = '${(total / 1024).toStringAsFixed(2)} KB';
    } else {
      string = '${(total / 1024 / 1024).toStringAsFixed(2)} MB';
    }
    return string;
  }
}
