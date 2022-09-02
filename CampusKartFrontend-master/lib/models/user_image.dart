// UserImage Model corresponding to userImage table in our database
class UserImage {
  String username;
  String image;

  UserImage({
    required this.username,
    required this.image,
  });

  factory UserImage.fromJson(Map<String, dynamic> json) {
    return UserImage(
      image: json['image'],
      username: json['username'],
    );
  }

  dynamic toJson() => {
        'image': image,
        'username': username,
      };
}
