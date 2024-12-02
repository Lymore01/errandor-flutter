import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/errand_status_controller.dart';
import 'stats_grid.dart';
import 'status_card.dart';

class ErrandStatus extends StatelessWidget {
  const ErrandStatus({
    super.key,
    required this.isCreator,
  });

  final bool isCreator;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ErrandStatusController());

    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }

      if (controller.hasError.value) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Error: ${controller.errorMessage.value}',
                style: const TextStyle(color: Colors.red),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: controller.refreshDashboard,
                child: const Text('Retry'),
              ),
            ],
          ),
        );
      }

      return RefreshIndicator(
        onRefresh: controller.refreshDashboard,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              StatusCard(controller: controller, isCreator: isCreator),
              const SizedBox(height: 20),
              StatsGrid(controller: controller, isCreator: isCreator),
            ],
          ),
        ),
      );
    });
  }
} 