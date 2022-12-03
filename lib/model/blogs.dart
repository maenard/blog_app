class Blogs {
  final postId;
  final userId;
  final content;
  final datePosted;
  final authorName;
  final authorPic;
  final List? likes;
  final likesCount;

  Blogs({
    required this.postId,
    required this.userId,
    required this.content,
    required this.datePosted,
    required this.authorName,
    required this.authorPic,
    this.likes,
    this.likesCount,
  });

  Map<String, dynamic> toJson() => {
        'postId': postId,
        'userId': userId,
        'content': content,
        'datePosted': datePosted,
        'authorName': authorName,
        'authorPic': authorPic,
        'likes': likes,
        'likesCount': likesCount,
      };

  static Blogs fromJson(Map<String, dynamic> json) => Blogs(
        postId: json['postId'],
        userId: json['userId'],
        content: json['content'],
        datePosted: json['datePosted'],
        authorName: json['authorName'],
        authorPic: json['authorPic'],
        likes: json['likes'],
        likesCount: json['likesCount'],
      );
}
