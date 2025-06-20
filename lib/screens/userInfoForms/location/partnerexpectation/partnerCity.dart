import 'package:_96kuliapp/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:_96kuliapp/commons/dialogues/AllFields/LocationFields/ShowAllCities.dart';
import 'package:_96kuliapp/commons/textdecoration.dart';
import 'package:_96kuliapp/controllers/locationcontroller/LocationController.dart';
import 'package:_96kuliapp/models/forms/CityModel.dart';
import 'package:_96kuliapp/models/forms/cityfkmodel.dart';
import 'package:_96kuliapp/routes/routenames.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:_96kuliapp/utils/Apptheme.dart';
import 'package:_96kuliapp/utils/customsnackbar.dart';
import 'package:_96kuliapp/utils/customtextform.dart';
import 'package:shimmer/shimmer.dart';

class PartnerSelectCityScreen extends StatefulWidget {
  const PartnerSelectCityScreen({super.key});

  @override
  State<PartnerSelectCityScreen> createState() =>
      _PartnerSelectCityScreenState();
}

class _PartnerSelectCityScreenState extends State<PartnerSelectCityScreen> {
  final LocationController _locationController =
      Get.put(LocationController()); /* Get.find<LocationController>(); */
  final TextEditingController searchController =
      TextEditingController(); // Controller for search text
  final RxString searchText = ''.obs; // Observable for search text
  final GlobalKey<FormState> _formKeyCities = GlobalKey<FormState>();
  String? language = sharedPreferences?.getString("Language");

  @override
  void initState() {
    super.initState();
    _locationController.fetchMultiCity();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Form(
          key: _formKeyCities,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 18.0, right: 18, top: 18),
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
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                AppLocalizations.of(context)!
                                    .selectPartnerDistrict,
                                style: CustomTextStyle.bodytextLarge),
                            Text(
                              AppLocalizations.of(context)!
                                  .youCanSelectMultipleOptions,
                              style: CustomTextStyle.bodytext
                                  .copyWith(fontSize: 12),
                            ),
                          ],
                        )
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: CustomTextField(
                  autovalidateMode: AutovalidateMode.disabled,
                  validator: (value) {
                    if (_locationController.selectedCities.length < 4) {
                      return language == "en"
                          ? "please select at least 4 district"
                          : 'कमीत कमी ४ पर्याय निवडा';
                      // AppLocalizations.of(context)!
                      //     .pleaseSelectAtLeast4Districts;
                    }
                    return null;
                  },
                  suffixIcon: Icon(Icons.search, color: Colors.grey.shade300),
                  HintText: AppLocalizations.of(context)!.searchDistricts,
                  onChange: (value) {
                    searchText.value = value!;
                    return null;
                  },
                ),
              ),
              Obx(
                () {
                  if (_locationController.selectedCities.isEmpty) {
                    return Padding(
                      padding:
                          const EdgeInsets.only(bottom: 8, left: 18, right: 18),
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(5)),
                            border: Border.all(
                                color: AppTheme.dividerDarkColor, width: 1)),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                AppLocalizations.of(context)!.selectvisible,
                                // "Selected items will be visible here.",
                                style: CustomTextStyle.hintText,
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  } else {
                    return Padding(
                      padding:
                          const EdgeInsets.only(bottom: 8, left: 18, right: 18),
                      child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(5)),
                              border: Border.all(
                                  color: AppTheme.dividerDarkColor, width: 1)),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Wrap(
                                    direction: Axis.horizontal,

                                    spacing:
                                        10, // Spacing between chips horizontally
                                    runSpacing:
                                        10, // Spacing between rows vertically
                                    children: [
                                      ...List.generate(
                                        _locationController
                                                    .selectedCities.length >
                                                4
                                            ? 4
                                            : _locationController
                                                .selectedCities.length,
                                        (index) {
                                          final item = _locationController
                                              .selectedCities[index];
                                          return Chip(
                                            deleteIcon: const Padding(
                                              padding: EdgeInsets.all(0),
                                              child:
                                                  Icon(Icons.close, size: 12),
                                            ),
                                            padding: const EdgeInsets.all(2),
                                            labelPadding:
                                                const EdgeInsets.all(4),
                                            backgroundColor:
                                                AppTheme.lightPrimaryColor,
                                            side: const BorderSide(
                                              style: BorderStyle.none,
                                              color: Colors.blue,
                                            ),
                                            label: Text(
                                              item.name ?? "",
                                              style: CustomTextStyle.bodytext
                                                  .copyWith(fontSize: 11),
                                            ),
                                            onDeleted: () {
                                              _locationController
                                                  .toggleCitySelection(item);
                                            },
                                          );
                                        },
                                      ),
                                      // Add button as a Chip
                                      Obx(
                                        () {
                                          if (_locationController
                                                  .selectedCities.length <=
                                              4) {
                                            return const SizedBox();
                                          } else {
                                            return GestureDetector(
                                              onTap: () {
                                                // Navigate to view all countries
                                                showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    _locationController
                                                        .selectedCitiesTemp
                                                        .clear();

                                                    _locationController
                                                        .selectedCitiesTemp
                                                        .value
                                                        .addAll(_locationController
                                                            .selectedCities
                                                            .where((newItem) => !_locationController
                                                                .selectedCitiesTemp
                                                                .any((existingItem) =>
                                                                    existingItem
                                                                        .id ==
                                                                    newItem
                                                                        .id)));
                                                    return ShowAllCitiesDialogue(
                                                      items: _locationController
                                                          .selectedCitiesTemp,
                                                    );
                                                  },
                                                );
                                              },
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 2, top: 12.0),
                                                child: Text(
                                                  "${language == "en" ? "View" : "बघा"} (+${_locationController.selectedCities.length - 4})",
                                                  style: CustomTextStyle
                                                      .bodytext
                                                      .copyWith(
                                                    color: AppTheme
                                                        .selectedOptionColor,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            );
                                          }
                                        },
                                      )
                                    ],
                                  ),
                                ]),
                          )),
                    );
                  }
                },
              ),
              Obx(() {
                // Filter multistates based on search text
                var filteredMultiCities =
                    _locationController.multiCities.where((multicity) {
                  // Check if any city name within the value list contains the search text
                  return multicity.value?.any((city) =>
                          city.serchkey
                              ?.toLowerCase()
                              .contains(searchText.value.toLowerCase()) ??
                          false) ??
                      false;
                }).toList();

                if (_locationController.cityLoading.value == true) {
                  return Expanded(
                    child: Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: ListView.builder(
                        itemCount: 5,
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
                    child: filteredMultiCities.isEmpty
                        ? const Center(child: Text('No districts found'))
                        : ListView.builder(
                            itemCount: filteredMultiCities.length,
                            itemBuilder: (context, index) {
                              final multiCity = filteredMultiCities[index];

                              // Filter and sort the cities within the multiCity
                              List<MultiCityFKModel> filteredCities =
                                  multiCity.value!.where((city) {
                                return city.serchkey?.toLowerCase().contains(
                                        searchText.value.toLowerCase()) ??
                                    false;
                              }).toList();

                              // Sort the filtered cities to prioritize matches
                              filteredCities.sort((a, b) {
                                bool aMatches = a.name?.toLowerCase().contains(
                                        searchText.value.toLowerCase()) ??
                                    false;
                                bool bMatches = b.name?.toLowerCase().contains(
                                        searchText.value.toLowerCase()) ??
                                    false;
                                return aMatches ? -1 : (bMatches ? 1 : 0);
                              });

                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Display the name of the multiCity
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8.0, horizontal: 16.0),
                                    child: Text(
                                      multiCity.name ?? "",
                                      style: CustomTextStyle.title,
                                    ),
                                  ),
                                  // Display the corresponding filtered and sorted city values
                                  ...filteredCities.map((city) {
                                    return Obx(() {
                                      bool isSelected = _locationController
                                          .selectedCities
                                          .any((element) =>
                                              element.id == city.id);
                                      return ListTile(
                                        trailing: Checkbox(
                                          value: isSelected,
                                          onChanged: (bool? value) {
                                            if (value != null) {
                                              _locationController
                                                  .toggleCitySelection(city);
                                            }
                                          },
                                          activeColor: AppTheme
                                              .selectedOptionColor, // Customize the checkbox color if needed
                                        ),
                                        title: Text(
                                          city.name ?? "",
                                          style:
                                              CustomTextStyle.bodytext.copyWith(
                                            color: AppTheme.textColor,
                                          ),
                                        ),
                                        tileColor: Colors.white,
                                        onTap: () {
                                          _locationController
                                              .toggleCitySelection(city);
                                        },
                                      );
                                    });
                                  }),
                                  const Divider(), // Optional: Add a divider between different multiCities
                                ],
                              );
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
          if (_locationController.selectedCities.length < 4) {
            //   Get.snackbar("Error", "Please Select State");
            if (_formKeyCities.currentState!.validate()) {
              Navigator.pop(context);
            }
          } else {
            Get.back();
          }
        },
        child: Text(AppLocalizations.of(context)!.next,
            style: CustomTextStyle.elevatedButton),
      ),
    );
  }
}
