// ignore_for_file: unused_import

import 'package:deafspace_prod/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

//testing
import 'package:deafspace_prod/pages/login/login.dart';
import 'package:deafspace_prod/onboarding/splash.dart';
import 'package:deafspace_prod/onboarding/ob1.dart';
import 'package:deafspace_prod/pages/featurepage/translate.dart';
import 'package:deafspace_prod/admin/adminPage.dart';
// import 'package:deafspace_prod/pages/signup/signup.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,

//testing Onboard
      home: OnboardingScreen(),
      // home: AdminPage(),
      // home: SplashScreen(),   
      // home: Login()

//Testing feature 
      // home: Translate(),
     
    );
  }
}
