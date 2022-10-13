import 'package:freezed_annotation/freezed_annotation.dart';

part 'history.freezed.dart';

@freezed
class History with _$History {
  const factory History({
    required String? name,
  }) = _History;
}
