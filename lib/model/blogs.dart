class Blogs {
  final postId;
  final userId;
  final content;
  final datePosted;

  Blogs({
    required this.postId,
    required this.userId,
    required this.content,
    required this.datePosted,
  });

  Map<String, dynamic> toJson() => {
        'postId': postId,
        'userId': userId,
        'content': content,
        'datePosted': datePosted,
      };

  static Blogs fromJson(Map<String, dynamic> json) => Blogs(
        postId: json['postId'],
        userId: json['userId'],
        content: json['content'],
        datePosted: json['datePosted'],
      );
}
