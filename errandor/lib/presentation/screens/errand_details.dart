import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../models/errand.dart';

class ErrandDetails extends StatelessWidget {
  final Errand errand;

  const ErrandDetails({super.key, required this.errand});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1F2937)),
          onPressed: () => Get.back(),
        ),
        title: Text(
          errand.name,
          style: const TextStyle(
            color: Color(0xFF1F2937),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Section
            if (errand.errandImage != null)
              Container(
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                ),
                child: Image.network(
                  'http://localhost:3000${errand.errandImage}',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.error_outline, color: Colors.grey[400], size: 40),
                          const SizedBox(height: 8),
                          Text(
                            'Failed to load image',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    );
                  },
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                            : null,
                      ),
                    );
                  },
                ),
              ),

            // Creator Info Section
            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.white,
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.blue[100],
                    child: Text(
                      errand.belongsTo.firstName[0],
                      style: const TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${errand.belongsTo.firstName} ${errand.belongsTo.lastName}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1F2937),
                        ),
                      ),
                      Text(
                        'Posted on ${_formatDate(errand.createdAt)}',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Main Content
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Price and Urgency Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF4CAF50).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'KSH ${errand.reward.toStringAsFixed(0)}',
                          style: const TextStyle(
                            color: Color(0xFF4CAF50),
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      _buildUrgencyBadge(errand.urgency),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Location and Time Info
                  _buildInfoCard([
                    _buildInfoRow(
                      Icons.location_on,
                      '${errand.place}, ${errand.subCounty}',
                      subtitle: errand.county,
                      iconColor: Colors.red,
                    ),
                    const SizedBox(height: 16),
                    _buildInfoRow(
                      Icons.calendar_today,
                      'Due: ${_formatDateTime(errand.dateTime)}',
                      subtitle: 'Complete by: ${_formatDateTime(errand.completionTime)}',
                      iconColor: Colors.blue,
                    ),
                    const SizedBox(height: 16),
                    _buildInfoRow(
                      Icons.verified,
                      'Status: ${errand.status}',
                      iconColor: _getStatusColor(errand.status),
                    ),
                  ]),
                  const SizedBox(height: 24),

                  // Description Section
                  _buildSection(
                    'Description',
                    errand.description,
                    icon: Icons.description,
                  ),
                  const SizedBox(height: 24),

                  // Instructions Section
                  _buildSection(
                    'Instructions',
                    errand.instructions,
                    icon: Icons.list_alt,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: errand.status == 'Pending' ? () {
            
            Get.back();
          } : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF4CAF50),
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 0,
          ),
          child: Text(
            errand.status == 'Pending' ? 'Claim Errand' : 'Not Available',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUrgencyBadge(String urgency) {
    Color color;
    IconData icon;
    
    switch (urgency.toLowerCase()) {
      case 'high':
        color = Colors.red;
        icon = Icons.priority_high;
        break;
      case 'medium':
        color = Colors.orange;
        icon = Icons.warning;
        break;
      default:
        color = Colors.green;
        icon = Icons.info;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 6),
          Text(
            urgency,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }

  Widget _buildInfoRow(IconData icon, String text, {
    String? subtitle,
    Color iconColor = Colors.grey,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: iconColor, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                text,
                style: const TextStyle(
                  color: Color(0xFF1F2937),
                  fontSize: 16,
                ),
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSection(String title, String content, {IconData? icon}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (icon != null) ...[
                Icon(icon, color: Colors.blue),
                const SizedBox(width: 8),
              ],
              Text(
                title,
                style: const TextStyle(
                  color: Color(0xFF1F2937),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            content,
            style: TextStyle(
              color: Colors.grey[700],
              fontSize: 16,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return Colors.green;
      case 'approved':
        return Colors.blue;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.orange;
    }
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} at ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
} 