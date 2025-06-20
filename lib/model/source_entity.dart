class SourceEntity {
  int id = 0;
  String name = '';
  String url = '';
  bool enabled = true;
  bool exploreEnabled = false;
  String type = 'book';
  String comment = '';
  String header = '';
  String charset = 'utf8';
  String searchUrl = '';
  String searchMethod = 'get';
  String searchBooks = '';
  String searchName = '';
  String searchAuthor = '';
  String searchCategory = '';
  String searchWordCount = '';
  String searchIntroduction = '';
  String searchCover = '';
  String searchInformationUrl = '';
  String searchLatestChapter = '';
  String informationMethod = 'get';
  String informationName = '';
  String informationAuthor = '';
  String informationCategory = '';
  String informationWordCount = '';
  String informationLatestChapter = '';
  String informationIntroduction = '';
  String informationCover = '';
  String informationCatalogueUrl = '';
  String catalogueMethod = 'get';
  String catalogueChapters = '';
  String catalogueName = '';
  String catalogueUrl = '';
  String catalogueUpdatedAt = '';
  String cataloguePagination = '';
  String cataloguePaginationValidation = '';
  String cataloguePreset = '';
  String contentMethod = 'get';
  String contentContent = '';
  String contentPagination = '';
  String contentPaginationValidation = '';
  String exploreJson = '';

  SourceEntity();

  factory SourceEntity.fromJson(Map<String, dynamic> json) {
    return SourceEntity()
      ..id = json['id'] ?? 0
      ..name = json['name'] ?? ''
      ..url = json['url'] ?? ''
      ..enabled = json['enabled'] == 1
      ..exploreEnabled = json['explore_enabled'] == 1
      ..type = json['type'] ?? 'book'
      ..comment = json['comment'] ?? ''
      ..header = json['header'] ?? ''
      ..charset = json['charset'] ?? 'utf8'
      ..searchUrl = json['search_url'] ?? ''
      ..searchMethod = json['search_method'] ?? 'get'
      ..searchBooks = json['search_books'] ?? ''
      ..searchName = json['search_name'] ?? ''
      ..searchAuthor = json['search_author'] ?? ''
      ..searchCategory = json['search_category'] ?? ''
      ..searchWordCount = json['search_word_count'] ?? ''
      ..searchIntroduction = json['search_introduction'] ?? ''
      ..searchCover = json['search_cover'] ?? ''
      ..searchInformationUrl = json['search_information_url'] ?? ''
      ..searchLatestChapter = json['search_latest_chapter'] ?? ''
      ..informationMethod = json['information_method'] ?? 'get'
      ..informationName = json['information_name'] ?? ''
      ..informationAuthor = json['information_author'] ?? ''
      ..informationCategory = json['information_category'] ?? ''
      ..informationWordCount = json['information_word_count'] ?? ''
      ..informationLatestChapter = json['information_latest_chapter'] ?? ''
      ..informationIntroduction = json['information_introduction'] ?? ''
      ..informationCover = json['information_cover'] ?? ''
      ..informationCatalogueUrl = json['information_catalogue_url'] ?? ''
      ..catalogueMethod = json['catalogue_method'] ?? 'get'
      ..catalogueChapters = json['catalogue_chapters'] ?? ''
      ..catalogueName = json['catalogue_name'] ?? ''
      ..catalogueUrl = json['catalogue_url'] ?? ''
      ..catalogueUpdatedAt = json['catalogue_updated_at'] ?? ''
      ..cataloguePagination = json['catalogue_pagination'] ?? ''
      ..cataloguePaginationValidation =
          json['catalogue_pagination_validation'] ?? ''
      ..cataloguePreset = json['catalogue_preset'] ?? ''
      ..contentMethod = json['content_method'] ?? 'get'
      ..contentContent = json['content_content'] ?? ''
      ..contentPagination = json['content_pagination'] ?? ''
      ..contentPaginationValidation =
          json['content_pagination_validation'] ?? ''
      ..exploreJson = json['explore_json'] ?? '';
  }

  SourceEntity copyWith({
    int? id,
    String? name,
    String? url,
    bool? enabled,
    bool? exploreEnabled,
    String? type,
    String? comment,
    String? header,
    String? charset,
    String? searchUrl,
    String? searchMethod,
    String? searchBooks,
    String? searchName,
    String? searchAuthor,
    String? searchCategory,
    String? searchWordCount,
    String? searchIntroduction,
    String? searchCover,
    String? searchInformationUrl,
    String? searchLatestChapter,
    String? informationMethod,
    String? informationName,
    String? informationAuthor,
    String? informationCategory,
    String? informationWordCount,
    String? informationLatestChapter,
    String? informationIntroduction,
    String? informationCover,
    String? informationCatalogueUrl,
    String? catalogueMethod,
    String? catalogueChapters,
    String? catalogueName,
    String? catalogueUrl,
    String? catalogueUpdatedAt,
    String? cataloguePagination,
    String? cataloguePaginationValidation,
    String? cataloguePreset,
    String? contentMethod,
    String? contentContent,
    String? contentPagination,
    String? contentPaginationValidation,
    String? exploreJson,
  }) {
    return SourceEntity()
      ..id = id ?? this.id
      ..name = name ?? this.name
      ..url = url ?? this.url
      ..enabled = enabled ?? this.enabled
      ..exploreEnabled = exploreEnabled ?? this.exploreEnabled
      ..type = type ?? this.type
      ..comment = comment ?? this.comment
      ..header = header ?? this.header
      ..charset = charset ?? this.charset
      ..searchUrl = searchUrl ?? this.searchUrl
      ..searchMethod = searchMethod ?? this.searchMethod
      ..searchBooks = searchBooks ?? this.searchBooks
      ..searchName = searchName ?? this.searchName
      ..searchAuthor = searchAuthor ?? this.searchAuthor
      ..searchCategory = searchCategory ?? this.searchCategory
      ..searchWordCount = searchWordCount ?? this.searchWordCount
      ..searchIntroduction = searchIntroduction ?? this.searchIntroduction
      ..searchCover = searchCover ?? this.searchCover
      ..searchInformationUrl = searchInformationUrl ?? this.searchInformationUrl
      ..searchLatestChapter = searchLatestChapter ?? this.searchLatestChapter
      ..informationMethod = informationMethod ?? this.informationMethod
      ..informationName = informationName ?? this.informationName
      ..informationAuthor = informationAuthor ?? this.informationAuthor
      ..informationCategory = informationCategory ?? this.informationCategory
      ..informationWordCount = informationWordCount ?? this.informationWordCount
      ..informationLatestChapter =
          informationLatestChapter ?? this.informationLatestChapter
      ..informationIntroduction =
          informationIntroduction ?? this.informationIntroduction
      ..informationCover = informationCover ?? this.informationCover
      ..informationCatalogueUrl =
          informationCatalogueUrl ?? this.informationCatalogueUrl
      ..catalogueMethod = catalogueMethod ?? this.catalogueMethod
      ..catalogueChapters = catalogueChapters ?? this.catalogueChapters
      ..catalogueName = catalogueName ?? this.catalogueName
      ..catalogueUrl = catalogueUrl ?? this.catalogueUrl
      ..catalogueUpdatedAt = catalogueUpdatedAt ?? this.catalogueUpdatedAt
      ..cataloguePagination = cataloguePagination ?? this.cataloguePagination
      ..cataloguePaginationValidation =
          cataloguePaginationValidation ?? this.cataloguePaginationValidation
      ..cataloguePreset = cataloguePreset ?? this.cataloguePreset
      ..contentMethod = contentMethod ?? this.contentMethod
      ..contentContent = contentContent ?? this.contentContent
      ..contentPagination = contentPagination ?? this.contentPagination
      ..contentPaginationValidation =
          contentPaginationValidation ?? this.contentPaginationValidation
      ..exploreJson = exploreJson ?? this.exploreJson;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'url': url,
      'enabled': enabled,
      'explore_enabled': exploreEnabled,
      'type': type,
      'comment': comment,
      'header': header,
      'charset': charset,
      'search_url': searchUrl,
      'search_method': searchMethod,
      'search_books': searchBooks,
      'search_name': searchName,
      'search_author': searchAuthor,
      'search_category': searchCategory,
      'search_word_count': searchWordCount,
      'search_introduction': searchIntroduction,
      'search_cover': searchCover,
      'search_information_url': searchInformationUrl,
      'search_latest_chapter': searchLatestChapter,
      'information_method': informationMethod,
      'information_name': informationName,
      'information_author': informationAuthor,
      'information_category': informationCategory,
      'information_word_count': informationWordCount,
      'information_latest_chapter': informationLatestChapter,
      'information_introduction': informationIntroduction,
      'information_cover': informationCover,
      'information_catalogue_url': informationCatalogueUrl,
      'catalogue_method': catalogueMethod,
      'catalogue_chapters': catalogueChapters,
      'catalogue_name': catalogueName,
      'catalogue_url': catalogueUrl,
      'catalogue_updated_at': catalogueUpdatedAt,
      'catalogue_pagination': cataloguePagination,
      'catalogue_pagination_validation': cataloguePaginationValidation,
      'catalogue_preset': cataloguePreset,
      'content_method': contentMethod,
      'content_content': contentContent,
      'content_pagination': contentPagination,
      'content_pagination_validation': contentPaginationValidation,
      'explore_json': exploreJson,
    };
  }

  SourceEntity updateWithJson(Map<String, dynamic> map) {
    return copyWith(
      id: map['id'],
      name: map['name'],
      url: map['url'],
      enabled: map['enabled'],
      exploreEnabled: map['explore_enabled'],
      type: map['type'],
      comment: map['comment'],
      header: map['header'],
      charset: map['charset'],
      searchUrl: map['search_url'],
      searchMethod: map['search_method'],
      searchBooks: map['search_books'],
      searchName: map['search_name'],
      searchAuthor: map['search_author'],
      searchCategory: map['search_category'],
      searchWordCount: map['search_word_count'],
      searchIntroduction: map['search_introduction'],
      searchCover: map['search_cover'],
      searchInformationUrl: map['search_information_url'],
      searchLatestChapter: map['search_latest_chapter'],
      informationMethod: map['information_method'],
      informationName: map['information_name'],
      informationAuthor: map['information_author'],
      informationCategory: map['information_category'],
      informationWordCount: map['information_word_count'],
      informationLatestChapter: map['information_latest_chapter'],
      informationIntroduction: map['information_introduction'],
      informationCover: map['information_cover'],
      informationCatalogueUrl: map['information_catalogue_url'],
      catalogueMethod: map['catalogue_method'],
      catalogueChapters: map['catalogue_chapters'],
      catalogueName: map['catalogue_name'],
      catalogueUrl: map['catalogue_url'],
      catalogueUpdatedAt: map['catalogue_updated_at'],
      cataloguePagination: map['catalogue_pagination'],
      cataloguePaginationValidation: map['catalogue_pagination_validation'],
      cataloguePreset: map['catalogue_preset'],
      contentMethod: map['content_method'],
      contentContent: map['content_content'],
      contentPagination: map['content_pagination'],
      contentPaginationValidation: map['content_pagination_validation'],
      exploreJson: map['explore_json'],
    );
  }
}
