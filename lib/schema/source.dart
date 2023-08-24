import 'package:isar/isar.dart';

part 'source.g.dart';

@collection
@Name('sources')
class Source {
  Id id = Isar.autoIncrement;
  String name = '';
  String url = '';
  bool enabled = true;
  @Name('explore_enabled')
  bool exploreEnabled = false;
  String type = 'book';
  String group = '';
  String comment = '';
  @Name('login_url')
  String loginUrl = '';
  @Name('url_regex')
  String urlRegex = '';
  String header = '';
  String charset = 'utf8';
  short weight = 0;
  short order = 0;
  @Name('search_url')
  String searchUrl = '';
  @Name('search_check_credential')
  String searchCheckCredential = '';
  @Name('search_books')
  String searchBooks = '';
  @Name('search_name')
  String searchName = '';
  @Name('search_author')
  String searchAuthor = '';
  @Name('search_category')
  String searchCategory = '';
  @Name('search_word_count')
  String searchWordCount = '';
  @Name('search_introduction')
  String searchIntroduction = '';
  @Name('search_cover')
  String searchCover = '';
  @Name('search_information_url')
  String searchInformationUrl = '';
  @Name('search_latest_chapter')
  String searchLatestChapter = '';
  @Name('information_preprocess')
  String informationPreprocess = '';
  @Name('information_name')
  String informationName = '';
  @Name('information_author')
  String informationAuthor = '';
  @Name('information_category')
  String informationCategory = '';
  @Name('information_word_count')
  String informationWordCount = '';
  @Name('information_latest_chapter')
  String informationLatestChapter = '';
  @Name('information_introduction')
  String informationIntroduction = '';
  @Name('information_cover')
  String informationCover = '';
  @Name('information_catalogue_url')
  String informationCatalogueUrl = '';
  @Name('catalogue_chapters')
  String catalogueChapters = '';
  @Name('catalogue_name')
  String catalogueName = '';
  @Name('catalogue_url')
  String catalogueUrl = '';
  @Name('catalogue_vip')
  String catalogueVip = '';
  @Name('catalogue_updated_at')
  String catalogueUpdatedAt = '';
  @Name('catalogue_pagination')
  String cataloguePagination = '';
  @Name('content_content')
  String contentContent = '';
  @Name('content_pagination')
  String contentPagination = '';
  @Name('content_replace')
  String contentReplace = '';
  @Name('explore_url')
  String exploreUrl = '';
  @Name('explore_books')
  String exploreBooks = '';
  @Name('explore_name')
  String exploreName = '';
  @Name('explore_author')
  String exploreAuthor = '';
  @Name('explore_category')
  String exploreCategory = '';
  @Name('explore_word_count')
  String exploreWordCount = '';
  @Name('explore_latest_chapter')
  String exploreLatestChapter = '';
  @Name('explore_introduction')
  String exploreIntroduction = '';
  @Name('explore_cover')
  String exploreCover = '';
  @Name('explore_information_url')
  String exploreInformationUrl = '';

  Source();

  Source.fromJson(Map<String, dynamic> json)
      : id = json['id'] ?? Isar.autoIncrement,
        name = json['name'] ?? '',
        url = json['url'] ?? '',
        enabled = json['enabled'] ?? true,
        exploreEnabled = json['explore_enabled'] ?? false,
        type = json['type'] ?? 'book',
        group = json['group'] ?? '',
        comment = json['comment'] ?? '',
        loginUrl = json['login_url'] ?? '',
        urlRegex = json['url_regex'] ?? '',
        header = json['header'] ?? '',
        charset = json['charset'] ?? 'utf8',
        weight = json['weight'] ?? 0,
        order = json['order'] ?? 0,
        searchUrl = json['search_url'] ?? '',
        searchCheckCredential = json['search_check_credential'] ?? '',
        searchBooks = json['search_books'] ?? '',
        searchName = json['search_name'] ?? '',
        searchAuthor = json['search_author'] ?? '',
        searchCategory = json['search_category'] ?? '',
        searchWordCount = json['search_word_count'] ?? '',
        searchIntroduction = json['search_introduction'] ?? '',
        searchCover = json['search_cover'] ?? '',
        searchInformationUrl = json['search_information_url'] ?? '',
        searchLatestChapter = json['search_latest_chapter'] ?? '',
        informationPreprocess = json['information_preprocess'] ?? '',
        informationName = json['information_name'] ?? '',
        informationAuthor = json['information_author'] ?? '',
        informationCategory = json['information_category'] ?? '',
        informationWordCount = json['information_word_count'] ?? '',
        informationLatestChapter = json['information_latest_chapter'] ?? '',
        informationIntroduction = json['information_introduction'] ?? '',
        informationCover = json['information_cover'] ?? '',
        informationCatalogueUrl = json['information_catalogue_url'] ?? '',
        catalogueChapters = json['catalogue_chapters'] ?? '',
        catalogueName = json['catalogue_name'] ?? '',
        catalogueUrl = json['catalogue_url'] ?? '',
        catalogueVip = json['catalogue_vip'] ?? '',
        catalogueUpdatedAt = json['catalogue_updated_at'] ?? '',
        cataloguePagination = json['catalogue_pagination'] ?? '',
        contentContent = json['content_content'] ?? '',
        contentPagination = json['content_pagination'] ?? '',
        contentReplace = json['content_replace'] ?? '',
        exploreUrl = json['explore_url'] ?? '',
        exploreBooks = json['explore_books'] ?? '',
        exploreName = json['explore_name'] ?? '',
        exploreAuthor = json['explore_author'] ?? '',
        exploreCategory = json['explore_category'] ?? '',
        exploreWordCount = json['explore_word_count'] ?? '',
        exploreLatestChapter = json['explore_latest_chapter'] ?? '',
        exploreIntroduction = json['explore_introduction'] ?? '',
        exploreCover = json['explore_cover'] ?? '',
        exploreInformationUrl = json['explore_information_url'] ?? '';

  Source copyWith({
    Id? id,
    String? name,
    String? url,
    bool? enabled,
    bool? exploreEnabled,
    String? type,
    String? group,
    String? comment,
    String? loginUrl,
    String? urlRegex,
    String? header,
    String? charset,
    int? weight,
    int? order,
    String? searchUrl,
    String? searchCheckCredential,
    String? searchBooks,
    String? searchName,
    String? searchAuthor,
    String? searchCategory,
    String? searchWordCount,
    String? searchIntroduction,
    String? searchCover,
    String? searchInformationUrl,
    String? searchLatestChapter,
    String? informationPreprocess,
    String? informationName,
    String? informationAuthor,
    String? informationCategory,
    String? informationWordCount,
    String? informationLatestChapter,
    String? informationIntroduction,
    String? informationCover,
    String? informationCatalogueUrl,
    String? catalogueChapters,
    String? catalogueName,
    String? catalogueUrl,
    String? catalogueVip,
    String? catalogueUpdatedAt,
    String? cataloguePagination,
    String? contentContent,
    String? contentPagination,
    String? contentReplace,
    String? exploreUrl,
    String? exploreBooks,
    String? exploreName,
    String? exploreAuthor,
    String? exploreCategory,
    String? exploreWordCount,
    String? exploreLatestChapter,
    String? exploreIntroduction,
    String? exploreCover,
    String? exploreInformationUrl,
  }) {
    return Source()
      ..id = id ?? this.id
      ..name = name ?? this.name
      ..url = url ?? this.url
      ..enabled = enabled ?? this.enabled
      ..exploreEnabled = exploreEnabled ?? this.exploreEnabled
      ..type = type ?? this.type
      ..group = group ?? this.group
      ..comment = comment ?? this.comment
      ..loginUrl = loginUrl ?? this.loginUrl
      ..urlRegex = urlRegex ?? this.urlRegex
      ..header = header ?? this.header
      ..charset = charset ?? this.charset
      ..weight = weight ?? this.weight
      ..order = order ?? this.order
      ..searchUrl = searchUrl ?? this.searchUrl
      ..searchCheckCredential =
          searchCheckCredential ?? this.searchCheckCredential
      ..searchBooks = searchBooks ?? this.searchBooks
      ..searchName = searchName ?? this.searchName
      ..searchAuthor = searchAuthor ?? this.searchAuthor
      ..searchCategory = searchCategory ?? this.searchCategory
      ..searchWordCount = searchWordCount ?? this.searchWordCount
      ..searchIntroduction = searchIntroduction ?? this.searchIntroduction
      ..searchCover = searchCover ?? this.searchCover
      ..searchInformationUrl = searchInformationUrl ?? this.searchInformationUrl
      ..searchLatestChapter = searchLatestChapter ?? this.searchLatestChapter
      ..informationPreprocess =
          informationPreprocess ?? this.informationPreprocess
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
      ..catalogueChapters = catalogueChapters ?? this.catalogueChapters
      ..catalogueName = catalogueName ?? this.catalogueName
      ..catalogueUrl = catalogueUrl ?? this.catalogueUrl
      ..catalogueVip = catalogueVip ?? this.catalogueVip
      ..catalogueUpdatedAt = catalogueUpdatedAt ?? this.catalogueUpdatedAt
      ..cataloguePagination = cataloguePagination ?? this.cataloguePagination
      ..contentContent = contentContent ?? this.contentContent
      ..contentPagination = contentPagination ?? this.contentPagination
      ..contentReplace = contentReplace ?? this.contentReplace
      ..exploreUrl = exploreUrl ?? this.exploreUrl
      ..exploreBooks = exploreBooks ?? this.exploreBooks
      ..exploreName = exploreName ?? this.exploreName
      ..exploreAuthor = exploreAuthor ?? this.exploreAuthor
      ..exploreCategory = exploreCategory ?? this.exploreCategory
      ..exploreWordCount = exploreWordCount ?? this.exploreWordCount
      ..exploreLatestChapter = exploreLatestChapter ?? this.exploreLatestChapter
      ..exploreIntroduction = exploreIntroduction ?? this.exploreIntroduction
      ..exploreCover = exploreCover ?? this.exploreCover
      ..exploreInformationUrl =
          exploreInformationUrl ?? this.exploreInformationUrl;
  }
}
