import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final formKey = GlobalKey<FormState>();
  late bool passView;
  late Icon _visibility;

  @override
  void initState() {
    super.initState();
    passView = true;
    _visibility = Icon(Icons.visibility_off);
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  backIcon(),
                  spacing(20, 0),
                  greeting(),
                  spacing(10, 0),
                  formControl(
                    'Full Name',
                    false,
                    Icon(Icons.person_outline_rounded),
                    (name) {
                      if (name != null && name.length < 1) {
                        return 'Fill out this field';
                      } else {
                        return null;
                      }
                    },
                    null,
                  ),
                  spacing(10, 0),
                  formControl(
                    'Username',
                    false,
                    Icon(Icons.alternate_email),
                    (username) {
                      if (username != null && username.length < 4) {
                        return 'Enter minimum 4 charaters';
                      } else {
                        return null;
                      }
                    },
                    null,
                  ),
                  spacing(10, 0),
                  formControl(
                    'Password',
                    passView,
                    Icon(Icons.lock_outline_rounded),
                    (pass) {
                      if (pass != null && pass.length < 7) {
                        return 'Enter minimum 7 characters';
                      } else {
                        null;
                      }
                    },
                    IconButton(
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
                  ),
                  spacing(10, 0),
                  formControl(
                    'Email',
                    false,
                    Icon(Icons.email_outlined),
                    (email) {
                      if (email != null && !EmailValidator.validate(email)) {
                        return 'Enter a valid email';
                      } else {
                        null;
                      }
                    },
                    null,
                  ),
                  spacing(10, 0),
                  regBtn(),
                  spacing(5, 0),
                  login(),
                  spacing(MediaQuery.of(context).size.height - 600, 0),
                  appLogo(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget login() => GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: 'Already have an account? ',
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: Colors.white54,
                ),
              ),
              TextSpan(
                text: 'Login here.',
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
                if (isValidForm) {}
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
                    'Register',
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
                    Icons.how_to_reg,
                    size: 20.0,
                    color: Colors.black,
                  ),
                ],
              ),
            ),
          ),
        ],
      );

  Widget formControl(
          String text, bool invisibility, Icon icon, validator, suffix) =>
      TextFormField(
        obscureText: invisibility,
        decoration: InputDecoration(
          errorStyle: GoogleFonts.poppins(
            fontSize: 12,
          ),
          suffixIcon: suffix,
          prefixIcon: icon,
          hintText: text,
          border: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Colors.white54,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Colors.white,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        validator: validator,
      );

  Widget greeting() => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Hello there,',
            style: GoogleFonts.poppins(
              fontSize: 15,
            ),
          ),
          Text(
            'Create an Account',
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      );

  Widget appLogo() => Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Image.asset(
            'assets/images/blog2.png',
            height: 40,
          ),
          spacing(10, 0),
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
          spacing(10, 0)
        ],
      );

  Widget backIcon() => GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Container(
          padding:
              EdgeInsets.only(top: MediaQuery.of(context).size.width - 330),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Icon(
                Icons.arrow_back_ios_new_rounded,
              ),
              Text(
                'Back',
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      );
}
