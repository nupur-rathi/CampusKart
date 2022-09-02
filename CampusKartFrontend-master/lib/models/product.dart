// Product Model corresponding to product table in our database
class Product {
  String? id;
  String title;
  int category_id;
  String description;
  int price;
  String username;
  String? time_uploaded;
  bool negotiation_status;
  String? brand;
  String? selling_reason;
  String time_used;

  Product(
      {this.id,
      required this.title,
      required this.category_id,
      this.brand,
      required this.description,
      required this.price,
      this.selling_reason,
      required this.negotiation_status,
      required this.time_used,
      required this.username,
      this.time_uploaded});

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      title: json['title'],
      category_id: json['category_id'],
      description: json['description'],
      price: json['price'],
      username: json['username'],
      time_uploaded: json['time_uploaded'],
      brand: json['brand'],
      selling_reason: json['selling_reason'],
      time_used: json['time_used'],
      negotiation_status: json['negotiation_status'],
    );
  }
  dynamic toJson() => {
        'title': title,
        'category_id': category_id,
        'description': description,
        'price': price,
        'username': username,
        'brand': brand,
        'time_used': time_used,
        'selling_reason': selling_reason,
        'negotiation_status': negotiation_status,
      };
}
