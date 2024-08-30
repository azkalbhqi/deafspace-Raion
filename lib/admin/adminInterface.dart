import 'package:deafspace_prod/admin/adminPage.dart';
import 'package:deafspace_prod/pages/order/order.dart';
import 'package:deafspace_prod/pages/workerPage/orderList.dart';
import 'package:deafspace_prod/pages/workerPage/worker_profile.dart';
import 'package:deafspace_prod/styles.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// Import your pages here
import 'package:deafspace_prod/pages/home/home.dart';
import 'package:deafspace_prod/pages/profile/profile.dart';

class WorkerInterface extends StatefulWidget {
  @override
  State<WorkerInterface> createState() => _WorkerInterfaceState();
}

class _WorkerInterfaceState extends State<WorkerInterface> {
  int _selectedIndex = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.animateToPage(index, duration: const Duration(milliseconds: 300), curve: Curves.ease);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Worker Interface',
          style: GoogleFonts.raleway(
            textStyle: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              // Handle notifications
            },
          ),
        ],
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        children: [
          AdminPage(),
          AdminOrderPage(),
          WorkerProfilingPage(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag),
            label: 'Orders',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: ColorStyles.primary, // Adjust the color to match your design
        onTap: _onItemTapped,
      ),
    );
  }
}
