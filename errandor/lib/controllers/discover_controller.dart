import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/errand.dart';
import '../utils/auth_utils.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class DiscoverController extends GetxController {
  final RxString searchQuery = ''.obs;
  final RxList<Errand> errands = <Errand>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool hasError = false.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    fetchErrands();
    super.onInit();
  }

  void searchErrands(String query) {
    searchQuery.value = query;
    if (query.isEmpty) {
      fetchErrands();
      return;
    }

    final filteredErrands = errands.where((errand) {
      final searchLower = query.toLowerCase();
      return errand.name.toLowerCase().contains(searchLower) ||
          errand.description.toLowerCase().contains(searchLower) ||
          errand.place.toLowerCase().contains(searchLower) ||
          errand.county.toLowerCase().contains(searchLower) ||
          errand.subCounty.toLowerCase().contains(searchLower);
    }).toList();

    errands.value = filteredErrands;
  }

  Future<void> fetchErrands() async {
    try {
      isLoading.value = true;
      hasError.value = false;
      errorMessage.value = '';

      final headers = await AuthUtils.getAuthHeaders();

      final response = await http.get(
        Uri.parse("http://localhost:3000/api/errands/all"),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['message'] != null) {
          final List<dynamic> errandsJson = data['data'];
          final List<Errand> fetchedErrands =
              errandsJson.map((json) => Errand.fromJson(json)).toList();
          errands.value = fetchedErrands;
        } else {
          hasError.value = true;
          errorMessage.value = 'Invalid response format';
        }
      } else if (response.statusCode == 401) {
        hasError.value = true;
        errorMessage.value = 'Session expired. Please login again.';
        Get.offAllNamed('/login');
      } else {
        hasError.value = true;
        errorMessage.value =
            'Failed to fetch errands. Status: ${response.statusCode}';
      }
    } catch (e) {
      print("Error fetching errands: $e");
      hasError.value = true;
      errorMessage.value = 'Error fetching errands: $e';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> claimErrand(String errandId) async {
    try {
      // Show loading indicator
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      final headers = await AuthUtils.getAuthHeaders();

      final response = await http.post(
        Uri.parse("http://localhost:3000/api/errands/claim/errand/$errandId"),
        headers: headers,
      );

      // Remove loading indicator
      Get.back();

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        
        // Show success message
        Get.snackbar(
          "Success",
          data['message'] ?? 'Errand claimed successfully',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
        );

        // Refresh errands list
        await fetchErrands();
      } else {
        final data = jsonDecode(response.body);
        Get.snackbar(
          "Error",
          data['message'] ?? 'Failed to claim errand',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.back(); // Remove loading indicator
      Get.snackbar(
        "Error",
        'Failed to claim errand: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}