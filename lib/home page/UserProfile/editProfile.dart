import 'package:blog_app/model/users.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  final user = FirebaseAuth.instance.currentUser!;
  late TextEditingController namecontroller;
  late TextEditingController emailcontroller;
  late TextEditingController passwordcontroller;
  late TextEditingController aboutcontroller;
  late bool _isNotVisible;

  @override
  void initState() {
    super.initState();
    namecontroller = TextEditingController(text: widget.newUser.name);
    emailcontroller = TextEditingController(text: widget.newUser.email);
    passwordcontroller = TextEditingController(text: widget.newUser.password);
    aboutcontroller = TextEditingController(text: widget.newUser.about);
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
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
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
          ),
          Row(
            children: [
              cancelBtn(),
              saveBtn(),
            ],
          ),
        ],
      ),
    );
  }

  cancelBtn() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: TextButton(
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            backgroundColor: Colors.transparent,
            side: const BorderSide(
              width: .5,
              color: Colors.black38,
            ),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.close,
                size: 15,
              ),
              Text(
                'Cancel',
                style: GoogleFonts.poppins(),
              ),
            ],
          ),
        ),
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
              const Icon(Icons.abc),
              null,
              namecontroller,
              false,
              1,
            ),
            const SizedBox(height: 10),
            formControl(
              'About',
              false,
              const Icon(Icons.description_outlined),
              null,
              aboutcontroller,
              false,
              null,
            ),
            const SizedBox(height: 10),
            formControl(
              'Email',
              false,
              const Icon(Icons.email_outlined),
              null,
              emailcontroller,
              true,
              1,
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
                        icon: const Icon(Icons.key),
                      )
                    : IconButton(
                        onPressed: () {
                          setState(() {
                            _isNotVisible = !_isNotVisible;
                          });
                        },
                        icon: const Icon(Icons.key_off),
                      ),
              ),
              null,
              passwordcontroller,
              true,
              1,
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      );

  saveBtn() => Expanded(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: TextButton(
            onPressed: () {
              if (namecontroller.text.trim().isEmpty) {
                customSnackbar(
                    Icons.error_outline, 'Name should not be empty.');
              } else {
                showCustomDialog();
              }
            },
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.save_outlined,
                  size: 15,
                  color: Colors.white,
                ),
                Text(
                  'Save',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
        ),
      );

  Widget formControl(String text, bool invisibility, icon, validator,
          controller, readOnly, _maxlines) =>
      TextFormField(
        maxLines: _maxlines,
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

  showCustomDialog() {
    return showDialog(
      context: context,
      builder: (_) => customDialog(),
    );
  }

  customDialog() {
    return AlertDialog(
      backgroundColor: Colors.black,
      title: Text(
        'Are you sure?',
        style: GoogleFonts.poppins(),
      ),
      content: Text(
        'This will update your information.',
        style: GoogleFonts.poppins(),
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
            updateUserInfo(user.uid);
            Navigator.pop(context);
            customSnackbar(
                Icons.check, 'You have successfully updated your profile.');
          },
          child: Text(
            'Yes',
            style: GoogleFonts.poppins(),
          ),
        ),
      ],
    );
  }

  customSnackbar(icon, msg) {
    return ScaffoldMessenger.of(context).showSnackBar(
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

  Future updateUserInfo(id) async {
    final docUser = FirebaseFirestore.instance.collection('users').doc(id);
    await docUser.update({
      'password': passwordcontroller.text,
      'email': emailcontroller.text,
      'about': aboutcontroller.text,
      'name': namecontroller.text,
    });

    batchUpdateBlogAuthorInfo(id);
    batchUpdateCommenterInfo(id);

    Navigator.pop(context);
  }

  void _changePassword() async {
    //Pass in the password to updatePassword.
    user.updatePassword(passwordcontroller.text).then((_) {
      print("Successfully changed password");
      FirebaseAuth.instance.signOut();
    }).catchError((error) {
      print("Password can't be changed" + error.toString());
      //This might happen, when the wrong password is in, the user isn't found, or if the user hasn't logged in recently.
    });
  }

  Future<void> batchUpdateCommenterInfo(id) {
    WriteBatch batch = FirebaseFirestore.instance.batch();
    final _doc = FirebaseFirestore.instance.collection('comments');
    final comments = FirebaseFirestore.instance
        .collection('comments')
        .where('commenterId', isEqualTo: id);
    return comments.get().then((querySnapshot) {
      querySnapshot.docs.forEach((document) {
        batch.update(_doc.doc(document.id), {
          'commentername': namecontroller.text,
        });
      });

      return batch.commit();
    });
  }

  Future<void> batchUpdateBlogAuthorInfo(id) {
    WriteBatch batch = FirebaseFirestore.instance.batch();
    final _doc = FirebaseFirestore.instance.collection('blogs');
    final comments = FirebaseFirestore.instance
        .collection('blogs')
        .where('userId', isEqualTo: id);
    return comments.get().then((querySnapshot) {
      querySnapshot.docs.forEach((document) {
        batch.update(_doc.doc(document.id), {
          'authorName': namecontroller.text,
        });
      });

      return batch.commit();
    });
  }
}
