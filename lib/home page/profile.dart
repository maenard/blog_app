import 'package:blog_app/home%20page/UserProfile/uploadCoverPic.dart';
import 'package:blog_app/home%20page/UserProfile/uploadProfilePic.dart';
import 'package:blog_app/home%20page/blogComments/userComments.dart';
import 'package:blog_app/home%20page/post/editPost.dart';
import 'package:blog_app/home%20page/post/newPost.dart';
import 'package:blog_app/model/blogs.dart';
import 'package:blog_app/model/users.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'dart:math';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final user = FirebaseAuth.instance.currentUser!;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Column(
          children: [
            fetchUserProfile(),
            fetchUserBlogs(),
          ],
        ),
      ),
    );
  }

  Widget fetchUserProfile() {
    return StreamBuilder<List<Users>>(
      stream: readUserProfile(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong! ${snapshot.error}');
        } else if (snapshot.hasData) {
          final _user = snapshot.data!;
          return Column(
            children: _user.map(userProfile).toList(),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator.adaptive(),
          );
        }
      },
    );
  }

  Widget fetchUserBlogs() {
    return StreamBuilder<List<Blogs>>(
      stream: readPosts(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong! ${snapshot.error}');
        } else if (snapshot.hasData) {
          final blogs = snapshot.data!;
          if (blogs.isEmpty) {
            return Center(
              child: Text(
                'You don\'t have any blog yet',
                style: GoogleFonts.poppins(
                  color: Colors.white54,
                  height: 3,
                ),
              ),
            );
          } else {
            return Column(
              children: blogs.map(userPost).toList(),
            );
          }
        } else {
          return const Center(
            child: CircularProgressIndicator.adaptive(),
          );
        }
      },
    );
  }

  Widget userPost(Blogs blogs) => Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          Container(
            padding: const EdgeInsets.only(
              right: 20,
              left: 20,
              top: 10,
            ),
            color: Colors.white10,
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      backgroundImage: blogs.authorPic == "-"
                          ? imgNotExist()
                          : imgExist(blogs.authorPic),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          blogs.authorName,
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                          overflow: TextOverflow.clip,
                        ),
                        Text(
                          DateFormat('MMM. dd, yyyy | EEE.')
                              .format(blogs.datePosted.toDate()),
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            height: 1.2,
                          ),
                        ),
                      ],
                    ),
                    const Expanded(child: SizedBox()),
                    SizedBox(
                      width: 20,
                      child: PopupMenuButton(
                        onSelected: (value) {
                          if (value == 'edit') {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditPost(blogs: blogs),
                              ),
                            );
                          } else {
                            _showdialog(blogs);
                          }
                        },
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            value: 'edit',
                            child: Text(
                              'Edit',
                              style: GoogleFonts.poppins(),
                            ),
                          ),
                          PopupMenuItem(
                            value: 'delete',
                            child: Text(
                              'Delete',
                              style: GoogleFonts.poppins(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        blogs.content,
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          height: 1.5,
                        ),
                        textAlign: TextAlign.start,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      ' ${blogs.likesCount.toString()} ${likeGrammar(blogs.likesCount)} •',
                      style: GoogleFonts.poppins(
                        color: Colors.white54,
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      ' ${blogs.totalComments} ${commentGrammar(blogs.totalComments)}',
                      style: GoogleFonts.poppins(
                        color: Colors.white54,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                const Divider(
                  height: .9,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          if (blogs.likes!.contains(user.uid)) {
                            final newLikes = blogs.likes;
                            final newLikesCount = blogs.likes!.length - 1;
                            newLikes!.remove(user.uid);
                            updateBlog(blogs.postId, newLikes, newLikesCount);
                          } else {
                            final newLikes = blogs.likes;
                            final newLikesCount = blogs.likes!.length + 1;
                            newLikes!.add(user.uid);
                            updateBlog(blogs.postId, newLikes, newLikesCount);
                          }
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            blogs.likes!.contains(user.uid)
                                ? liked()
                                : notLiked(),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          final db = FirebaseFirestore.instance;
                          final docRef = db.collection("users").doc(user.uid);
                          docRef.get().then(
                            (DocumentSnapshot doc) {
                              final data = doc.data() as Map<String, dynamic>;
                              final newUser = Users(
                                id: data['id'],
                                name: data['name'],
                                password: data['password'],
                                email: data['email'],
                                userProfilePic: data['userProfilePic'],
                                userProfileCover: data['userProfileCover'],
                              );

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => UserComments(
                                    blogs: blogs,
                                    users: newUser,
                                  ),
                                ),
                              );
                            },
                            onError: (e) => print("Error getting document: $e"),
                          );
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.message_outlined,
                              color: Colors.white54,
                            ),
                            Text(
                              " Comment",
                              style: GoogleFonts.poppins(
                                color: Colors.white54,
                                fontSize: 12,
                                // height: 3.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      );

  _popUpDialog(Blogs blogs) => AlertDialog(
        title: Text(
          'Are you sure?',
          style: GoogleFonts.poppins(color: Colors.white),
        ),
        content: Text(
          'This blog will be deleted. You can not undo these changes.',
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
              batchDeleteComments(blogs.postId);
              deleteBlog(blogs.postId);
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  duration: const Duration(seconds: 5),
                  content: Text(
                    "Your blog is deleted!",
                    style: GoogleFonts.poppins(),
                  ),
                ),
              );
            },
            child: Text(
              'Yes',
              style: GoogleFonts.poppins(color: Colors.white),
            ),
          ),
        ],
        backgroundColor: Colors.black,
      );

  _showdialog(Blogs blogs) => showDialog(
        context: context,
        builder: (_) => _popUpDialog(blogs),
      );

  likeGrammar(count) {
    if (count <= 1) {
      return 'Like';
    } else {
      return 'Likes';
    }
  }

  commentGrammar(count) {
    if (count <= 1) {
      return 'Comment';
    } else {
      return 'Comments';
    }
  }

  liked() => Row(
        children: [
          const Icon(
            Icons.thumb_up_sharp,
            color: Colors.blueAccent,
          ),
          Text(
            ' Like',
            style: GoogleFonts.poppins(color: Colors.blueAccent),
          )
        ],
      );
  notLiked() => Row(
        children: [
          const Icon(
            Icons.thumb_up_sharp,
            color: Colors.white54,
          ),
          Text(
            ' Like',
            style: GoogleFonts.poppins(color: Colors.white54),
          )
        ],
      );

  Widget userProfile(Users newUser) => Column(
        children: [
          userDetail(newUser),
          const SizedBox(
            height: 10,
          ),
          addPost(newUser),
        ],
      );

  addPost(Users newUser) => Container(
        color: Color.fromARGB(35, 158, 158, 158),
        padding: const EdgeInsets.all(20),
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'Post',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const Expanded(
                  child: Divider(
                    color: Colors.white,
                    indent: 10,
                  ),
                ),
              ],
            ),
            postField(newUser),
          ],
        ),
      );

  postField(Users newUser) => Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundImage: newUser.userProfilePic == "-"
                ? imgNotExist()
                : imgExist(newUser.userProfilePic),
            radius: 18,
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: SizedBox(
              height: 40,
              child: TextField(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: ((context) => NewPost(
                          newUser: newUser,
                        )),
                  ),
                ),
                readOnly: true,
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
                  hintText: "What's on your mind...?",
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
        ],
      );

  imgNotExist() => const AssetImage('assets/images/blank_profile.jpg');
  imgExist(img) => NetworkImage(img);

  userDetail(Users newUser) => Container(
        color: Color.fromARGB(35, 158, 158, 158),
        padding: const EdgeInsets.only(bottom: 20),
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 70),
              child: Stack(
                alignment: Alignment.center,
                clipBehavior: Clip.none,
                children: [
                  newUser.userProfileCover == "-"
                      ? userNoCoverPhoto(newUser)
                      : userHasCoverPhoto(newUser),
                  userProfilePic(newUser),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              newUser.name,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            Text(
              newUser.email,
              style: GoogleFonts.poppins(
                color: Colors.white54,
                fontSize: 15,
                height: .9,
              ),
            ),
          ],
        ),
      );

  userProfilePic(Users newUser) {
    return Positioned(
      bottom: -70,
      child: Stack(
        alignment: Alignment.topLeft,
        children: [
          CircleAvatar(
            backgroundImage: newUser.userProfilePic == "-"
                ? imgNotExist()
                : imgExist(newUser.userProfilePic),
            radius: 70,
          ),
          CircleAvatar(
            radius: 20,
            backgroundColor: Colors.blueAccent,
            child: GestureDetector(
              onTap: () {
                // selectProfile();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UploadProfilePic(newUser: newUser),
                  ),
                );
              },
              child: const Icon(
                Icons.camera_alt_outlined,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  userHasCoverPhoto(Users newUser) {
    return Stack(
      children: [
        ClipRect(
          child: Container(
            color: Colors.white12,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * .25,
            child: FittedBox(
              fit: BoxFit.cover,
              child: Image.network(newUser.userProfileCover),
            ),
          ),
        ),
        Positioned(
          top: 5,
          left: 5,
          child: CircleAvatar(
            radius: 15,
            backgroundColor: Color.fromARGB(105, 68, 137, 255),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UploadCoverPic(newUser: newUser),
                  ),
                );
              },
              child: const Icon(
                Icons.photo_camera_front_outlined,
                color: Colors.white,
                size: 15,
              ),
            ),
          ),
        ),
      ],
    );
  }

  userNoCoverPhoto(Users newUser) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => UploadCoverPic(newUser: newUser),
          ),
        );
      },
      child: Container(
        color: Colors.white12,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * .25,
        child: Column(
          children: [
            const SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.camera_alt_outlined,
                  color: Colors.grey,
                  size: 15,
                ),
                Text(
                  ' Tap to update your cover photo.',
                  style: GoogleFonts.poppins(
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  updateBlog(id, newLikes, newLikesCount) {
    final docUser = FirebaseFirestore.instance.collection('blogs').doc(id);
    docUser.update({
      'likes': newLikes,
      'likesCount': newLikesCount,
    });
  }

  Future<void> batchDeleteComments(id) {
    WriteBatch batch = FirebaseFirestore.instance.batch();
    final comments = FirebaseFirestore.instance
        .collection('comments')
        .where('postId', isEqualTo: id);
    return comments.get().then((querySnapshot) {
      querySnapshot.docs.forEach((document) {
        batch.delete(document.reference);
      });

      return batch.commit();
    });
  }

  deleteBlog(id) {
    final docUser = FirebaseFirestore.instance.collection('blogs').doc(id);
    docUser.delete();
  }

  Stream<List<Blogs>> readPosts() => FirebaseFirestore.instance
      .collection('blogs')
      .where("userId", isEqualTo: user.uid)
      .orderBy("datePosted", descending: true)
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => Blogs.fromJson(doc.data())).toList());

  Stream<List<Users>> readUserProfile() => FirebaseFirestore.instance
      .collection('users')
      .where("id", isEqualTo: user.uid)
      .limit(1)
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => Users.fromJson(doc.data())).toList());
}
