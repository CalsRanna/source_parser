import 'package:isar/isar.dart';

part 'source.g.dart';

@collection
@Name('sources')
class Source {
  Id id = Isar.autoIncrement;
  String? name;
  String? url;
  bool enabled = true;
  @Name('explore_enabled')
  bool exploreEnabled = false;
  String type = 'book';
  String? group;
  String? comment;
  @Name('login_url')
  String? loginUrl;
  @Name('url_regex')
  String? urlRegex;
  String? header;
  String charset = 'utf8';
  short? weight;
  short order = 0;
  @Name('search_url')
  String? searchUrl;
  @Name('search_check_credential')
  String? searchCheckCredential;
  @Name('search_books')
  String? searchBooks;
  @Name('search_name')
  String? searchName;
  @Name('search_author')
  String? searchAuthor;
  @Name('search_category')
  String? searchCategory;
  @Name('search_word_count')
  String? searchWordCount;
  @Name('search_introduction')
  String? searchIntroduction;
  @Name('search_cover')
  String? searchCover;
  @Name('search_information_url')
  String? searchInformationUrl;
  @Name('search_latest_chapter')
  String? searchLatestChapter;
  @Name('information_preprocess')
  String? informationPreprocess;
  @Name('information_name')
  String? informationName;
  @Name('information_author')
  String? informationAuthor;
  @Name('information_category')
  String? informationCategory;
  @Name('information_word_count')
  String? informationWordCount;
  @Name('information_latest_chapter')
  String? informationLatestChapter;
  @Name('information_introduction')
  String? informationIntroduction;
  @Name('information_cover')
  String? informationCover;
  @Name('information_catalogue_url')
  String? informationCatalogueUrl;
  @Name('catalogue_chapters')
  String? catalogueChapters;
  @Name('catalogue_name')
  String? catalogueName;
  @Name('catalogue_url')
  String? catalogueUrl;
  @Name('catalogue_vip')
  String? catalogueVip;
  @Name('catalogue_updated_at')
  String? catalogueUpdatedAt;
  @Name('catalogue_pagination')
  String? cataloguePagination;
  @Name('content_content')
  String? contentContent;
  @Name('content_pagination')
  String? contentPagination;
  @Name('content_replace')
  String? contentReplace;
  @Name('explore_url')
  String? exploreUrl;
  @Name('explore_books')
  String? exploreBooks;
  @Name('explore_name')
  String? exploreName;
  @Name('explore_author')
  String? exploreAuthor;
  @Name('explore_category')
  String? exploreCategory;
  @Name('explore_word_count')
  String? exploreWordCount;
  @Name('explore_latest_chapter')
  String? exploreLatestChapter;
  @Name('explore_introduction')
  String? exploreIntroduction;
  @Name('explore_cover')
  String? exploreCover;
  @Name('explore_information_url')
  String? exploreInformationUrl;
}
