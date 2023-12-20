import 'dart:io';

import 'package:flutter/material.dart';
import 'package:platform_specific_map_services/widgets/apple_map_widget.dart';
import 'package:platform_specific_map_services/widgets/googleMapWidget.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    if (Platform.isAndroid) {
      return GoogleMapWidget();
    } else {
      return AppleMapWidget();
    }
  }
}
