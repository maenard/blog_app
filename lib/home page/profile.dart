import 'package:blog_app/home%20page/post/editPost.dart';
import 'package:blog_app/home%20page/post/newPost.dart';
import 'package:blog_app/model/blogs.dart';
import 'package:blog_app/model/users.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:sweetsheet/sweetsheet.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final user = FirebaseAuth.instance.currentUser!;
  final SweetSheet dialog = SweetSheet();
  late String currUserName;

  @override
  void initState() {
    super.initState();
    currUserName = "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          'Profile',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
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
          return Column(
            children: blogs.map(userPost).toList(),
          );
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
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 10,
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
                    IconButton(
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      splashRadius: 20,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditPost(blogs: blogs),
                          ),
                        );
                      },
                      icon: const Icon(Icons.edit_note_rounded),
                    ),
                    IconButton(
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      splashRadius: 20,
                      onPressed: () {
                        dialog.show(
                          icon: Icons.delete,
                          context: context,
                          title: Text(
                            'Are you sure?',
                            style: GoogleFonts.poppins(),
                          ),
                          description: Text(
                            'This blog will be deleted. You can not undo these changes.',
                            style: GoogleFonts.poppins(),
                          ),
                          color: SweetSheetColor.DANGER,
                          negative: SweetSheetAction(
                            title: 'Cancel',
                            icon: Icons.close,
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          positive: SweetSheetAction(
                            title: 'Yes',
                            icon: Icons.check,
                            onPressed: () {
                              deleteBlog(blogs.postId);
                              Navigator.of(context).pop();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  duration: const Duration(seconds: 5),
                                  content: Text(
                                    "Your post is deleted!",
                                    style: GoogleFonts.poppins(),
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      },
                      icon: const Icon(Icons.delete_outline_rounded),
                    )
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
                  children: [
                    const Icon(
                      Icons.thumb_up_sharp,
                      color: Colors.white54,
                      size: 18,
                    ),
                    Text(
                      ' ${blogs.likesCount.toString()}',
                      style: GoogleFonts.poppins(
                        color: Colors.white54,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    const Icon(
                      Icons.message_outlined,
                      color: Colors.white54,
                      size: 18,
                    ),
                    Text(
                      ' ${blogs.likesCount.toString()}',
                      style: GoogleFonts.poppins(
                        color: Colors.white54,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
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
        color: Colors.white10,
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
        color: Colors.white10,
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
                      ? Container(
                          color: Colors.white12,
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * .30,
                        )
                      : Container(
                          color: Colors.white12,
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * .30,
                          child: FittedBox(
                            fit: BoxFit.fill,
                            child: Image.network(newUser.userProfileCover),
                          ),
                        ),
                  Positioned(
                    bottom: -70,
                    child: CircleAvatar(
                      backgroundImage: newUser.userProfilePic == "-"
                          ? imgNotExist()
                          : imgExist(newUser.userProfilePic),
                      radius: 70,
                    ),
                  ),
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
