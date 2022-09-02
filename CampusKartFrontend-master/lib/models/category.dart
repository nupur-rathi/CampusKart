// Category Model corresponding to category table in our database
class Category {
  final int id;
  final String name;
  final String logo;

  Category({required this.id, required this.name, required this.logo});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(id: json['id'], name: json['name'], logo: json['logo']);
  }
  dynamic toJson() => {'id': id, 'name': name, 'logo': logo};
}