import '../model/rule.dart';

extension GetBy on List<Rule?> {
  String? getBy(String name) {
    String? rule;
    for (var i = 0; i < length; i++) {
      if (this[i]?.name == name) {
        rule = this[i]?.value;
      }
    }
    return rule;
  }
}

extension ToJSON on List<Rule>? {
  Map<String, String?> toJson() {
    final map = <String, String?>{};
    if (this == null) {
      return {};
    } else {
      for (var i = 0; i < this!.length; i++) {
        map[this![i].name] = this![i].value;
      }
      return map;
    }
  }
}
