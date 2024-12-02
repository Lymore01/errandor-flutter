import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/discover_controller.dart';
import '../widgets/errand_list.dart';

class Discover extends StatelessWidget {
  const Discover({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(DiscoverController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Available Errands'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: controller.searchErrands,
              decoration: InputDecoration(
                hintText: 'Search errands...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[200],
              ),
            ),
          ),
        ),
      ),
      body: ErrandList(controller: controller),
    );
  }
} 