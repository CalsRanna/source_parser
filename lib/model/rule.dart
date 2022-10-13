import 'package:floor/floor.dart';

@Entity(tableName: 'rules')
class Rule {
  @PrimaryKey(autoGenerate: true)
  final int? id;
  final String name;
  @ColumnInfo(name: 'source_id')
  final int? sourceId;
  final String? value;
  // IntColumn get id => integer().autoIncrement()();
  // TextColumn get name => text()();
  // IntColumn get sourceId => integer()();
  // TextColumn get value => text().nullable()();
  Rule(this.id, this.name, this.sourceId, this.value);

  Rule.bean({this.id, this.name = '', this.sourceId, this.value});
}

class SearchRule {
  final String? author;
  final String? checkKeyWord;
  final String? books;
  final String? url;
  final String? cover;
  final String? introduction;
  final String? category;
  final String? latestChapter;
  final String? name;
  final String? words;

  SearchRule(
      this.author,
      this.checkKeyWord,
      this.books,
      this.url,
      this.cover,
      this.introduction,
      this.category,
      this.latestChapter,
      this.name,
      this.words);

  SearchRule.bean({
    this.author,
    this.checkKeyWord,
    this.books,
    this.url,
    this.cover,
    this.introduction,
    this.category,
    this.latestChapter,
    this.name,
    this.words,
  });

  SearchRule.fromJson(Map<String, String?> json)
      : author = json['search_author'],
        checkKeyWord = json['search_check_key_word'],
        books = json['search_books'],
        url = json['search_url'],
        cover = json['search_cover'],
        introduction = json['search_introduction'],
        category = json['search_category'],
        latestChapter = json['search_latest_chapter'],
        name = json['search_name'],
        words = json['search_words'];

  SearchRule copyWith({
    String? author,
    String? checkKeyWord,
    String? books,
    String? url,
    String? cover,
    String? introduction,
    String? category,
    String? latestChapter,
    String? name,
    String? words,
  }) {
    return SearchRule(
      author ?? this.author,
      checkKeyWord ?? this.checkKeyWord,
      books ?? this.books,
      url ?? this.url,
      cover ?? this.cover,
      introduction ?? this.introduction,
      category ?? this.category,
      latestChapter ?? this.latestChapter,
      name ?? this.name,
      words ?? this.words,
    );
  }

  Map<String, String?> toJson() {
    final map = <String, String?>{};
    map['search_author'] = author;
    map['search_check_key_word'] = checkKeyWord;
    map['search_books'] = books;
    map['search_url'] = url;
    map['search_cover'] = cover;
    map['search_introduction'] = introduction;
    map['search_category'] = category;
    map['search_latest_chapter'] = latestChapter;
    map['search_name'] = name;
    map['search_words'] = words;
    return map;
  }
}

class ExploreRule {
  final String? author;
  final String? books;
  final String? url;
  final String? cover;
  final String? introduction;
  final String? category;
  final String? latestChapter;
  final String? name;
  final String? words;

  ExploreRule(
    this.author,
    this.books,
    this.url,
    this.cover,
    this.introduction,
    this.category,
    this.latestChapter,
    this.name,
    this.words,
  );

  ExploreRule.bean({
    this.author,
    this.books,
    this.url,
    this.cover,
    this.introduction,
    this.category,
    this.latestChapter,
    this.name,
    this.words,
  });

  ExploreRule.fromJson(Map<String, String?> json)
      : author = json['explore_author'],
        books = json['explore_books'],
        url = json['explore_url'],
        cover = json['explore_cover'],
        introduction = json['explore_introduction'],
        category = json['explore_category'],
        latestChapter = json['explore_latest_chapter'],
        name = json['explore_name'],
        words = json['explore_words'];

  ExploreRule copyWith({
    String? author,
    String? checkKeyWord,
    String? books,
    String? url,
    String? cover,
    String? introduction,
    String? category,
    String? latestChapter,
    String? name,
    String? words,
  }) {
    return ExploreRule(
      author ?? this.author,
      books ?? this.books,
      url ?? this.url,
      cover ?? this.cover,
      introduction ?? this.introduction,
      category ?? this.category,
      latestChapter ?? this.latestChapter,
      name ?? this.name,
      words ?? this.words,
    );
  }

  Map<String, String?> toJson() {
    final map = <String, String?>{};
    map['explore_author'] = author;
    map['explore_books'] = books;
    map['explore_url'] = url;
    map['explore_cover'] = cover;
    map['explore_introduction'] = introduction;
    map['explore_category'] = category;
    map['explore_latest_chapter'] = latestChapter;
    map['explore_name'] = name;
    map['explore_words'] = words;
    return map;
  }
}

class InformationRule {
  final String? author;
  final String? category;
  final String? catalogueUrl;
  final String? cover;
  final String? introduction;
  final String? latestChapter;
  final String? name;
  final String? preprocess;
  final String? words;

  InformationRule(
    this.author,
    this.category,
    this.catalogueUrl,
    this.cover,
    this.introduction,
    this.latestChapter,
    this.name,
    this.preprocess,
    this.words,
  );

  InformationRule.bean({
    this.author,
    this.category,
    this.catalogueUrl,
    this.cover,
    this.introduction,
    this.latestChapter,
    this.name,
    this.preprocess,
    this.words,
  });

  InformationRule.fromJson(Map<String, String?> json)
      : author = json['information_author'],
        catalogueUrl = json['information_catalogue_url'],
        cover = json['information_cover'],
        introduction = json['information_introduction'],
        category = json['information_category'],
        latestChapter = json['information_latest_chapter'],
        name = json['information_name'],
        preprocess = json['information_preprocess'],
        words = json['information_words'];

  InformationRule copyWith({
    String? author,
    String? category,
    String? catalogueUrl,
    String? cover,
    String? introduction,
    String? latestChapter,
    String? name,
    String? preprocess,
    String? words,
  }) {
    return InformationRule(
      author ?? this.author,
      category ?? this.category,
      catalogueUrl ?? this.catalogueUrl,
      cover ?? this.cover,
      introduction ?? this.introduction,
      latestChapter ?? this.latestChapter,
      name ?? this.name,
      preprocess ?? this.preprocess,
      words ?? this.words,
    );
  }

  Map<String, String?> toJson() {
    final map = <String, String?>{};
    map['information_preprocess'] = preprocess;
    map['information_name'] = name;
    map['information_author'] = author;
    map['information_category'] = category;
    map['information_words'] = words;
    map['information_latest_chapter'] = latestChapter;
    map['information_introduction'] = introduction;
    map['information_cover'] = cover;
    map['information_catalogue_url'] = catalogueUrl;
    return map;
  }
}

class CatalogueRule {
  final String? chapters;
  final String? name;
  final String? url;
  final String? vip;
  final String? updatedAt;
  final String? pagination;

  CatalogueRule(
    this.chapters,
    this.name,
    this.url,
    this.vip,
    this.updatedAt,
    this.pagination,
  );

  CatalogueRule.bean({
    this.chapters,
    this.name,
    this.url,
    this.vip,
    this.updatedAt,
    this.pagination,
  });

  CatalogueRule.fromJson(Map<String, String?> json)
      : chapters = json['catalogue_chapters'],
        name = json['catalogue_name'],
        url = json['catalogue_url'],
        vip = json['catalogue_vip'],
        updatedAt = json['catalogue_updated_at'],
        pagination = json['catalogue_pagination'];

  CatalogueRule copyWith({
    String? chapters,
    String? name,
    String? url,
    String? vip,
    String? updatedAt,
    String? pagination,
  }) {
    return CatalogueRule(
      chapters ?? this.chapters,
      name ?? this.name,
      url ?? this.url,
      vip ?? this.vip,
      updatedAt ?? this.updatedAt,
      pagination ?? this.pagination,
    );
  }

  Map<String, String?> toJson() {
    final map = <String, String?>{};
    map['catalogue_chapters'] = chapters;
    map['catalogue_name'] = name;
    map['catalogue_url'] = url;
    map['catalogue_vip'] = vip;
    map['catalogue_updated_at'] = updatedAt;
    map['catalogue_pagination'] = pagination;
    return map;
  }
}

class ContentRule {
  final String? content;
  final String? pagination;
  final String? script;
  final String? source;
  final String? replace;
  final String? imageStyle;

  ContentRule(
    this.content,
    this.pagination,
    this.script,
    this.source,
    this.replace,
    this.imageStyle,
  );

  ContentRule.bean({
    this.content,
    this.pagination,
    this.script,
    this.source,
    this.replace,
    this.imageStyle,
  });

  ContentRule.fromJson(Map<String, String?> json)
      : content = json['content_content'],
        pagination = json['content_pagination'],
        script = json['content_script'],
        source = json['content_source'],
        replace = json['content_replace'],
        imageStyle = json['content_image_style'];

  ContentRule copyWith({
    String? content,
    String? pagination,
    String? script,
    String? source,
    String? replace,
    String? imageStyle,
  }) {
    return ContentRule(
      content ?? this.content,
      pagination ?? this.pagination,
      script ?? this.script,
      source ?? this.source,
      replace ?? this.replace,
      imageStyle ?? this.imageStyle,
    );
  }

  Map<String, String?> toJson() {
    final map = <String, String?>{};
    map['content_content'] = content;
    map['content_pagination'] = pagination;
    map['content_script'] = script;
    map['content_source'] = source;
    map['content_replace'] = replace;
    map['content_image_style'] = imageStyle;
    return map;
  }
}
