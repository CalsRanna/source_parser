class Chapter {
  String name;
  String url;

  Chapter({
    required this.name,
    required this.url,
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
}
