class CloudSearchBookEntity {
  String bookUrl = '';
  String origin = '';
  String originName = '';
  String name = '';
  String author = '';
  String kind = '';
  String coverUrl = '';
  String intro = '';
  String latestChapterTitle = '';
  String wordCount = '';
  String tocUrl = '';
  int type = 0;

  CloudSearchBookEntity();

  CloudSearchBookEntity.fromJson(Map<String, dynamic> json) {
    bookUrl = json['bookUrl'] ?? '';
    origin = json['origin'] ?? '';
    originName = json['originName'] ?? '';
    name = json['name'] ?? '';
    author = json['author'] ?? '';
    kind = json['kind'] ?? '';
    coverUrl = json['coverUrl'] ?? '';
    intro = json['intro'] ?? '';
    latestChapterTitle = json['latestChapterTitle'] ?? '';
    wordCount = json['wordCount'] ?? '';
    tocUrl = json['tocUrl'] ?? '';
    type = json['type'] ?? 0;
  }

  Map<String, dynamic> toJson() {
    return {
      'bookUrl': bookUrl,
      'origin': origin,
      'originName': originName,
      'name': name,
      'author': author,
      'kind': kind,
      'coverUrl': coverUrl,
      'intro': intro,
      'latestChapterTitle': latestChapterTitle,
      'wordCount': wordCount,
      'tocUrl': tocUrl,
      'type': type,
    };
  }
}
