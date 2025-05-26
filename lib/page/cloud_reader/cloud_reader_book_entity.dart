class CloudReaderBookEntity {
  String bookUrl = '';
  String tocUrl = '';
  String origin = '';
  String originName = '';
  String name = '';
  String author = '';
  String kind = '';
  String coverUrl = '';
  String intro = '';
  int type = 0;
  int group = 0;
  String latestChapterTitle = '';
  int latestChapterTime = 0;
  int lastCheckTime = 0;
  int lastCheckCount = 0;
  int totalChapterNum = 0;
  String durChapterTitle = '';
  int durChapterIndex = 0;
  int durChapterPos = 0;
  int durChapterTime = 0;
  String wordCount = '';
  bool canUpdate = false;
  int order = 0;
  int originOrder = 0;
  bool useReplaceRule = false;
  bool isInShelf = false;

  CloudReaderBookEntity();

  CloudReaderBookEntity.fromJson(Map<String, dynamic> json) {
    bookUrl = json['bookUrl'];
    tocUrl = json['tocUrl'];
    origin = json['origin'];
    originName = json['originName'];
    name = json['name'];
    author = json['author'];
    kind = json['kind'];
    coverUrl = json['coverUrl'];
    intro = json['intro'];
    type = json['type'];
    group = json['group'];
    latestChapterTitle = json['latestChapterTitle'];
    latestChapterTime = json['latestChapterTime'];
    lastCheckTime = json['lastCheckTime'];
    lastCheckCount = json['lastCheckCount'];
    totalChapterNum = json['totalChapterNum'];
    durChapterTitle = json['durChapterTitle'];
    durChapterIndex = json['durChapterIndex'];
    durChapterPos = json['durChapterPos'];
    durChapterTime = json['durChapterTime'];
    wordCount = json['wordCount'];
    canUpdate = json['canUpdate'];
    order = json['order'];
    originOrder = json['originOrder'];
    useReplaceRule = json['useReplaceRule'];
    isInShelf = json['isInShelf'];
  }

  CloudReaderBookEntity copyWith({
    String? bookUrl,
    String? tocUrl,
    String? origin,
    String? originName,
    String? name,
    String? author,
    String? kind,
    String? coverUrl,
    String? intro,
    int? type,
    int? group,
    String? latestChapterTitle,
    int? latestChapterTime,
    int? lastCheckTime,
    int? lastCheckCount,
    int? totalChapterNum,
    String? durChapterTitle,
    int? durChapterIndex,
    int? durChapterPos,
    int? durChapterTime,
    String? wordCount,
    bool? canUpdate,
    int? order,
    int? originOrder,
    bool? useReplaceRule,
    bool? isInShelf,
  }) {
    return CloudReaderBookEntity()
      ..bookUrl = bookUrl ?? this.bookUrl
      ..tocUrl = tocUrl ?? this.tocUrl
      ..origin = origin ?? this.origin
      ..originName = originName ?? this.originName
      ..name = name ?? this.name
      ..author = author ?? this.author
      ..kind = kind ?? this.kind
      ..coverUrl = coverUrl ?? this.coverUrl
      ..intro = intro ?? this.intro
      ..type = type ?? this.type
      ..group = group ?? this.group
      ..latestChapterTitle = latestChapterTitle ?? this.latestChapterTitle
      ..latestChapterTime = latestChapterTime ?? this.latestChapterTime
      ..lastCheckTime = lastCheckTime ?? this.lastCheckTime
      ..lastCheckCount = lastCheckCount ?? this.lastCheckCount
      ..totalChapterNum = totalChapterNum ?? this.totalChapterNum
      ..durChapterTitle = durChapterTitle ?? this.durChapterTitle
      ..durChapterIndex = durChapterIndex ?? this.durChapterIndex
      ..durChapterPos = durChapterPos ?? this.durChapterPos
      ..durChapterTime = durChapterTime ?? this.durChapterTime
      ..wordCount = wordCount ?? this.wordCount
      ..canUpdate = canUpdate ?? this.canUpdate
      ..order = order ?? this.order
      ..originOrder = originOrder ?? this.originOrder
      ..useReplaceRule = useReplaceRule ?? this.useReplaceRule
      ..isInShelf = isInShelf ?? this.isInShelf;
  }

  Map<String, dynamic> toJson() {
    return {
      'bookUrl': bookUrl,
      'tocUrl': tocUrl,
      'origin': origin,
      'originName': originName,
      'name': name,
      'author': author,
      'kind': kind,
      'coverUrl': coverUrl,
      'intro': intro,
      'type': type,
      'group': group,
      'latestChapterTitle': latestChapterTitle,
      'latestChapterTime': latestChapterTime,
      'lastCheckTime': lastCheckTime,
      'lastCheckCount': lastCheckCount,
      'totalChapterNum': totalChapterNum,
      'durChapterTitle': durChapterTitle,
      'durChapterIndex': durChapterIndex,
      'durChapterPos': durChapterPos,
      'durChapterTime': durChapterTime,
      'wordCount': wordCount,
      'canUpdate': canUpdate,
      'order': order,
      'originOrder': originOrder,
      'useReplaceRule': useReplaceRule,
      'isInShelf': isInShelf,
    };
  }
}
