import 'package:deafspace_prod/pages/order/makeOrderPage.dart';
import 'package:deafspace_prod/pages/order/orderdetail.dart'; // Import the OrderDetailPage
import 'package:deafspace_prod/pages/workerPage/workerHome.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert'; // To parse JSON
import 'package:http/http.dart' as http; // To fetch data from the API
import 'package:deafspace_prod/styles.dart';

class AdminOrderPage extends StatefulWidget {
  @override
  _AdminOrderPageState createState() => _AdminOrderPageState();
}

class _AdminOrderPageState extends State<AdminOrderPage> {
  List<dynamic> orders = [];

  @override
  void initState() {
    super.initState();
    fetchOrders();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    fetchOrders();
  }

  // Function to fetch orders from the API
  Future<void> fetchOrders() async {
    final response = await http.get(
      Uri.parse('https://65fd90629fc4425c653243d7.mockapi.io/orders'),
    );

    if (response.statusCode == 200) {
      setState(() {
        orders = json.decode(response.body);
      });
    } else {
      throw Exception('Failed to load orders');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorStyles.whites,
      appBar: AppBar(
        title: Text(
          'Order Page',
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
      body: Column(
        children: [
          Expanded(
            child: orders.isEmpty
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
                    padding: EdgeInsets.all(16.0),
                    itemCount: orders.length,
                    itemBuilder: (context, index) {
                      final order = orders[index];
                      return GestureDetector(
                        onTap: () {
                          // Navigate to the OrderDetailPage when tapped
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AdminPageControl(
                                order: order,
                                onStatusChanged: (String status) {},
                              ),
                            ),
                          );
                        },
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          margin: EdgeInsets.only(bottom: 16.0),
                          child: Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Left side: Event details
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        order["event_name"]!,
                                        style: GoogleFonts.raleway(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        order["location"]!,
                                        style: GoogleFonts.raleway(
                                          fontSize: 14,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      SizedBox(height: 2),
                                      Text(
                                        order["date"]!,
                                        style: GoogleFonts.raleway(
                                          fontSize: 14,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                // Right side: Price and Payment Status
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      order["price"]!,
                                      style: GoogleFonts.raleway(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: ColorStyles.primary,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      order["payment_status"]!,
                                      style: GoogleFonts.raleway(
                                        fontSize: 14,
                                        color: getStatusColor(order["payment_status"]!),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: ElevatedButton(
                onPressed: () {
                  // Navigate to the order-making page
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => OrderForm()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorStyles.primary, // Background color
                  iconColor: Colors.white, // Text color
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Make Order',
                  style: GoogleFonts.raleway(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),
        ],
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
