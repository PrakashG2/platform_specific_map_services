import 'package:apple_maps_flutter/apple_maps_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/instance_manager.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:platform_specific_map_services/controller/apple_map_controller.dart';
import 'package:platform_specific_map_services/widgets/appple_map_bottomModel_chooseMap.dart';

class AppleMapWidget extends StatefulWidget {
  const AppleMapWidget({super.key});

  @override
  State<AppleMapWidget> createState() => _AppleMapWidgetState();
}

class _AppleMapWidgetState extends State<AppleMapWidget> {
  final AppleMapWidgetController _appleMapWidgetController =
      Get.put(AppleMapWidgetController());
  

  bool twoDimentional = true;
  final List<MapType> mapTypesEnum = [
    MapType.standard,
    MapType.satellite,
    MapType.hybrid,
    MapType.standard
  ];

  //init
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    locationAccess();
  }

  //locationAcess
  void locationAccess() async {
    final locationStatus = await Permission.location.request();

    if (locationStatus.isGranted) {
      print("got location access");
    } else {
      openAppSettings();
    }
  }

  //getCurrentLocation
  void currentPosition() async {
    final Position currentPosition = await Geolocator.getCurrentPosition();
    appleMapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(currentPosition.latitude, currentPosition.longitude),
          zoom: 19,
        ),
      ),
    );
  }

  late AppleMapController appleMapController;
  LatLng initialCameraPosition = LatLng(11.018832818104553, 76.96758439858705);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      // appBar: AppBar(
      //   title: Text("APPLE MAP"),
      // ),
      body: Stack(
        children: [
          Obx(
            () => AppleMap(
              initialCameraPosition: CameraPosition(
                target: initialCameraPosition,
                zoom: 10,
              ),
              onMapCreated: (AppleMapController controller) {
                appleMapController = controller;
              },
              mapType:
                  mapTypesEnum[_appleMapWidgetController.mapTypeIndex.value],
            ),
          ),
          Positioned(
            top: 100,
            right: 20,
            child: Container(
              color: Color.fromARGB(255, 255, 254, 254),
              child: Column(
                children: [
                  IconButton(
                    onPressed: () {
                      currentPosition();
                    },
                    icon: const Icon(CupertinoIcons.location_fill),
                  ),
                  IconButton(
                    onPressed: () {
                      appleMapController.animateCamera(CameraUpdate.zoomBy(1));
                    },
                    icon: const Icon(CupertinoIcons.plus),
                  ),
                  IconButton(
                    onPressed: () {
                      appleMapController.animateCamera(CameraUpdate.zoomBy(-1));
                    },
                    icon: const Icon(CupertinoIcons.minus),
                  ),
                  // SizedBox(height: 10,),
                  // IconButton(
                  //   onPressed: () {
                  //     appleMapController.moveCamera(CameraUpdate.newCameraPosition(CameraPosition(target: initialCameraPosition,zoom: 40,pitch: twoDimentional ? 0 : 30)));
                  //     setState(() {
                  //       twoDimentional = !twoDimentional;
                  //     });
                  //   },
                  //   icon: twoDimentional ? const Icon(CupertinoIcons.view_2d) : const Icon(CupertinoIcons.view_3d),
                  // ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.small(
        backgroundColor: CupertinoColors.systemGrey5,
        onPressed: () {
          showModalBottomSheet(
              enableDrag: true,
              context: context,
              builder: (BuildContext context) => ChooseMapBottomModel());
        },
        child: const Icon(
          CupertinoIcons.map_fill,
          size: 16,
        ),
      ),
    );
  }
}
