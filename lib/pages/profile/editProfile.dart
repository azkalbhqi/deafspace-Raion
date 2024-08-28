import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deafspace_prod/styles.dart';
import 'package:deafspace_prod/widget/buttons.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:deafspace_prod/services/database.dart'; // Ensure this import is correct

class ProfileUpdatePage extends StatefulWidget {
  @override
  _ProfileUpdatePageState createState() => _ProfileUpdatePageState();
}

class _ProfileUpdatePageState extends State<ProfileUpdatePage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  bool _isButtonEnabled = false;

  void _checkIfButtonShouldBeEnabled() {
    setState(() {
      _isButtonEnabled = _usernameController.text.isNotEmpty &&
          _phoneNumberController.text.isNotEmpty &&
          _addressController.text.isNotEmpty;
    });
  }

  @override
  void initState() {
    super.initState();

    _usernameController.addListener(_checkIfButtonShouldBeEnabled);
    _phoneNumberController.addListener(_checkIfButtonShouldBeEnabled);
    _addressController.addListener(_checkIfButtonShouldBeEnabled);

    _loadUserData();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _phoneNumberController.dispose();
    _addressController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _loadUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        DocumentSnapshot<Map<String, dynamic>> doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
        if (doc.exists) {
          setState(() {
            _usernameController.text = doc.data()?['username'] ?? '';
            _phoneNumberController.text = doc.data()?['phoneNumber'] ?? '';
            _addressController.text = doc.data()?['address'] ?? '';
            _emailController.text = user.email ?? ''; // Display email but keep it read-only
          });
        } else {
          // Handle the case where the document does not exist
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('User document does not exist'),
            ),
          );
        }
      } catch (e) {
        // Handle errors
        print('Error loading user data: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load user data: $e'),
          ),
        );
      }
    } else {
      // Handle the case where the user is not authenticated
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No user is currently logged in'),
        ),
      );
    }
  }

  Future<void> _updateProfile() async {
    if (_formKey.currentState!.validate()) {
      try {
        User? user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          final databaseMethods = DatabaseMethods();
          await databaseMethods.addUserDetail({
            'username': _usernameController.text,
            'phoneNumber': _phoneNumberController.text,
            'address': _addressController.text,
          }, user.uid);

          // Only update email if it's changed
          if (user.email != _emailController.text) {
            await user.updateEmail(_emailController.text);
          }

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Profile updated successfully'),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('User is not logged in'),
            ),
          );
        }
      } catch (e) {
        print('Error updating profile: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update profile: $e'),
          ),
        );
      }
    }
  }

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
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          children: [
            Center(
              child: Text(
                'Update Profile',
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

            // Square Container wrapping all fields and button
            Container(
              width: 500,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: ColorStyles.blacks,
                    blurRadius: 10,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTextField('Username', 'Enter Username', _usernameController),
                  const SizedBox(height: 20),
                  _buildTextField('Phone Number', 'Enter Phone Number', _phoneNumberController),
                  const SizedBox(height: 20),
                  _buildTextField('Address', 'Enter Address', _addressController),
                  const SizedBox(height: 20),
                  _buildReadOnlyTextField('Email', _emailController),
                  const SizedBox(height: 30),
                  _submitButton(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, String hint, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: GoogleFonts.raleway(fontSize: 16, color: ColorStyles.black)),
          const SizedBox(height: 8),
          TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(
                color: Color.fromARGB(132, 160, 160, 160),
                fontWeight: FontWeight.normal,
                fontSize: 14,
              ),
              filled: true,
              fillColor: const Color(0xffF7F7F9),
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReadOnlyTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: GoogleFonts.raleway(fontSize: 16, color: ColorStyles.black)),
          const SizedBox(height: 8),
          TextField(
            controller: controller,
            readOnly: true,
            decoration: InputDecoration(
              hintText: 'No changes allowed',
              hintStyle: const TextStyle(
                color: Color.fromARGB(132, 160, 160, 160),
                fontWeight: FontWeight.normal,
                fontSize: 14,
              ),
              filled: true,
              fillColor: const Color(0xffF7F7F9),
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _submitButton() {
    return Buttons(
      onClicked: _isButtonEnabled ? _updateProfile : () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please fill in all fields to update profile'),
          )
        );
      },
      text: 'Update Profile',
      width: MediaQuery.of(context).size.width,
      backgroundColor: ColorStyles.primary,
      fontColor: ColorStyles.whites,
    );
  }
}
