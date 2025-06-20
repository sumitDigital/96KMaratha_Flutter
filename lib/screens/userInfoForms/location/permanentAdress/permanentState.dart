import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:_96kuliapp/commons/textdecoration.dart';
import 'package:_96kuliapp/controllers/locationcontroller/LocationController.dart';
import 'package:_96kuliapp/main.dart';
import 'package:_96kuliapp/models/forms/CityModel.dart';
import 'package:_96kuliapp/models/forms/StateModel.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:_96kuliapp/routes/routenames.dart';
import 'package:_96kuliapp/screens/userInfoForms/location/permanentAdress/permanentCity.dart';
import 'package:_96kuliapp/utils/Apptheme.dart';
import 'package:_96kuliapp/utils/checkIcon.dart';
import 'package:_96kuliapp/utils/customtextform.dart';
import 'package:shimmer/shimmer.dart';

class PermanentStateScreen extends StatefulWidget {
  const PermanentStateScreen({super.key, required this.countryId});
  final String countryId;
  @override
  State<PermanentStateScreen> createState() => _PermanentStateScreenState();
}

class _PermanentStateScreenState extends State<PermanentStateScreen> {
//  final String countryId = Get.arguments(); // Get the passed country ID
  final LocationController _locationController =
      Get.put(LocationController()); /* Get.find<LocationController>(); */
  final TextEditingController searchController =
      TextEditingController(); // Controller for search text
  final RxString searchText = ''.obs; // Observable for search text
  final RxString selectedStateId =
      ''.obs; // Observable to track the selected state
  final GlobalKey<FormState> _formKeyState = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _locationController
        .fetchState(widget.countryId); // Fetch states based on country ID

    // Reorder the list to show the selected state at the top when the screen is reopened
    WidgetsBinding.instance.addPostFrameCallback((_) {
      var selectedState = _locationController.permanentSelectedState.value;
      if (selectedState.id != null) {
        _locationController.states
            .removeWhere((state) => state.id == selectedState.id);
        _locationController.states.insert(0, selectedState);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Form(
          key: _formKeyState,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: Row(
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
                    Text(
                      AppLocalizations.of(context)!.selectState,
                      style: CustomTextStyle.bodytextLarge,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: CustomTextField(
                  autovalidateMode: AutovalidateMode.disabled,
                  validator: (p0) {
                    if (_locationController.permanentSelectedState.value.id ==
                        null) {
                      return AppLocalizations.of(context)!
                          .pleaseSelectPermanentState;
                    }
                    return null;
                  },
                  suffixIcon: Icon(
                    Icons.search,
                    color: Colors.grey.shade300,
                  ),
                  HintText: AppLocalizations.of(context)!.searchState,
                  onChange: (value) {
                    searchText.value = value!; // Update search text
                    return null;
                  },
                ),
              ),
              Obx(
                () {
                  if (_locationController.permanentSelectedState.value.id ==
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
                                  "${_locationController.permanentSelectedState.value.name}",
                                  style: CustomTextStyle.bodytext
                                      .copyWith(fontSize: 11),
                                ),
                                onDeleted: () {
                                  print("PRessed on delete");
                                  _locationController.permanentSelectedState
                                      .value = StateModel(id: null, name: "");
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
                var filteredStates = _locationController.states.where((state) {
                  return state.serchkey!
                      .toLowerCase()
                      .contains(searchText.value.toLowerCase());
                }).toList();

                if (_locationController.stateLoading.value) {
                  // Show shimmer while loading
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
                    child: filteredStates.isEmpty
                        ? const Center(child: Text('No states found'))
                        : ListView.builder(
                            itemCount: filteredStates.length,
                            itemBuilder: (context, index) {
                              final state = filteredStates[index];
                              return Obx(() {
                                // _locationController.permanentSelectedState.value.id == state.id
                                return ListTile(
                                  trailing: Checkbox(
                                    value: _locationController
                                            .permanentSelectedState.value.id ==
                                        state.id,
                                    onChanged: (bool? value) {
                                      if (value != null) {
                                        selectedStateId.value =
                                            state.id.toString();
                                        _locationController
                                            .permanentSelectedState
                                            .value = state;
                                        _locationController.permanentStateID
                                            .value = state.id ?? 0;
                                        _locationController
                                            .permanentSelectedCity
                                            .value = CityModel();
                                      }
                                    },
                                    activeColor: AppTheme
                                        .selectedOptionColor, // Customize the checkbox color if needed
                                  ),
                                  tileColor: Colors.white,
                                  title: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        state.name ?? "",
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
                                                  .permanentSelectedState
                                                  .value
                                                  .id ==
                                              state.id) {
                                            return const IconCheck();
                                          } else {
                                            return const SizedBox();
                                          }
                                        },
                                      )
                                    ],
                                  ),
                                  onTap: () {
                                    WidgetsBinding.instance
                                        .addPostFrameCallback((_) {
                                      selectedStateId.value =
                                          state.id.toString();
                                      _locationController
                                          .permanentSelectedState.value = state;
                                      _locationController.permanentStateID
                                          .value = state.id ?? 0;
                                      _locationController.permanentSelectedCity
                                          .value = CityModel(); // Reset city
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
      floatingActionButton: ElevatedButton(
        onPressed: () {
          if (_locationController.permanentSelectedState.value.id == null) {
            // Show error if no state is selected
            if (_formKeyState.currentState!.validate()) {}
          } else {
            // Navigate to the city selection screen
            navigatorKey.currentState!.push(MaterialPageRoute(
              builder: (context) => PermanentSelectCityScreen(
                stateId: selectedStateId.value,
              ),
            ));
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
