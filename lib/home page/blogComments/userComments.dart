import 'package:blog_app/home%20page/blogComments/editComment.dart';
import 'package:blog_app/model/blogs.dart';
import 'package:blog_app/model/comments.dart';
import 'package:blog_app/model/users.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:sweetsheet/sweetsheet.dart';

class UserComments extends StatefulWidget {
  const UserComments({
    super.key,
    required this.blogs,
    required this.users,
  });

  final Blogs blogs;
  final Users users;

  @override
  State<UserComments> createState() => _UserCommentsState();
}

class _UserCommentsState extends State<UserComments> {
  final user = FirebaseAuth.instance.currentUser!;
  final SweetSheet dialog = SweetSheet();
  late TextEditingController commentcontroller;

  @override
  void initState() {
    super.initState();
    commentcontroller = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        automaticallyImplyLeading: true,
        elevation: 0,
        title: Text(
          'Comments',
          style: GoogleFonts.poppins(),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: fetchBlogComments(),
            ),
          ),
          commentField(),
        ],
      ),
    );
  }

  imgNotExist() => const AssetImage('assets/images/blank_profile.jpg');
  imgExist(img) => NetworkImage(img);

  Widget blogComments(Comments comments) => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
            ),
            child: CircleAvatar(
              radius: 20,
              backgroundImage: comments.commenterimg == '-'
                  ? imgNotExist()
                  : imgExist(comments.commenterimg),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width - 100),
                decoration: const BoxDecoration(
                  color: Color.fromARGB(35, 158, 158, 158),
                  borderRadius: BorderRadius.all(
                    Radius.circular(20),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        comments.commentername,
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              comments.commentcontent,
                              style: GoogleFonts.poppins(
                                fontSize: 13,
                                height: 1.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      DateFormat('MMM. dd, yyyy | EEE.').format(
                        comments.commentime.toDate(),
                      ),
                      style: GoogleFonts.poppins(
                        color: Colors.white54,
                        fontSize: 12,
                        height: 1,
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    widget.users.id == comments.commenterId
                        ? allowEditDeleteComment(comments)
                        : Container()
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              )
            ],
          ),
        ],
      );

  allowEditDeleteComment(Comments comments) {
    return Row(
      children: [
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EditComments(comments: comments),
              ),
            );
          },
          child: Text(
            'Edit',
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 12,
              height: 1,
            ),
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        GestureDetector(
          onTap: () {
            _showdialog(comments);
          },
          child: Text(
            'Delete',
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 12,
              height: 1,
            ),
          ),
        ),
      ],
    );
  }

  _popUpDialog(Comments comments) => AlertDialog(
        title: Text(
          'Are you sure?',
          style: GoogleFonts.poppins(color: Colors.white),
        ),
        content: Text(
          'This comment will be deleted. You can not undo these changes.',
          style: GoogleFonts.poppins(color: Colors.white),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(
              'Cancel',
              style: GoogleFonts.poppins(color: Colors.white),
            ),
          ),
          TextButton(
            onPressed: () {
              final commentCount = widget.blogs.totalComments;
              final newCommentCount = commentCount - 1;
              deleteComment(comments.commentId);
              updateCommentsCount(widget.blogs.postId, newCommentCount);
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  duration: const Duration(seconds: 5),
                  content: Text(
                    "Your comment was deleted!",
                    style: GoogleFonts.poppins(),
                  ),
                ),
              );
              Navigator.pop(context);
            },
            child: Text(
              'Yes',
              style: GoogleFonts.poppins(color: Colors.white),
            ),
          ),
        ],
        backgroundColor: Colors.black,
      );

  _showdialog(Comments comments) => showDialog(
        context: context,
        builder: (_) => _popUpDialog(comments),
      );

  deleteComment(id) {
    final docUser = FirebaseFirestore.instance.collection('comments').doc(id);
    docUser.delete();
  }

  commentField() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: Row(
        children: [
          Expanded(
            child: SizedBox(
              height: 40,
              child: TextField(
                controller: commentcontroller,
                maxLines: null,
                obscureText: false,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.only(
                    left: 20,
                  ),
                  filled: true,
                  fillColor: Colors.white10,
                  errorStyle: GoogleFonts.poppins(
                    fontSize: 12,
                    height: 0,
                    fontStyle: FontStyle.italic,
                  ),
                  hintText: "Add comment here...",
                  hintStyle: GoogleFonts.poppins(
                    fontSize: 13,
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ),
          ),
          IconButton(
            onPressed: () {
              if (commentcontroller.text.trim().isEmpty) {
              } else {
                final commentCount = widget.blogs.totalComments;
                final newCommentCount = commentCount + 1;
                createComment();
                updateCommentsCount(widget.blogs.postId, newCommentCount);
                Navigator.pop(context);
              }
            },
            icon: const Icon(Icons.send),
          ),
        ],
      ),
    );
  }

  Widget fetchBlogComments() {
    return StreamBuilder<List<Comments>>(
      stream: readBlogsComments(widget.blogs.postId),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong! ${snapshot.error}');
        } else if (snapshot.hasData) {
          final comments = snapshot.data!;
          if (comments.isEmpty) {
            return Center(
              child: Text(
                'This blog has no comments',
                style: GoogleFonts.poppins(color: Colors.white54),
              ),
            );
          } else {
            return ListView(
              children: comments.map(blogComments).toList(),
            );
          }
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Stream<List<Comments>> readBlogsComments(id) => FirebaseFirestore.instance
      .collection('comments')
      .where('postId', isEqualTo: id)
      .orderBy('commentime', descending: true)
      .snapshots()
      .map(
        (snapshot) => snapshot.docs
            .map(
              (doc) => Comments.fromJson(
                doc.data(),
              ),
            )
            .toList(),
      );

  updateCommentsCount(postId, count) {
    final docUser = FirebaseFirestore.instance.collection('blogs').doc(postId);
    docUser.update({
      'totalComments': count,
    });
  }

  createComment() async {
    final docUser = FirebaseFirestore.instance.collection('comments').doc();

    final newComment = Comments(
      commentId: docUser.id,
      commenterId: user.uid,
      commentcontent: commentcontroller.text,
      commenterimg: widget.users.userProfilePic,
      commentername: widget.users.name,
      commentime: DateTime.now(),
      postId: widget.blogs.postId,
    );

    final json = newComment.toJson();
    await docUser.set(json);

    setState(() {
      commentcontroller.text = "";
    });
  }
}
