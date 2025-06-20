import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:_96kuliapp/commons/textdecoration.dart';
import 'package:_96kuliapp/controllers/locationcontroller/LocationController.dart';
import 'package:_96kuliapp/main.dart';
import 'package:_96kuliapp/models/forms/CountryModel.dart';
import 'package:_96kuliapp/models/forms/StateModel.dart';
import 'package:_96kuliapp/models/forms/CityModel.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:_96kuliapp/routes/routenames.dart';
import 'package:_96kuliapp/screens/userInfoForms/location/presentAddress/PresentState.dart';
import 'package:_96kuliapp/utils/Apptheme.dart';
import 'package:_96kuliapp/utils/customtextform.dart';
import 'package:shimmer/shimmer.dart';

class PresentCountrySelectScreen extends StatefulWidget {
  const PresentCountrySelectScreen({super.key});

  @override
  State<PresentCountrySelectScreen> createState() =>
      _PresentCountrySelectScreenState();
}

class _PresentCountrySelectScreenState
    extends State<PresentCountrySelectScreen> {
  final LocationController _locationController = Get.put(LocationController());
  final TextEditingController searchController = TextEditingController();
  final RxString searchText = ''.obs;
  final RxString selectedCountryID = ''.obs;
  final GlobalKey<FormState> _formKeyCountry = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _locationController.fetchCountries();
    print(
        "This is contry ${_locationController.presentselectedCountry.value.id}");
    if (_locationController.presentselectedCountry.value.id != null) {
      final selectedCountry = _locationController.presentselectedCountry.value;
      _locationController.countries
          .removeWhere((state) => state.id == selectedCountry.id);
      _locationController.countries.insert(0, selectedCountry);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Form(
          key: _formKeyCountry,
          child: Column(
            children: [
              // App Bar
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: Row(
                  children: [
                    Text(AppLocalizations.of(context)!.selectCountry,
                        style: CustomTextStyle.bodytextLarge),
                  ],
                ),
              ),
              // Search Field
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: CustomTextField(
                  autovalidateMode: AutovalidateMode.disabled,
                  validator: (value) {
                    if (_locationController.presentselectedCountry.value.id ==
                        null) {
                      return AppLocalizations.of(context)!
                          .pleaseSelectPresentCountry;
                    }
                    return null;
                  },
                  suffixIcon: Icon(Icons.search, color: Colors.grey.shade300),
                  HintText: AppLocalizations.of(context)!.searchCountry,
                  onChange: (value) {
                    searchText.value = value!;
                    return null;
                  },
                ),
              ),
              Obx(
                () {
                  if (_locationController.presentselectedCountry.value.id ==
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
                                  "${_locationController.presentselectedCountry.value.name}",
                                  style: CustomTextStyle.bodytext
                                      .copyWith(fontSize: 11),
                                ),
                                onDeleted: () {
                                  print("PRessed on delete");
                                  _locationController.presentselectedCountry
                                      .value = CountryModel(id: null, name: "");
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
              // Country List
              Obx(() {
                // Filter countries based on search text
                var filteredCountries =
                    _locationController.countries.where((country) {
                  return country.serchkey
                          ?.toLowerCase()
                          .contains(searchText.value.toLowerCase()) ??
                      false;
                }).toList();

                // Show shimmer effect while loading
                if (_locationController.countriesLoading.value) {
                  return Expanded(
                    child: Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: ListView.builder(
                        itemCount: 5,
                        itemBuilder: (context, index) => ListTile(
                          title: Container(height: 20, color: Colors.white),
                        ),
                      ),
                    ),
                  );
                } else {
                  // Display filtered list
                  return Expanded(
                    child: filteredCountries.isEmpty
                        ? const Center(child: Text('No countries found'))
                        : ListView.builder(
                            itemCount: filteredCountries.length,
                            itemBuilder: (context, index) {
                              final country = filteredCountries[index];
                              return Obx(() {
                                return ListTile(
                                  trailing: Checkbox(
                                    value: _locationController
                                            .presentselectedCountry.value.id ==
                                        country.id,
                                    onChanged: (bool? value) {
                                      if (value != null) {
                                        _locationController
                                            .presentselectedCountry
                                            .value = country;
                                        selectedCountryID.value =
                                            country.id.toString();
                                        _locationController.presentselectedState
                                            .value = StateModel();
                                        _locationController.presentselectedCity
                                            .value = CityModel();
                                      }
                                    },
                                    activeColor: AppTheme
                                        .selectedOptionColor, // Customize the checkbox color if needed
                                  ),
                                  tileColor: Colors.white,
                                  title: Text(
                                    country.name ?? "",
                                    style:
                                        CustomTextStyle.bodytextbold.copyWith(
                                      color: AppTheme.textColor,
                                    ),
                                  ),
                                  onTap: () {
                                    _locationController
                                        .presentselectedCountry.value = country;
                                    selectedCountryID.value =
                                        country.id.toString();
                                    _locationController.presentselectedState
                                        .value = StateModel();
                                    _locationController.presentselectedCity
                                        .value = CityModel();
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
          if (_locationController.presentselectedCountry.value.id == null) {
            if (_formKeyCountry.currentState!.validate()) {
              Navigator.pop(context);
            }
          } else {
            String countryId = _locationController
                    .presentselectedCountry.value.id
                    ?.toString() ??
                '';
            print("Selected Country ID: $countryId");
            //    Get.toNamed(AppRouteNames.presentselectState, arguments: selectedCountryID);
            navigatorKey.currentState!.push(MaterialPageRoute(
              builder: (context) => PresentStateScreen(
                countryId: countryId,
              ),
            ));
          }
        },
        child: Text(AppLocalizations.of(context)!.next,
            style: CustomTextStyle.elevatedButton),
      ),
    );
  }
}
