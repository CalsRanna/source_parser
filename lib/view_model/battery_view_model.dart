import 'package:battery_plus/battery_plus.dart';
import 'package:signals/signals_flutter.dart';

class BatteryViewModel {
  final batteryLevel = signal<int>(100);
  final isCharging = signal(false);

  BatteryViewModel();

  Future<void> initSignals() async {
    batteryLevel.value = await Battery().batteryLevel;
    isCharging.value = await Battery().batteryState == BatteryState.charging;
  }

  String get batteryLevelText {
    return '${batteryLevel.value}%';
  }

  String get batteryStatusText {
    if (batteryLevel.value < 20) {
      return '电量极低';
    } else if (batteryLevel.value < 50) {
      return '电量较低';
    } else if (batteryLevel.value < 80) {
      return '电量充足';
    } else {
      return '电量满';
    }
  }
}
