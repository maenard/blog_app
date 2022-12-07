import 'package:blog_app/home%20page/UserProfile/visitOtherUserProfile.dart';
import 'package:blog_app/home%20page/navigation.dart';
import 'package:blog_app/home%20page/profile.dart';
import 'package:blog_app/model/users.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SearchUsers extends StatefulWidget {
  const SearchUsers({super.key});

  @override
  State<SearchUsers> createState() => _SearchUsersState();
}

class _SearchUsersState extends State<SearchUsers> {
  final user = FirebaseAuth.instance.currentUser!;
  late String searchedName;

  @override
  void initState() {
    super.initState();
    searchedName = "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          searhBar(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .where('id', isNotEqualTo: user.uid)
                    .snapshots(),
                builder: (context, snapshot) {
                  return (snapshot.connectionState == ConnectionState.waiting)
                      ? const Center(
                          child: CircularProgressIndicator.adaptive(),
                        )
                      : ListView.builder(
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            var data = snapshot.data!.docs[index].data()
                                as Map<String, dynamic>;
                            if (searchedName.isEmpty) {
                              return userProfiles(
                                data['userProfilePic'],
                                data['name'],
                                data['email'],
                                data['id'],
                              );
                            } else if (data['name']
                                .toString()
                                .toLowerCase()
                                .contains(searchedName.toLowerCase())) {
                              return userProfiles(
                                data['userProfilePic'],
                                data['name'],
                                data['email'],
                                data['id'],
                              );
                            } else {
                              return Container();
                            }
                          },
                        );
                },
              ),
            ),
          ),
          // commentField(),
        ],
      ),
    );
  }

  searhBar() => Padding(
        padding: const EdgeInsets.all(20),
        child: TextFormField(
          onChanged: (value) {
            setState(() {
              searchedName = value;
            });
          },
          scrollPadding: const EdgeInsets.only(bottom: 50),
          decoration: InputDecoration(
            contentPadding:
                const EdgeInsets.only(left: 20, top: 10, bottom: 10),
            filled: true,
            fillColor: Colors.white10,
            hintText: 'Search',
            hintStyle: GoogleFonts.poppins(),
            suffixIcon: const Padding(
              padding: EdgeInsets.only(right: 10),
              child: Icon(Icons.search),
            ),
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
      );

  Widget userProfiles(img, name, email, id) {
    return ListTile(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VisitOtherUserProfile(id: id),
          ),
        );
      },
      leading: CircleAvatar(
        backgroundImage: img == '-'
            ? AssetImage('assets/images/blank_profile.jpg')
            : NetworkImage(img) as ImageProvider,
      ),
      title: Text(name),
      subtitle: Text(email),
    );
  }
}
