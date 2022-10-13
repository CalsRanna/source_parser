import 'package:floor/floor.dart';

@Entity(tableName: 'book_sources')
class BookSource {
  String charset;
  String? comment;
  bool enabled;
  @ColumnInfo(name: 'explore_enabled')
  bool exploreEnabled;
  @ColumnInfo(name: 'explore_url')
  String? exploreUrl;
  String group;
  String? header;
  @PrimaryKey(autoGenerate: true)
  int? id;
  @ColumnInfo(name: 'login_url')
  String? loginUrl;
  String name;
  int order;
  @ColumnInfo(name: 'response_time')
  int? responseTime;
  @ColumnInfo(name: 'search_url')
  String? searchUrl;
  int type;
  @ColumnInfo(name: 'update_at')
  int? updatedAt;
  String url;
  @ColumnInfo(name: 'url_pattern')
  String? urlPattern;
  int weight;

  BookSource(
    this.charset,
    this.comment,
    this.enabled,
    this.exploreEnabled,
    this.exploreUrl,
    this.group,
    this.header,
    this.id,
    this.loginUrl,
    this.name,
    this.order,
    this.responseTime,
    this.searchUrl,
    this.type,
    this.updatedAt,
    this.url,
    this.urlPattern,
    this.weight,
  );

  BookSource.bean({
    this.charset = 'utf8',
    this.comment,
    this.enabled = true,
    this.exploreEnabled = false,
    this.exploreUrl,
    this.group = '',
    this.header,
    this.id,
    this.loginUrl,
    this.name = '',
    this.order = 0,
    this.responseTime,
    this.searchUrl,
    this.type = 0,
    this.updatedAt,
    this.url = '',
    this.urlPattern,
    this.weight = 9999,
  });

  BookSource copyWith({
    String? charset,
    String? comment,
    bool? enabled,
    bool? exploreEnabled,
    String? exploreUrl,
    String? group,
    String? header,
    int? id,
    String? loginUrl,
    String? name,
    int? order,
    int? responseTime,
    String? searchUrl,
    int? type,
    int? updatedAt,
    String? url,
    String? urlPattern,
    int? weight,
  }) {
    return BookSource(
      charset ?? this.charset,
      comment ?? this.comment,
      enabled ?? this.enabled,
      exploreEnabled ?? this.exploreEnabled,
      exploreUrl ?? this.exploreUrl,
      group ?? this.group,
      header ?? this.header,
      id ?? this.id,
      loginUrl ?? this.loginUrl,
      name ?? this.name,
      order ?? this.order,
      responseTime ?? this.responseTime,
      searchUrl ?? this.searchUrl,
      type ?? this.type,
      updatedAt ?? this.updatedAt,
      url ?? this.url,
      urlPattern ?? this.urlPattern,
      weight ?? this.weight,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'charset': charset,
      'comment': comment,
      'enabled': enabled,
      'explore_enabled': exploreEnabled,
      'explore_url': exploreUrl,
      'group': group,
      'header': header,
      'id': id,
      'login_url': loginUrl,
      'name': name,
      'order': order,
      'response_time': responseTime,
      'search_url': searchUrl,
      'type': type,
      'updated_at': updatedAt,
      'url': url,
      'url_pattern': urlPattern,
      'weight': weight,
    };
  }

  @override
  String toString() {
    return toJson().toString();
  }
}
