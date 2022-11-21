import 'package:badges/badges.dart';
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
      extendBodyBehindAppBar: true,
      appBar: customAppBar(),
      body: Center(child: Text('Home')),
    );
  }

  customAppBar() => AppBar(
        backgroundColor: Colors.transparent,
        actions: [
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
          SizedBox(
            width: 5,
          ),
        ],
        elevation: 0,
        leading: InkWell(
          borderRadius: BorderRadius.circular(100),
          onTap: () {},
          child: Ink(
            child: Padding(
              padding: const EdgeInsets.all(13),
              child: ClipOval(
                child: Image(
                  image: AssetImage('assets/images/photo_male_7.jpg'),
                ),
              ),
            ),
          ),
        ),
        title: Text(
          'Blog.',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
          ),
        ),
        titleSpacing: 0,
      );
}
