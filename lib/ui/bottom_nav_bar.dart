import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pay_roll/shared/contants.dart';
import 'package:pay_roll/ui/attendance/attendance.dart';
import 'package:pay_roll/ui/history/history.dart';
import 'package:pay_roll/ui/home/home.dart';

class BottomNavBar extends StatefulWidget {
  final int initialIndex;

  const BottomNavBar({super.key, this.initialIndex = 0});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  late int _selectedIndex;
  PageController? _pageController;

  final List<Widget> _screens = [
    const AttendancePage(),
    const HomePage(),
    const HistoryPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        final shouldPop = await showDialog<bool>(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Exit App'),
              content: const Text('Are you sure you want to exit the app?'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                  child: const Text('No'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, true);
                  },
                  child: const Text('Yes'),
                ),
              ],
            );
          },
        );

        if (shouldPop ?? false) {
          SystemNavigator.pop();
        }
      },
      child: Scaffold(
        body: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          children: _screens,
        ),
        bottomNavigationBar: Container(
          margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [primaryColor, primaryColor..withValues(alpha: 0.8)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(50),
            boxShadow: [
              BoxShadow(
                color: Colors.black..withValues(alpha: 0.1),
                blurRadius: 10,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: Row(
            children: [
              const SizedBox(width: 15),
              _buildNavItem(0, Icons.task_rounded, 'Attendance'),
              const Spacer(),
              _buildNavItem(1, Icons.home_rounded, 'Home'),
              const Spacer(),
              _buildNavItem(2, Icons.calendar_month_rounded, 'Calendar'),
              const SizedBox(width: 15),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pageController?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
    _pageController = PageController(initialPage: _selectedIndex);
    // _initBackgroundService();
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final isSelected = _selectedIndex == index;
    return InkWell(
      onTap: () => _onItemTapped(index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        margin: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFAE181C) : Colors.transparent,
          borderRadius: BorderRadius.circular(50),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : Colors.white70,
            ),
            if (isSelected) ...[
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _pageController?.animateToPage(
        index,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }
}
