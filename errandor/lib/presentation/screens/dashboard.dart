// ignore_for_file: prefer_const_constructors

import 'package:errandor/controllers/bottom_nav_controller.dart';
import 'package:errandor/presentation/screens/create_errand.dart';
import 'package:errandor/presentation/screens/discover.dart';
import 'package:errandor/presentation/screens/home.dart';
import 'package:errandor/presentation/screens/my_errands.dart';
import 'package:errandor/presentation/screens/profile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

BottomNavController bottomNavController = Get.put(BottomNavController());
final List<Widget> pages = [
  Home(), 
  Discover(), 
  MyErrands(), 
  CreateErrand(), 
  Profile()
];

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Obx(() => AnimatedSwitcher(
            duration: Duration(milliseconds: 300),
            child: pages[bottomNavController.selectedIndex.value],
          )),
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          backgroundColor: Colors.white,
          selectedItemColor: Color(0xFF4CAF50),
          unselectedItemColor: Colors.grey[600],
          currentIndex: bottomNavController.selectedIndex.value,
          onTap: bottomNavController.changeTabIndex,
          type: BottomNavigationBarType.fixed,
          elevation: 10,
          selectedLabelStyle: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
          unselectedLabelStyle: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w400,
          ),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.explore_outlined),
              activeIcon: Icon(Icons.explore),
              label: "Discover",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.assignment_outlined),
              activeIcon: Icon(Icons.assignment),
              label: "Errands",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.add_circle_outline),
              activeIcon: Icon(Icons.add_circle),
              label: "Create",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: "Profile",
            ),
          ],
        ),
      ),
    );
  }
}
