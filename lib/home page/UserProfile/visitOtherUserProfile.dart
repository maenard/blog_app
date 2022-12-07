import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class VisitOtherUserProfile extends StatefulWidget {
  const VisitOtherUserProfile({super.key, required this.id});

  final id;

  @override
  State<VisitOtherUserProfile> createState() => _VisitOtherUserProfileState();
}

class _VisitOtherUserProfileState extends State<VisitOtherUserProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(39, 158, 158, 158),
        automaticallyImplyLeading: true,
        title: Text(
          '.blog',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      backgroundColor: Colors.black,
    );
  }
}
