import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:_96kuliapp/commons/textdecoration.dart';
import 'package:_96kuliapp/controllers/locationcontroller/LocationController.dart';
import 'package:_96kuliapp/models/forms/CityModel.dart';
import 'package:_96kuliapp/routes/routenames.dart';
import 'package:_96kuliapp/utils/Apptheme.dart';
import 'package:_96kuliapp/utils/checkIcon.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:_96kuliapp/utils/customtextform.dart';
import 'package:shimmer/shimmer.dart';

class PermanentSelectCityScreen extends StatefulWidget {
  const PermanentSelectCityScreen({super.key, required this.stateId});
  final String stateId;
  @override
  State<PermanentSelectCityScreen> createState() =>
      _PermanentSelectCityScreenState();
}

class _PermanentSelectCityScreenState extends State<PermanentSelectCityScreen> {
  // late String stateID;
  final LocationController _locationController =
      Get.put(LocationController()); /* Get.find<LocationController>(); */
  final TextEditingController searchController =
      TextEditingController(); // Controller for search text
  final RxString searchText = ''.obs; // Observable for search text
  final GlobalKey<FormState> _formKeyCity = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    //  stateID = Get.arguments as String; // Ensure it matches the type you pass
    _locationController.fetchCity(widget.stateId); // Use the correct type
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Form(
          key: _formKeyCity,
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
                        Text(
                          AppLocalizations.of(context)!.selectDistricts,
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
                  validator: (p0) {
                    if (_locationController.permanentSelectedCity.value.id ==
                        null) {
                      return AppLocalizations.of(context)!
                          .pleaseSelectPermanentCity;
                    }
                    return null;
                  },
                  autovalidateMode: AutovalidateMode.disabled,
                  suffixIcon: Icon(
                    Icons.search,
                    color: Colors.grey.shade300,
                  ),
                  HintText: AppLocalizations.of(context)!.searchDistricts,
                  onChange: (value) {
                    searchText.value = value!;
                    return null;
                  },
                ),
              ),
              Obx(
                () {
                  if (_locationController.permanentSelectedCity.value.id ==
                      null) {
                    return const SizedBox();
                  } else {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 18.0, vertical: 10),
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          border:
                              Border.all(color: Colors.grey.shade300, width: 1),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(5)),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Chip(
                                deleteIcon: const Padding(
                                  padding: EdgeInsets.all(0),
                                  child: Icon(Icons.close, size: 12),
                                ),
                                padding: const EdgeInsets.all(2),
                                labelPadding: const EdgeInsets.all(4),
                                backgroundColor: AppTheme.lightPrimaryColor,
                                side: const BorderSide(
                                  style: BorderStyle.none,
                                  color: Colors.blue,
                                ),
                                label: Text(
                                  "${_locationController.permanentSelectedCity.value.name}",
                                  style: CustomTextStyle.bodytext
                                      .copyWith(fontSize: 11),
                                ),
                                onDeleted: () {
                                  print("PRessed on delete");
                                  _locationController.permanentSelectedCity
                                      .value = CityModel(id: null, name: "");
                                },
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  }
                },
              ),
              Obx(() {
                // Filter cities based on search text
                var filteredCities = _locationController.cities.where((city) {
                  return city.serchkey!
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
                        ? const Center(child: Text('No district found'))
                        : ListView.builder(
                            itemCount: filteredCities.length,
                            itemBuilder: (context, index) {
                              final city = filteredCities[index];
                              // _locationController
                              //                           .permanentSelectedCity.value.id ==
                              //                     city.id
                              return Obx(() {
                                // Change the tile color if the city is selected
                                return ListTile(
                                  trailing: Checkbox(
                                    value: _locationController
                                            .permanentSelectedCity.value.id ==
                                        city.id,
                                    onChanged: (bool? value) {
                                      if (value != null) {
                                        _locationController
                                            .permanentSelectedCity.value = city;
                                        _locationController.permanentCityID
                                            .value = city.id ?? 0;
                                      }
                                    },
                                    activeColor: AppTheme
                                        .selectedOptionColor, // Customize the checkbox color if needed
                                  ),
                                  tileColor: Colors.white,
                                  title: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        city.name ?? "",
                                        style: CustomTextStyle.bodytextbold
                                            .copyWith(
                                          color: AppTheme.textColor,
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Obx(
                                        () {
                                          if (_locationController
                                                  .permanentSelectedCity
                                                  .value
                                                  .id ==
                                              city.id) {
                                            return const IconCheck();
                                          } else {
                                            return const SizedBox();
                                          }
                                        },
                                      )
                                    ],
                                  ),
                                  onTap: () {
                                    // Update the selected city
                                    _locationController
                                        .permanentSelectedCity.value = city;
                                    _locationController.permanentCityID.value =
                                        city.id ?? 0;
                                  },
                                );
                              });
                            },
                          ),
                  );
                }
              }),
            ],
          ),
        ),
      ),
      floatingActionButton: ElevatedButton(
        onPressed: () {
          if (_locationController.permanentSelectedCity.value.id == null) {
            // Show error message if no city is selected
            if (_formKeyCity.currentState!.validate()) {}
          } else {
            // Proceed to the next screen and store the selected city ID
            Get.back();
            Get.back();
            Get.back();
          }
        },
        child: Text(
          AppLocalizations.of(context)!.next,
          style: CustomTextStyle.elevatedButton,
        ),
      ),
    );
  }
}
