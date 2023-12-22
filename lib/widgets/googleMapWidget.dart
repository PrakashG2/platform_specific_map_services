import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get/route_manager.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:platform_specific_map_services/controller/google_map_controller.dart';
import 'package:platform_specific_map_services/widgets/google_map_type_selector.dart';

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
  final homeScaffoldKey = GlobalKey<ScaffoldState>();
  Set<Marker> markersList = {};
  bool locationAccess = false;
  final List<MapType> mapTypeEnum = [
    MapType.normal,
    MapType.satellite,
    MapType.terrain,
    MapType.hybrid
  ];
  //instance of getx Controller
  final GoogleMapGetXController _googleMapController =
      Get.put(GoogleMapGetXController());

  //locationAcessRequest
  void locationAcess() async {
    final permissionStatus = await Permission.location.request();
    if (permissionStatus.isGranted) {
      setState(() {
        locationAccess = true;
      });
    } else if (permissionStatus.isDenied) {
      openAppSettings();
    }
  }

  //currentlocation
  void currentLocation() async {
    currentPosition = await Geolocator.getCurrentPosition();
    googleMapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
            target: LatLng(currentPosition.latitude, currentPosition.longitude),
            zoom: 16),
      ),
    );
    markers.add(
      Marker(
        markerId: MarkerId("currentPosition"),
        position: LatLng(currentPosition.latitude, currentPosition.longitude),
      ),
    );
  }

  //Places COntent
  //--> on submitted
  Future<void> _handlePressButton() async {
    Prediction? p = await PlacesAutocomplete.show(
        context: context,
        apiKey: "AIzaSyBzsv3gv5Pxp6IM9J5G0vnk83Mn3XtjmH4",
        mode: Mode.overlay,
        onError: onError,
        language: 'en',
        strictbounds: false,
        types: [""],
        decoration: InputDecoration(
            hintText: 'Search',
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(color: Colors.white))),
        components: [
          Component(Component.country, "pk"),
          Component(Component.country, "usa")
        ]);

    displayPrediction(p!, homeScaffoldKey.currentState);
  }

  void onError(PlacesAutocompleteResponse response) {
    print(response.errorMessage);
    Get.snackbar("ERROR", response.errorMessage!,
        margin: EdgeInsets.only(bottom: 5),
        padding: EdgeInsets.all(10),
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: 30),
        backgroundColor: Colors.red);

    // homeScaffoldKey.currentState!.showSnackBar(SnackBar(content: Text(response.errorMessage!)));
  }

  Future<void> displayPrediction(
      Prediction p, ScaffoldState? currentState) async {
    GoogleMapsPlaces places = GoogleMapsPlaces(
        apiKey: "AIzaSyDIDrFmg46yEb_UCEvLXNuSrR4iZ39gNaM",
        apiHeaders: await const GoogleApiHeaders().getHeaders());

    PlacesDetailsResponse detail = await places.getDetailsByPlaceId(p.placeId!);

    final lat = detail.result.geometry!.location.lat;
    final lng = detail.result.geometry!.location.lng;

    markersList.clear();
    markersList.add(Marker(
        markerId: const MarkerId("0"),
        position: LatLng(lat, lng),
        infoWindow: InfoWindow(title: detail.result.name)));

    setState(() {});

    googleMapController
        .animateCamera(CameraUpdate.newLatLngZoom(LatLng(lat, lng), 14.0));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: homeScaffoldKey,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text("GOOGLE MAP"),
        actions: [
          IconButton(
            onPressed: _handlePressButton,
            icon: Icon(Icons.search),
          ),
        ],
      ),
      body: Obx(() => Stack(
        children: [
          GoogleMap(
            zoomControlsEnabled: false,
            mapType: mapTypeEnum[_googleMapController.mapTypeIndex.value],
            initialCameraPosition:
                CameraPosition(target: initialCameraPosition, zoom: 9),
            markers: markers,
            onMapCreated: (GoogleMapController controller) {
              googleMapController = controller;
            },
          ),

          // //searchbar
          // Positioned(
          //   top: 50,
          //   right: 10,
          //   left: 10,
          //   child: SearchBar(
          //     hintText: "Search for something ...",
          //     onSubmitted: (String) {
          //       _handlePressButton();
          //     },
          //   ),
          // ),

          //controlls
          Positioned(
            bottom: 100,
            right: 10,
            child: Column(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.white),
                  child: IconButton(
                    color: Colors.black,
                    onPressed: () {
                      locationAccess ? currentLocation() : locationAcess();
                    },
                    icon: Icon(Icons.my_location),
                  ),
                ),
                SizedBox(height: 8),
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: IconButton(
                    onPressed: () {
                      googleMapController.animateCamera(CameraUpdate.zoomBy(1));
                    },
                    icon: Icon(Icons.add),
                  ),
                ),
                SizedBox(height: 8),
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: IconButton(
                    onPressed: () {
                      googleMapController
                          .animateCamera(CameraUpdate.zoomBy(-1));
                    },
                    icon: Icon(Icons.remove),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                // Container(
                //   width: 40,
                //   height: 40,
                //   decoration: BoxDecoration(
                //     color: Colors.white,
                //     borderRadius: BorderRadius.circular(8),
                //   ),
                //   child: IconButton(
                //     onPressed: () {
                //       showDialog(
                //         context: context,
                //         builder: (BuildContext context) => Expanded(
                //           child: Row(
                //             children: [
                //               GoogleMapTypeSelectorWidget(),
                //               GoogleMapTypeSelectorWidget(),
                //               GoogleMapTypeSelectorWidget(),
                //               GoogleMapTypeSelectorWidget()
                //             ],
                //           ),
                //         ),
                //       );
                //     },
                //     icon: Icon(Icons.map_rounded),
                //   ),
                // ),

                SpeedDial(buttonSize: Size(35, 35),child: Icon(Icons.map_rounded,size: 40,),backgroundColor: Colors.white,
                  direction: SpeedDialDirection.left,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        12.0), // Adjust the radius as needed
                  ),
                  childPadding:
                      EdgeInsets.all(5.0), // Adjust the padding as needed
                  children: [
                    SpeedDialChild(
                     labelWidget: Text("SATTELITE",style:  TextStyle(fontSize: 10, fontWeight: FontWeight.w600),),
                      backgroundColor: Colors.transparent,
                      child: SizedBox(
                        width: 60.0, // Adjust the width as needed
                        height: 60.0, // Adjust the height as needed
                        child: GoogleMapTypeSelectorWidget(index:0,
                            image:
                                "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS0GJha9TbOBoL8Ozm52N4mJhjvPF2nIQWCpg&usqp=CAU"),
                      ),
                    ),
                    SpeedDialChild(
                      backgroundColor: Colors.transparent,
                      labelWidget: Text("TERRAIN", style:  TextStyle(fontSize: 10, fontWeight: FontWeight.w600),),
                      child: SizedBox(
                        width: 60.0, // Adjust the width as needed
                        height: 60.0, // Adjust the height as needed
                        child: GoogleMapTypeSelectorWidget(index:1,
                            image:
                                "https://media.istockphoto.com/id/141573867/photo/world-topographic-map-national-border.jpg?b=1&s=170667a&w=0&k=20&c=vVIi7KK-KHS8thgQbiWbd0Nfy4Zt8NKvJ9HfUx8s62E="),
                      ),
                    ),
                    SpeedDialChild(
                      labelWidget: Text("HYBRID",style:  TextStyle(fontSize: 10, fontWeight: FontWeight.w600),),
                      backgroundColor: Colors.transparent,
                      child: SizedBox(
                        width: 60.0, // Adjust the width as needed
                        height: 60.0, // Adjust the height as needed
                        child: GoogleMapTypeSelectorWidget(index:2,
                            image:
                                "https://64.media.tumblr.com/4fa18e265e873a0ebf94d2f4e7e3ee8d/tumblr_pahdpdc4zI1rasnq9o1_1280.png"),
                      ),
                    ),
                    // SpeedDialChild(
                    //   labelWidget: Text("DEFAULT",style:  TextStyle(fontSize: 10, fontWeight: FontWeight.w600),),
                    //   backgroundColor: Colors.transparent,
                    //   child: SizedBox(
                    //     width: 60.0, // Adjust the width as needed
                    //     height: 60.0, // Adjust the height as needed
                    //     child: GoogleMapTypeSelectorWidget(index:2,
                    //         image:
                    //             "https://64.media.tumblr.com/4fa18e265e873a0ebf94d2f4e7e3ee8d/tumblr_pahdpdc4zI1rasnq9o1_1280.png"),
                    //   ),
                    // ),
                    // Add similar SpeedDialChild widgets for other items
                  ],
                )
              ],
            ),
          )
        ],
      ),),
    );
  }
}
