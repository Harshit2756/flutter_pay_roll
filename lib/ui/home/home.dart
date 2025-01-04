import 'package:flutter/material.dart';
import 'package:pay_roll/shared/contants.dart';
import 'package:pay_roll/shared/widgets/background.dart';
import 'package:pay_roll/ui/bottom_nav_bar.dart';
import 'package:pay_roll/ui/home/holidays.dart';
import 'package:pay_roll/ui/home/leave_request.dart';
import 'package:pay_roll/ui/home/pay_slip.dart';
import 'package:pay_roll/ui/home/profile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return BackgroundContainer(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Home'),
          leading: IconButton(
            onPressed: () => Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const BottomNavBar()),
                (route) => false),
            icon: const Icon(Icons.arrow_back_ios_new),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: GridView.count(
          padding: const EdgeInsets.all(16),
          shrinkWrap: true,
          childAspectRatio: 1,
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          children: [
            _buildDashboardItem('Attendance', fingerprintIcon, () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const BottomNavBar(),
                ),
              );
            }),
            _buildDashboardItem('Profile', usersIcon, () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ProfilePage(),
                ),
              );
            }),
            _buildDashboardItem('Leave Request', requestIcon, () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const LeaveRequest(),
                ),
              );
            }),
            _buildDashboardItem('Leave History', planningIcon, () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const LeaveRequest(initialTabIndex: 1),
                ),
              );
            }),
            _buildDashboardItem('Holidays', holidayIcon, () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const HolidaysPage(),
                ),
              );
            }),
            _buildDashboardItem('Calendar', historyIcon, () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const BottomNavBar(initialIndex: 2),
                ),
              );
            }),
            _buildDashboardItem('Pay Slip', paySlipIcon, () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PaySlipsPage(),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardItem(
    String title,
    String path,
    VoidCallback onPressed,
  ) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey..withValues(alpha: 0.4),
              blurRadius: 20,
              offset: const Offset(10, 10),
            ),
            const BoxShadow(
              color: Colors.white,
              blurRadius: 20,
              offset: Offset(-10, -10),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 75, // Adjusted size for the image
              height: 75, // Adjusted size for the image
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey..withValues(alpha: 0.5),
                    blurRadius: 15,
                    offset: const Offset(5, 5),
                  ),
                  const BoxShadow(
                    color: Colors.white,
                    blurRadius: 15,
                    offset: Offset(-5, -5),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.asset(
                  path,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Flexible(
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFCA282C), // Dark red color
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.red, Colors.red..withValues(alpha: 0.5)],
                ),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 8), // Added spacing to prevent overflow
          ],
        ),
      ),
    );
  }
}
