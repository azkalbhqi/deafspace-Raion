import 'package:deafspace_prod/pages/order/newOrder.dart';
import 'package:deafspace_prod/styles.dart';
import 'package:flutter/material.dart';
import 'package:deafspace_prod/widget/buttons.dart';



class OrderPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorStyles.primary,
      ),
      body: Container(
              width: 500,  // Set the desired width
              height: 540, // Set the desired height
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
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
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
            Buttons(text: 'Make Order', onClicked: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => WorkerListPage()), // Navigate to home
                  );
                }, width: MediaQuery.of(context).size.width, backgroundColor: ColorStyles.primary, fontColor: Colors.white)
          ],
        ),
                ],
              ),
            ),
      
      
      
    );
  }
}

