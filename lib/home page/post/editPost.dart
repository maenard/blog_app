import 'package:blog_app/model/blogs.dart';
import 'package:blog_app/model/users.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EditPost extends StatefulWidget {
  const EditPost({
    super.key,
    required this.blogs,
  });

  final Blogs blogs;

  @override
  State<EditPost> createState() => _EditPostState();
}

class _EditPostState extends State<EditPost> {
  final user = FirebaseAuth.instance.currentUser!;
  late TextEditingController postcontroller;
  late Users currentUserInfo;

  @override
  void initState() {
    super.initState();
    postcontroller = TextEditingController(text: widget.blogs.content);
  }

  @override
  void dispose() {
    postcontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          "Edit Blogs",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              if (postcontroller.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    duration: const Duration(seconds: 5),
                    content: Text(
                      "Your post is empty!",
                      style: GoogleFonts.poppins(),
                    ),
                  ),
                );
              } else {
                updateBlog(widget.blogs.postId);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    duration: const Duration(seconds: 5),
                    content: Text(
                      "Blog Updated Successfuly!",
                      style: GoogleFonts.poppins(),
                    ),
                  ),
                );
              }
            },
            icon: const Icon(Icons.save),
          ),
        ],
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              readCurrentUser(user.uid),
            ],
          ),
        ),
      ),
    );
  }

  Widget postField(Users user) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          userInfo(user),
          TextField(
            onChanged: (value) => {
              if (postcontroller.text.isEmpty)
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
            controller: postcontroller,
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

  Widget userInfo(Users newUser) => Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundImage: newUser.userProfilePic == "-"
                ? imgNotExist()
                : imgExist(newUser.userProfilePic),
          ),
          const SizedBox(
            width: 10,
          ),
          Text(
            newUser.name,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
        ],
      );

  updateBlog(id) {
    final docUser = FirebaseFirestore.instance.collection('blogs').doc(id);
    docUser.update({
      'content': postcontroller.text,
    });

    Navigator.pop(context);
  }

  Widget readCurrentUser(uid) {
    var collection = FirebaseFirestore.instance.collection('users');
    return Column(
      children: [
        StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          stream: collection.doc(uid).snapshots(),
          builder: (_, snapshot) {
            if (snapshot.hasError) return Text('Error = ${snapshot.error}');

            if (snapshot.hasData) {
              final users = snapshot.data!.data();
              final newUser = Users(
                id: users!['id'],
                name: users['name'],
                password: users['password'],
                email: users['email'],
                userProfilePic: users['userProfilePic'],
                userProfileCover: users['userProfileCover'],
                about: users['about'],
              );
              currentUserInfo = newUser;
              return (postField(newUser));
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ],
    );
  }
}
