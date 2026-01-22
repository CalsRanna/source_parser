import 'package:source_parser/database/service.dart';
import 'package:source_parser/schema/layout.dart';

class LayoutService {
  Future<Layout?> getLayout() async {
    var laconic = DatabaseService.instance.laconic;
    var layouts = await laconic.table('layouts').get();
    if (layouts.isEmpty) return null;
    final json = layouts.first.toMap();
    return Layout(
      slot0: json['slot_0']?.toString() ?? '',
      slot1: json['slot_1']?.toString() ?? '',
      slot2: json['slot_2']?.toString() ?? '',
      slot3: json['slot_3']?.toString() ?? '',
      slot4: json['slot_4']?.toString() ?? '',
      slot5: json['slot_5']?.toString() ?? '',
      slot6: json['slot_6']?.toString() ?? '',
    );
  }

  Future<void> updateLayout(Layout layout) async {
    var laconic = DatabaseService.instance.laconic;
    await laconic.table('layouts').where('id', 1).update(layout.toJson());
  }

  Future<void> createLayout(Layout layout) async {
    var laconic = DatabaseService.instance.laconic;
    var json = layout.toJson();
    json.remove('id');
    await laconic.table('layouts').insert([json]);
  }
}
