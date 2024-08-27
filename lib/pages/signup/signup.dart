import 'package:deafspace_prod/pages/login/login.dart';
import 'package:deafspace_prod/services/auth_service.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:deafspace_prod/widget/buttons.dart';
import 'package:deafspace_prod/styles.dart';

class Signup extends StatelessWidget {
  Signup({super.key});

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: ColorStyles.primary,
    resizeToAvoidBottomInset: true,
    appBar: AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      toolbarHeight: 90,
    ),
    body: SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 1),
      child: Column(
        children: [
          Center(
            child: Text(
              'DeafSpace',
              style: GoogleFonts.raleway(
                textStyle: TextStyle(
                  color: ColorStyles.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 32,
                ),
              ),
            ),
          ),
          const SizedBox(height: 50),
          
          // Square Container wrapping email, password, and button
          Container(
            width: 500,  // Set the desired width
            height: 540, // Set the desired height
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white, // Background color of the square
              borderRadius: BorderRadius.circular(10), // Optional: rounded corners
              boxShadow: [
                BoxShadow(
                  color: ColorStyles.blacks,
                  blurRadius: 10,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 15),
                _title(),
                const SizedBox(height: 20),
                _emailAddress(),
                const SizedBox(height: 50),
                _password(),
                const SizedBox(height: 50),
                _signup(context),
                const SizedBox(height: 15),
                _signin(context),
              ],
            ),
          ),
          
          const SizedBox(height: 50),
        ],
      ),
    ),
  );
}

 Widget _title() {
  return Container(
    alignment: Alignment.centerLeft, // Aligns the text to the left
    child: Text(
      'Register',
      style: GoogleFonts.raleway(
        textStyle: TextStyle(
          color: ColorStyles.black,
          fontWeight: FontWeight.bold,
          fontSize: 32,
        ),
      ),
    ),
  );
 }

  Widget _emailAddress() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Email Address',
          style: GoogleFonts.raleway(
            textStyle: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.normal,
              fontSize: 16
            )
          ),
        ),
        const SizedBox(height: 16,),
        TextField(
          controller: _emailController,
          decoration: InputDecoration(
            filled: true,
            hintText: 'example@gmail.com',
            hintStyle: TextStyle(
              color: ColorStyles.grey,
              fontWeight: FontWeight.normal,
              fontSize: 14
            ),
            fillColor: const Color(0xffF7F7F9) ,
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(14)
            )
          ),
        )
      ],
    );
  }

  Widget _password() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Password',
          style: GoogleFonts.raleway(
            textStyle: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.normal,
              fontSize: 16
            )
          ),
        ),
        const SizedBox(height: 16,),
        TextField(
          controller: _passwordController,
          obscureText: true,
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xffF7F7F9) ,
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(14)
            )
          ),
        )
      ],
    );
  }


  Widget _signup(BuildContext context) {
    return Buttons(
      onClicked: () async {
        await AuthService().signin(
          email: _emailController.text,
          password: _passwordController.text,
          context: context
        );
      },
      text: ('Sign In'),
      width: MediaQuery.of(context).size.width, 
      backgroundColor: ColorStyles.primary, 
      fontColor: ColorStyles.whites
    );
  }

  Widget _signin(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 0),
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          children: [
            TextSpan(
                text: "Already Have Account? ",
                style: TextStyle(
                  color: ColorStyles.grey,
                  fontWeight: FontWeight.normal,
                  fontSize: 16
                ),
              ),
              TextSpan(
                text: "Log In",
                style: TextStyle(
                    color: ColorStyles.primary,
                    fontWeight: FontWeight.normal,
                    fontSize: 16
                  ),
                  recognizer: TapGestureRecognizer()..onTap = () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Login()
                      ),
                    );
                  }
              ),
          ]
        )
      ),
    );
  }
}