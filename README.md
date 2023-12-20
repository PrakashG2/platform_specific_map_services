# platform_specific_map_services

import 'package:apple_maps_flutter/apple_maps_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:platform_specific_map_services/widgets/appple_map_bottomModel_chooseMap.dart';

int mapTypeIndex = 0;
final List<String> mapTypes = ["STANDARD", "SATELLITE", "HYBRID", "STANDARD"];

class AppleMapWidget extends StatefulWidget {
  const AppleMapWidget({super.key});

  @override
  State<AppleMapWidget> createState() => _AppleMapWidgetState();
}

class _AppleMapWidgetState extends State<AppleMapWidget> {
  bool twoDimentional = true;
  final List<MapType> mapTypesEnum = [
    MapType.standard,
    MapType.satellite,
    MapType.hybrid,
    MapType.satellite
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
          AppleMap(
            initialCameraPosition:
                CameraPosition(target: initialCameraPosition, zoom: 10),
            onMapCreated: (AppleMapController controller) {
              appleMapController = controller;
            },
            mapType: mapTypesEnum[mapTypeIndex],
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

class ChooseMapBottomModel extends StatefulWidget {
  const ChooseMapBottomModel({super.key});

  @override
  State<ChooseMapBottomModel> createState() => _ChooseMapBottomModelState();
}

class _ChooseMapBottomModelState extends State<ChooseMapBottomModel> {
  // int mapTypeIndex = 0;
  // final List<MapType> mapTypesEnum = [MapType.standard,MapType.satellite,MapType.hybrid,MapType.satellite];
  // final List<String> mapTypes = ["STANDARD","SATELLITE","HYBRID","STANDARD"];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 400,
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Choose Map Type",
                  style: TextStyle(fontSize: 21, fontWeight: FontWeight.w800),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(CupertinoIcons.xmark_circle_fill),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    childAspectRatio: 1.5,
                    crossAxisCount: 2,
                    mainAxisSpacing: 15,
                    crossAxisSpacing: 15),
                itemCount: 4,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        mapTypeIndex = index;
                      });

                      print(index);
                    },
                    child: Container(
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        border: mapTypeIndex == index
                            ? Border.all(
                                color: Color.fromARGB(255, 78, 72, 255),
                                width: 3.0)
                            : null,
                        borderRadius: BorderRadius.circular(10),
                        image: const DecorationImage(
                            image: NetworkImage(
                                "https://cheeaun.com/blog/images/screenshots/software/wwdc21-apple-maps-elevation-trees-buildings@2x.jpg"),
                            fit: BoxFit.cover),
                      ),
                      child: Container(
                        alignment: Alignment.bottomLeft,
                        child: Container(
                          alignment: Alignment.centerLeft,
                          width: double.infinity,
                          color: Color.fromARGB(255, 255, 255, 255),
                          height: 30,
                          child: Text(mapTypes[index]),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Text("Powered by Apple Maps")
          ],
        ),
      ),
    );
  }
}



class ChooseMapBottomModel extends StatefulWidget {
  final Function(int) onMapTypeSelected;

  const ChooseMapBottomModel({Key? key, required this.onMapTypeSelected}) : super(key: key);

  @override
  _ChooseMapBottomModelState createState() => _ChooseMapBottomModelState();
}

class _ChooseMapBottomModelState extends State<ChooseMapBottomModel> {
  // ... existing code ...

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // ... existing code ...

                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      mapTypeIndex = index;
                    });

                    // Call the callback function to notify the parent about the selected map type
                    widget.onMapTypeSelected(index);
                  },
                  // ... existing code ...
                ),
              );
            },
          ),
        ),
        // ... existing code ...
      ],
    ),
  ),
);





class _AppleMapWidgetState extends State<AppleMapWidget> {
  // ... existing code ...

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ... existing code ...

      floatingActionButton: FloatingActionButton.small(
        backgroundColor: CupertinoColors.systemGrey5,
        onPressed: () {
          showModalBottomSheet(
            enableDrag: true,
            context: context,
            builder: (BuildContext context) => ChooseMapBottomModel(
              onMapTypeSelected: (selectedMapTypeIndex) {
                setState(() {
                  mapTypeIndex = selectedMapTypeIndex;
                });

                // Update the map type in AppleMapController
                appleMapController.updateMapType(mapTypesEnum[selectedMapTypeIndex]);
              },
            ),
          );
        },
        child: const Icon(
          CupertinoIcons.map_fill,
          size: 16,
        ),
      ),
    );
  }
}

