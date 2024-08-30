import 'package:deafspace_prod/styles.dart';
import 'package:flutter/material.dart';

class explorePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Explore'),
        backgroundColor: ColorStyles.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset(
              'assets/images/img/home.png', // Path to your long image
              fit: BoxFit.fitWidth, // Adjust based on your image aspect ratio
              width: double.infinity,
            ),
          ],
        ),
      ),
    );
  }
}
