import 'package:flutter/material.dart';
import '../../models/errand.dart';
import 'package:get/get.dart';
import '../screens/errand_details.dart';

class CreatedErrandCard extends StatelessWidget {
  final Errand errand;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final Function(String)? onApproveClaim;
  final VoidCallback? onMarkComplete;
  final VoidCallback? onDeclineClaim;

  const CreatedErrandCard({
    super.key,
    required this.errand,
    this.onEdit,
    this.onDelete,
    this.onApproveClaim,
    this.onMarkComplete,
    this.onDeclineClaim,
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

            
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                
                TextButton(
                  onPressed: () => Get.to(() => ErrandDetails(errand: errand)),
                  child: const Text('View Details'),
                ),

                
                if (onEdit != null && errand.status != 'Completed')
                  TextButton.icon(
                    onPressed: onEdit,
                    icon: const Icon(Icons.edit),
                    label: const Text('Edit'),
                  ),

                
                if (onDelete != null && errand.status != 'Completed')
                  TextButton.icon(
                    onPressed: () => _showDeleteConfirmation(context),
                    icon: const Icon(Icons.delete),
                    label: const Text('Delete'),
                    style: TextButton.styleFrom(foregroundColor: Colors.red),
                  ),

                
                if (errand.claimedErrandor.isNotEmpty && errand.status == 'Claimed') ...[
                  TextButton(
                    onPressed: onDeclineClaim,
                    style: TextButton.styleFrom(foregroundColor: Colors.red),
                    child: const Text('Decline'),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () => onApproveClaim?.call(errand.claimedErrandor.first),
                    child: const Text('Approve'),
                  ),
                ],

                
                if (errand.status == 'Approved' && onMarkComplete != null)
                  ElevatedButton.icon(
                    onPressed: onMarkComplete,
                    icon: const Icon(Icons.check_circle),
                    label: const Text('Mark Complete'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                  ),
              ],
            ),
          ],
        ),
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
      case 'claimed':
        return Colors.orange;
      case 'approved':
        return Colors.blue;
      case 'completed':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirm Delete'),
          content: const Text('Are you sure you want to delete this errand?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: onDelete,
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
} 