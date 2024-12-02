import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/user.dart';
import '../utils/auth_utils.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';

class ProfileController extends GetxController {
  final Rx<User?> user = Rx<User?>(null);
  final RxBool isLoading = false.obs;
  final RxInt totalCreated = 0.obs;
  final RxInt totalClaimed = 0.obs;
  final RxInt totalCompleted = 0.obs;
  final RxDouble totalEarnings = 0.0.obs;
  final RxDouble totalSpent = 0.0.obs;

  final ImagePicker picker = ImagePicker();
  final Rx<XFile?> imageFile = Rx<XFile?>(null);
  final Rx<Uint8List?> imageBytes = Rx<Uint8List?>(null);

  @override
  void onInit() {
    fetchUserProfile();
    super.onInit();
  }

  Future<void> fetchUserProfile() async {
    try {
      isLoading.value = true;
      final headers = await AuthUtils.getAuthHeaders();
      
      final response = await http.get(
        Uri.parse('http://localhost:3000/api/users/profile'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        user.value = User.fromJson(data['data']['user']);
        
        // Update stats
        final stats = data['data']['stats'];
        totalCreated.value = stats['created'] ?? 0;
        totalClaimed.value = stats['claimed'] ?? 0;
        totalCompleted.value = stats['completed'] ?? 0;
        totalEarnings.value = (stats['totalEarnings'] ?? 0).toDouble();
        totalSpent.value = (stats['totalSpent'] ?? 0).toDouble();
      } else {
        throw 'Failed to load profile';
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load profile: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateProfileImage() async {
    try {
      final XFile? pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );
      
      if (pickedFile != null) {
     
        final extension = pickedFile.name.split('.').last.toLowerCase();
        if (!['jpg', 'jpeg', 'png'].contains(extension)) {
          Get.snackbar(
            'Error',
            'Only JPG, JPEG and PNG files are allowed',
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
          return;
        }

        isLoading.value = true;
        final headers = await AuthUtils.getAuthHeaders();

        
        var request = http.MultipartRequest(
          'PUT',
          Uri.parse('http://localhost:3000/api/users/update-profile'),
        );

        request.headers.addAll(headers);

        // Add image file
        final bytes = await pickedFile.readAsBytes();
        final multipartFile = http.MultipartFile.fromBytes(
          'profileImage',
          bytes,
          filename: pickedFile.name,
        );
        request.files.add(multipartFile);

        // Send request
        final streamedResponse = await request.send();
        final response = await http.Response.fromStream(streamedResponse);

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          user.value = User.fromJson(data['data']);
          Get.snackbar(
            'Success',
            'Profile image updated successfully',
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
        } else {
          throw 'Failed to update profile image';
        }
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to update profile image: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateProfile({
    String? firstName,
    String? lastName,
    String? email,
  }) async {
    try {
      isLoading.value = true;
      final headers = await AuthUtils.getAuthHeaders();

      final response = await http.put(
        Uri.parse('http://localhost:3000/api/users/update-profile'),
        headers: {
          ...headers,
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          if (firstName != null) 'firstName': firstName,
          if (lastName != null) 'lastName': lastName,
          if (email != null) 'email': email,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        user.value = User.fromJson(data['data']);
        Get.snackbar(
          'Success',
          'Profile updated successfully',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        await fetchUserProfile(); 
      } else {
        throw 'Failed to update profile';
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to update profile: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
} 