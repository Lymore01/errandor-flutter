// import 'package:errandor/models/errand.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/my_errands_controller.dart';
import 'created_errand_card.dart';

class CreatedErrandsTab extends StatelessWidget {
  final MyErrandsController controller;

  const CreatedErrandsTab({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      return RefreshIndicator(
        onRefresh: controller.fetchCreatedErrands,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            if (controller.postedErrands.isNotEmpty) ...[
              const Text(
                'All Posted Errands',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              ...controller.postedErrands.map((errand) => CreatedErrandCard(
                    errand: errand,
                    onEdit: () => controller.editErrand(errand),
                    onDelete: () => controller.deleteErrand(errand),
                    onApproveClaim: errand.status == 'Claimed' 
                        ? (claimerId) => controller.approveErrandClaim(errand.id, claimerId)
                        : null,
                    onMarkComplete: errand.status == 'Approved'
                        ? () => controller.markErrandComplete(errand.id)
                        : null,
                    onDeclineClaim: errand.status == 'Claimed'
                        ? () => controller.declineClaim(errand)
                        : null,
                  )),
            ],

            // Empty State
            if (controller.postedErrands.isEmpty)
              const Center(
                child: Text(
                  'No errands found',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ),
          ],
        ),
      );
    });
  }
} 