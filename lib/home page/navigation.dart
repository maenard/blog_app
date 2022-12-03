import 'package:blog_app/home%20page/home.dart';
import 'package:blog_app/home%20page/profile.dart';
import 'package:blog_app/home%20page/userNotif.dart';
import 'package:blog_app/model/users.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Navigation extends StatefulWidget {
  const Navigation({super.key});

  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  int navBarIndex = 1;
  screens() => [
        Profile(),
        Home(),
        UserNotif(),
      ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        height: 60,
        selectedIndex: navBarIndex,
        onDestinationSelected: (navBarIndex) =>
            setState(() => this.navBarIndex = navBarIndex),
        elevation: 0,
        backgroundColor: Colors.black,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(
              Icons.home,
              color: Colors.blueAccent,
            ),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.notifications_active_outlined),
            selectedIcon: Icon(
              Icons.notifications,
              color: Colors.blueAccent,
            ),
            label: 'Notifications',
          ),
        ],
      ),
      backgroundColor: Colors.black,
      body: screens()[navBarIndex],
    );
  }
}
