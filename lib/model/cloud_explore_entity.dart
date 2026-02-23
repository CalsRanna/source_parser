import 'package:source_parser/model/cloud_search_book_entity.dart';

class CloudExploreResult {
  final String layout;
  final String title;
  final List<CloudExploreBook> books;

  CloudExploreResult({
    required this.layout,
    required this.title,
    required this.books,
  });
}

class CloudExploreCategory {
  String title;
  String url;

  CloudExploreCategory({required this.title, required this.url});

  factory CloudExploreCategory.fromJson(Map<String, dynamic> json) {
    return CloudExploreCategory(
      title: json['title']?.toString() ?? '',
      url: json['url']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'title': title, 'url': url};
  }
}

class CloudExploreSource {
  String bookSourceUrl;
  String bookSourceName;
  List<CloudExploreCategory> exploreCategories;

  CloudExploreSource({
    required this.bookSourceUrl,
    required this.bookSourceName,
    required this.exploreCategories,
  });

  factory CloudExploreSource.fromJson(Map<String, dynamic> json) {
    var exploreUrl = json['exploreUrl']?.toString() ?? '';
    var categories = <CloudExploreCategory>[];

    // Parse exploreUrl - format: "title1::url1&&title2::url2&&..." or "title1::url1\ntitle2::url2"
    if (exploreUrl.isNotEmpty) {
      var separators = ['&&', '\n', '||'];
      List<String> parts = [];
      for (var sep in separators) {
        if (exploreUrl.contains(sep)) {
          parts = exploreUrl.split(sep);
          break;
        }
      }
      if (parts.isEmpty && exploreUrl.contains('::')) {
        parts = [exploreUrl];
      }
      for (var part in parts) {
        var trimmed = part.trim();
        if (trimmed.isEmpty) continue;
        var categorySeparators = ['::', '##', '|'];
        for (var catSep in categorySeparators) {
          if (trimmed.contains(catSep)) {
            var idx = trimmed.indexOf(catSep);
            var title = trimmed.substring(0, idx).trim();
            var url = trimmed.substring(idx + catSep.length).trim();
            if (title.isNotEmpty && url.isNotEmpty) {
              categories.add(
                CloudExploreCategory(title: title, url: url),
              );
            }
            break;
          }
        }
      }
    }

    return CloudExploreSource(
      bookSourceUrl: json['bookSourceUrl']?.toString() ?? '',
      bookSourceName: json['bookSourceName']?.toString() ?? '',
      exploreCategories: categories,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bookSourceUrl': bookSourceUrl,
      'bookSourceName': bookSourceName,
      'exploreCategories':
          exploreCategories.map((c) => c.toJson()).toList(),
    };
  }
}

class CloudExploreBook {
  String bookUrl;
  String name;
  String author;
  String coverUrl;
  String intro;
  String kind;
  String latestChapterTitle;
  String wordCount;
  String tocUrl;
  String origin;
  String originName;

  CloudExploreBook({
    this.bookUrl = '',
    this.name = '',
    this.author = '',
    this.coverUrl = '',
    this.intro = '',
    this.kind = '',
    this.latestChapterTitle = '',
    this.wordCount = '',
    this.tocUrl = '',
    this.origin = '',
    this.originName = '',
  });

  factory CloudExploreBook.fromJson(Map<String, dynamic> json) {
    return CloudExploreBook(
      bookUrl: json['bookUrl']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      author: json['author']?.toString() ?? '',
      coverUrl: json['coverUrl']?.toString() ?? '',
      intro: json['intro']?.toString() ?? '',
      kind: json['kind']?.toString() ?? '',
      latestChapterTitle: json['latestChapterTitle']?.toString() ?? '',
      wordCount: json['wordCount']?.toString() ?? '',
      tocUrl: json['tocUrl']?.toString() ?? '',
      origin: json['origin']?.toString() ?? '',
      originName: json['originName']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bookUrl': bookUrl,
      'name': name,
      'author': author,
      'coverUrl': coverUrl,
      'intro': intro,
      'kind': kind,
      'latestChapterTitle': latestChapterTitle,
      'wordCount': wordCount,
      'tocUrl': tocUrl,
      'origin': origin,
      'originName': originName,
    };
  }

  CloudSearchBookEntity toSearchBook() {
    return CloudSearchBookEntity()
      ..bookUrl = bookUrl
      ..name = name
      ..author = author
      ..coverUrl = coverUrl
      ..intro = intro
      ..kind = kind
      ..latestChapterTitle = latestChapterTitle
      ..wordCount = wordCount
      ..tocUrl = tocUrl
      ..origin = origin
      ..originName = originName;
  }
}
