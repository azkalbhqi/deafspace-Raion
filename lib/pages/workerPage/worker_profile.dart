import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:deafspace_prod/styles.dart';
import 'package:deafspace_prod/widget/buttons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';

class WorkerProfilingPage extends StatefulWidget {
  @override
  _WorkerProfilingPageState createState() => _WorkerProfilingPageState();
}

class _WorkerProfilingPageState extends State<WorkerProfilingPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();

  String _selectedGender = 'Male';
  bool _isButtonEnabled = false;

  void _checkIfButtonShouldBeEnabled() {
    setState(() {
      _isButtonEnabled = _nameController.text.isNotEmpty &&
          _phoneNumberController.text.isNotEmpty &&
          _ageController.text.isNotEmpty &&
          _fullNameController.text.isNotEmpty;
    });
  }

  @override
  void initState() {
    super.initState();

    _nameController.addListener(_checkIfButtonShouldBeEnabled);
    _phoneNumberController.addListener(_checkIfButtonShouldBeEnabled);
    _ageController.addListener(_checkIfButtonShouldBeEnabled);
    _fullNameController.addListener(_checkIfButtonShouldBeEnabled);

    _loadUserData();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneNumberController.dispose();
    _ageController.dispose();
    _emailController.dispose();
    _fullNameController.dispose();
    super.dispose();
  }

  Future<void> _loadUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    
    if (user != null) {
      final url = 'https://65fd90629fc4425c653243d7.mockapi.io/workers/${user.uid}';
      try {
        final response = await http.get(Uri.parse(url));

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          setState(() {
            _nameController.text = data['name'] ?? '';
            _phoneNumberController.text = data['phonenumber'].toString() ?? '';
            _ageController.text = data['age']?.toString() ?? '';
            _selectedGender = data['gender'] ?? 'Male';
            _emailController.text = FirebaseAuth.instance.currentUser!.email!.toString(); // Display email but keep it read-only
            _fullNameController.text = data['fullname'] ?? '';
            
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to load user data'),
            ),
          );
        }
      } catch (e) {
        print('Error loading user data: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load user data: $e'),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No user is currently logged in'),
        ),
      );
    }
  }

  Future<void> _updateProfile() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final randomId = Random().nextInt(100000); // Generate random ID
        final url = 'https://65fd90629fc4425c653243d7.mockapi.io/workers';
        final response = await http.put(
          Uri.parse(url),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, dynamic>{
            'email': _emailController.text,
            'gender': _selectedGender,
            'phonenumber': _phoneNumberController.text,
            'age': int.tryParse(_ageController.text) ?? 0,
            'orders': false,
            'name': _nameController.text,
            'fullname': _fullNameController.text,
            'id': randomId.toString(),
          }),
        );

        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Profile updated successfully'),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to update profile: ${response.reasonPhrase}'),
            ),
          );
        }
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
                  _buildTextField('Full Name', 'Enter Full Name', _fullNameController),
                  const SizedBox(height: 20),
                  _buildTextField('Name', 'Enter Name', _nameController),
                  const SizedBox(height: 20),
                  _buildTextField('Phone Number', 'Enter Phone Number', _phoneNumberController),
                  const SizedBox(height: 20),
                  _buildTextField('Age', 'Enter Age', _ageController),
                  const SizedBox(height: 20),
                  _buildGenderDropdown(),
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

  Widget _buildGenderDropdown() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Gender', style: GoogleFonts.raleway(fontSize: 16, color: ColorStyles.black)),
          const SizedBox(height: 8),
          DropdownButton<String>(
            value: _selectedGender,
            isExpanded: true,
            items: ['Male', 'Female'].map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (newValue) {
              setState(() {
                _selectedGender = newValue!;
                _checkIfButtonShouldBeEnabled();
              });
            },
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
    return Align(
      alignment: Alignment.center,
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton(
          onPressed: _isButtonEnabled ? _updateProfile : null,
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.resolveWith<Color>(
              (Set<MaterialState> states) {
                if (_isButtonEnabled) {
                  return ColorStyles.primary;
                }
                return Colors.grey; // Disable button color
              },
            ),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),
          child: Text(
            'Update Profile',
            style: GoogleFonts.raleway(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

