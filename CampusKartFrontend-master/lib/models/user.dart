// User Model corresponding to user table in our database
class User {
  String username;
  String? first_name;
  String? last_name;
  String? phone_number;
  String emailId;

  User({
    required this.username,
    this.first_name,
    this.last_name,
    this.phone_number,
    required this.emailId,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      username: json['username'],
      first_name: json['first_name'],
      last_name: json['last_name'],
      phone_number: json['phone_number'],
      emailId: json['emailId'],
    );
  }

  dynamic toJson() => {
        'username': username,
        'first_name': first_name,
        'last_name': last_name,
        'phone_number': phone_number,
        'emailId': emailId,
      };
}
