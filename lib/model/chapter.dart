class Chapter {
  String name;
  String url;

  Chapter({
    this.name = '',
    this.url = '',
  });

  factory Chapter.fromJson(Map<String, dynamic> json) {
    return Chapter(
      name: json['name'],
      url: json['url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'url': url,
    };
  }

  @override
  String toString() {
    return toJson().toString();
  }
}
