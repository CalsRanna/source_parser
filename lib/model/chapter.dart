class Chapter {
  Chapter({
    this.id,
    this.name,
    this.url,
    this.content,
  });

  int? id;
  String? name;
  String? url;
  String? content;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'url': url,
      'content': content,
    };
  }
}
