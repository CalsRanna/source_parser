import 'package:floor/floor.dart';

@Entity(tableName: 'book_sources')
class BookSource {
  final String? charset;
  final String? comment;
  final bool enabled;
  @ColumnInfo(name: 'explore_enabled')
  final bool? exploreEnabled;
  @ColumnInfo(name: 'explore_url')
  final String? exploreUrl;
  final String group;
  final String? header;
  @PrimaryKey(autoGenerate: true)
  final int? id;
  @ColumnInfo(name: 'login_url')
  final String? loginUrl;
  final String name;
  final int order;
  @ColumnInfo(name: 'response_time')
  final int? responseTime;
  @ColumnInfo(name: 'search_url')
  final String? searchUrl;
  final int type;
  @ColumnInfo(name: 'update_at')
  final int? updatedAt;
  final String url;
  @ColumnInfo(name: 'url_pattern')
  final String? urlPattern;
  final int weight;

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
    this.charset,
    this.comment,
    this.enabled = true,
    this.exploreEnabled,
    this.exploreUrl,
    this.group = '',
    this.header,
    this.id,
    this.loginUrl,
    this.name = '',
    this.order = 1000,
    this.responseTime,
    this.searchUrl,
    this.type = 0,
    this.updatedAt,
    this.url = '',
    this.urlPattern,
    this.weight = 0,
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
      'source_charset': charset,
      'source_comment': comment,
      'source_enabled': enabled,
      'source_explore_enabled': exploreEnabled,
      'source_explore_url': exploreUrl,
      'source_group': group,
      'source_header': header,
      'source_id': id,
      'source_login_url': loginUrl,
      'source_name': name,
      'source_order': order,
      'source_response_time': responseTime,
      'source_search_url': searchUrl,
      'source_type': type,
      'source_updated_at': updatedAt,
      'source_url': url,
      'source_url_pattern': urlPattern,
      'source_weight': weight,
    };
  }
}
