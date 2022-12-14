import 'dart:io';
import 'dart:math';

import 'package:blog_app/model/users.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import "package:flutter/material.dart";
import 'package:google_fonts/google_fonts.dart';

class UploadCoverPic extends StatefulWidget {
  const UploadCoverPic({
    super.key,
    required this.newUser,
  });

  final Users newUser;

  @override
  State<UploadCoverPic> createState() => _UploadCoverPicState();
}

class _UploadCoverPicState extends State<UploadCoverPic> {
  final user = FirebaseAuth.instance.currentUser!;
  late String error;
  PlatformFile? pickedCover;
  UploadTask? uploadTaskCover;

  @override
  void initState() {
    super.initState();
    error = "";
  }

  Future selectCover() async {
    final profile = await FilePicker.platform.pickFiles();
    if (profile == null) return;

    setState(() {
      pickedCover = profile.files.first;
    });
  }

  String generateRandomString(int len) {
    var r = Random();
    const _chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    return List.generate(len, (index) => _chars[r.nextInt(_chars.length)])
        .join();
  }

  Future uploadCover() async {
    final path = 'userCoverPics/${generateRandomString(8)}';
    print('update path Link: $path');
    final file = File(pickedCover!.path!);
    final ref = FirebaseStorage.instance.ref().child(path);

    try {
      setState(() {
        uploadTaskCover = ref.putFile(file);
      });
    } on FirebaseException catch (e) {
      setState(() {
        error = e.message.toString();
      });
    }

    final snapshot = await uploadTaskCover!.whenComplete(() {});
    final urlDownload = await snapshot.ref.getDownloadURL();
    print('update Download Link: $urlDownload');

    updateUserProfileCover(user.uid, urlDownload);

    setState(() {
      uploadTaskCover = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color.fromARGB(35, 158, 158, 158),
        automaticallyImplyLeading: true,
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
            child: pickedCover == null
                ? checkUserCoverVal(widget.newUser)
                : pickedFileExist(),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                uploadButtons(
                  Icons.photo_camera_back,
                  'Select Picture',
                  Colors.white60,
                  () {
                    selectCover();
                  },
                ),
                uploadButtons(
                  Icons.file_upload_outlined,
                  'Upload',
                  Colors.blueAccent,
                  () {
                    if (pickedCover == null) {
                      customSnackBar(
                        Icons.error_outline,
                        'There is no picture picked.',
                      );
                    } else {
                      widget.newUser.userProfileCover != '-'
                          ? deleteCoverPic(widget.newUser.userProfileCover)
                          : print('user has no cover photo');
                      uploadCover();
                    }
                    ;
                  },
                ),
              ],
            ),
          ),
          buildProgress(),
        ],
      ),
    );
  }

  pickedFileExist() {
    return Container(
      child: Image.file(
        File(pickedCover!.path!),
      ),
    );
  }

  uploadButtons(icon, text, color, function) {
    return Expanded(
      child: TextButton(
        onPressed: function,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 17,
              color: color,
            ),
            Text(
              ' $text',
              style: GoogleFonts.poppins(
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildProgress() => StreamBuilder<TaskSnapshot>(
      stream: uploadTaskCover?.snapshotEvents,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final data = snapshot.data!;
          double progress = data.bytesTransferred / data.totalBytes;

          return SizedBox(
            height: 25,
            child: Stack(
              fit: StackFit.expand,
              children: [
                LinearProgressIndicator(
                  value: progress,
                  backgroundColor: Colors.grey,
                  color: Colors.black,
                ),
                Center(
                  child: Text(
                    'Uploading: ${(100 * progress).roundToDouble()}%',
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                )
              ],
            ),
          );
        } else {
          return Container();
        }
      });

  checkUserCoverVal(Users newUser) {
    return newUser.userProfileCover == "-"
        ? Center(
            child: Text(
              'Upload a picture to update your cover photo.',
              style: GoogleFonts.poppins(),
            ),
          )
        : Container(
            child: Image.network(newUser.userProfileCover),
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

  deleteCoverPic(url) {
    var ref = FirebaseStorage.instance.refFromURL(url);
    ref.delete();
  }

  Future updateUserProfileCover(id, img) async {
    final docUser = FirebaseFirestore.instance.collection('users').doc(id);
    await docUser.update({
      'userProfileCover': img,
    });
    Navigator.pop(context);
    customSnackBar(Icons.check, 'Cover photo uploaded successfully.');
  }
}
