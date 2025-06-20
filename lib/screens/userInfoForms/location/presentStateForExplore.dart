import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:_96kuliapp/commons/textdecoration.dart';
import 'package:_96kuliapp/controllers/locationcontroller/LocationController.dart';
import 'package:_96kuliapp/main.dart';
import 'package:_96kuliapp/models/forms/CityModel.dart';
import 'package:_96kuliapp/models/forms/StateModel.dart';
import 'package:_96kuliapp/utils/Apptheme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:_96kuliapp/utils/customtextform.dart';
import 'package:shimmer/shimmer.dart';

class PresentStateScreenForExplore extends StatefulWidget {
  const PresentStateScreenForExplore({super.key, required this.StateId});
  final String StateId;
  @override
  State<PresentStateScreenForExplore> createState() =>
      _PresentStateScreenForExploreState();
}

class _PresentStateScreenForExploreState
    extends State<PresentStateScreenForExplore> {
//  final String countryId = Get.arguments(); // Country ID from the previous screen
  final LocationController _locationController = Get.find<LocationController>();
  final TextEditingController searchController =
      TextEditingController(); // Controller for search text
  final RxString searchText = ''.obs; // Observable for search text
  final RxString selectedCityId =
      ''.obs; // Observable to track the selected state

  String? language = sharedPreferences?.getString("Language");
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    // _locationController.fetchState(widget.countryId);
    _locationController.fetchCity(widget.StateId);
    if (_locationController.presentselectedCity.value.id != null) {
      final selectedCity = _locationController.presentselectedCity.value;
      _locationController.cities
          .removeWhere((city) => city.id == selectedCity.id);
      _locationController.cities.insert(0, selectedCity);
    }
    // Ensure the selected state is set at the top when the screen is opened
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                        const SizedBox(width: 10),
                        Text(AppLocalizations.of(context)!.selectDistricts,
                            // "Select State",
                            style: CustomTextStyle.bodytextLarge),
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
                  HintText: language == "en"
                      ? "Search Your Districts"
                      : "तुमचा जिल्हा निवडा",
                  onChange: (value) {
                    searchText.value = value!;
                    return null;
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return AppLocalizations.of(context)!
                          .pleaseSelectyourDistrict;
                    }
                    return null;
                  },
                ),
              ),
              Obx(
                () {
                  if (_locationController.presentselectedCity.value.id ==
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
                                  "${_locationController.presentselectedCity.value.name}",
                                  style: CustomTextStyle.bodytext
                                      .copyWith(fontSize: 11),
                                ),
                                onDeleted: () {
                                  print("PRessed on delete");
                                  _locationController.presentselectedCity
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
                // Filter states based on search text
                var filteredCity = _locationController.cities.where((city) {
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
                    child: filteredCity.isEmpty
                        ? const Center(child: Text('No states found'))
                        : ListView.builder(
                            itemCount: filteredCity.length,
                            itemBuilder: (context, index) {
                              final city = filteredCity[index];

                              return Obx(() {
                                return ListTile(
                                  trailing: Checkbox(
                                    value: _locationController
                                            .presentselectedCity.value.id ==
                                        city.id,
                                    onChanged: (bool? value) {
                                      if (value != null) {
                                        selectedCityId.value =
                                            city.id.toString();
                                        _locationController
                                            .presentselectedCity.value = city;
                                        // _locationController.presentselectedCity
                                        //     .value = CityModel();
                                      }
                                    },
                                    activeColor: AppTheme
                                        .selectedOptionColor, // Customize the checkbox color if needed
                                  ),
                                  tileColor: Colors.white,
                                  title: Text(
                                    city.name ?? "",
                                    style:
                                        CustomTextStyle.bodytextbold.copyWith(
                                      color: AppTheme.textColor,
                                    ),
                                  ),
                                  onTap: () {
                                    // Update the selected state but don't immediately move it to the top
                                    // selectedCityId.value = city.id.toString();
                                    _locationController.cityID.value =
                                        city.id ?? 0;
                                    _locationController
                                        .presentselectedCity.value = city;
                                    // _locationController
                                    //     .presentselectedCity.value = CityModel();
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
          if (_formKey.currentState!.validate()) {}
          if (_locationController.presentselectedCity.value.id == null) {
            print(
                "Error,${AppLocalizations.of(context)!.pleaseSelectyourDistrict}");
            // Get.snackbar("Error",
            //     AppLocalizations.of(context)!.pleaseSelectyourDistrict);
          } else {
            Get.back();
            //  Get.toNamed(AppRouteNames.presentselectCity, arguments: selectedStateId);
            //navigatorKey.currentState!.push(MaterialPageRoute(builder: (context) => PresentSelectCityScreen(stateId: selectedStateId.value ,),));
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
