import 'dart:convert'; // For JSON encoding
import 'dart:math'; // For random string generation
import 'package:deafspace_prod/styles.dart';
import 'package:deafspace_prod/widget/buttons.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http; // For HTTP requests
import 'package:intl/intl.dart'; // For date formatting
import 'package:deafspace_prod/services/payment.dart';

class MakeOrderPage extends StatefulWidget {
  final String workerEmail;

  MakeOrderPage({required this.workerEmail});

  @override
  _MakeOrderPageState createState() => _MakeOrderPageState();
}

class _MakeOrderPageState extends State<MakeOrderPage> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for each text field
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  DateTime? _selectedDate;

  // Function to generate a random string
  String _generateRandomString(int length) {
    const characters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    return String.fromCharCodes(Iterable.generate(
      length,
      (_) => characters.codeUnitAt(Random().nextInt(characters.length)),
    ));
  }

  void _selectDate() async {
    DateTime initialDate = DateTime.now();
    DateTime firstDate = DateTime(1900);
    DateTime lastDate = DateTime(2100);

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );

    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
        _dateController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
      });
    }
  }

  Future<void> _submitOrder() async {
    // Get the user's email from Firebase authentication
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      // Handle the case where the user is not logged in
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User not logged in')),
      );
      return;
    }

    String emailUser = user.email ?? 'Unknown';

    // Generate a random ID string
    String randomId = _generateRandomString(10);

    try {
      // Prepare the data to send to the REST API
      final orderData = {
        'id': randomId,
        'email_worker': widget.workerEmail,
        'email_user': emailUser,
        'payment_status': 'false', // Convert to string
        'order_status': 'false', // Convert to string
        'Description': _descriptionController.text,
        'date': _dateController.text, // Use selected date as string
        'location': _locationController.text,
      };

      // Send the data to the REST API using POST method
      final response = await http.post(
        Uri.parse('https://65fd90629fc4425c653243d7.mockapi.io/orders/'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(orderData),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        _formKey.currentState?.reset();
        setState(() {
          _selectedDate = null;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Order successfully submitted!'),
          ),
        );

        // Navigate to the payment page
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => PaymentPage()), // Navigate to payment page
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
    } finally {
      // Ensure navigation happens even if there is an error
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => PaymentPage()), // Navigate to payment page
      );
    }
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _locationController.dispose();
    _dateController.dispose();
    super.dispose();
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
                'Create Order',
                style: GoogleFonts.raleway(
                  textStyle: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 32,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 50),
            Container(
              width: 500,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black,
                    blurRadius: 10,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _descriptionField(),
                  const SizedBox(height: 20),
                  _dateField(),
                  const SizedBox(height: 20),
                  _locationField(),
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

  Widget _descriptionField() {
    return TextFormField(
      controller: _descriptionController,
      decoration: const InputDecoration(
        labelText: 'Description',
        border: OutlineInputBorder(),
      ),
      maxLines: 4,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a description';
        }
        return null;
      },
    );
  }

  Widget _dateField() {
    return TextFormField(
      controller: _dateController,
      decoration: InputDecoration(
        labelText: 'Date',
        border: const OutlineInputBorder(),
        suffixIcon: IconButton(
          icon: const Icon(Icons.calendar_today),
          onPressed: _selectDate,
        ),
      ),
      readOnly: true,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please select a date';
        }
        return null;
      },
    );
  }

  Widget _locationField() {
    return TextFormField(
      controller: _locationController,
      decoration: const InputDecoration(
        labelText: 'Location',
        border: OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a location';
        }
        return null;
      },
    );
  }

  Widget _submitOrderButton() {
    return Buttons(
      text: 'Add Orders',
      onClicked: _submitOrder,
      width: MediaQuery.of(context).size.width,
      backgroundColor: ColorStyles.primary,
      fontColor: ColorStyles.whites,
    );
  }
}
