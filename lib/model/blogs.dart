class Blogs {
  final postId;
  final userId;
  final content;
  final datePosted;
  final name;

  Blogs({
    required this.postId,
    required this.userId,
    required this.content,
    required this.datePosted,
    required this.name,
  });

  Map<String, dynamic> toJson() => {
        'postId': postId,
        'userId': userId,
        'content': content,
        'datePosted': datePosted,
        'name': name,
      };

  static Blogs fromJson(Map<String, dynamic> json) => Blogs(
        postId: json['postId'],
        userId: json['userId'],
        content: json['content'],
        datePosted: json['datePosted'],
        name: json['name'],
      );
}
