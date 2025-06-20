import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:_96kuliapp/commons/textdecoration.dart';
import 'package:_96kuliapp/controllers/locationcontroller/LocationController.dart';
import 'package:_96kuliapp/main.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:_96kuliapp/models/forms/CityModel.dart';
import 'package:_96kuliapp/models/forms/StateModel.dart';
import 'package:_96kuliapp/routes/routenames.dart';
import 'package:_96kuliapp/screens/userInfoForms/location/presentAddress/presentCity.dart';
import 'package:_96kuliapp/utils/Apptheme.dart';
import 'package:_96kuliapp/utils/customtextform.dart';
import 'package:shimmer/shimmer.dart';

class PresentStateScreen extends StatefulWidget {
  const PresentStateScreen({super.key, required this.countryId});
  final String countryId;
  @override
  State<PresentStateScreen> createState() => _PresentStateScreenState();
}

class _PresentStateScreenState extends State<PresentStateScreen> {
//  final String countryId = Get.arguments(); // Country ID from the previous screen
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
    _locationController.fetchState(widget.countryId);
    if (_locationController.presentselectedState.value.id != null) {
      final selectedState = _locationController.presentselectedState.value;
      _locationController.states
          .removeWhere((state) => state.id == selectedState.id);
      _locationController.states.insert(0, selectedState);
    }
    // Ensure the selected state is set at the top when the screen is opened
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
                        Text(AppLocalizations.of(context)!.selectStates,
                            style: CustomTextStyle.bodytextLarge),
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
                    if (_locationController.presentselectedState.value.id ==
                        null) {
                      return AppLocalizations.of(context)!
                          .pleaseSelectPresentState;
                    }
                    return null;
                  },
                  suffixIcon: Icon(
                    Icons.search,
                    color: Colors.grey.shade300,
                  ),
                  HintText: AppLocalizations.of(context)!.searchState,
                  onChange: (value) {
                    searchText.value = value!;
                    return null;
                  },
                ),
              ),
              Obx(
                () {
                  if (_locationController.presentselectedState.value.id ==
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
                                  "${_locationController.presentselectedState.value.name}",
                                  style: CustomTextStyle.bodytext
                                      .copyWith(fontSize: 11),
                                ),
                                onDeleted: () {
                                  print("PRessed on delete");
                                  _locationController.presentselectedState
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

                if (_locationController.stateLoading.value == true) {
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
                                return ListTile(
                                  trailing: Checkbox(
                                    value: _locationController
                                            .presentselectedState.value.id ==
                                        state.id,
                                    onChanged: (bool? value) {
                                      if (value != null) {
                                        selectedStateId.value =
                                            state.id.toString();
                                        _locationController
                                            .presentselectedState.value = state;
                                        _locationController.presentselectedCity
                                            .value = CityModel();
                                      }
                                    },
                                    activeColor: AppTheme
                                        .selectedOptionColor, // Customize the checkbox color if needed
                                  ),
                                  tileColor: Colors.white,
                                  title: Text(
                                    state.name ?? "",
                                    style:
                                        CustomTextStyle.bodytextbold.copyWith(
                                      color: AppTheme.textColor,
                                    ),
                                  ),
                                  onTap: () {
                                    // Update the selected state but don't immediately move it to the top
                                    selectedStateId.value = state.id.toString();
                                    _locationController
                                        .presentselectedState.value = state;
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
          if (_locationController.presentselectedState.value.id == null) {
            if (_formKeyState.currentState!.validate()) {}
          } else {
            //  Get.toNamed(AppRouteNames.presentselectCity, arguments: selectedStateId);
            navigatorKey.currentState!.push(MaterialPageRoute(
              builder: (context) => PresentSelectCityScreen(
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
