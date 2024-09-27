import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'UI/Home/Components/home.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Product Search App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
      debugShowCheckedModeBanner: false, // Remove the debug banner
    );
  }
}
