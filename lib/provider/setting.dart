import 'package:isar/isar.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:source_parser/schema/isar.dart';
import 'package:source_parser/schema/setting.dart';
import 'package:source_parser/schema/theme.dart';

part 'setting.g.dart';

@riverpod
class SettingNotifier extends _$SettingNotifier {
  @override
  Future<Setting> build() async {
    var setting = await isar.settings.where().findFirst();
    if (setting == null) {
      setting = Setting();
      await isar.writeTxn(() async {
        await isar.settings.put(setting!);
      });
    }
    return setting;
  }

  void toggleDarkMode() async {
    final setting = await future;
    setting.darkMode = !setting.darkMode;
    await isar.writeTxn(() async {
      await isar.settings.put(setting);
    });
    ref.invalidateSelf();
  }

  void updateEInkMode(bool value) async {
    final setting = await future;
    setting.eInkMode = value;
    await isar.writeTxn(() async {
      await isar.settings.put(setting);
    });
    ref.invalidateSelf();
  }

  void updateTurningMode(int value) async {
    final setting = await future;
    if (setting.turningMode & value != 0) {
      setting.turningMode -= value;
    } else {
      setting.turningMode += value;
    }
    await isar.writeTxn(() async {
      await isar.settings.put(setting);
    });
    ref.invalidateSelf();
  }

  void updateTimeout(int value) async {
    final setting = await future;
    setting.timeout = value;
    await isar.writeTxn(() async {
      await isar.settings.put(setting);
    });
    ref.invalidateSelf();
  }

  void updateShelfMode(String mode) async {
    final setting = await future;
    setting.shelfMode = mode;
    await isar.writeTxn(() async {
      await isar.settings.put(setting);
    });
    ref.invalidateSelf();
  }

  void updateExploreSource(int source) async {
    final setting = await future;
    setting.exploreSource = source;
    await isar.writeTxn(() async {
      await isar.settings.put(setting);
    });
    ref.invalidateSelf();
  }

  void updateMaxConcurrent(double concurrent) async {
    final setting = await future;
    setting.maxConcurrent = concurrent;
    await isar.writeTxn(() async {
      await isar.settings.put(setting);
    });
    ref.invalidateSelf();
  }

  void updateCacheDuration(double duration) async {
    final setting = await future;
    setting.cacheDuration = duration;
    await isar.writeTxn(() async {
      await isar.settings.put(setting);
    });
    ref.invalidateSelf();
  }

  // void updateLineSpace(double lineSpace) async {
  //   final setting = await future;
  //   setting.lineSpace = lineSpace;
  //   await isar.writeTxn(() async {
  //     await isar.settings.put(setting);
  //   });
  //   ref.invalidateSelf();
  // }

  // void updateFontSize(int step) async {
  //   final setting = await future;
  //   var fontSize = setting.fontSize;
  //   setting.fontSize = (fontSize + step).clamp(12, 48);
  //   await isar.writeTxn(() async {
  //     await isar.settings.put(setting);
  //   });
  //   ref.invalidateSelf();
  // }

  // void updateBackgroundColor(int colorValue) async {
  //   final setting = await future;
  //   setting.backgroundColor = colorValue;
  //   await isar.writeTxn(() async {
  //     await isar.settings.put(setting);
  //   });
  //   ref.invalidateSelf();
  // }

  void updateSearchFilter(bool value) async {
    final setting = await future;
    setting.searchFilter = value;
    await isar.writeTxn(() async {
      await isar.settings.put(setting);
    });
    ref.invalidateSelf();
  }

  void selectTheme(Theme theme) async {
    final setting = await future;
    if (setting.themeId == theme.id) return;
    setting.themeId = theme.id!;
    await isar.writeTxn(() async {
      await isar.settings.put(setting);
    });
    ref.invalidateSelf();
  }

  void migrate() async {
    var setting = await future;
    // if (setting.backgroundColor.isNegative) {
    //   setting.backgroundColor = Colors.white.value;
    // }
    if (setting.cacheDuration.isNaN) {
      setting.cacheDuration = 4.0;
    }
    // if (setting.fontSize.isNegative) {
    //   setting.fontSize = 18;
    // }
    // if (setting.lineSpace.isNaN) {
    //   setting.lineSpace = 1.0 + 0.618 * 2;
    // }
    if (setting.maxConcurrent.isNaN) {
      setting.maxConcurrent = 16.0;
    }
    if (setting.shelfMode.isEmpty) {
      setting.shelfMode = 'list';
    }
    if (setting.timeout.isNegative) {
      setting.timeout = 30 * 1000;
    }
    if (setting.turningMode.isNegative) {
      setting.turningMode = 3;
    }
    await isar.writeTxn(() async {
      await isar.settings.put(setting);
    });
    ref.invalidateSelf();
  }
}
