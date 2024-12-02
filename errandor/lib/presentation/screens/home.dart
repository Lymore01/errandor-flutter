// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:errandor/controllers/auth_controller.dart';
import 'package:errandor/presentation/widgets/claimer_dashboard.dart';
import 'package:errandor/presentation/widgets/creator_dashboard.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'create_errand.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isCreator = true;
  final AuthController authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        
        title: const Text('Errandor'),
        actions: [
          TextButton.icon(
            onPressed: () => setState(() => isCreator = !isCreator),
            icon: Icon(
              isCreator ? Icons.create : Icons.work,
              color: Colors.black,
            ),
            label: Text(
              isCreator ? 'Creator' : 'Claimer',
              style: const TextStyle(color: Colors.black),
            ),
          ),
          // Logout button
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _showLogoutDialog(context),
          ),
        ],
      ),
      body: isCreator ? CreatorDashboard() : ClaimerDashboard(),
      floatingActionButton: isCreator
          ? FloatingActionButton.extended(
              onPressed: () => Get.to(() => const CreateErrand()),
              icon: const Icon(Icons.add),
              label: const Text('New Errand'),
            )
          : null,
    );
  }

  Future<void> _showLogoutDialog(BuildContext context) async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Logout'),
          ),
        ],
      ),
    );

    if (shouldLogout == true) {
      await authController.logout();
    }
  }
}
