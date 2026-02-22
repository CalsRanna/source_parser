class CloudChapterEntity {
  String url = '';
  String title = '';
  bool isVolume = false;
  String baseUrl = '';
  String bookUrl = '';
  int index = 0;
  String tag = '';

  CloudChapterEntity();

  CloudChapterEntity.fromJson(Map<String, dynamic> json) {
    url = json['url'] ?? '';
    title = json['title'] ?? '';
    isVolume = json['isVolume'] ?? false;
    baseUrl = json['baseUrl'] ?? '';
    bookUrl = json['bookUrl'] ?? '';
    index = json['index'] ?? 0;
    tag = json['tag'] ?? '';
  }

  Map<String, dynamic> toJson() {
    return {
      'url': url,
      'title': title,
      'isVolume': isVolume,
      'baseUrl': baseUrl,
      'bookUrl': bookUrl,
      'index': index,
      'tag': tag,
    };
  }
}
