import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../utils/auth_utils.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:typed_data';

class CreateErrandController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final errandNameController = TextEditingController();
  final descriptionController = TextEditingController();
  final countyController = TextEditingController();
  final subCountyController = TextEditingController();
  final placeController = TextEditingController();
  final dateTimeController = TextEditingController();
  final completionTimeController = TextEditingController();
  final paymentController = TextEditingController();
  final instructionsController = TextEditingController();
  final urgencyController = TextEditingController();
  
  final Rx<XFile?> imageFile = Rx<XFile?>(null);
  final Rx<Uint8List?> imageBytes = Rx<Uint8List?>(null);
  final ImagePicker picker = ImagePicker();
  final RxBool isLoading = false.obs;

  Future<void> pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await picker.pickImage(
        source: source,
        imageQuality: 85,
      );
      
      if (pickedFile != null) {
        print(pickedFile.name);
        final extension = pickedFile.name.split('.').last.toLowerCase();
        if (!['jpg', 'JPG', 'jpeg', 'JPEG', 'png', 'PNG', 'gif', 'GIF'].contains(extension)) {
          Get.snackbar(
            'Error',
            'Only JPG, JPEG, PNG and GIF files are allowed',
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
          return;
        }

        imageFile.value = pickedFile;
        imageBytes.value = await pickedFile.readAsBytes();
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to pick image',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> submitForm() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    if (imageFile.value == null) {
      Get.snackbar(
        'Error',
        'Please select an image',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    try {
      isLoading.value = true;
      final headers = await AuthUtils.getAuthHeaders();

      var formData = http.MultipartRequest(
        'POST',
        Uri.parse('http://localhost:3000/api/errands/create'),
      );

      // Add headers
      formData.headers.addAll(headers);

      // Add text fields
      formData.fields.addAll({
        'errandName': errandNameController.text,
        'description': descriptionController.text,
        'county': countyController.text,
        'subCounty': subCountyController.text,
        'place': placeController.text,
        'dateTime': dateTimeController.text,
        'completionTime': completionTimeController.text,
        'reward': paymentController.text,
        'instructions': instructionsController.text,
        'urgency': urgencyController.text,
        'status': 'Pending',
      });

      // Add image
      final bytes = await imageFile.value!.readAsBytes();
      final multipartFile = http.MultipartFile.fromBytes(
        'errandImage',
        bytes,
        filename: imageFile.value!.name,
      );
      formData.files.add(multipartFile);

      
      final streamedResponse = await formData.send();
      final response = await http.Response.fromStream(streamedResponse);
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 201 || response.statusCode == 200) { 
        try {
          final data = jsonDecode(response.body);
          Get.snackbar(
            'Success',
            data['message'] ?? 'Errand created successfully',
            backgroundColor: Colors.green,
            colorText: Colors.white,
            duration: const Duration(seconds: 2),
          );
          
          
          await Future.delayed(const Duration(seconds: 1));
          Get.back();
        } catch (e) {
          print('Error parsing response: $e');
          throw 'Invalid server response';
        }
      } else {
        final data = jsonDecode(response.body);
        throw data['message'] ?? 'Failed to create errand';
      }
    } catch (e) {
      print('Error creating errand: $e');
      Get.snackbar(
        'Error',
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    errandNameController.dispose();
    descriptionController.dispose();
    countyController.dispose();
    subCountyController.dispose();
    placeController.dispose();
    dateTimeController.dispose();
    completionTimeController.dispose();
    paymentController.dispose();
    instructionsController.dispose();
    urgencyController.dispose();
    super.onClose();
  }
} 