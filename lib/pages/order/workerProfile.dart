import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:deafspace_prod/styles.dart';
import 'package:deafspace_prod/widget/buttons.dart';
import 'package:deafspace_prod/pages/order/makeOrderPage.dart'; // Import the MakeOrderPage

class WorkerProfilePage extends StatelessWidget {
  final Map<String, dynamic> worker;

  WorkerProfilePage({required this.worker});

  Future<void> updateOrderStatus() async {
    final url = 'https://65fd90629fc4425c653243d7.mockapi.io/workers/${worker['id']}';
    final response = await http.put(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'orders': true,
      }),
    );

    if (response.statusCode == 200) {
      // Successfully updated
      print('Order status updated');
    } else {
      // Handle error
      throw Exception('Failed to update order status');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorStyles.primary,
      appBar: AppBar(
        title: Text('${worker['name'] ?? 'Worker'}'),
      ),
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(worker['profile'] ?? 'https://via.placeholder.com/150'), // Use a placeholder image if profile is null
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Name: ${worker['name'] ?? 'N/A'}',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text('Email: ${worker['email'] ?? 'N/A'}'),
              Text('Phone: ${worker['phonenumber'] ?? 'N/A'}'),
              Text('Age: ${worker['age'] ?? 'N/A'}'),
              SizedBox(height: 20),
              Buttons(
                text: 'ORDERS',
                onClicked: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MakeOrderPage(
                        workerEmail: worker['email'] ?? '', // Ensure it's not null
                      ),
                    ),
                  );
                },
                width: MediaQuery.of(context).size.width,
                backgroundColor: ColorStyles.primary,
                fontColor: ColorStyles.whites,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
