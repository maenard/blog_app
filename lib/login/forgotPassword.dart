import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import 'package:google_fonts/google_fonts.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final formKey = GlobalKey<FormState>();
  final emailcontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          'Reset Password',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Form(
        key: formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Center(
            child: SingleChildScrollView(
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/blog3.png',
                      height: 80,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      "We have sent you an email.",
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "Please change your password.",
                      style: GoogleFonts.poppins(
                        color: Colors.white54,
                        fontSize: 15,
                        height: .9,
                      ),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    emailField(),
                    const SizedBox(
                      height: 10,
                    ),
                    resetPass(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget emailField() => TextFormField(
        scrollPadding: const EdgeInsets.only(bottom: 50),
        controller: emailcontroller,
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

  Widget resetPass() => Row(
        children: [
          Expanded(
            child: TextButton(
              onPressed: () {
                final isValidForm = formKey.currentState!.validate();
                if (isValidForm == true) {
                  resetPassword();
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.key,
                    color: Colors.white,
                  ),
                  Text(
                    ' Reset Password',
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
        ],
      );

  Future resetPassword() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator.adaptive(
          valueColor: AlwaysStoppedAnimation(Colors.white),
        ),
      ),
    );
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: emailcontroller.text.trim(),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Password Reset Email Sent'),
        ),
      );
      Navigator.of(context).pop();
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message.toString()),
        ),
      );

      Navigator.of(context).pop();
    }
  }
}
