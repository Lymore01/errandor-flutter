import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/my_errands_controller.dart';
import 'claimed_errand_card.dart';

class ClaimedErrandsTab extends StatelessWidget {
  final MyErrandsController controller;

  const ClaimedErrandsTab({
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
        onRefresh: controller.fetchClaimedErrands,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // All Claimed Errands
            if (controller.allErrands.isNotEmpty) ...[
              const Text(
                'My Claimed Errands',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              ...controller.allErrands.map((errand) => ClaimedErrandCard(
                    errand: errand,
                    // Show cancel button only for 'Claimed' status
                    onCancel: errand.status == 'Claimed' 
                        ? () => controller.cancelClaim(errand)
                        : null,
                    // Show mark complete button only for 'Approved' status
                    onMarkComplete: errand.status == 'Approved'
                        ? () => controller.markClaimComplete(errand.id)
                        : null,
                  )),
            ],

            // Empty State
            if (controller.allErrands.isEmpty)
              const Center(
                child: Text(
                  'No claimed errands found',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ),
          ],
        ),
      );
    });
  }
} 