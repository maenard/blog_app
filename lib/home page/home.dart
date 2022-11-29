import 'package:badges/badges.dart';
import 'package:blog_app/home%20page/post/newPost.dart';
import 'package:blog_app/home%20page/profile.dart';
import 'package:blog_app/model/users.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final user = FirebaseAuth.instance.currentUser!;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      // appBar: customAppBar(),
      body: SafeArea(
        child: ListView(
          children: [
            addPost(),
            const SizedBox(
              height: 10,
            ),
            blogPosts(),
            const SizedBox(
              height: 10,
            ),
            blogPosts(),
            const SizedBox(
              height: 10,
            ),
            blogPosts(),
            const SizedBox(
              height: 10,
            ),
            blogPosts(),
            const SizedBox(
              height: 10,
            ),
            blogPosts(),
          ],
        ),
      ),
    );
  }

  Widget blogPosts() => Container(
        color: Colors.white12,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            userPost(),
          ],
        ),
      );

  Widget userPost() => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundImage: AssetImage("assets/images/photo_male_7.jpg"),
              ),
              const SizedBox(
                width: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Maenard Abo-Abo",
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  Text(
                    "December 1, 2022",
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
                  "There are many variations of passages of Lorem Ipsum available, but the majority have suffered alteration in some form, by injected humour, or randomised words which don't look even slightly believable. If you are going to use a passage of Lorem Ipsum, you need to be sure there isn't anything embarrassing hidden in the middle of text. All the Lorem Ipsum generators on the Internet tend to repeat predefined chunks as necessary, making this the first true generator on the Internet. It uses a dictionary of over 200 Latin words, combined with a handful of model sentence structures, to generate Lorem Ipsum which looks reasonable. The generated Lorem Ipsum is therefore always free from repetition, injected humour, or non-characteristic words etc.",
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.justify,
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
      );

  Widget addPost() => Container(
        color: Colors.white12,
        padding: const EdgeInsets.all(20),
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            readCurrentUser(user.uid),
            const SizedBox(
              height: 10,
            ),
            postField(),
          ],
        ),
      );

  Widget postField() => Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          CircleAvatar(
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

  Widget userGreeting(Users userInfo) => Column(
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
                    userInfo.name,
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
        ],
      );

  appBarActions() => Row(
        children: [
          IconButton(
            splashRadius: 20,
            onPressed: () {},
            icon: Icon(Icons.search),
          ),
          IconButton(
            splashRadius: 20,
            onPressed: () {},
            icon: Badge(
              padding: EdgeInsets.all(3),
              animationType: BadgeAnimationType.fade,
              position: BadgePosition.topEnd(
                top: -8,
                end: -3,
              ),
              badgeContent: Text(
                '69',
                style: GoogleFonts.poppins(
                  fontSize: 9,
                ),
              ),
              child: Icon(Icons.notifications_none),
            ),
          ),
        ],
      );

  // profileTab() => InkWell(
  //       borderRadius: BorderRadius.circular(100),
  //       onTap: () {
  //         Navigator.push(
  //           context,
  //           MaterialPageRoute(
  //             builder: (context) => Profile(),
  //           ),
  //         );
  //       },
  //       child: Ink(
  //         child: Padding(
  //           padding: EdgeInsets.all(15),
  //           child: ClipOval(
  //             child: Image.asset("assets/images/photo_male_7.jpg"),
  //           ),
  //         ),
  //       ),
  //     );

  customAppBar() => AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.grey.shade900,
        actions: [
          appBarActions(),
        ],
        elevation: 0,
        title: Text(
          '.blog',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
          ),
        ),
        titleSpacing: 15,
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

              return (userGreeting(newUser));
            }

            return const Center(child: CircularProgressIndicator());
          },
        ),
      ],
    );
  }
}
