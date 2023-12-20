import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

class GoogleMapWidget extends StatefulWidget {
  const GoogleMapWidget({super.key});

  @override
  State<GoogleMapWidget> createState() => _GoogleMapWidgetState();
}

class _GoogleMapWidgetState extends State<GoogleMapWidget> {
  LatLng initialCameraPosition = LatLng(11.018832818104553, 76.96758439858705);
  late Position currentPosition;
  late GoogleMapController googleMapController;
  Set<Marker> markers = {};

  //locationAcessRequest
  void locationAcess() async {
    final permissionStatus = await Permission.location.request();
    if (permissionStatus.isGranted) {
      currentPosition = await Geolocator.getCurrentPosition();
      googleMapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
              target:
                  LatLng(currentPosition.latitude, currentPosition.longitude),
              zoom: 16),
        ),
      );
    } else if (permissionStatus.isDenied) {
      openAppSettings();
    }
  }
  //currentlocation
  // void currentLocation() async {
  //   Position currentPosition = await Geolocator.getCurrentPosition();
  //   setState(() {
  //     initialCameraPosition = currentPosition as LatLng;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(extendBodyBehindAppBar: true,
      // appBar: AppBar(
      //   title: Text("GOOGLE MAP"),
      // ),
      body: GoogleMap(myLocationButtonEnabled: true,myLocationEnabled: true,mapType: MapType.hybrid,
        initialCameraPosition:
            CameraPosition(target: initialCameraPosition, zoom: 9),
        markers: markers,
        onMapCreated: (GoogleMapController controller) {
          googleMapController = controller;
        },
      ),
      floatingActionButton: FloatingActionButton(onPressed: () {
        locationAcess();
        markers.add(Marker(
          markerId: MarkerId("currentPosition"),
          position: LatLng(currentPosition.latitude, currentPosition.longitude),
        ));
      }),
    );
  }
}
