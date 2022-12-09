import 'dart:io';
import 'dart:math';

import 'package:blog_app/model/blogs.dart';
import 'package:blog_app/model/users.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NewPost extends StatefulWidget {
  const NewPost({
    super.key,
    required this.newUser,
  });

  final Users newUser;

  @override
  State<NewPost> createState() => _NewPostState();
}

class _NewPostState extends State<NewPost> {
  final user = FirebaseAuth.instance.currentUser!;
  late TextEditingController postcontroller;
  // late Users currentUserInfo;
  late String error;
  PlatformFile? pickedBlogPhoto;
  UploadTask? uploadTaskBlogPhoto;

  @override
  void initState() {
    super.initState();
    postcontroller = TextEditingController();
    error = "";
  }

  Future selectBlogPhoto() async {
    final profile = await FilePicker.platform.pickFiles();
    if (profile == null) return;

    setState(() {
      pickedBlogPhoto = profile.files.first;
    });
  }

  String generateRandomString(int len) {
    var r = Random();
    const _chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    return List.generate(len, (index) => _chars[r.nextInt(_chars.length)])
        .join();
  }

  Future uploadBlogPhoto() async {
    final path = 'blogPics/${generateRandomString(8)}';
    print('update path Link: $path');
    final file = File(pickedBlogPhoto!.path!);
    final ref = FirebaseStorage.instance.ref().child(path);

    try {
      setState(() {
        uploadTaskBlogPhoto = ref.putFile(file);
      });
    } on FirebaseException catch (e) {
      setState(() {
        error = e.message.toString();
      });
    }

    final snapshot = await uploadTaskBlogPhoto!.whenComplete(() {});
    final urlDownload = await snapshot.ref.getDownloadURL();
    print('update Download Link: $urlDownload');

    // batchUpdateCommenterImg(user.uid, urlDownload);
    // batchUpdateBlogAuthorPic(user.uid, urlDownload);
    // updateUserProfilePic(user.uid, urlDownload);

    addBlogWithPic(widget.newUser.posts + 1, urlDownload);

    setState(() {
      uploadTaskBlogPhoto = null;
    });
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
          "Create Post",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              if (postcontroller.text.trim().isEmpty) {
                customSnackBar(Icons.error_outline, 'Your blog is empty');
              } else {
                showCustomDialog();
              }
            },
            child: Text(
              'Post',
              style: GoogleFonts.poppins(color: Colors.blueAccent),
            ),
          ),
        ],
        backgroundColor: Colors.black,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: postField(widget.newUser),
            ),
          ),
          buildProgress(),
        ],
      ),
    );
  }

  showCustomDialog() {
    return showDialog(context: context, builder: (context) => customDialog());
  }

  customDialog() {
    return AlertDialog(
      backgroundColor: Colors.black,
      title: Text(
        'Are you sure?',
        style: GoogleFonts.poppins(),
      ),
      content: Text(
        'This will add new blog to your account.',
        style: GoogleFonts.poppins(),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(
            'No',
            style: GoogleFonts.poppins(),
          ),
        ),
        TextButton(
          onPressed: () {
            if (pickedBlogPhoto == null) {
              addBlogWithoutPic(widget.newUser.posts + 1);
              updateUserPostCount(user.uid, widget.newUser.posts + 1);
              Navigator.pop(context);
            } else {
              uploadBlogPhoto();
              updateUserPostCount(user.uid, widget.newUser.posts + 1);
              Navigator.pop(context);
            }
          },
          child: Text(
            'Yes',
            style: GoogleFonts.poppins(),
          ),
        ),
      ],
    );
  }

  customSnackBar(icon, msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: Duration(seconds: 5),
        content: Row(
          children: [
            Icon(
              icon,
              color: Colors.black,
            ),
            const SizedBox(
              width: 10,
            ),
            Flexible(
              child: Text(
                msg,
                style: GoogleFonts.poppins(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  blogHasPhoto() {
    return Stack(
      children: [
        ClipRect(
          child: Container(
            color: Colors.white12,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * .30,
            child: FittedBox(
              fit: BoxFit.cover,
              child: Image.file(File(pickedBlogPhoto!.path!)),
            ),
          ),
        ),
        Positioned(
          top: 5,
          right: 5,
          child: CircleAvatar(
            backgroundColor: Colors.white38,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  pickedBlogPhoto = null;
                });
              },
              child: Icon(Icons.close),
            ),
          ),
        ),
      ],
    );
  }

  Widget postField(Users user) => Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: userInfo(user),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: TextField(
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
          ),
          pickedBlogPhoto == null ? Container() : blogHasPhoto(),
        ],
      );

  imgNotExist() => const AssetImage('assets/images/blank_profile.jpg');
  imgExist(img) => NetworkImage(img);

  Widget userInfo(Users user) => Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundImage: user.userProfilePic == "-"
                ? imgNotExist()
                : imgExist(user.userProfilePic),
          ),
          const SizedBox(
            width: 10,
          ),
          Text(
            widget.newUser.name,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
          const Expanded(child: SizedBox()),
          IconButton(
            splashRadius: 25,
            icon: Icon(Icons.photo_album_outlined),
            onPressed: () {
              selectBlogPhoto();
            },
          ),
        ],
      );

  updateUserPostCount(id, postCount) {
    final docUser = FirebaseFirestore.instance.collection('users').doc(id);
    docUser.update({
      'posts': postCount,
    });
  }

  Future addBlogWithoutPic(postCount) async {
    final docUser = FirebaseFirestore.instance.collection('blogs').doc();
    final newUser = Blogs(
      postId: docUser.id,
      userId: user.uid,
      content: postcontroller.text,
      datePosted: DateTime.now(),
      authorName: widget.newUser.name,
      authorPic: widget.newUser.userProfilePic,
      likes: [],
      likesCount: 0,
      totalComments: 0,
      blogPhoto: '-',
    );

    final json = newUser.toJson();
    await docUser.set(json);

    // updateUserPostCount(user.uid, postCount);

    setState(() {
      postcontroller.text = "";
    });
    Navigator.pop(context);
    customSnackBar(Icons.check, 'You have successfully added new blog.');
  }

  Future addBlogWithPic(postCount, url) async {
    final docUser = FirebaseFirestore.instance.collection('blogs').doc();
    final newUser = Blogs(
      postId: docUser.id,
      userId: user.uid,
      content: postcontroller.text,
      datePosted: DateTime.now(),
      authorName: widget.newUser.name,
      authorPic: widget.newUser.userProfilePic,
      likes: [],
      likesCount: 0,
      totalComments: 0,
      blogPhoto: url,
    );

    final json = newUser.toJson();
    await docUser.set(json);

    // updateUserPostCount(user.uid, postCount);

    setState(() {
      postcontroller.text = "";
    });

    Navigator.pop(context);
    customSnackBar(Icons.check, 'You have successfully added new blog.');
  }

  Widget buildProgress() => StreamBuilder<TaskSnapshot>(
      stream: uploadTaskBlogPhoto?.snapshotEvents,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final data = snapshot.data!;
          double progress = data.bytesTransferred / data.totalBytes;

          return SizedBox(
            height: 25,
            child: Stack(
              fit: StackFit.expand,
              children: [
                LinearProgressIndicator(
                  value: progress,
                  backgroundColor: Colors.grey,
                  color: Colors.black,
                ),
                Center(
                  child: Text(
                    'Uploading: ${(100 * progress).roundToDouble()}%',
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                )
              ],
            ),
          );
        } else {
          return Container();
        }
      });
}
