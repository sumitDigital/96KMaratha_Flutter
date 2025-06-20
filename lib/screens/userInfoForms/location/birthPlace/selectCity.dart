import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:_96kuliapp/commons/textdecoration.dart';
import 'package:_96kuliapp/controllers/locationcontroller/LocationController.dart';
import 'package:_96kuliapp/utils/Apptheme.dart';
import 'package:_96kuliapp/utils/customtextform.dart';
import 'package:shimmer/shimmer.dart';

class SelectCityScreen extends StatefulWidget {
  const SelectCityScreen({super.key});

  @override
  State<SelectCityScreen> createState() => _SelectCityScreenState();
}

class _SelectCityScreenState extends State<SelectCityScreen> {
  final String stateID = Get.arguments();
  final LocationController _locationController = Get.find<LocationController>();
  final TextEditingController searchController =
      TextEditingController(); // Controller for search text
  final RxString searchText = ''.obs; // Observable for search text
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _locationController.fetchCity(stateID);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Get.back();
                      },
                      child: SizedBox(
                        width: 25,
                        height: 20,
                        child: SvgPicture.asset(
                          "assets/arrowback.svg",
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    const Text(
                      "Select City",
                      style: CustomTextStyle.bodytextLarge,
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: CustomTextField(
              suffixIcon: Icon(
                Icons.search,
                color: Colors.grey.shade300,
              ),
              HintText: "Search City",
              onChange: (value) {
                searchText.value = value!;
                return null;
              },
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Obx(() {
            // Filter cities based on search text
            var filteredCities = _locationController.cities.where((city) {
              return city.name!
                  .toLowerCase()
                  .contains(searchText.value.toLowerCase());
            }).toList();

            if (_locationController.cityLoading.value == true) {
              return Expanded(
                child: Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: ListView.builder(
                    itemCount: 5, // Show 5 shimmer items
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Container(
                          height: 20,
                          color: Colors.white,
                        ),
                      );
                    },
                  ),
                ),
              );
            } else {
              return Expanded(
                child: filteredCities.isEmpty
                    ? const Center(child: Text('No cities found'))
                    : ListView.builder(
                        itemCount: filteredCities.length,
                        itemBuilder: (context, index) {
                          final city = filteredCities[index];

                          return Obx(() {
                            // Change the tile color if the city is selected
                            return ListTile(
                              tileColor:
                                  _locationController.selectedCity.value ==
                                          city.name.toString()
                                      ? AppTheme.selectedOptionColor
                                      : Colors.white,
                              title: Text(
                                city.name ?? "",
                                style: CustomTextStyle.bodytextbold.copyWith(
                                    color: _locationController
                                                .selectedCity.value ==
                                            city.name.toString()
                                        ? Colors.white
                                        : AppTheme.textColor),
                              ),
                              onTap: () {
                                // Update the selected city
                                _locationController.selectedCity.value =
                                    city.name.toString();
                                _locationController.cityID.value = city.id ?? 0;
                              },
                            );
                          });
                        },
                      ),
              );
            }
          }),
        ],
      )),
      floatingActionButton: ElevatedButton(
          onPressed: () {
            if (_locationController.selectedCity.value == "") {
              Get.snackbar("Error", "Please Select State");
            } else {
              Get.back();
              Get.back();
              Get.back();
            }
          },
          child: const Text(
            "Next",
            style: CustomTextStyle.elevatedButton,
          )),
    );
  }
}
