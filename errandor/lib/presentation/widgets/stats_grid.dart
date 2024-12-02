import 'package:errandor/controllers/errand_status_controller.dart';
import 'package:flutter/material.dart';

class StatsGrid extends StatelessWidget {
  final ErrandStatusController controller;
  final bool isCreator;

  const StatsGrid({
    super.key,
    required this.controller,
    required this.isCreator,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.5,
      children: [
        if (isCreator) ...[
          
          _buildStatCard(
            'Total Spent',
            'KSH ${controller.totalSpent}',
            Icons.payments,
            Colors.orange,
          ),
          _buildStatCard(
            'Pending Claims',
            controller.totalPendingApproval.toString(),
            Icons.people,
            Colors.purple,
          ),
          _buildStatCard(
            'Completed',
            controller.totalErrandsCompleted.toString(),
            Icons.check_circle,
            Colors.green,
          ),
        ] else ...[
          // Claimer Stats
          _buildStatCard(
            'Claimed Errands',
            controller.totalErrandsClaimed.toString(),
            Icons.assignment_turned_in,
            Colors.blue,
          ),
          _buildStatCard(
            'Earnings',
            'KSH ${controller.totalEarnings}',
            Icons.payments,
            Colors.green,
          ),
          _buildStatCard(
            'Pending',
            controller.totalPendingApproval.toString(),
            Icons.pending,
            Colors.orange,
          ),
          _buildStatCard(
            'Completed',
            controller.totalErrandsCompleted.toString(),
            Icons.check_circle,
            Colors.purple,
          ),
        ],
      ],
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            title,
            style: TextStyle(
              color: color.withOpacity(0.8),
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}