import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../database/database.dart';

// final currentIndexOfBottomBarProvider = StateProvider((ref) => 0);

// final currentColorProvider =
//     StateProvider<int>((ref) => Hive.box('setting').get('theme') ?? 0);

// final databaseProvider = StateProvider<MyDatabase?>((ref) => null);

part 'global.freezed.dart';

@freezed
class GlobalState with _$GlobalState {
  const factory GlobalState({
    required int color,
    required AppDatabase? database,
    required int index,
  }) = _GlobalState;
}

class GlobalStateNotifier extends StateNotifier<GlobalState> {
  GlobalStateNotifier()
      : super(GlobalState(
          color: Hive.box('setting').get('theme') ?? 0,
          database: null,
          index: 0,
        ));

  void updateColor(int theme) {
    state = state.copyWith(color: theme);
  }

  void initDatabase(AppDatabase database) {
    state = state.copyWith(database: database);
  }

  void updateIndex(int index) {
    state = state.copyWith(index: index);
  }
}

final globalState = StateNotifierProvider<GlobalStateNotifier, GlobalState>(
    (ref) => GlobalStateNotifier());
