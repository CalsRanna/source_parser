class CloudChapterEntity {
  String url = '';
  String title = '';
  bool isVolume = false;
  String baseUrl = '';
  String bookUrl = '';
  int index = 0;
  String tag = '';

  CloudChapterEntity();

  CloudChapterEntity.fromDb(Map<String, dynamic> map) {
    url = map['url'] ?? '';
    title = map['title'] ?? '';
    isVolume = (map['is_volume'] ?? 0) == 1;
    baseUrl = map['base_url'] ?? '';
    bookUrl = map['book_url'] ?? '';
    index = map['chapter_index'] ?? 0;
    tag = map['tag'] ?? '';
  }

  Map<String, dynamic> toDb() {
    return {
      'url': url,
      'title': title,
      'is_volume': isVolume ? 1 : 0,
      'base_url': baseUrl,
      'book_url': bookUrl,
      'chapter_index': index,
      'tag': tag,
    };
  }

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
