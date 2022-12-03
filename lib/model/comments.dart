class Comments {
  final commenterimg;
  final commentername;
  final commentime;
  final commentcontent;
  final postId;
  final commentId;
  final commenterId;

  Comments({
    required this.commenterimg,
    required this.commentername,
    required this.commentime,
    required this.commentcontent,
    required this.postId,
    required this.commentId,
    required this.commenterId,
  });

  Map<String, dynamic> toJson() => {
        'commenterimg': commenterimg,
        'commentername': commentername,
        'commentime': commentime,
        'commentcontent': commentcontent,
        'postId': postId,
        'commentId': commentId,
        'commenterId': commenterId,
      };

  static Comments fromJson(Map<String, dynamic> json) => Comments(
        commenterimg: json['commenterimg'],
        commentername: json['commentername'],
        commentime: json['commentime'],
        commentcontent: json['commentcontent'],
        postId: json['postId'],
        commentId: json['commentId'],
        commenterId: json['commenterId'],
      );
}
