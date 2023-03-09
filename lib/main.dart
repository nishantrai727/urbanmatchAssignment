// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import './view/DashboardScreen.dart';
import './view/repoScreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      home: DashboardScreen(),
      getPages: [
        GetPage(name: "/dashboard", page: () => DashboardScreen()),
        GetPage(name: "/repoScreen", page: (() => RepoScreen())),
      ],
    );
  }
}
