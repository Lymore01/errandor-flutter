import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../models/errand.dart';
import '../utils/auth_utils.dart';

class MyErrandsController extends GetxController {
  final isLoading = false.obs;

  // Created Errands
  final postedErrands = <Errand>[].obs;
  final activeErrands = <Errand>[].obs;
  final approvedErrands = <Errand>[].obs;

  // Claimed Errands
  final inProgressErrands = <Errand>[].obs;
  final pendingApprovalErrands = <Errand>[].obs;
  final completedErrands = <Errand>[].obs;
  final allErrands = <Errand>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchCreatedErrands();
    fetchClaimedErrands();
  }

  // Fetch errands created by user
  Future<void> fetchCreatedErrands() async {
    try {
      isLoading.value = true;
      final headers = await AuthUtils.getAuthHeaders();

      final response = await http.get(
        Uri.parse('http://localhost:3000/api/errands/user'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final errandsJson = data['data'] as List;

        
        postedErrands.value =
            errandsJson.map((json) => Errand.fromJson(json)).toList();

        // Filter for specific sections
        activeErrands.value = postedErrands
            .where((errand) => errand.status == 'Claimed')
            .toList();

        approvedErrands.value = postedErrands
            .where((errand) => errand.status == 'Approved')
            .toList();
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to fetch created errands',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }


  Future<void> fetchClaimedErrands() async {
    try {
      isLoading.value = true;
      final headers = await AuthUtils.getAuthHeaders();

     
      print('Fetching claimed errands...');

      final response = await http.get(
        Uri.parse('http://localhost:3000/api/errands/claimed'),
        headers: headers,
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final errandsJson = data['data'] as List;

        // Update lists
        allErrands.value =
            errandsJson.map((json) => Errand.fromJson(json)).toList();

        pendingApprovalErrands.value = errandsJson
            .where((json) => json['status'] == 'Claimed')
            .map((json) => Errand.fromJson(json))
            .toList();

        inProgressErrands.value = errandsJson
            .where((json) => json['status'] == 'In Progress')
            .map((json) => Errand.fromJson(json))
            .toList();

        completedErrands.value = errandsJson
            .where((json) => json['status'] == 'Completed')
            .map((json) => Errand.fromJson(json))
            .toList();

        
        print('Pending claims: ${pendingApprovalErrands.length}');
        print('In progress: ${inProgressErrands.length}');
        print('Completed: ${completedErrands.length}');
      } else {
        throw 'Failed to fetch claimed errands';
      }
    } catch (e) {
      print('Error fetching claimed errands: $e'); 
      Get.snackbar(
        'Error',
        'Failed to fetch claimed errands: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  
  Future<void> deleteErrand(Errand errand) async {
    try {
      final headers = await AuthUtils.getAuthHeaders();
      await http.delete(
        Uri.parse('http://localhost:3000/api/errands/delete/errand/${errand.id}'),
        headers: headers,
      );
      await fetchCreatedErrands();
      Get.snackbar('Success', 'Errand deleted successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete errand');
    }
  }

  Future<void> cancelClaim(Errand errand) async {
    try {
      final headers = await AuthUtils.getAuthHeaders();
      await http.put(
        Uri.parse(
            'http://localhost:3000/api/errands/cancel-claim/errand/${errand.id}'),
        headers: headers,
      );
      await fetchClaimedErrands();
      Get.snackbar('Success', 'Claim cancelled successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to cancel claim');
    }
  }

  Future<void> markClaimComplete(String errandId) async {
    try {
      final headers = await AuthUtils.getAuthHeaders();
      final response = await http.put(
        Uri.parse('http://localhost:3000/api/errands/update/errand/${errandId}'),
        headers: headers,
        body: jsonEncode({
          'status': 'Completed'
        }),
      );

      if (response.statusCode == 200) {
        await fetchClaimedErrands();
        Get.snackbar(
          'Success',
          'Errand marked as complete',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        throw 'Failed to mark errand as complete';
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to complete errand: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> approveErrandClaim(String errandId, String claimerId) async {
    try {
      final headers = await AuthUtils.getAuthHeaders();

      final response = await http.put(
        Uri.parse('http://localhost:3000/api/errands/approve/errand/$errandId'),
        headers: {
          ...headers,
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'claimerId': claimerId,
        }),
      );

      if (response.statusCode == 200) {
        await fetchCreatedErrands();
        Get.snackbar(
          'Success',
          'Claim approved successfully',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to approve claim',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> editErrand(Errand errand) async {
    // Show edit dialog
    final result = await Get.dialog<Map<String, dynamic>>(
      AlertDialog(
        title: const Text('Edit Errand'),
        content: _EditErrandForm(errand: errand),
      ),
    );

    if (result != null) {
      try {
        final headers = await AuthUtils.getAuthHeaders();

        final response = await http.put(
          Uri.parse(
              'http://localhost:3000/api/errands/update/errand/${errand.id}'),
          headers: {
            ...headers,
            'Content-Type': 'application/json',
          },
          body: jsonEncode(result),
        );

        if (response.statusCode == 200) {
          await fetchCreatedErrands();
          Get.snackbar(
            'Success',
            'Errand updated successfully',
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
        }
      } catch (e) {
        Get.snackbar(
          'Error',
          'Failed to update errand',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    }
  }

  Future<void> markErrandComplete(String errandId) async {
    print("ello");
    try {
      final headers = await AuthUtils.getAuthHeaders();
      final response = await http.put(
        Uri.parse('http://localhost:3000/api/errands/update/errand/${errandId}'),
        headers: headers,
        body: jsonEncode({
          'status': 'Completed'
        }),
      );

      if (response.statusCode == 200) {
        await fetchCreatedErrands();
        Get.snackbar(
          'Success',
          'Errand marked as complete',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        throw 'Failed to mark errand as complete';
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to mark errand as complete: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> declineClaim(Errand errand) async {
    try {
      final headers = await AuthUtils.getAuthHeaders();
      
      final response = await http.put(
        Uri.parse('http://localhost:3000/api/errands/update/errand/${errand.id}'),
        headers: headers,
        body: jsonEncode({
          'status': 'Pending',
          'claimedErrandor': [],
        }),
      );

      if (response.statusCode == 200) {
        await fetchCreatedErrands();
        Get.snackbar(
          'Success',
          'Claim declined successfully',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        throw 'Failed to decline claim';
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to decline claim: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}

// Helper widget for edit form
class _EditErrandForm extends StatelessWidget {
  final Errand errand;
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final rewardController = TextEditingController();

  _EditErrandForm({required this.errand}) {
    nameController.text = errand.name;
    descriptionController.text = errand.description;
    rewardController.text = errand.reward.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextField(
          controller: nameController,
          decoration: const InputDecoration(labelText: 'Name'),
        ),
        TextField(
          controller: descriptionController,
          decoration: const InputDecoration(labelText: 'Description'),
          maxLines: 3,
        ),
        TextField(
          controller: rewardController,
          decoration: const InputDecoration(labelText: 'Reward'),
          keyboardType: TextInputType.number,
        ),
        ButtonBar(
          children: [
            TextButton(
              onPressed: () => Get.back(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Get.back(result: {
                'name': nameController.text,
                'description': descriptionController.text,
                'reward': int.parse(rewardController.text),
              }),
              child: const Text('Save'),
            ),
          ],
        ),
      ],
    );
  }
}
