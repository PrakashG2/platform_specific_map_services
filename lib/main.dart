import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/bindings_interface.dart';
import 'package:get/instance_manager.dart';
import 'package:get/route_manager.dart';
import 'package:platform_specific_map_services/controller/apple_map_controller.dart';
import 'package:platform_specific_map_services/controller/google_map_controller.dart';
import 'package:platform_specific_map_services/screens/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'PLATFORM SPECIFIC MAP SERVICES',
      home: HomePage(),
      initialBinding: RootBindings(),
    );
  }
}

class RootBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(AppleMapWidgetController());
    Get.put(GoogleMapGetXController());
  }
}
