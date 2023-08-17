class Chapter {
  bool cached;
  String name;
  String url;

  Chapter({
    this.cached = false,
    this.name = '',
    this.url = '',
  });

  factory Chapter.fromJson(Map<String, dynamic> json) {
    return Chapter(
      cached: json['cached'],
      name: json['name'],
      url: json['url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cached': cached,
      'name': name,
      'url': url,
    };
  }

  @override
  String toString() {
    return toJson().toString();
  }
}
