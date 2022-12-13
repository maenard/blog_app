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
  late String error;
  PlatformFile? pickedBlogPhoto;
  UploadTask? uploadTaskBlogPhoto;

  @override
  void initState() {
    super.initState();
    postcontroller = TextEditingController(text: widget.blogs.content);
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

    updateBlogWithPic(widget.blogs.postId, urlDownload);

    setState(() {
      uploadTaskBlogPhoto = null;
    });
    Navigator.pop(context);
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
          "Edit Blog",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              if (postcontroller.text.trim().isEmpty) {
                customSnackBar(Icons.error_outline, 'Your blog is empty.');
              } else {
                showCustomDialog(dialogForUpdatingBlog());
              }
            },
            child: Text(
              'Save',
              style: GoogleFonts.poppins(
                color: Colors.blueAccent,
              ),
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
              child: readCurrentUser(user.uid),
            ),
          ),
          buildProgress(),
        ],
      ),
    );
  }

  blogHasPickedPhoto() {
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
              child: Image.network(widget.blogs.blogPhoto),
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
                showCustomDialog(dialogForDeletingExistingBlogPhoto());
              },
              child: Icon(Icons.close),
            ),
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

  Widget postField(Users user) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
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
          pickedBlogPhoto == null ? checkBlogPhotoVal() : blogHasPickedPhoto(),
        ],
      );

  Widget checkBlogPhotoVal() {
    return widget.blogs.blogPhoto != '-' ? blogHasPhoto() : Container();
  }

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

  dialogForUpdatingBlog() {
    return AlertDialog(
      backgroundColor: Colors.black,
      title: Text(
        'Are you sure?',
        style: GoogleFonts.poppins(),
      ),
      content: Text(
        'This will update your blog.',
        style: GoogleFonts.poppins(),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(
            'Cancel',
            style: GoogleFonts.poppins(),
          ),
        ),
        TextButton(
          onPressed: () {
            if (pickedBlogPhoto == null) {
              updateBlogWithoutPic(widget.blogs.postId);
            } else {
              widget.blogs.blogPhoto != '-'
                  ? deleteBlogPhoto(widget.blogs.blogPhoto)
                  : print('this post has no pic');
              uploadBlogPhoto();
              Navigator.pop(context);
            }
          },
          child: Text(
            'Update',
            style: GoogleFonts.poppins(color: Colors.blueAccent),
          ),
        ),
      ],
    );
  }

  dialogForDeletingExistingBlogPhoto() {
    return AlertDialog(
      backgroundColor: Colors.black,
      title: Text(
        'Are you sure?',
        style: GoogleFonts.poppins(),
      ),
      content: Text(
        'This will delete the photo of your blog.',
        style: GoogleFonts.poppins(),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(
            'Cancel',
            style: GoogleFonts.poppins(),
          ),
        ),
        TextButton(
          onPressed: () {
            updateDeletedBlogPhoto(widget.blogs.postId);
            deleteBlogPhoto(widget.blogs.blogPhoto);
            Navigator.pop(context);
            Navigator.pop(context);
            customSnackBar(
              Icons.check,
              'You have successfully deleted the picture.',
            );
          },
          child: Text(
            'Delete',
            style: GoogleFonts.poppins(color: Colors.red),
          ),
        ),
      ],
    );
  }

  showCustomDialog(dialog) {
    return showDialog(
      context: context,
      builder: (context) => dialog,
    );
  }

  deleteBlogPhoto(url) {
    var ref = FirebaseStorage.instance.refFromURL(url);
    ref.delete();
  }

  updateDeletedBlogPhoto(id) {
    final docUser = FirebaseFirestore.instance.collection('blogs').doc(id);
    docUser.update({
      'blogPhoto': '-',
    });
  }

  updateBlogWithPic(id, url) {
    final docUser = FirebaseFirestore.instance.collection('blogs').doc(id);
    docUser.update({
      'blogPhoto': url,
      'content': postcontroller.text,
    });
    // Navigator.pop(context);
    customSnackBar(Icons.check, 'You have successfully updated your blog.');
  }

  updateBlogWithoutPic(id) {
    final docUser = FirebaseFirestore.instance.collection('blogs').doc(id);
    docUser.update({
      'content': postcontroller.text,
    });
    Navigator.pop(context);
    Navigator.pop(context);
    customSnackBar(Icons.check, 'You have successfully updated your blog.');
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
                followers: users['followers'],
                followerCount: users['followerCount'],
                posts: users['posts'],
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
        },
      );
}
