import 'package:flutter/material.dart';
import 'package:signals/signals.dart';
import 'package:signals/signals_flutter.dart' hide signal;
import 'package:source_parser/page/setting/setting_turning_mode_bottom_sheet.dart';
import 'package:source_parser/util/cache_network.dart';
import 'package:source_parser/util/shared_preference_util.dart';

class SettingViewModel {
  final turningMode = signal(0);
  final searchFilter = signal(false);
  final timeout = signal(30);
  final maxConcurrent = signal(16);
  final cacheDuration = signal(8);
  final eInkMode = signal(false);
  final cacheSize = signal('');

  Future<void> initSignals() async {
    turningMode.value = await SharedPreferenceUtil.getTurningMode();
    searchFilter.value = await SharedPreferenceUtil.getSearchFilter();
    timeout.value = await SharedPreferenceUtil.getTimeout();
    maxConcurrent.value = await SharedPreferenceUtil.getMaxConcurrent();
    cacheDuration.value = await SharedPreferenceUtil.getCacheDuration();
    eInkMode.value = await SharedPreferenceUtil.getEInkMode();
    final total = await CacheManager().getCacheSize();
    String string;
    if (total < 1024) {
      string = '$total Bytes';
    } else if (total >= 1024 && total < 1024 * 1024) {
      string = '${(total / 1024).toStringAsFixed(2)} KB';
    } else {
      string = '${(total / 1024 / 1024).toStringAsFixed(2)} MB';
    }
    cacheSize.value = string;
  }

  Future<void> openTurningModeBottomSheet(BuildContext context) async {
    var sheet = Watch(
      (_) => SettingTurningModeBottomSheet(
        mode: turningMode.value,
        onSelected: _updateTurningMode,
      ),
    );
    await showModalBottomSheet(
      builder: (_) => sheet,
      context: context,
      showDragHandle: true,
    );
  }

  Future<void> updateSearchFilter(bool value) async {
    searchFilter.value = value;
    await SharedPreferenceUtil.setSearchFilter(value);
  }

  void _updateTurningMode(int value) async {
    if (turningMode.value & value != 0) {
      turningMode.value -= value;
    } else {
      turningMode.value += value;
    }
    await SharedPreferenceUtil.setTurningMode(turningMode.value);
  }
}
