import 'package:blog_app/model/users.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:io';
import 'dart:math';

class UploadProfilePic extends StatefulWidget {
  const UploadProfilePic({
    super.key,
    required this.newUser,
  });

  final Users newUser;

  @override
  State<UploadProfilePic> createState() => _UploadProfilePicState();
}

class _UploadProfilePicState extends State<UploadProfilePic> {
  final user = FirebaseAuth.instance.currentUser!;
  late String error;
  PlatformFile? pickedProfile;
  UploadTask? uploadTaskProfile;

  @override
  void initState() {
    super.initState();
    error = "";
  }

  Future selectProfile() async {
    final profile = await FilePicker.platform.pickFiles();
    if (profile == null) return;

    setState(() {
      pickedProfile = profile.files.first;
    });
  }

  String generateRandomString(int len) {
    var r = Random();
    const _chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    return List.generate(len, (index) => _chars[r.nextInt(_chars.length)])
        .join();
  }

  Future uploadProfile() async {
    final path = 'userProfilePics/${generateRandomString(8)}';
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

    batchUpdateCommenterImg(user.uid, urlDownload);
    batchUpdateBlogAuthorPic(user.uid, urlDownload);
    updateUserProfilePic(user.uid, urlDownload);

    setState(() {
      uploadTaskProfile = null;
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
            child: pickedProfile == null
                ? checkUserProfilePicVal(widget.newUser)
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
                    selectProfile();
                  },
                ),
                uploadButtons(
                  Icons.file_upload_outlined,
                  'Upload',
                  Colors.blueAccent,
                  () {
                    if (pickedProfile == null) {
                      customSnackBar(
                          Icons.error_outline, 'There is no image picked.');
                    } else {
                      widget.newUser.userProfilePic != '-'
                          ? deleteProfilePic(widget.newUser.userProfilePic)
                          : print('user has no profile');
                      uploadProfile();
                    }
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
    return CircleAvatar(
      radius: 150,
      backgroundImage: FileImage(
        File(pickedProfile!.path!),
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
      stream: uploadTaskProfile?.snapshotEvents,
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

  checkUserProfilePicVal(Users newUser) {
    return newUser.userProfilePic == "-"
        ? const CircleAvatar(
            backgroundImage: AssetImage('assets/images/blank_profile.jpg'),
            radius: 150,
          )
        : CircleAvatar(
            backgroundImage: NetworkImage(newUser.userProfilePic),
            radius: 150,
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

  deleteProfilePic(url) {
    var ref = FirebaseStorage.instance.refFromURL(url);
    ref.delete();
  }

  Future updateUserProfilePic(id, img) async {
    final docUser = FirebaseFirestore.instance.collection('users').doc(id);
    await docUser.update({
      'userProfilePic': img,
    });
    Navigator.pop(context);
    customSnackBar(Icons.check, 'Profile photo uploaded successfully.');
  }

  Future<void> batchUpdateCommenterImg(id, imgUrl) {
    WriteBatch batch = FirebaseFirestore.instance.batch();
    final _doc = FirebaseFirestore.instance.collection('comments');
    final comments = FirebaseFirestore.instance
        .collection('comments')
        .where('commenterId', isEqualTo: id);
    return comments.get().then((querySnapshot) {
      querySnapshot.docs.forEach((document) {
        batch.update(_doc.doc(document.id), {'commenterimg': imgUrl});
      });

      return batch.commit();
    });
  }

  Future<void> batchUpdateBlogAuthorPic(id, imgUrl) {
    WriteBatch batch = FirebaseFirestore.instance.batch();
    final _doc = FirebaseFirestore.instance.collection('blogs');
    final comments = FirebaseFirestore.instance
        .collection('blogs')
        .where('userId', isEqualTo: id);
    return comments.get().then((querySnapshot) {
      querySnapshot.docs.forEach((document) {
        batch.update(_doc.doc(document.id), {'authorPic': imgUrl});
      });

      return batch.commit();
    });
  }
}
