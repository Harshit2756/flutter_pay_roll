import 'package:flutter/material.dart';
import 'package:pay_roll/shared/storage_helper.dart';
import 'package:pay_roll/shared/widgets/background.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _isLoading = false;
  late Future<Map<String, dynamic>> _userDataFuture;

  @override
  Widget build(BuildContext context) {
    return BackgroundContainer(
      child: FutureBuilder<Map<String, dynamic>>(
        future: _userDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting ||
              _isLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('No data available'));
          }

          final userData = snapshot.data!;
          final userName = userData['username'];
          final empId = userData['empId'];

          return BackgroundContainer(
            child: Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                centerTitle: true,
                title: const Text('Profile'),
                leading: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.arrow_back_ios_new),
                ),
              ),
              body: SafeArea(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        // ID Card Design with reddish gradient background
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.red.shade300,
                                Colors.red.shade600,
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black..withValues(alpha: 0.1),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.all(
                              24), // Increased padding for spaciousness
                          child: Column(
                            children: [
                              const CircleAvatar(
                                radius: 50,
                                backgroundColor: Colors.white,
                                child: Icon(Icons.person,
                                    size: 50, color: Colors.grey),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                userName.split('- ').last,
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color:
                                      Colors.white, // White text for contrast
                                ),
                              ),
                              Text(
                                "${userName.split('- ').first} - $empId",
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors
                                      .white70, // Lighter white for contrast
                                ),
                              ),
                              const SizedBox(height: 10),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 4, horizontal: 8),
                                decoration: BoxDecoration(
                                  color: Colors.white..withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Text(
                                  'Employee ID Card',
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 32),
                        // Upgraded Menu Items
                        _buildMenuItem(
                            Icons.person_outline, 'Personal Information', () {
                          // Handle personal info tap
                        }),
                        _buildMenuItem(Icons.settings_outlined, 'Settings', () {
                          // Handle settings tap
                        }),
                        _buildMenuItem(
                            Icons.notifications_outlined, 'Notifications', () {
                          // Handle notifications tap
                        }),
                        _buildMenuItem(Icons.help_outline, 'Help & Support',
                            () {
                          // Handle help tap
                        }),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _userDataFuture = _loadUserData();
  }

  Widget _buildMenuItem(IconData icon, String title, VoidCallback onTap) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.red, width: 1),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black..withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        leading: Icon(icon, color: Colors.red),
        title: Text(title,
            style: const TextStyle(
                fontWeight: FontWeight.bold, color: Colors.black)),
        trailing:
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.red),
        onTap: onTap,
      ),
    );
  }

  // load user data from storage
  Future<Map<String, dynamic>> _loadUserData() async {
    try {
      setState(() {
        _isLoading = false;
      });
      final userData = await StorageHelper.getUserData();
      return userData;
    } catch (e) {
      throw Exception('Error loading user data: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}
