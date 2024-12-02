// ignore_for_file: unused_local_variable

import 'dart:convert';

import 'package:errandor/utils/auth_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class AuthController extends GetxController {
  final isLoading = false.obs;
  final token = ''.obs;

  Future<void> login({required String email, required String password}) async {
    try {
      isLoading.value = true;
      
      final response = await http.post(
        Uri.parse('http://localhost:3000/api/users/login-user'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        try {
          final data = jsonDecode(response.body);
          final token = data['AccessToken'];
          
          if (token != null) {
            SharedPreferences pref = await SharedPreferences.getInstance();
            await pref.setString("token", token);
            this.token.value = token;
            
            print("Token stored successfully: $token");
            
            Get.snackbar(
              'Success',
              'Login successful!',
              backgroundColor: Colors.green,
              colorText: Colors.white,
              duration: const Duration(seconds: 2),
            );

            await Future.delayed(const Duration(seconds: 2));
            Get.offAllNamed('/');
          } else {
            Get.snackbar(
              'Error',
              'Token not found in response',
              backgroundColor: Colors.red,
              colorText: Colors.white,
            );
          }
        } catch (e) {
          print("Error parsing response: $e");
          Get.snackbar(
            'Error',
            'Invalid server response',
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      } else {
        Get.snackbar(
          'Error',
          'Login failed. Status: ${response.statusCode}',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      print("Login error: $e");
      Get.snackbar(
        'Error',
        'Connection error. Please check your internet connection.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
  }) async {
    try {
      isLoading.value = true;
      
      final response = await http.post(
        Uri.parse('http://localhost:3000/api/users/register-user'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'firstName': firstName,
          'lastName': lastName,
          'email': email,
          'password': password,
        }),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 201 || response.statusCode == 200) {
        try {
          final data = jsonDecode(response.body);
          Get.snackbar(
            'Success',
            'Registration successful! Please login.',
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
          await Future.delayed(const Duration(seconds: 2));
          Get.offAllNamed('/login');
        } catch (e) {
          print("Error parsing response: $e");
          Get.snackbar(
            'Error',
            'Invalid server response',
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      } else {
        Get.snackbar(
          'Error',
          'Registration failed. Status: ${response.statusCode}',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      print("Registration error: $e");
      Get.snackbar(
        'Error',
        'Connection error. Please check your internet connection.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      await pref.clear();
      token.value = "";
      Get.offAllNamed("/login");
    } catch (e) {
      print("Logout error: $e");
      Get.snackbar(
        'Error',
        'An error occurred during logout',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // Add method to check if user is logged in
  Future<bool> isLoggedIn() async {
    final token = await AuthUtils.getToken();
    return token != null && token.isNotEmpty;
  }
}
