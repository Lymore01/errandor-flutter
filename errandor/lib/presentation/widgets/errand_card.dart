import 'package:flutter/material.dart';
import '../../models/errand.dart';
import 'package:get/get.dart';
import '../screens/errand_details.dart';

class ErrandCard extends StatelessWidget {
  final Errand errand;
  final VoidCallback? onTap;

  const ErrandCard({
    super.key,
    required this.errand,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with Status
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
                Text(
                  errand.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 16),

                // Details Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Location
                    Expanded(
                      child: Row(
                        children: [
                          const Icon(Icons.location_on_outlined, size: 16),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              '${errand.county}, ${errand.subCounty}',
                              style: const TextStyle(fontSize: 14),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Reward
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'KSH ${errand.reward}',
                        style: const TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Action Buttons - Always show
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => Get.to(() => ErrandDetails(errand: errand)),
                    icon: const Icon(Icons.info_outline),
                    label: const Text('Details'),
                  ),
                ),
                const SizedBox(width: 16),
                // Claim Button - Disabled if not pending
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: errand.status == 'Pending' ? onTap : null,
                    icon: const Icon(Icons.handshake),
                    label: Text(errand.status == 'Pending' ? 'Claim' : 'Not Available'),
                    style: ElevatedButton.styleFrom(
                      disabledBackgroundColor: Colors.grey[300],
                      disabledForegroundColor: Colors.grey[600],
                    ),
                  ),
                ),
              ],
            ),
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
      case 'pending':
        return Colors.blue;
      case 'claimed':
        return Colors.orange;
      case 'completed':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}
