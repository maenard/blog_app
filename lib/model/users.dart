class Users {
  final id;
  final name;
  final password;
  final email;

  Users({
    required this.id,
    required this.name,
    required this.password,
    required this.email,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'password': password,
        'email': email,
      };

  static Users fromJson(Map<String, dynamic> json) => Users(
        id: json['id'],
        name: json['name'],
        password: json['password'],
        email: json['email'],
      );
}
