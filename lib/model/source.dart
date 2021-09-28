import 'dart:convert';

class Source {
  String? name;
  String? id;
  String? description;
  String? url;
  String? category;
  String? language;
  String? country;
  Source({
    this.name,
    this.id,
    this.description,
    this.url,
    this.category,
    this.language,
    this.country,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'id': id,
      'description': description,
      'url': url,
      'category': category,
      'language': language,
      'country': country,
    };
  }

  factory Source.fromMap(Map<String, dynamic> map) {
    return Source(
      name: map['name'],
      id: map['id'],
      description: map['description'],
      url: map['url'],
      category: map['category'],
      language: map['language'],
      country: map['country'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Source.fromJson(String source) => Source.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Source(name: $name, id: $id, description: $description, url: $url, category: $category, language: $language, country: $country)';
  }
}
