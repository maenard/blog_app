import 'package:badges/badges.dart';
import 'package:blog_app/home%20page/profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(),
      body: SafeArea(
        child: Center(
          child: TextButton(
            onPressed: () => FirebaseAuth.instance.signOut(),
            child: Text('Signout bitc'),
          ),
        ),
      ),
    );
  }

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
          profileTab(),
          // const SizedBox(
          //   width: 5,
          // ),
        ],
      );

  profileTab() => InkWell(
        borderRadius: BorderRadius.circular(100),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Profile(),
            ),
          );
        },
        child: Ink(
          child: Padding(
            padding: EdgeInsets.all(13),
            child: ClipOval(
              child: Image.asset("assets/images/photo_male_7.jpg"),
            ),
          ),
        ),
      );

  customAppBar() => AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        actions: [
          appBarActions(),
        ],
        elevation: 0,
        title: Text(
          'Blog.',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
          ),
        ),
        titleSpacing: 10,
      );
}
