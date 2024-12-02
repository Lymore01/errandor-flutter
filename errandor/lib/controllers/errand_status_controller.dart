import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../utils/auth_utils.dart';

class ErrandStatusController extends GetxController {
  // Creator Stats
  final RxInt totalErrandsPosted = 0.obs;
  final RxInt totalPendingErrands = 0.obs;
  final RxInt totalInProgressErrands = 0.obs;
  final RxInt totalCompletedCreated = 0.obs;
  final RxInt totalCancelledCreated = 0.obs;
  final RxDouble totalSpent = 0.0.obs;

  // Claimer Stats
  final RxInt totalErrandsClaimed = 0.obs;
  final RxInt totalErrandsCompleted = 0.obs;
  final RxInt totalErrandsApproved = 0.obs;
  final RxInt totalErrandsCancelled = 0.obs;
  final RxInt totalPendingApproval = 0.obs;
  final RxDouble totalEarnings = 0.0.obs;

  final RxBool isLoading = false.obs;
  final RxBool hasError = false.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    fetchDashboardData();
    super.onInit();
  }

  Future<void> fetchDashboardData() async {
    try {
      isLoading.value = true;
      hasError.value = false;
      errorMessage.value = '';

      final headers = await AuthUtils.getAuthHeaders();
      final response = await http.get(
        Uri.parse('http://localhost:3000/api/dashboard'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        
        if (data['success'] == true) {
          final creatorData = data['data']['creator'];
          final claimerData = data['data']['claimer'];
          
          // Update Creator Stats
          totalErrandsPosted.value = creatorData['totalErrandsPosted'] ?? 0;
          totalPendingErrands.value = creatorData['totalPendingErrands'] ?? 0;
          totalInProgressErrands.value = creatorData['totalInProgressErrands'] ?? 0;
          totalCompletedCreated.value = creatorData['totalCompletedCreated'] ?? 0;
          totalCancelledCreated.value = creatorData['totalCancelledCreated'] ?? 0;
          totalSpent.value = (creatorData['totalSpent'] ?? 0).toDouble();

          // Update Claimer Stats
          totalErrandsClaimed.value = claimerData['totalErrandsClaimed'] ?? 0;
          totalErrandsCompleted.value = claimerData['totalErrandsCompleted'] ?? 0;
          totalErrandsApproved.value = claimerData['totalErrandsApproved'] ?? 0;
          totalErrandsCancelled.value = claimerData['totalErrandsCancelled'] ?? 0;
          totalPendingApproval.value = claimerData['totalPendingApproval'] ?? 0;
          totalEarnings.value = (claimerData['totalEarnings'] ?? 0).toDouble();
        } else {
          hasError.value = true;
          errorMessage.value = data['message'] ?? 'Failed to fetch dashboard data';
        }
      } else {
        hasError.value = true;
        errorMessage.value = 'Failed to fetch dashboard data';
      }
    } catch (e) {
      hasError.value = true;
      errorMessage.value = 'Error fetching dashboard data: $e';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshDashboard() async {
    await fetchDashboardData();
  }
} 