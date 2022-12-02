class Likes {
  final postId;
  final userId;
  final isLiked;

  Likes({
    required this.postId,
    required this.userId,
    required this.isLiked,
  });

  Map<String, dynamic> toJson() => {
        'postId': postId,
        'userId': userId,
        'isLiked': isLiked,
      };

  static Likes fromJson(Map<String, dynamic> json) => Likes(
        postId: json['postId'],
        userId: json['userId'],
        isLiked: json['isLiked'],
      );
}
