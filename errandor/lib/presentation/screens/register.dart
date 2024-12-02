// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:errandor/controllers/auth_controller.dart';
import 'package:errandor/presentation/widgets/button.dart';
import 'package:errandor/presentation/widgets/formTextField.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

AuthController authController = Get.put(AuthController());
TextEditingController firstNameController = TextEditingController();
TextEditingController lastNameController = TextEditingController();
TextEditingController emailController = TextEditingController();
TextEditingController passwordController = TextEditingController();

class Register extends StatelessWidget {
  const Register({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 36.0),
          child: Form(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: SizedBox(
                    height: 100,
                    width: 180,
                    child: Image.asset("images/Errandor-logo-black.png"),
                  ),
                ),
                const SizedBox(height: 20.0),
                const Text(
                  "Create An Account",
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 20.0,
                    fontFamily: "Poppins",
                  ),
                ),
                const SizedBox(height: 20.0),
                formTextField(
                  controller: firstNameController,
                  hint: "john",
                  icon: Icons.person,
                  labelText: "First Name",
                  isPassword: false,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your first name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20.0),
                formTextField(
                  controller: lastNameController,
                  hint: "doe",
                  icon: Icons.person,
                  labelText: "Last Name",
                  isPassword: false,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your last name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20.0),
                formTextField(
                  controller: emailController,
                  hint: "johndoe@gmail.com",
                  icon: Icons.email,
                  labelText: "Email",
                  isPassword: false,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!GetUtils.isEmail(value)) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20.0),
                formTextField(
                  controller: passwordController,
                  hint: "",
                  icon: Icons.password,
                  labelText: "Password",
                  isPassword: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20.0),
                SizedBox(
                  width: double.infinity,
                  child: buttonWidget(
                    method: () async {
                      try {
                        await authController.register(
                          firstName: firstNameController.text.trim(),
                          lastName: lastNameController.text.trim(),
                          email: emailController.text.trim(),
                          password: passwordController.text,
                        );
                      } catch (e) {
                        Get.snackbar(
                          "Error",
                          "Registration failed: $e",
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.red,
                          colorText: Colors.white,
                        );
                      }
                    },
                    text: "Register",
                  ),
                ),
                const SizedBox(height: 20.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Already have an account?",
                      style: TextStyle(color: Colors.black87),
                    ),
                    const SizedBox(width: 8.0),
                    TextButton(
                      onPressed: () => Get.offAndToNamed("/login"),
                      child: const Text(
                        "Sign in",
                        style: TextStyle(
                          color: Colors.orange,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 20.0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
