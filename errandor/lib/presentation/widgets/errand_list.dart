import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/discover_controller.dart';
import 'errand_card.dart';

class ErrandList extends StatelessWidget {
  final DiscoverController controller;

  const ErrandList({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (controller.errands.isEmpty) {
        return const Center(
          child: Text('No errands available'),
        );
      }

      return RefreshIndicator(
        onRefresh: controller.fetchErrands,
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.errands.length,
          itemBuilder: (context, index) {
            final errand = controller.errands[index];
            return ErrandCard(
              errand: errand,
              onTap: () => _showClaimDialog(context, errand.id),
            );
          },
        ),
      );
    });
  }

  void _showClaimDialog(BuildContext context, String errandId) {
    Get.dialog(
      AlertDialog(
        title: const Text('Claim Errand'),
        content: const Text('Are you sure you want to claim this errand?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              controller.claimErrand(errandId);
            },
            child: const Text('Claim'),
          ),
        ],
      ),
    );
  }
} 