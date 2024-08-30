import 'dart:convert';
import 'dart:math';
import 'package:deafspace_prod/styles.dart';
import 'package:deafspace_prod/widget/buttons.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:deafspace_prod/services/payment.dart';

class OrderForm extends StatefulWidget {
  @override
  _OrderFormState createState() => _OrderFormState();
}

class _OrderFormState extends State<OrderForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _eventController = TextEditingController();

  DateTime? _selectedDate;

  @override
  void dispose() {
    _descriptionController.dispose();
    _locationController.dispose();
    _phoneController.dispose();
    _eventController.dispose();
    _timeController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  Future<void> _submitOrder() async {
    if (!_formKey.currentState!.validate()) return;

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User not logged in')),
      );
      return;
    }

    final orderData = {
      "email_user": user.email!,
      "payment_status": 'diproses',
      "description": _descriptionController.text,
      "date": _selectedDate != null
          ? DateFormat('yyyy-MM-dd').format(_selectedDate!)
          : '',
      "location": _locationController.text,
      "phone": _phoneController.text,
      "time": _timeController.text,
      "event_name": _eventController.text,
      "price": "Rp350.000,.",
    };

    try {
      final response = await http.post(
        Uri.parse('https://65fd90629fc4425c653243d7.mockapi.io/orders/'),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode(orderData),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Order successfully submitted!')),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => PaymentPage()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to submit order: ${response.reasonPhrase}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorStyles.primary,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 90,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Center(
                child: Text(
                  'Order Form',
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
              Container(
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
                  children: [
                    _buildEmailField(),
                    const SizedBox(height: 16),
                    _buildTextField('Event Name', _eventController),
                    const SizedBox(height: 16),
                    _buildTextField('Description', _descriptionController),
                    const SizedBox(height: 16),
                    _buildTextField('Location', _locationController),
                    const SizedBox(height: 16),
                    _buildTextField('Phone Number', _phoneController,
                        keyboardType: TextInputType.phone),
                    const SizedBox(height: 16),
                    _buildDateField(context),
                    const SizedBox(height: 16),
                    _buildTextField('Time', _timeController,
                        keyboardType: TextInputType.datetime),
                    const SizedBox(height: 32),
                    _buildSubmitButton(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmailField() {
    final userEmail = FirebaseAuth.instance.currentUser?.email ?? 'Unknown';
    return Text(
      userEmail,
      style: GoogleFonts.raleway(
        textStyle: TextStyle(
          color: ColorStyles.primary,
          fontSize: 18,
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {TextInputType keyboardType = TextInputType.text}) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        filled: true,
        labelText: label,
        fillColor: const Color(0xffF7F7F9),
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(14),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '$label cannot be empty';
        }
        return null;
      },
    );
  }

  Widget _buildDateField(BuildContext context) {
    return GestureDetector(
      onTap: () => _selectDate(context),
      child: AbsorbPointer(
        child: TextFormField(
          decoration: InputDecoration(
            filled: true,
            labelText: 'Date',
            hintText: _selectedDate == null
                ? 'Select a date'
                : DateFormat('yyyy-MM-dd').format(_selectedDate!),
            fillColor: const Color(0xffF7F7F9),
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(14),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return Buttons(
      onClicked: _submitOrder,
      text: 'Submit Order',
      width: MediaQuery.of(context).size.width,
      backgroundColor: ColorStyles.primary,
      fontColor: ColorStyles.whites,
    );
  }
}
