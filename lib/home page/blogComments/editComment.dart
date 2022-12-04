import 'package:blog_app/model/comments.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import "package:flutter/material.dart";
import 'package:google_fonts/google_fonts.dart';

class EditComments extends StatefulWidget {
  const EditComments({
    super.key,
    required this.comments,
  });
  final Comments comments;

  @override
  State<EditComments> createState() => _EditCommentsState();
}

class _EditCommentsState extends State<EditComments> {
  late TextEditingController commentController;

  @override
  void initState() {
    super.initState();
    commentController =
        TextEditingController(text: widget.comments.commentcontent);
  }

  @override
  void dispose() {
    commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          "Edit Comment",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              if (commentController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    duration: const Duration(seconds: 5),
                    content: Text(
                      "Your comment is empty!",
                      style: GoogleFonts.poppins(),
                    ),
                  ),
                );
              } else {
                updateComment(widget.comments.commentId);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    duration: const Duration(seconds: 5),
                    content: Text(
                      "Comment Updated Successfuly!",
                      style: GoogleFonts.poppins(),
                    ),
                  ),
                );
              }
            },
            icon: const Icon(Icons.save),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              postField(widget.comments),
            ],
          ),
        ),
      ),
    );
  }

  Widget postField(Comments comments) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          userInfo(comments),
          TextField(
            onChanged: (value) => {
              if (commentController.text.isEmpty)
                {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      duration: const Duration(seconds: 5),
                      content: Text(
                        "Please fill out this field",
                        style: GoogleFonts.poppins(),
                      ),
                    ),
                  ),
                }
              else
                {}
            },
            maxLines: null,
            scrollPadding: const EdgeInsets.only(bottom: 50),
            controller: commentController,
            decoration: InputDecoration(
              hintText: 'What\'s on your mind?',
              hintStyle: GoogleFonts.poppins(),
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
        ],
      );

  imgNotExist() => const AssetImage('assets/images/blank_profile.jpg');
  imgExist(img) => NetworkImage(img);

  Widget userInfo(Comments comments) => Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundImage: comments.commenterimg == "-"
                ? imgNotExist()
                : imgExist(comments.commenterimg),
          ),
          const SizedBox(
            width: 10,
          ),
          Text(
            comments.commentername,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
        ],
      );

  updateComment(id) {
    final docUser = FirebaseFirestore.instance.collection('comments').doc(id);
    docUser.update({
      'commentcontent': commentController.text,
    });

    Navigator.pop(context);
  }
}
