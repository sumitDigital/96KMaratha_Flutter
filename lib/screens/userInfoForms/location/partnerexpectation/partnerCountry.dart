import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:_96kuliapp/commons/dialogues/AllFields/LocationFields/ShowAllCountries.dart';
import 'package:_96kuliapp/commons/textdecoration.dart';
import 'package:_96kuliapp/controllers/locationcontroller/LocationController.dart';
import 'package:_96kuliapp/main.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:_96kuliapp/models/forms/CountryModel.dart';
import 'package:_96kuliapp/routes/routenames.dart';
import 'package:_96kuliapp/screens/userInfoForms/location/partnerexpectation/partnerState.dart';
import 'package:_96kuliapp/utils/Apptheme.dart';
import 'package:_96kuliapp/utils/customtextform.dart';
import 'package:shimmer/shimmer.dart';

class PartnerCountrySelectScreen extends StatefulWidget {
  const PartnerCountrySelectScreen({super.key});

  @override
  State<PartnerCountrySelectScreen> createState() =>
      _PartnerCountrySelectScreenState();
}

class _PartnerCountrySelectScreenState
    extends State<PartnerCountrySelectScreen> {
  final LocationController _locationController =
      Get.put(LocationController()); /* Get.find<LocationController>(); */
  final TextEditingController searchController = TextEditingController();
  final RxString searchText = ''.obs;
  String? language = sharedPreferences?.getString("Language");

  @override
  void initState() {
    super.initState();
    _locationController.fetchCountries();
    // Set default selection for country with id 101
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final defaultCountry = _locationController.countries.firstWhere(
        (country) => country.id == 101,
        orElse: () => CountryModel(),
      );
      if (defaultCountry.id != null &&
          !_locationController.selectedCountries
              .any((element) => element.id == defaultCountry.id)) {
        _locationController.toggleCountrySelection(defaultCountry);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
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
                      const SizedBox(width: 10),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              AppLocalizations.of(context)!
                                  .selectPartnerCountry,
                              style: CustomTextStyle.bodytextLarge),
                          Text(
                            AppLocalizations.of(context)!
                                .youCanSelectMultipleOptions,
                            style:
                                CustomTextStyle.bodytext.copyWith(fontSize: 12),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: CustomTextField(
                autovalidateMode: AutovalidateMode.disabled,
                suffixIcon: Icon(Icons.search, color: Colors.grey.shade300),
                HintText: AppLocalizations.of(context)!.searchCountry,
                onChange: (value) {
                  searchText.value = value ?? '';
                  return null;
                },
              ),
            ),
            Obx(
              () {
                if (_locationController.selectedCountries.isEmpty) {
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
                                                  .selectedCountries.length >
                                              4
                                          ? 4
                                          : _locationController
                                              .selectedCountries.length,
                                      (index) {
                                        final item = _locationController
                                            .selectedCountries[index];
                                        return Chip(
                                          deleteIcon: const Padding(
                                            padding: EdgeInsets.all(0),
                                            child: Icon(Icons.close, size: 12),
                                          ),
                                          padding: const EdgeInsets.all(2),
                                          labelPadding: const EdgeInsets.all(4),
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
                                                .toggleCountrySelection(item);
                                          },
                                        );
                                      },
                                    ),
                                    // Add button as a Chip
                                    Obx(
                                      () {
                                        if (_locationController
                                                .selectedCountries.length <=
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
                                                      .selectedCountriesTemp
                                                      .clear();

                                                  _locationController
                                                      .selectedCountriesTemp
                                                      .value
                                                      .addAll(_locationController
                                                          .selectedCountries
                                                          .where((newItem) =>
                                                              !_locationController
                                                                  .selectedCountriesTemp
                                                                  .any((existingItem) =>
                                                                      existingItem
                                                                          .id ==
                                                                      newItem
                                                                          .id)));
                                                  return ShowAllCountriesDialogue(
                                                    items: _locationController
                                                        .selectedCountriesTemp,
                                                  );
                                                },
                                              );
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 2, top: 12.0),
                                              child: Text(
                                                "${language == "en" ? "View All!!" : 'सर्व प्रोफाईल्स बघा'} (+${_locationController.selectedCountries.length - 4})",
                                                style: CustomTextStyle.bodytext
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
              var filteredCountries =
                  _locationController.countries.where((country) {
                return country.serchkey!
                    .toLowerCase()
                    .contains(searchText.value.toLowerCase());
              }).toList();

              // Move the country with id 101 to the top
              filteredCountries.sort((a, b) {
                if (a.id == 101) return -1;
                if (b.id == 101) return 1;
                return 0;
              });

              if (_locationController.countriesLoading.value) {
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
                  child: filteredCountries.isEmpty
                      ? const Center(child: Text('No countries found'))
                      : ListView.builder(
                          itemCount: filteredCountries.length,
                          itemBuilder: (context, index) {
                            final country = filteredCountries[index];
                            return Obx(() {
                              bool isSelected = _locationController
                                  .selectedCountries
                                  .any((element) => element.id == country.id);
                              return ListTile(
                                trailing: Checkbox(
                                  value: isSelected,
                                  onChanged: (bool? value) {
                                    if (value != null) {
                                      _locationController
                                          .toggleCountrySelection(country);
                                    }
                                  },
                                  activeColor: AppTheme
                                      .selectedOptionColor, // Customize the checkbox color if needed
                                ),
                                tileColor: Colors.white,
                                title: Text(
                                  country.name ?? "",
                                  style: CustomTextStyle.bodytextbold.copyWith(
                                    color: AppTheme.textColor,
                                  ),
                                ),
                                onTap: () {
                                  _locationController
                                      .toggleCountrySelection(country);
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
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          ElevatedButton(
            onPressed: () {
              if (_locationController.selectedCountries.isEmpty) {
                //  Get.snackbar("Error", "Please Select Country");
              } else {
                _locationController.countryids.value = _locationController
                    .selectedCountries
                    .map((element) => element.id)
                    .toList();
                if (_locationController.countryids.isNotEmpty) {
                  //  Get.offNamed(AppRouteNames.partnerSelectState);
                  navigatorKey.currentState!.pushReplacement(MaterialPageRoute(
                    builder: (context) => const PartnerStateScreen(),
                  ));
                } else {
                  //  Get.snackbar("Error", "State IDs could not be updated");
                }
              }
            },
            child: Text(AppLocalizations.of(context)!.next,
                style: CustomTextStyle.elevatedButton),
          )
        ],
      ),
    );
  }
}
