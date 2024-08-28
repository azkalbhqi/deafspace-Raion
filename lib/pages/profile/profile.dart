import 'package:deafspace_prod/pages/profile/editProfile.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:deafspace_prod/styles.dart'; // Ensure you have this import
 // Import your ProfileUpdatePage

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Profile Image
          Container(
            margin: const EdgeInsets.all(20),
            child: const CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage('assets/images/profile.png'), // Replace with actual profile image
            ),
          ),
          // Profile Info
          Text(
            'Angel Aurora', // Replace with actual profile name
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Edit Profil', // Replace with actual profile info
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 20),
          // Button Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              children: [
                _buildProfileOption(
                  icon: Icons.history,
                  title: 'History',
                  onTap: () {
                    // Handle view history
                  },
                ),
                const SizedBox(height: 10),
                _buildProfileOption(
                  icon: Icons.receipt_long,
                  title: 'Pesan Jasa',
                  onTap: () {
                    // Handle pesan jasa
                  },
                ),
                const SizedBox(height: 10),
                _buildProfileOption(
                  icon: Icons.edit,
                  title: 'Edit Profil',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ProfileUpdatePage()),
                    );
                  },
                ),
                const SizedBox(height: 10),
                _buildProfileOption(
                  icon: Icons.logout,
                  title: 'Logout',
                  onTap: () {
                    // Handle log out
                  },
                  isLogout: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileOption({required IconData icon, required String title, required VoidCallback onTap, bool isLogout = false}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isLogout ? Colors.red : ColorStyles.primary, // Red border for logout, primary color for others
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: isLogout ? Colors.red : ColorStyles.primary),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: isLogout ? Colors.red : ColorStyles.primary,
                ),
              ),
            ),
            Icon(Icons.arrow_forward_ios, color: isLogout ? Colors.red : ColorStyles.primary, size: 16),
          ],
        ),
      ),
    );
  }
}
