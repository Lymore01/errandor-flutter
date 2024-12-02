import 'package:errandor/presentation/widgets/errand_status.dart';
import 'package:flutter/material.dart';

class CreatorDashboard extends StatelessWidget {
  const CreatorDashboard({super.key});

  @override
  Widget build(BuildContext context) {
     return const SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Creator Dashboard',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            ErrandStatus(isCreator: true),
          ],
        ),
      ),
    );
  }
}