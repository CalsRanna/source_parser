import 'package:battery_plus/battery_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'battery.g.dart';

@riverpod
class BatteryNotifier extends _$BatteryNotifier {
  @override
  int build() => 100;

  Future<void> updateBattery() async {
    state = await Battery().batteryLevel;
  }
}
