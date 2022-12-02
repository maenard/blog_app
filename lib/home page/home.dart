import 'package:badges/badges.dart';
import 'package:blog_app/home%20page/post/newPost.dart';
import 'package:blog_app/home%20page/profile.dart';
import 'package:blog_app/model/blogs.dart';
import 'package:blog_app/model/users.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class Home extends StatefulWidget {
  const Home({
    super.key,
  });

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final user = FirebaseAuth.instance.currentUser!;
  late String currentUserName;
  late String userId;

  @override
  void initState() {
    super.initState();
    currentUserName = "";
    userId = "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      // appBar: customAppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              fetchUserProfile(),
              fetchAllBlogs(),
            ],
          ),
        ),
      ),
    );
  }

  Widget fetchAllBlogs() {
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
            child: CircularProgressIndicator(),
          );
        }
      },
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
            children: _user.map(addPost).toList(),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator.adaptive(),
          );
        }
      },
    );
  }

  imgNotExist() => const AssetImage('assets/images/blank_profile.jpg');
  imgExist(img) => NetworkImage(img);

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
                      radius: 18,
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
                      constraints: BoxConstraints(),
                      splashRadius: 20,
                      onPressed: () {},
                      icon: Icon(Icons.star_outline),
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
                    Text(
                      '1k Stars',
                      style: GoogleFonts.poppins(
                        color: Colors.white54,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ],
      );

  Widget addPost(Users newUser) => Container(
        color: Colors.white10,
        padding: const EdgeInsets.all(20),
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            userGreeting(newUser),
          ],
        ),
      );

  Widget postField(Users newUser) => Row(
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
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: ((context) => NewPost(
                            newUser: newUser,
                          )),
                    ),
                  );
                },
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

  Widget userGreeting(Users newUser) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Good day,",
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      color: Colors.white54,
                    ),
                  ),
                  Text(
                    newUser.name,
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      height: 1.2,
                    ),
                  ),
                ],
              ),
              IconButton(
                padding: EdgeInsets.zero,
                constraints: BoxConstraints(),
                onPressed: () {
                  FirebaseAuth.instance.signOut();
                },
                icon: Icon(Icons.logout_outlined),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          postField(newUser),
        ],
      );

  Stream<List<Blogs>> readPosts() => FirebaseFirestore.instance
      .collection('blogs')
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
