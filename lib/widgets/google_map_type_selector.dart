import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:platform_specific_map_services/controller/google_map_controller.dart';

class GoogleMapTypeSelectorWidget extends StatefulWidget {
  final int index;
  final String image;
  const GoogleMapTypeSelectorWidget(
      {Key? key, required this.image, required this.index});

  @override
  State<GoogleMapTypeSelectorWidget> createState() =>
      _GoogleMapTypeSelectorWidgetState();
}

class _GoogleMapTypeSelectorWidgetState
    extends State<GoogleMapTypeSelectorWidget> {
  @override
  Widget build(BuildContext context) {
    // Instance of GetX Controller
    final GoogleMapGetXController _googleMapController =
        Get.put(GoogleMapGetXController());

    return Obx(
      () => Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: _googleMapController.mapTypeIndex.value == widget.index
                  ? Colors.blue
                  : Color.fromARGB(192, 150, 148, 148),
              blurRadius: 10,
              spreadRadius: 8,
            ),
          ],
        ),
        child: ClipOval(
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                _googleMapController.mapTypeIndex.value = widget.index;
              },
              child: Image.network(
                widget.image,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
