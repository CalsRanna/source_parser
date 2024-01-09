class CacheProgress {
  final int amount;
  final int succeed;
  final int failed;

  CacheProgress({this.amount = 0, this.succeed = 0, this.failed = 0});

  double get progress => amount == 0 ? 0 : (succeed + failed) / amount;

  CacheProgress copyWith({
    int? amount,
    int? succeed,
    int? failed,
  }) {
    return CacheProgress(
      amount: amount ?? this.amount,
      succeed: succeed ?? this.succeed,
      failed: failed ?? this.failed,
    );
  }
}
