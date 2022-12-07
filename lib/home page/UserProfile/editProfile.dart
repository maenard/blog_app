import 'package:blog_app/model/users.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:io';
import 'dart:math';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({
    super.key,
    required this.newUser,
  });
  final Users newUser;

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  late TextEditingController namecontroller;
  late TextEditingController emailcontroller;
  late TextEditingController passwordcontroller;
  late bool _isNotVisible;
  late String error;
  PlatformFile? pickedProfile;
  PlatformFile? pickedCover;
  UploadTask? uploadTaskProfile;
  UploadTask? uploadTaskCover;

  //pick function for user profile picture
  Future selectProfile() async {
    final profile = await FilePicker.platform.pickFiles();
    if (profile == null) return;

    setState(() {
      pickedProfile = profile.files.first;
    });
  }

  //pick function for user cover picture
  Future selectCover() async {
    final cover = await FilePicker.platform.pickFiles();
    if (cover == null) return;

    setState(() {
      pickedCover = cover.files.first;
    });
  }

  //generates random string for file name upload
  String generateRandomString(int len) {
    var r = Random();
    const _chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    return List.generate(len, (index) => _chars[r.nextInt(_chars.length)])
        .join();
  }

  // upload profile to firebase storage
  Future uploadProfile() async {
    final path = 'files/${generateRandomString(8)}';
    print('update path Link: $path');
    final file = File(pickedProfile!.path!);

    final ref = FirebaseStorage.instance.ref().child(path);

    try {
      setState(() {
        uploadTaskProfile = ref.putFile(file);
      });
    } on FirebaseException catch (e) {
      setState(() {
        error = e.message.toString();
      });
    }

    final snapshot = await uploadTaskProfile!.whenComplete(() {});
    final urlDownload = await snapshot.ref.getDownloadURL();
    print('update Download Link: $urlDownload');

    // updateUser(widget.newUser.id, urlDownload);

    setState(() {
      uploadTaskProfile = null;
    });
  }

  @override
  void initState() {
    super.initState();
    namecontroller = TextEditingController(text: widget.newUser.name);
    emailcontroller = TextEditingController(text: widget.newUser.email);
    passwordcontroller = TextEditingController(text: widget.newUser.password);
    error = "";
    _isNotVisible = true;
  }

  @override
  void dispose() {
    namecontroller.dispose();
    emailcontroller.dispose();
    passwordcontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.black,
        title: Text(
          'Profile',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              // batchUpdateComments(widget.newUser.id);
            },
            child: Text(
              'Save',
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 15,
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        children: [
          Center(
            child: Text(
              '.blog',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w900,
                fontSize: 80,
              ),
            ),
          ),
          fields(),
        ],
      ),
    );
  }

  Widget fields() => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            formControl(
              'Name',
              false,
              Icon(Icons.abc),
              null,
              namecontroller,
              false,
            ),
            const SizedBox(height: 10),
            formControl(
              'Email',
              false,
              Icon(Icons.email_outlined),
              null,
              emailcontroller,
              true,
            ),
            const SizedBox(height: 10),
            formControl(
              'Password',
              _isNotVisible,
              SizedBox(
                width: 35,
                child: _isNotVisible
                    ? IconButton(
                        onPressed: () {
                          setState(() {
                            _isNotVisible = !_isNotVisible;
                          });
                        },
                        icon: Icon(Icons.key),
                      )
                    : IconButton(
                        onPressed: () {
                          setState(() {
                            _isNotVisible = !_isNotVisible;
                          });
                        },
                        icon: Icon(Icons.key_off),
                      ),
              ),
              null,
              passwordcontroller,
              false,
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                saveBtn(),
              ],
            ),
          ],
        ),
      );

  Widget saveBtn() => Expanded(
        child: TextButton(
          onPressed: () {},
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            backgroundColor: Colors.blueAccent,
            side: const BorderSide(
              width: .5,
              color: Colors.black38,
            ),
          ),
          child: Text(
            'Save',
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
        ),
      );

  Widget formControl(
    String text,
    bool invisibility,
    icon,
    validator,
    controller,
    readOnly,
  ) =>
      TextFormField(
        readOnly: readOnly,
        controller: controller,
        obscureText: invisibility,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.only(left: 20, top: 10, bottom: 10),
          filled: true,
          fillColor: Colors.white12,
          errorStyle: GoogleFonts.poppins(
            fontSize: 12,
            height: 0,
            fontStyle: FontStyle.italic,
          ),
          suffixIcon: Padding(
            padding: const EdgeInsets.only(right: 20),
            child: icon,
          ),
          hintText: text,
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        validator: validator,
      );

  Future updateUserInfo(id) async {
    final docUser = FirebaseFirestore.instance.collection('users').doc(id);
    await docUser.update({
      'password': passwordcontroller.text,
      'email': emailcontroller.text,
      'name': namecontroller.text,
    });
    // Navigator.pop(context);
  }

  Future updateUserProfilePic(id, profile) async {
    final docUser = FirebaseFirestore.instance.collection('users').doc(id);
    await docUser.update({
      'userProfilePic': profile,
    });
    // Navigator.pop(context);
  }

  Future updateUserCoverPic(id, cover) async {
    final docUser = FirebaseFirestore.instance.collection('users').doc(id);
    await docUser.update({
      'userProfileCover': cover,
    });
    // Navigator.pop(context);
  }

  //this works
  Future<void> batchUpdateComments(id) {
    WriteBatch batch = FirebaseFirestore.instance.batch();
    final _doc = FirebaseFirestore.instance.collection('comments');
    final comments = FirebaseFirestore.instance
        .collection('comments')
        .where('commenterId', isEqualTo: id);
    return comments.get().then((querySnapshot) {
      querySnapshot.docs.forEach((document) {
        batch.update(
            _doc.doc(document.id), {'commentername': namecontroller.text});
      });

      return batch.commit();
    });
  }

  Future<void> batchUpdateBlogs(id) {
    WriteBatch batch = FirebaseFirestore.instance.batch();
    final comments = FirebaseFirestore.instance
        .collection('comments')
        .where('postId', isEqualTo: id);
    return comments.get().then((querySnapshot) {
      querySnapshot.docs.forEach((document) {
        batch.delete(document.reference);
      });

      return batch.commit();
    });
  }
}
