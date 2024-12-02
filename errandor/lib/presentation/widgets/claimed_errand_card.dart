import 'package:flutter/material.dart';
import '../../models/errand.dart';
import 'package:get/get.dart';
import '../screens/errand_details.dart';

class ClaimedErrandCard extends StatelessWidget {
  final Errand errand;
  final VoidCallback? onCancel;
  final VoidCallback? onMarkComplete;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const ClaimedErrandCard({
    super.key,
    required this.errand,
    this.onCancel,
    this.onMarkComplete,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    errand.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                _buildStatusChip(),
              ],
            ),
            const SizedBox(height: 8),

            // Description
            Text(errand.description),
            const SizedBox(height: 8),

            // Location & Reward
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('${errand.county}, ${errand.subCounty}'),
                Text(
                  'KSH ${errand.reward}',
                  style: const TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            // Actions
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // View Details Button
                TextButton(
                  onPressed: () => Get.to(() => ErrandDetails(errand: errand)),
                  child: const Text('View Details'),
                ),

                // Edit Button (if owner)
                if (onEdit != null)
                  TextButton.icon(
                    onPressed: onEdit,
                    icon: const Icon(Icons.edit),
                    label: const Text('Edit'),
                  ),

                // Delete Button (if owner)
                if (onDelete != null)
                  TextButton.icon(
                    onPressed: () => _showDeleteConfirmation(context),
                    icon: const Icon(Icons.delete),
                    label: const Text('Delete'),
                    style: TextButton.styleFrom(foregroundColor: Colors.red),
                  ),

                // Mark Complete Button (if approved)
                if (errand.status == 'Approved')
                  ElevatedButton(
                    onPressed: onMarkComplete,
                    child: const Text('Mark Complete'),
                  )
                // Cancel Claim Button (if not completed)
                else if (errand.status != 'Completed' && onCancel != null)
                  TextButton(
                    onPressed: onCancel,
                    style: TextButton.styleFrom(foregroundColor: Colors.red),
                    child: const Text('Cancel Claim'),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    Get.dialog(
      AlertDialog(
        title: const Text('Delete Errand'),
        content: const Text('Are you sure you want to delete this errand?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              onDelete?.call();
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: _getStatusColor().withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        errand.status,
        style: TextStyle(
          color: _getStatusColor(),
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Color _getStatusColor() {
    switch (errand.status.toLowerCase()) {
      case 'approved':
        return Colors.blue;
      case 'completed':
        return Colors.green;
      case 'in progress':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }
} 