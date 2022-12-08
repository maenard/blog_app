import 'package:blog_app/model/users.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final formKey = GlobalKey<FormState>();
  late bool _isNotVisible;
  late TextEditingController namecontroller;
  late TextEditingController passcontroller;
  late TextEditingController emailcontroller;
  late String error;

  @override
  void initState() {
    super.initState();
    _isNotVisible = true;
    namecontroller = TextEditingController();
    passcontroller = TextEditingController();
    emailcontroller = TextEditingController();
    error = "";
  }

  @override
  void dispose() {
    namecontroller.dispose();
    passcontroller.dispose();
    emailcontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Form(
        key: formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // spacing(15, 0),
                // backIcon(),
                spacing(50, 0),
                signUpMsg(),
                spacing(20, 0),
                spacing(10, 0),
                formControl(
                  'Full Name',
                  false,
                  const Icon(Icons.person_outline_rounded),
                  (name) {
                    if (name != null && name.length < 1) {
                      return 'Fill out this field';
                    } else {
                      return null;
                    }
                  },
                  namecontroller,
                ),
                spacing(15, 0),
                formControl(
                    'Password',
                    _isNotVisible,
                    _isNotVisible
                        ? SizedBox(
                            width: 20,
                            height: 50,
                            child: IconButton(
                              padding: EdgeInsets.all(0),
                              splashRadius: 30,
                              onPressed: () {
                                setState(() {
                                  _isNotVisible = !_isNotVisible;
                                });
                              },
                              icon: const Icon(
                                Icons.key,
                              ),
                            ),
                          )
                        : SizedBox(
                            width: 20,
                            height: 50,
                            child: IconButton(
                              padding: EdgeInsets.all(0),
                              splashRadius: 30,
                              onPressed: () {
                                setState(() {
                                  _isNotVisible = !_isNotVisible;
                                });
                              },
                              icon: const Icon(
                                Icons.key_off,
                              ),
                            ),
                          ), (pass) {
                  if (pass != null && pass.length < 7) {
                    return 'Enter minimum 7 characters';
                  } else {
                    null;
                  }
                }, passcontroller),
                spacing(15, 0),
                formControl(
                  'Email',
                  false,
                  const Icon(Icons.email_outlined),
                  (email) {
                    if (email != null && !EmailValidator.validate(email)) {
                      return 'Enter a valid email';
                    } else {
                      null;
                    }
                  },
                  emailcontroller,
                ),
                spacing(15, 0),
                Expanded(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: signUp(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget signUpMsg() => Center(
        child: Column(
          children: [
            myLogo(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Welcome!',
                  style: GoogleFonts.poppins(
                    fontSize: 30,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Create an account to continue',
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.normal,
                    color: Colors.white70,
                    height: .9,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ],
        ),
      );

  Widget signUp() => Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          regBtn(),
          login(),
          spacing(15, 0),
        ],
      );

  Widget login() => RichText(
        text: TextSpan(
          style: const TextStyle(
            height: 2,
          ),
          children: [
            TextSpan(
              text: 'Already have and account? ',
              style: GoogleFonts.poppins(
                color: Colors.white54,
              ),
            ),
            TextSpan(
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  Navigator.pop(context);
                },
              text: 'SIGN IN',
              style: GoogleFonts.poppins(
                color: Colors.blueAccent,
              ),
            ),
          ],
        ),
      );

  Widget spacing(double height, double width) => SizedBox(
        height: height,
        width: width,
      );

  Widget regBtn() => Row(
        children: [
          Expanded(
            child: TextButton(
              onPressed: () {
                final isValidForm = formKey.currentState!.validate();
                if (isValidForm) {
                  registerUser();
                }
              },
              style: TextButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
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
                'Sign Up',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ),
          ),
        ],
      );

  Widget formControl(
          String text, bool invisibility, icon, validator, controller) =>
      TextFormField(
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
            // borderSide: BorderSide(
            //   color: Colors.white54,
            // ),
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(20),
          ),
          // focusedBorder: const OutlineInputBorder(
          //   borderSide: BorderSide(
          //     color: Colors.blueAccent,
          //   ),
          //   borderRadius: BorderRadius.all(Radius.circular(10)),
          // ),
        ),
        validator: validator,
      );

  Widget myLogo() => Image.asset(
        'assets/images/blog3.png',
        height: 80,
      );

  Future registerUser() async {
    showDialog(
      context: context,
      useRootNavigator: false,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailcontroller.text.trim(),
        password: passcontroller.text.trim(),
      );
      createUser();

      setState(() {
        error = "";
      });
    } on FirebaseAuthException catch (e) {
      setState(() {
        error = e.message.toString();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: Duration(seconds: 5),
          content: Text(
            error,
            style: GoogleFonts.poppins(),
          ),
        ),
      );
    }
    Navigator.pop(context);
  }

  Future createUser() async {
    final user = FirebaseAuth.instance.currentUser!;
    final userid = user.uid;

    final docUser = FirebaseFirestore.instance.collection('users').doc(userid);

    final newUser = Users(
      id: userid,
      password: passcontroller.text,
      email: emailcontroller.text,
      name: namecontroller.text,
      userProfilePic: '-',
      userProfileCover: '-',
      about: '',
      followerCount: 0,
      followers: [],
      posts: 0,
    );

    final json = newUser.toJson();
    await docUser.set(json);

    Navigator.pop(context);
  }
}
