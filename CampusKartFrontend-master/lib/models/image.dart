//Picture Model corresponding to picture table in our database
class Picture {
  int? id;
  String image;
  String product_id;
  int category_id;

  Picture(
      {this.id,
      required this.image,
      required this.product_id,
      required this.category_id});

  factory Picture.fromJson(Map<String, dynamic> json) {
    return Picture(
        id: json['id'],
        image: json['image'],
        product_id: json['product_id'],
        category_id: json['category_id']);
  }

  dynamic toJson() => {
        'id': id,
        'image': image,
        'product_id': product_id,
        'category_id': category_id
      };
}
