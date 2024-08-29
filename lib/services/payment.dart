import 'dart:convert'; // For JSON encoding
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // For HTTP requests
import 'package:deafspace_prod/styles.dart'; // Adjust the path if necessary

class PaymentPage extends StatefulWidget {
  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final String orderId = 'your_order_id'; // Replace with dynamic order ID

  Future<void> _confirmPayment() async {
    try {
      final response = await http.put(
        Uri.parse('https://65fd90629fc4425c653243d7.mockapi.io/orders/$orderId'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'payment_status': true,
        }),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Payment confirmed successfully!'),
          ),
        );
        // Navigate back or to another page after payment
        Navigator.pop(context); // Navigate back to the previous page
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to confirm payment: ${response.reasonPhrase}'),
          ),
        );
      }
    } catch (e) {
      print('Error: $e');  // Log the error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to confirm payment: $e'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorStyles.primary,
      appBar: AppBar(
        title: const Text('Payment Confirmation'),
        backgroundColor: ColorStyles.primary,
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Confirm Payment',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _confirmPayment,
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorStyles.primary, // Background color
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                textStyle: const TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
              child: const Text('Pay Now'),
            ),
          ],
        ),
      ),
    );
  }
}
