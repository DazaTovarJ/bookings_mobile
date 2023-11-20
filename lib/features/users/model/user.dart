class User {
  final int? id;
  final String email;
  final String givenName;
  final String familyName;

  User({
    this.id,
    required this.email,
    required this.givenName,
    required this.familyName,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'],
      givenName: json['given_name'],
      familyName: json['family_name'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'email': email,
    'given_name': givenName,
    'family_name': familyName,
  };
}