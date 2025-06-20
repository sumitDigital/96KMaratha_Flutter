import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:_96kuliapp/commons/textdecoration.dart';
import 'package:_96kuliapp/controllers/locationcontroller/LocationController.dart';
import 'package:_96kuliapp/main.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:_96kuliapp/models/forms/CityModel.dart';
import 'package:_96kuliapp/models/forms/CountryModel.dart';
import 'package:_96kuliapp/models/forms/StateModel.dart';
import 'package:_96kuliapp/routes/routenames.dart';
import 'package:_96kuliapp/screens/userInfoForms/location/permanentAdress/permanentState.dart';
import 'package:_96kuliapp/utils/Apptheme.dart';
import 'package:_96kuliapp/utils/customtextform.dart';
import 'package:shimmer/shimmer.dart';

class PermanentCountrySelectScreen extends StatefulWidget {
  const PermanentCountrySelectScreen({super.key});

  @override
  State<PermanentCountrySelectScreen> createState() =>
      _PermanentCountrySelectScreenState();
}

class _PermanentCountrySelectScreenState
    extends State<PermanentCountrySelectScreen> {
  final LocationController _locationController = Get.put(LocationController());
  final TextEditingController searchController = TextEditingController();
  final RxString searchText = ''.obs;
  final RxString selectedCountryID = ''.obs;
  final GlobalKey<FormState> _formKeyCountry = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _locationController.fetchCountries();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Form(
          key: _formKeyCountry,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () => Get.back(),
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
                        Text(
                          AppLocalizations.of(context)!.selectCountry,
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
                  autovalidateMode: AutovalidateMode.disabled,
                  validator: (p0) {
                    if (_locationController.permanentSelectedCountry.value.id ==
                        null) {
                      return AppLocalizations.of(context)!
                          .pleaseSelectPermanentCountry;
                    }
                    return null;
                  },
                  suffixIcon: Icon(
                    Icons.search,
                    color: Colors.grey.shade300,
                  ),
                  HintText: AppLocalizations.of(context)!.searchCountry,
                  onChange: (value) {
                    searchText.value = value!;
                    return null;
                  },
                ),
              ),
              Obx(
                () {
                  if (_locationController.permanentSelectedCountry.value.id ==
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
                                  "${_locationController.permanentSelectedCountry.value.name}",
                                  style: CustomTextStyle.bodytext
                                      .copyWith(fontSize: 11),
                                ),
                                onDeleted: () {
                                  print("PRessed on delete");
                                  _locationController.permanentSelectedCountry
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
              Obx(() {
                var filteredCountries = _locationController.countries
                    .where(
                      (country) => country.serchkey!
                          .toLowerCase()
                          .contains(searchText.value.toLowerCase()),
                    )
                    .toList();

                // Ensure the selected country appears at the top of the list
                /*   var selectedCountry = _locationController.permanentSelectedCountry.value;
                if (selectedCountry.id != null && searchText.value.isEmpty) {
                  filteredCountries.removeWhere((country) => country.id == selectedCountry.id);
                  filteredCountries.insert(0, selectedCountry);
                }*/

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
                                return ListTile(
                                  trailing: Checkbox(
                                    value: _locationController
                                            .permanentSelectedCountry
                                            .value
                                            .id ==
                                        country.id,
                                    onChanged: (bool? value) {
                                      if (value != null) {
                                        selectedCountryID.value =
                                            country.id.toString();
                                        _locationController
                                            .permanentSelectedCountry
                                            .value = country;
                                        _locationController
                                            .permanentSelectedState
                                            .value = StateModel();
                                        _locationController
                                            .permanentSelectedCity
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
                                    WidgetsBinding.instance
                                        .addPostFrameCallback((_) {
                                      selectedCountryID.value =
                                          country.id.toString();
                                      _locationController
                                          .permanentSelectedCountry
                                          .value = country;
                                      _locationController.permanentSelectedState
                                          .value = StateModel();
                                      _locationController.permanentSelectedCity
                                          .value = CityModel();
                                    });
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
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          ElevatedButton(
            onPressed: () {
              if (_locationController.permanentSelectedCountry.value.id ==
                  null) {
                // Get.snackbar("Error", "Please Select Country");
                if (_formKeyCountry.currentState!.validate()) {}
              } else {
                navigatorKey.currentState!.push(MaterialPageRoute(
                  builder: (context) => PermanentStateScreen(
                    countryId: selectedCountryID.value,
                  ),
                ));
              }
            },
            child: Text(
              AppLocalizations.of(context)!.next,
              style: CustomTextStyle.elevatedButton,
            ),
          )
        ],
      ),
    );
  }
}
