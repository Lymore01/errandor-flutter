import 'package:flutter/material.dart';
import '../../controllers/errand_status_controller.dart';

class StatusCard extends StatelessWidget {
  final ErrandStatusController controller;
  final bool isCreator;

  const StatusCard({
    super.key,
    required this.controller,
    required this.isCreator,
  });

  @override
  Widget build(BuildContext context) {
    final revenue = isCreator 
        ? controller.totalSpent.value 
        : controller.totalEarnings.value;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isCreator 
              ? [const Color(0xFF6366F1), const Color(0xFF4F46E5)]
              : [const Color(0xFF8B5CF6), const Color(0xFF7C3AED)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: (isCreator ? const Color(0xFF6366F1) : const Color(0xFF8B5CF6))
                .withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                isCreator ? 'Total Spent' : 'Total Earnings',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  isCreator
                      ? Icons.account_balance_wallet
                      : Icons.payments,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            'KSH ${revenue.toStringAsFixed(2)}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}