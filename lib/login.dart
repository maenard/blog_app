import 'package:blog_app/home.dart';
import 'package:blog_app/register.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ignore: camel_case_types
class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final formKey = GlobalKey<FormState>();
  late bool passView;
  late Icon _visibility;
  late TextEditingController _usernameController;
  late TextEditingController _passController;

  @override
  void initState() {
    super.initState();
    passView = true;
    _visibility = const Icon(Icons.visibility_off);
    _usernameController = TextEditingController();
    _passController = TextEditingController();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: ListView(
          padding: EdgeInsets.all(0),
          children: [
            Center(
              child: Container(
                padding: const EdgeInsets.fromLTRB(30, 50, 30, 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _applogo,
                    // _divider(25),
                    _divider(20),
                    _appTitle(),
                    userName(
                      'Username',
                      false,
                      const Icon(Icons.person_outline_outlined),
                    ),
                    _divider(20),
                    passWord(
                      'Password',
                      const Icon(Icons.lock_outline),
                    ),
                    _divider(20),
                    _loginbtn(),
                    _divider(5),
                    _reg(context),
                    _divider(25),
                    _copyRight(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  final _applogo = Image.asset(
    'assets/images/blog.png',
    height: 150,
  );

  Widget _copyRight() => Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const Divider(
            color: Colors.white54,
          ),
          Text(
            'Version 0.0.1',
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: Colors.white54,
            ),
          ),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'Copyright © 2022-2023. ',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    color: Colors.white,
                  ),
                ),
                TextSpan(
                  text: 'All rights reserved.',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      );

  Widget _appTitle() => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Welcome Back',
            style: GoogleFonts.poppins(
              fontSize: 40,
              fontWeight: FontWeight.bold,
              height: 0,
            ),
          ),
          Text(
            'Log in your account!',
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white54,
              height: 0,
            ),
          ),
          _divider(15),
        ],
      );

  Widget userName(String text, bool bool, Icon icon) => TextFormField(
        controller: _usernameController,
        obscureText: bool,
        decoration: InputDecoration(
          hintText: text,
          hintStyle: GoogleFonts.poppins(),
          prefixIcon: icon,
          border: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Colors.white54,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.white),
            borderRadius: BorderRadius.circular(20),
          ),
          errorStyle: GoogleFonts.poppins(
            height: 0,
            fontStyle: FontStyle.italic,
          ),
        ),
        validator: (username) {
          if (username != null && username.isEmpty) {
            return 'Fill out this field';
          } else {
            return null;
          }
        },
      );
  Widget passWord(String text, Icon icon) => TextFormField(
        controller: _passController,
        obscureText: passView,
        decoration: InputDecoration(
          hintText: text,
          hintStyle: GoogleFonts.poppins(),
          prefixIcon: icon,
          suffixIcon: IconButton(
            icon: _visibility,
            onPressed: () {
              setState(() {
                if (passView == true) {
                  _visibility = const Icon(Icons.visibility);
                  passView = false;
                } else if (passView == false) {
                  _visibility = const Icon(Icons.visibility_off);
                  passView = true;
                }
              });
            },
          ),
          border: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Colors.white54,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.white),
            borderRadius: BorderRadius.circular(20),
          ),
          errorStyle: GoogleFonts.poppins(
            height: 0,
            fontStyle: FontStyle.italic,
          ),
        ),
        validator: (pass) {
          if (pass != null && pass.isEmpty) {
            return 'Fill out this field';
          } else {
            return null;
          }
        },
      );

  Widget _divider(double size) => SizedBox(
        height: size,
      );

  Widget _loginbtn() => Row(
        children: [
          Expanded(
            child: TextButton(
              onPressed: () {
                final isValidForm = formKey.currentState!.validate();
                if (isValidForm) {
                  print(_usernameController.text);
                  print(_passController.text);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Home(),
                    ),
                  );
                }
              },
              style: TextButton.styleFrom(
                padding: const EdgeInsets.all(15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                backgroundColor: Colors.white,
                side: const BorderSide(
                  width: .5,
                  color: Colors.black38,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Log in',
                    style: GoogleFonts.poppins(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  const Icon(
                    Icons.arrow_forward_rounded,
                    size: 20.0,
                    color: Colors.black,
                  ),
                ],
              ),
            ),
          ),
        ],
      );

  Widget _reg(BuildContext context) => GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Register(),
            ),
          );
        },
        child: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: 'Don\'t Have an Account? ',
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: Colors.white54,
                ),
              ),
              TextSpan(
                text: 'Register here.',
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.white54,
                ),
              ),
            ],
          ),
        ),
      );
}
