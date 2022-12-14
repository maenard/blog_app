import 'package:blog_app/home%20page/home.dart';
import 'package:blog_app/home%20page/profile.dart';
import 'package:blog_app/home%20page/searchUsers.dart';
import 'package:blog_app/model/users.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class Navigation extends StatefulWidget {
  const Navigation({super.key});

  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  int navBarIndex = 1;
  screens() => [
        const Profile(),
        const Home(),
        const SearchUsers(),
      ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(39, 158, 158, 158),
        elevation: 0,
        title: Text(
          '.blog',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              showCustomDialog();
            },
            child: Text(
              'Sign out',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w300,
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(
            width: 5,
          )
        ],
      ),
      bottomNavigationBar: NavigationBar(
        height: 60,
        selectedIndex: navBarIndex,
        onDestinationSelected: (navBarIndex) =>
            setState(() => this.navBarIndex = navBarIndex),
        elevation: 0,
        backgroundColor: const Color.fromARGB(35, 158, 158, 158),
        destinations: [
          NavigationDestination(
            icon: fetchCurrentUserProfilePic(),
            selectedIcon: fetchCurrentUserProfilePic(),
            label: 'Profile',
          ),
          const NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(
              Icons.home,
              color: Colors.blueAccent,
            ),
            label: 'Home',
          ),
          const NavigationDestination(
            icon: Icon(Icons.search),
            selectedIcon: Icon(
              Icons.search,
              color: Colors.blueAccent,
            ),
            label: 'Search',
          ),
        ],
      ),
      backgroundColor: Colors.black,
      body: screens()[navBarIndex],
    );
  }

  Widget fetchCurrentUserProfilePic() {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return snapshot.data?['userProfilePic'] != '-'
              ? CircleAvatar(
                  backgroundImage:
                      NetworkImage(snapshot.data?['userProfilePic']),
                  radius: 15,
                )
              : const CircleAvatar(
                  backgroundImage:
                      AssetImage('assets/images/blank_profile.jpg'),
                  radius: 15);
        } else {
          return const Icon(Icons.person);
        }
      },
    );
  }

  customDialog() {
    return AlertDialog(
      icon: const Icon(Icons.logout_outlined),
      backgroundColor: const Color.fromARGB(255, 28, 28, 28),
      actionsAlignment: MainAxisAlignment.center,
      content: Text(
        'Are you sure you want to sign out?',
        style: GoogleFonts.poppins(),
        textAlign: TextAlign.center,
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
            FirebaseAuth.instance.signOut();
            Navigator.pop(context);
            customSnackBar(
              Icons.check,
              'You have successfully signed out your account',
            );
          },
          child: Text(
            'Sign out',
            style: GoogleFonts.poppins(color: Colors.blueAccent),
          ),
        ),
      ],
    );
  }

  showCustomDialog() {
    return showDialog(
      context: context,
      builder: (context) => customDialog(),
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
}
