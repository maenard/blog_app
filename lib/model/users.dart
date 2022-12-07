class Users {
  final id;
  final name;
  final password;
  final email;
  final userProfilePic;
  final userProfileCover;
  final about;

  Users({
    required this.id,
    required this.name,
    required this.password,
    required this.email,
    required this.userProfilePic,
    required this.userProfileCover,
    required this.about,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'password': password,
        'email': email,
        'userProfilePic': userProfilePic,
        'userProfileCover': userProfileCover,
        'about': about,
      };

  static Users fromJson(Map<String, dynamic> json) => Users(
        id: json['id'],
        name: json['name'],
        password: json['password'],
        email: json['email'],
        userProfilePic: json['userProfilePic'],
        userProfileCover: json['userProfileCover'],
        about: json['about'],
      );
}
