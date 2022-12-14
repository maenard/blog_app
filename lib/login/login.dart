import 'package:blog_app/home%20page/home.dart';
import 'package:blog_app/login/forgotPassword.dart';
import 'package:blog_app/main.dart';
import 'package:blog_app/login/register.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

// ignore: camel_case_types
class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final logInKey = GlobalKey<FormState>();
  late bool _isNotVisible;
  late TextEditingController _emailController;
  late TextEditingController _passController;
  late String error;

  @override
  void initState() {
    super.initState();
    _isNotVisible = true;
    _emailController = TextEditingController();
    _passController = TextEditingController();
    error = "";
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Form(
        key: logInKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _divider(80),
                logInMsg(),
                _divider(20),
                loginForm(),
                _divider(20),
                // errorMsg(),
                Expanded(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: register(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget logInMsg() => Center(
        child: Column(
          children: [
            myLogo(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Welcome Back!',
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
                  'Please sign in to your account',
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
            _divider(60),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'LOGIN',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w700,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
          ],
        ),
      );

  Widget errorMsg() => Column(
        children: [
          Text(
            error,
            textAlign: TextAlign.start,
            style: const TextStyle(
              color: Colors.red,
            ),
          ),
        ],
      );

  Widget loginForm() => Column(
        children: [
          emailField(),
          _divider(20),
          passField(),
          _divider(10),
          logAndPass(),
        ],
      );

  Widget logAndPass() => Row(
        children: [
          forgotPass(),
          _loginbtn(),
        ],
      );

  Widget forgotPass() => Expanded(
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ForgotPassword(),
              ),
            );
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Forgot",
                style: GoogleFonts.poppins(
                  color: Colors.white54,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  height: 1,
                ),
              ),
              Text(
                "Password?",
                style: GoogleFonts.poppins(
                  color: Colors.white54,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  height: 1,
                ),
              ),
            ],
          ),
        ),
      );

  Widget emailField() => TextFormField(
        scrollPadding: const EdgeInsets.only(bottom: 50),
        controller: _emailController,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.only(left: 20, top: 10, bottom: 10),
          filled: true,
          fillColor: Colors.white10,
          hintText: 'Email',
          hintStyle: GoogleFonts.poppins(),
          suffixIcon: const Padding(
            padding: EdgeInsets.only(right: 20),
            child: Icon(Icons.email_outlined),
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(20),
          ),
          errorStyle: GoogleFonts.poppins(
            height: 0,
            fontStyle: FontStyle.italic,
          ),
        ),
        validator: (email) {
          if (email != null && !EmailValidator.validate(email)) {
            return 'Enter a valid email';
          } else {
            null;
          }
        },
      );
  Widget passField() => TextFormField(
        scrollPadding: const EdgeInsets.only(bottom: 50),
        controller: _passController,
        obscureText: _isNotVisible,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.only(left: 20, top: 10, bottom: 10),
          filled: true,
          fillColor: Colors.white10,
          hintText: 'Password',
          hintStyle: GoogleFonts.poppins(),
          suffixIcon: Padding(
            padding: const EdgeInsets.only(right: 10),
            child: _isNotVisible
                ? IconButton(
                    onPressed: () {
                      setState(() {
                        _isNotVisible = !_isNotVisible;
                      });
                    },
                    icon: const Icon(
                      Icons.key,
                    ),
                  )
                : IconButton(
                    onPressed: () {
                      setState(() {
                        _isNotVisible = !_isNotVisible;
                      });
                    },
                    icon: const Icon(
                      Icons.key_off,
                    ),
                  ),
          ),
          border: OutlineInputBorder(
            // borderSide: BorderSide(
            //   color: Colors.white54,
            // ),
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(20),
          ),
          // focusedBorder: const OutlineInputBorder(
          //   borderSide: BorderSide(color: Colors.blueAccent),
          //   borderRadius: BorderRadius.all(Radius.circular(10)),
          // ),
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

  Widget _loginbtn() => Expanded(
        child: TextButton(
          onPressed: () {
            final isValidForm = logInKey.currentState!.validate();
            if (isValidForm == true) {
              signIn();
            }
          },
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
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
            'Sign In',
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
        ),
      );

  Widget register() => Center(
        child: RichText(
          text: TextSpan(
            style: const TextStyle(
              height: 2,
            ),
            children: [
              TextSpan(
                text: 'Don\'t have an account? ',
                style: GoogleFonts.poppins(
                  color: Colors.white54,
                ),
              ),
              TextSpan(
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Register(),
                      ),
                    );
                  },
                text: 'SIGN UP',
                style: GoogleFonts.poppins(
                  color: Colors.blueAccent,
                ),
              ),
            ],
          ),
        ),
      );

  Widget myLogo() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/blog3.png',
            height: 80,
          ),
        ],
      );

  Future signIn() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(
        child: LoadingAnimationWidget.newtonCradle(
          color: Colors.white,
          size: 100,
        ),
      ),
    );

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passController.text.trim(),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 5),
          content: Row(
            children: [
              const Icon(
                Icons.check,
                color: Colors.black,
              ),
              const SizedBox(
                width: 10,
              ),
              Flexible(
                child: Text(
                  'You have successfully logged in to your account.',
                  style: GoogleFonts.poppins(),
                ),
              ),
            ],
          ),
        ),
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        error = e.message.toString();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: Duration(seconds: 5),
          content: Row(
            children: [
              const Icon(
                Icons.error_outline,
                color: Colors.black,
              ),
              const SizedBox(
                width: 10,
              ),
              Flexible(
                child: Text(
                  error,
                  style: GoogleFonts.poppins(),
                ),
              ),
            ],
          ),
        ),
      );
    }
    Navigator.of(context).pop();
  }
}
