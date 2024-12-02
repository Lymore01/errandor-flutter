// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers

import 'package:errandor/controllers/auth_controller.dart';
import 'package:errandor/presentation/widgets/button.dart';
import 'package:errandor/presentation/widgets/formTextField.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

AuthController authController = Get.put(AuthController());
TextEditingController emailController = TextEditingController();
TextEditingController passwordController = TextEditingController();

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    readValue().then((onValue) => emailController.text = onValue);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 36.0),
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
            SizedBox(height: 20.0),
            Text(
              "Welcome Back!",
              style: TextStyle(
                  color: Colors.black, fontSize: 20.0, fontFamily: "Poppins"),
            ),
            SizedBox(height: 20.0),
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
            SizedBox(height: 20.0),
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
            SizedBox(height: 20.0),
            Container(
              width: double.infinity,
              child: buttonWidget(
                method: () async {
                  await authController.login(
                    email: emailController.text,
                    password: passwordController.text,
                  );
                },
                text: "Login",
              ),
            ),
            SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Don't have an account?",
                  style: TextStyle(color: Colors.black87),
                ),
                TextButton(
                  onPressed: () {
                    Get.offAndToNamed("/register");
                  },
                  child: Text(
                    "Sign up",
                    style: TextStyle(
                      color: Colors.orange,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  readValue() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString("email") ?? "";
  }
}
