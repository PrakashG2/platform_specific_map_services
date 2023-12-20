import 'package:apple_maps_flutter/apple_maps_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';
import 'package:platform_specific_map_services/controller/apple_map_controller.dart';

class ChooseMapBottomModel extends StatefulWidget {
  const ChooseMapBottomModel({super.key});

  @override
  State<ChooseMapBottomModel> createState() => _ChooseMapBottomModelState();
}

class _ChooseMapBottomModelState extends State<ChooseMapBottomModel> {

  int mapTypeIndex = 0;
  final List<MapType> mapTypesEnum = [MapType.standard,MapType.satellite,MapType.hybrid,MapType.satellite];
  final List<String> mapTypes = ["STANDARD","SATELLITE","HYBRID","STANDARD"];
  final AppleMapWidgetController _appleMapWidgetController =
      Get.put(AppleMapWidgetController());
  
  @override
  Widget build(BuildContext context) {
    return SizedBox(
              height: 400,
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Choose Map Type",
                          style: TextStyle(
                              fontSize: 21, fontWeight: FontWeight.w800),
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
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                childAspectRatio: 1.5,
                                crossAxisCount: 2,
                                mainAxisSpacing: 15,
                                crossAxisSpacing: 15),
                        itemCount: 4,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              _appleMapWidgetController.mapTypeIndex.value = index;
                            },
                            child: Obx(() => Container(
                              clipBehavior: Clip.antiAlias,
                              decoration: BoxDecoration(
                                border: _appleMapWidgetController.mapTypeIndex == index
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
                            ),),
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