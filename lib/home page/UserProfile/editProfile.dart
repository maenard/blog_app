import 'package:blog_app/model/users.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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

  @override
  void initState() {
    super.initState();
    namecontroller = TextEditingController(text: widget.newUser.name);
    emailcontroller = TextEditingController(text: widget.newUser.email);
    passwordcontroller = TextEditingController(text: widget.newUser.password);
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
            onPressed: () {},
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
          userDetail(widget.newUser),
        ],
      ),
    );
  }

  imgNotExist() => const AssetImage('assets/images/blank_profile.jpg');
  imgExist(img) => NetworkImage(img);

  userDetail(Users newUser) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 70),
            child: Stack(
              alignment: Alignment.center,
              clipBehavior: Clip.none,
              children: [
                newUser.userProfileCover == "-"
                    ? Container(
                        color: Colors.white12,
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * .30,
                      )
                    : Container(
                        color: Colors.white12,
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * .30,
                        child: FittedBox(
                          fit: BoxFit.fill,
                          child: Image.network(newUser.userProfileCover),
                        ),
                      ),
                Positioned(
                  bottom: -70,
                  child: CircleAvatar(
                    backgroundImage: newUser.userProfilePic == "-"
                        ? imgNotExist()
                        : imgExist(newUser.userProfilePic),
                    radius: 70,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          fields(),
        ],
      );

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
                _loginbtn(),
              ],
            ),
          ],
        ),
      );

  Widget _loginbtn() => Expanded(
        child: TextButton(
          onPressed: () {
            // final isValidForm = logInKey.currentState!.validate();
            // if (isValidForm == true) {
            //   signIn();
            // }
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

  // Stream<List<Users>> readUser() => FirebaseFirestore.instance
  //     .collection('users').doc('asdf')
  //     .where('password', isEqualTo: 'maenard')
  //     .snapshots().
  //     .map((snapshot) =>
  //         snapshot.docs.re);

  updateBlog(id) {
    final docUser = FirebaseFirestore.instance.collection('users').doc();
    docUser.update({
      'name': namecontroller.text,
      'password': passwordcontroller.text,
      // 'userProfilePic': postcontroller.text,
      // 'userProfileCover': postcontroller.text,
    });

    Navigator.pop(context);
  }
}
