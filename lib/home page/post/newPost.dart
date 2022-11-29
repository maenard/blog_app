import 'package:blog_app/model/users.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NewPost extends StatefulWidget {
  const NewPost({super.key});

  @override
  State<NewPost> createState() => _NewPostState();
}

class _NewPostState extends State<NewPost> {
  final user = FirebaseAuth.instance.currentUser!;
  late TextEditingController postcontroller;

  @override
  void initState() {
    super.initState();
    postcontroller = TextEditingController();
  }

  @override
  void dispose() {
    postcontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          "Create Post",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                print(postcontroller.text);
              });
            },
            icon: const Icon(Icons.post_add),
          ),
        ],
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              postField(),
            ],
          ),
        ),
      ),
    );
  }

  Widget postField() => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          readCurrentUser(user.uid),
          TextField(
            onChanged: (value) => {
              if (postcontroller.text.isEmpty)
                {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      duration: Duration(seconds: 5),
                      content: Text(
                        "Please fill out this field",
                        style: GoogleFonts.poppins(),
                      ),
                    ),
                  )
                }
              else
                {}
            },
            maxLines: null,
            scrollPadding: const EdgeInsets.only(bottom: 50),
            controller: postcontroller,
            decoration: InputDecoration(
              // contentPadding:
              //     const EdgeInsets.only(left: 20, top: 10, bottom: 10),
              // filled: true,
              // fillColor: Colors.white10,
              hintText: 'What\'s on your mind?',
              hintStyle: GoogleFonts.poppins(),
              // suffixIcon: const Padding(
              //   padding: EdgeInsets.only(right: 20),
              //   child: Icon(Icons.email_outlined),
              // ),
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(20),
              ),
              // errorStyle: GoogleFonts.poppins(
              //   height: 0,
              //   fontStyle: FontStyle.italic,
              // ),
            ),
          ),
        ],
      );

  Widget userInfo(Users user) => Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundImage: AssetImage('assets/images/photo_male_7.jpg'),
          ),
          const SizedBox(
            width: 10,
          ),
          Text(
            user.name,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
        ],
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

              return (userInfo(newUser));
            }

            return const Center(child: CircularProgressIndicator());
          },
        ),
      ],
    );
  }
}
