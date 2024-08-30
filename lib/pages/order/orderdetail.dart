import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:deafspace_prod/styles.dart';

class OrderDetailPage extends StatelessWidget {
  final dynamic order;

  OrderDetailPage({required this.order});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Order Detail',
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
            Text(
              'Event Name:',
              style: GoogleFonts.raleway(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            SizedBox(height: 8),
            Text(
              order["event_name"]!,
              style: GoogleFonts.raleway(
                fontSize: 16,
                color: Colors.grey[800],
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Location:',
              style: GoogleFonts.raleway(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            SizedBox(height: 8),
            Text(
              order["location"]!,
              style: GoogleFonts.raleway(
                fontSize: 16,
                color: Colors.grey[800],
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Date:',
              style: GoogleFonts.raleway(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            SizedBox(height: 8),
            Text(
              order["date"]!,
              style: GoogleFonts.raleway(
                fontSize: 16,
                color: Colors.grey[800],
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Price:',
              style: GoogleFonts.raleway(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            SizedBox(height: 8),
            Text(
              order["price"]!,
              style: GoogleFonts.raleway(
                fontSize: 16,
                color: Colors.red,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Payment Status:',
              style: GoogleFonts.raleway(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            SizedBox(height: 8),
            Text(
              order["payment_status"]!,
              style: GoogleFonts.raleway(
                fontSize: 16,
                color: getStatusColor(order["payment_status"]!),
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Description:',
              style: GoogleFonts.raleway(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            SizedBox(height: 8),
            Text(
              order["description"]!,
              style: GoogleFonts.raleway(
                fontSize: 16,
                color: Colors.grey[800],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Function to get color based on payment status
  Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'diproses':
        return ColorStyles.primary;
      case 'dibatalkan':
        return Colors.red;
      case 'berhasil':
        return Colors.green;
      case 'selesai':
        return ColorStyles.grey;
      default:
        return Colors.black; // default color if status doesn't match any case
    }
  }
}
