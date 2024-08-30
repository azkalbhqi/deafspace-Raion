import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:deafspace_prod/styles.dart';
import 'package:http/http.dart' as http; // To make HTTP requests
import 'dart:convert'; // To parse JSON

class AdminPageControl extends StatefulWidget {
  final Map<String, dynamic> order;
  final Function(String) onStatusChanged;

  AdminPageControl({required this.order, required this.onStatusChanged});

  @override
  _AdminPageControlState createState() => _AdminPageControlState();
}

class _AdminPageControlState extends State<AdminPageControl> {
  late String selectedStatus;

  @override
  void initState() {
    super.initState();
    selectedStatus = widget.order['payment_status'];
  }

  // Function to update payment status on the API
  Future<void> updatePaymentStatus(String newStatus) async {
    final url = 'https://65fd90629fc4425c653243d7.mockapi.io/orders/${widget.order['id']}';
    final response = await http.put(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body: json.encode({
        "payment_status": newStatus,
      }),
    );

    if (response.statusCode == 200) {
      setState(() {
        widget.order['payment_status'] = newStatus;
      });
      widget.onStatusChanged(newStatus);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Payment status updated successfully!')));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to update payment status')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorStyles.whites,
      appBar: AppBar(
        title: Text(
          'Order Details',
          style: GoogleFonts.raleway(
            textStyle: TextStyle(
              color: ColorStyles.primary,
              fontWeight: FontWeight.bold,
              fontSize: 32,
            ),
          ),
        ),
        backgroundColor: ColorStyles.whites,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display order details
            Text(
              'Event: ${widget.order["event_name"]}',
              style: GoogleFonts.raleway(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Location: ${widget.order["location"]}',
              style: GoogleFonts.raleway(
                fontSize: 18,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Date: ${widget.order["date"]}',
              style: GoogleFonts.raleway(
                fontSize: 18,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Price: ${widget.order["price"]}',
              style: GoogleFonts.raleway(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: ColorStyles.primary,
              ),
            ),
            SizedBox(height: 16),
            // Payment status dropdown
            Text(
              'Payment Status:',
              style: GoogleFonts.raleway(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            SizedBox(height: 8),
            DropdownButton<String>(
              value: selectedStatus,
              icon: Icon(Icons.arrow_downward),
              elevation: 16,
              style: TextStyle(color: ColorStyles.primary),
              underline: Container(
                height: 2,
                color: ColorStyles.primary,
              ),
              onChanged: (String? newValue) {
                setState(() {
                  selectedStatus = newValue!;
                });
              },
              items: <String>['diproses', 'dibatalkan', 'berhasil', 'selesai']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            SizedBox(height: 16),
            ElevatedButton(
  onPressed: () async {
    await updatePaymentStatus(selectedStatus);
    Navigator.pop(context, true); // Pass `true` to indicate that the status was updated
  },
  style: ElevatedButton.styleFrom(
    backgroundColor: ColorStyles.primary, // Background color
    padding: EdgeInsets.symmetric(vertical: 16.0),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
  ),
  child: Text(
    'Save Changes',
    style: GoogleFonts.raleway(
      fontWeight: FontWeight.bold,
      fontSize: 16,
    ),
  ),
),
          ],
        ),
      ),
    );
  }
}
