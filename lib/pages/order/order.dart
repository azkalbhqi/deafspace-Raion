import 'package:deafspace_prod/styles.dart';
import 'package:flutter/material.dart';
import 'package:deafspace_prod/pages/order/makeOrderPage.dart';
import 'package:deafspace_prod/pages/order/history.dart';

class OrderPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Order'),
        backgroundColor: ColorStyles.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Your Order Details
            Text(
              'Your Order:',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 24),

            // Order History
            Text(
              'Order History:',
              style: Theme.of(context).textTheme.titleLarge,
            ),

            // Make Order Button
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MakeOrderPage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorStyles.primary, // Button color
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text(
                  'Make Order',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

