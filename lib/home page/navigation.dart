import 'package:blog_app/home%20page/home.dart';
import 'package:blog_app/home%20page/profile.dart';
import 'package:blog_app/home%20page/userNotif.dart';
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
  List<Widget> pages = [
    UserNotif(),
    Home(),
    Profile(),
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
            icon: Icon(Icons.notifications_active_outlined),
            selectedIcon: Icon(
              Icons.notifications,
              color: Colors.blueAccent,
            ),
            label: 'Notifications',
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
            icon: CircleAvatar(
              backgroundImage: AssetImage('assets/images/photo_male_7.jpg'),
              radius: 15,
            ),
            selectedIcon: CircleAvatar(
              backgroundImage: AssetImage('assets/images/photo_male_7.jpg'),
              radius: 15,
            ),
            label: 'Profile',
          ),
        ],
      ),
      backgroundColor: Colors.black,
      body: pages[navBarIndex],
    );
  }
}
