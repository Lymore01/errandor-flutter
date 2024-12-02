// ignore_for_file: prefer_const_constructors
import 'package:errandor/config/routes/routes.dart';
import 'package:errandor/presentation/screens/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialRoute: "/",
      getPages: routes,
      debugShowCheckedModeBanner: false,
      home: const Dashboard(),
    );
  }
}
