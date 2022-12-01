import 'package:blog_app/home%20page/post/newPost.dart';
import 'package:blog_app/model/blogs.dart';
import 'package:blog_app/model/users.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final user = FirebaseAuth.instance.currentUser!;
  late String currUserName;
  late String userId;

  @override
  void initState() {
    super.initState();
    currUserName = "";
    userId = "";
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
            readCurrentUser(user.uid),
            const SizedBox(
              height: 10,
            ),
            addPost(),
            StreamBuilder<List<Blogs>>(
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
            ),
          ],
        ),
      ),
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
                      backgroundImage:
                          AssetImage("assets/images/photo_male_7.jpg"),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          blogs.userId,
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
                      onPressed: () {},
                      icon: const Icon(Icons.edit_note_rounded),
                    ),
                    IconButton(
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      splashRadius: 20,
                      onPressed: () {},
                      icon: Icon(Icons.delete_outline_rounded),
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
                    IconButton(
                      onPressed: () {},
                      padding: EdgeInsets.zero,
                      constraints: BoxConstraints(),
                      splashRadius: 20,
                      icon: Icon(
                        Icons.star_border,
                        size: 18,
                      ),
                    ),
                    Text(
                      ' 1k Stars',
                      style: GoogleFonts.poppins(
                        color: Colors.white54,
                        fontSize: 12,
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ],
      );

  Widget addPost() => Container(
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
            postField(currUserName),
          ],
        ),
      );

  Widget postField(String currUserName) => Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const CircleAvatar(
            backgroundImage: AssetImage('assets/images/photo_male_7.jpg'),
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
                    builder: ((context) => NewPost()),
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

  Widget userStats() => IntrinsicHeight(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '150',
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Posts',
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    // fontWeight: FontWeight.w400,
                    height: .9,
                  ),
                ),
              ],
            ),
            const VerticalDivider(
              color: Colors.white,
              indent: 4,
              endIndent: 4,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '50',
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Stars',
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    // fontWeight: FontWeight.w400,
                    height: .9,
                  ),
                ),
              ],
            ),
          ],
        ),
      );

  Widget userDetail(Users newUser) => Container(
        color: Colors.white10,
        padding: const EdgeInsets.all(20),
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundImage: AssetImage("assets/images/photo_male_7.jpg"),
              radius: 70,
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
                fontSize: 12,
                height: .8,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            userStats(),
          ],
        ),
      );

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
              );
              return (userDetail(newUser));
            }

            return const Center(child: CircularProgressIndicator());
          },
        ),
      ],
    );
  }

  Stream<List<Blogs>> readPosts() => FirebaseFirestore.instance
      .collection('blogs')
      .where("userId", isEqualTo: user.uid)
      .orderBy("datePosted", descending: true)
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => Blogs.fromJson(doc.data())).toList());
}
