import 'package:flutter/services.dart';

class VolumeUtil {
  static final _channel = const EventChannel('xyz.cals.source_parser/volume');

  static Stream<String>? _stream;

  static Stream<String> get stream {
    _stream ??= _channel.receiveBroadcastStream().cast<String>();
    return _stream!;
  }
}
