import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';
import 'package:deafspace_prod/pages/order/workerProfile.dart'; // Import the WorkerProfilePage
import 'package:deafspace_prod/styles.dart';

class WorkerListPage extends StatefulWidget {
  @override
  _WorkerListPageState createState() => _WorkerListPageState();
}

class _WorkerListPageState extends State<WorkerListPage> {
  List workers = [];

  @override
  void initState() {
    super.initState();
    fetchWorkers();
  }

  fetchWorkers() async {
    final response = await http.get(Uri.parse('https://65fd90629fc4425c653243d7.mockapi.io/workers'));
    if (response.statusCode == 200) {
      setState(() {
        workers = json.decode(response.body);
      });
    } else {
      throw Exception('Failed to load workers');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Filter out workers with orders set to false
    final filteredWorkers = workers.where((worker) => worker['orders'] == false).toList();

    return Scaffold(
      backgroundColor: ColorStyles.primary,
      appBar: AppBar(
        title: Text(
          'Worker Profiles',
          style: GoogleFonts.raleway(),
        ),
      ),
      body: filteredWorkers.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : GridView.builder(
              padding: const EdgeInsets.all(10.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Two cards per row
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 10.0,
                childAspectRatio: 1, // Make the card square
              ),
              itemCount: filteredWorkers.length,
              itemBuilder: (context, index) {
                return WorkerCard(worker: filteredWorkers[index]);
              },
            ),
    );
  }
}

class WorkerCard extends StatelessWidget {
  final worker;

  WorkerCard({required this.worker});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => WorkerProfilePage(worker: worker),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 40,
                backgroundColor: Colors.grey[300], // Placeholder color
                child: const Icon(
                  Icons.person,
                  size: 40,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Name: ${worker['name']}',
                style: GoogleFonts.raleway(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              Text(
                'Age: ${worker['age']}',
                style: GoogleFonts.raleway(
                  fontSize: 14,
                  color: Colors.black54,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
