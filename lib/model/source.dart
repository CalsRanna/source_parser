class AvailableSource {
  String name;
  String url;

  AvailableSource({this.name = '', this.url = ''});

  factory AvailableSource.fromJson(Map<String, dynamic> json) {
    return AvailableSource(name: json['name'] ?? '', url: json['url'] ?? '');
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'url': url};
  }

  AvailableSource copyWith({String? name, String? url}) {
    return AvailableSource(url: url ?? this.url, name: name ?? this.name);
  }

  @override
  String toString() {
    return toJson().toString();
  }
}
