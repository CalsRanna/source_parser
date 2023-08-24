class AvailableSource {
  int id;
  String name;
  String url;

  AvailableSource({this.id = 0, this.name = '', this.url = ''});

  factory AvailableSource.fromJson(Map<String, dynamic> json) {
    return AvailableSource(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      url: json['url'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'url': url};
  }

  AvailableSource copyWith({int? id, String? name, String? url}) {
    return AvailableSource(
      id: id ?? this.id,
      url: url ?? this.url,
      name: name ?? this.name,
    );
  }

  @override
  String toString() {
    return toJson().toString();
  }
}
