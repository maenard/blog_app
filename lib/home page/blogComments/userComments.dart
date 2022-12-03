import 'package:blog_app/model/blogs.dart';
import 'package:blog_app/model/comments.dart';
import 'package:blog_app/model/users.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

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
              child: ListView(
                children: [fetchBlogComments()],
              ),
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
                        ? allowEditDeleteComment()
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

  allowEditDeleteComment() {
    return Row(
      children: [
        Text(
          'Edit',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 12,
            height: 1,
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        Text(
          'Delete',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 12,
            height: 1,
          ),
        ),
      ],
    );
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
              createComment();
              updateCommentsCount(
                  widget.blogs.postId, widget.blogs.totalComments + 1);
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

          return Column(
            children: comments.map(blogComments).toList(),
          );
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
