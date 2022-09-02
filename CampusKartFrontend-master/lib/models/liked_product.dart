//LikedProducts Model corresponding to likedproducts table in our database
class LikedProducts {
  String? id;
  String username;
  String product_id;

  LikedProducts(
      {
      this.id,
      required this.username,
      required this.product_id});

  factory LikedProducts.fromJson(Map<String, dynamic> json) {
    return LikedProducts(
      id: json['id'],
      username: json['username'],
      product_id: json['product_id']);
  }

  dynamic toJson() => {
        'username': username,
        'product_id': product_id
      };
}
