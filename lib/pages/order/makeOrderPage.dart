import 'dart:convert'; // For JSON encoding
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http; // For HTTP requests
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:deafspace_prod/styles.dart';
import 'package:deafspace_prod/widget/buttons.dart';

class MakeOrderPage extends StatefulWidget {
  @override
  _MakeOrderPageState createState() => _MakeOrderPageState();
}

class _MakeOrderPageState extends State<MakeOrderPage> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for each text field
  final TextEditingController _eventNameController = TextEditingController();
  final TextEditingController _eventDescriptionController = TextEditingController();
  final TextEditingController _eventDateController = TextEditingController();
  final TextEditingController _eventTimeController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _languageController = TextEditingController();
  final TextEditingController _serviceController = TextEditingController();
  final TextEditingController _jbiController = TextEditingController();

  // Flag to check if the button should be enabled
  bool _isButtonEnabled = false;

  void _checkIfButtonShouldBeEnabled() {
    setState(() {
      _isButtonEnabled = _eventNameController.text.isNotEmpty &&
          _eventDescriptionController.text.isNotEmpty &&
          _eventDateController.text.isNotEmpty &&
          _eventTimeController.text.isNotEmpty &&
          _locationController.text.isNotEmpty &&
          _languageController.text.isNotEmpty &&
          _serviceController.text.isNotEmpty &&
          _jbiController.text.isNotEmpty;
    });
  }

  @override
  void initState() {
    super.initState();

    // Add listeners to check the fields' status
    _eventNameController.addListener(_checkIfButtonShouldBeEnabled);
    _eventDescriptionController.addListener(_checkIfButtonShouldBeEnabled);
    _eventDateController.addListener(_checkIfButtonShouldBeEnabled);
    _eventTimeController.addListener(_checkIfButtonShouldBeEnabled);
    _locationController.addListener(_checkIfButtonShouldBeEnabled);
    _languageController.addListener(_checkIfButtonShouldBeEnabled);
    _serviceController.addListener(_checkIfButtonShouldBeEnabled);
    _jbiController.addListener(_checkIfButtonShouldBeEnabled);
  }

  @override
  void dispose() {
    _eventNameController.dispose();
    _eventDescriptionController.dispose();
    _eventDateController.dispose();
    _eventTimeController.dispose();
    _locationController.dispose();
    _languageController.dispose();
    _serviceController.dispose();
    _jbiController.dispose();
    super.dispose();
  }

  Future<void> _submitOrder() async {
    if (_formKey.currentState!.validate()) {
      // Check if user is authenticated
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('User not authenticated'),
          ),
        );
        return;
      }

      String email = user.email ?? 'anonymous';

      try {
        // Prepare data to send to REST API
        final orderData = {
          'email': email,
          'eventName': _eventNameController.text,
          'eventDescription': _eventDescriptionController.text,
          'eventDate': _eventDateController.text,
          'eventTime': _eventTimeController.text,
          'location': _locationController.text,
          'language': _languageController.text,
          'service': _serviceController.text,
          'jbi': _jbiController.text,
        };

        // Send data to REST API
        final response = await http.post(
          Uri.parse('https://yourapi.com/orders'), // Replace with your API URL
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(orderData),
        );

        if (response.statusCode == 200) {
          // Upload the data to Firestore
          await FirebaseFirestore.instance.collection('orders').add({
            ...orderData,
            'paymentStatus': 'pending',
            'orderTakeStatus': 'pending',
            'createdAt': Timestamp.now(),
          });

          // Clear all fields
          _formKey.currentState!.reset();

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Order successfully submitted!'),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to submit order to API: ${response.reasonPhrase}'),
            ),
          );
        }
      } catch (e) {
        print('Error: $e');  // Log the error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to submit order: $e'),
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
                'Deafspace',
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
              width: 500,  // Set the desired width
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _title(),
                  const SizedBox(height: 20),
                  _eventName(),
                  const SizedBox(height: 20),
                  _eventDescription(),
                  const SizedBox(height: 20),
                  _eventDate(),
                  const SizedBox(height: 20),
                  _eventTime(),
                  const SizedBox(height: 20),
                  _location(),
                  const SizedBox(height: 20),
                  _language(),
                  const SizedBox(height: 20),
                  _service(),
                  const SizedBox(height: 20),
                  _jbi(),
                  const SizedBox(height: 30),
                  _submitOrderButton(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _title() {
    return Text(
      'Create Order',
      style: GoogleFonts.raleway(
        textStyle: TextStyle(
          color: ColorStyles.black,
          fontWeight: FontWeight.bold,
          fontSize: 32,
        ),
      ),
    );
  }

  Widget _eventName() {
    return _buildTextField('Event Name', 'Enter Event Name', _eventNameController);
  }

  Widget _eventDescription() {
    return _buildTextField('Event Description', 'Enter Event Description', _eventDescriptionController, maxLines: 4);
  }

  Widget _eventDate() {
    return _buildTextField('Event Date', 'Enter Event Date', _eventDateController);
  }

  Widget _eventTime() {
    return _buildTextField('Event Time', 'Enter Event Time', _eventTimeController);
  }

  Widget _location() {
    return _buildTextField('Location', 'Enter Location', _locationController);
  }

  Widget _language() {
    return _buildTextField('Language', 'Enter Language', _languageController);
  }

  Widget _service() {
    return _buildTextField('Service', 'Enter Service', _serviceController);
  }

  Widget _jbi() {
    return _buildTextField('JBI', 'Enter JBI', _jbiController);
  }

  Widget _submitOrderButton() {
    return Buttons(
      onClicked: _isButtonEnabled ? _submitOrder : () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please fill in all fields to submit an order'),
          )
        );
      },
      text: 'Konfirmasi',
      width: MediaQuery.of(context).size.width,
      backgroundColor: ColorStyles.primary,
      fontColor: ColorStyles.whites,
    );
  }

  // Helper method to build each text field with the appropriate design
  Widget _buildTextField(String label, String hint, TextEditingController controller, {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: GoogleFonts.raleway(fontSize: 16, color: ColorStyles.black)),
          const SizedBox(height: 8),
          TextField(
            controller: controller,
            maxLines: maxLines,
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
}
