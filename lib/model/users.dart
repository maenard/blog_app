class Users {
  final id;
  final name;
  final password;
  final email;
  final userProfilePic;
  final userProfileCover;

  Users({
    required this.id,
    required this.name,
    required this.password,
    required this.email,
    required this.userProfilePic,
    required this.userProfileCover,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'password': password,
        'email': email,
        'userProfilePic': userProfilePic,
        'userProfileCover': userProfileCover,
      };

  static Users fromJson(Map<String, dynamic> json) => Users(
        id: json['id'],
        name: json['name'],
        password: json['password'],
        email: json['email'],
        userProfilePic: json['userProfilePic'],
        userProfileCover: json['userProfileCover'],
      );
}
