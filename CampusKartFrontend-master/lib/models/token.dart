// Token Model corresponding to tokens table in our database
class Token {
  String? token;
  String? username;
  String? id;

  Token({this.id, required this.token, required this.username});

  factory Token.fromJson(Map<String, dynamic> json) {
    return Token(
        username: json['username'], token: json['token'], id: json['id']);
  }

  dynamic toJson() => {
        'token': token,
        'username': username,
        'id': id,
      };
}
