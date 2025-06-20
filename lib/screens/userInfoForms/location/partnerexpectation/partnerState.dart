import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:_96kuliapp/commons/dialogues/AllFields/LocationFields/showAllStates.dart';
import 'package:_96kuliapp/commons/textdecoration.dart';
import 'package:_96kuliapp/controllers/locationcontroller/LocationController.dart';
import 'package:_96kuliapp/main.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:_96kuliapp/models/forms/StateModel.dart';
import 'package:_96kuliapp/models/forms/statefkmodel.dart';
import 'package:_96kuliapp/routes/routenames.dart';
import 'package:_96kuliapp/screens/userInfoForms/location/partnerexpectation/partnerCity.dart';
import 'package:_96kuliapp/utils/Apptheme.dart';
import 'package:_96kuliapp/utils/customtextform.dart';
import 'package:shimmer/shimmer.dart';

class PartnerStateScreen extends StatefulWidget {
  const PartnerStateScreen({super.key});

  @override
  State<PartnerStateScreen> createState() => _PartnerScreenState();
}

class _PartnerScreenState extends State<PartnerStateScreen> {
  final LocationController _locationController =
      Get.put(LocationController()); /* Get.find<LocationController>(); */
  final TextEditingController searchController = TextEditingController();
  final RxString searchText = ''.obs;
  final RxString selectedStateId = ''.obs;
  String? language = sharedPreferences?.getString("Language");

  @override
  void initState() {
    super.initState();
    _locationController.fetchMultiState();
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
                          Text(AppLocalizations.of(context)!.selectPartnerState,
                              style: CustomTextStyle.bodytextLarge),
                          Text(
                            AppLocalizations.of(context)!
                                .youCanSelectMultipleOptions,
                            style:
                                CustomTextStyle.bodytext.copyWith(fontSize: 12),
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
                suffixIcon: Icon(Icons.search, color: Colors.grey.shade300),
                HintText: AppLocalizations.of(context)!.searchState,
                onChange: (value) {
                  searchText.value = value!;
                  return null;
                },
              ),
            ),
            Obx(
              () {
                if (_locationController.selectedStates.isEmpty) {
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
                                                  .selectedStates.length >
                                              4
                                          ? 4
                                          : _locationController
                                              .selectedStates.length,
                                      (index) {
                                        final item = _locationController
                                            .selectedStates[index];
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
                                                .toggleStateSelection(item);
                                          },
                                        );
                                      },
                                    ),
                                    // Add button as a Chip
                                    Obx(
                                      () {
                                        if (_locationController
                                                .selectedStates.length <=
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
                                                      .selectedStatesTemp
                                                      .clear();

                                                  _locationController
                                                      .selectedStatesTemp.value
                                                      .addAll(_locationController
                                                          .selectedStates
                                                          .where((newItem) =>
                                                              !_locationController
                                                                  .selectedStatesTemp
                                                                  .any((existingItem) =>
                                                                      existingItem
                                                                          .id ==
                                                                      newItem
                                                                          .id)));
                                                  return ShowAllStatesDialogue(
                                                    items: _locationController
                                                        .selectedStatesTemp,
                                                  );
                                                },
                                              );
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 2, top: 12.0),
                                              child: Text(
                                                "${language == "en" ? "View" : "बघा"} (+${_locationController.selectedStates.length - 4})",
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
              // Filter multistates based on search text
              var filteredMultiStates =
                  _locationController.multistates.where((multiState) {
                // Check if any state name within the value list contains the search text
                return multiState.value?.any((state) =>
                        state.serchkey
                            ?.toLowerCase()
                            .contains(searchText.value.toLowerCase()) ??
                        false) ??
                    false;
              }).toList();

              if (_locationController.stateLoading.value == true) {
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
                  child: filteredMultiStates.isEmpty
                      ? const Center(child: Text('No states found'))
                      : ListView.builder(
                          itemCount: filteredMultiStates.length,
                          itemBuilder: (context, index) {
                            final multiState = filteredMultiStates[index];

                            // Filter and sort the states within the multiState
                            // Filter and sort the states within the multiState
                            List<StatefkModel> filteredStates = [];
                            if (multiState.value != null &&
                                multiState.value is List<StatefkModel>) {
                              filteredStates =
                                  (multiState.value as List<StatefkModel>)
                                      .where((state) {
                                return state.serchkey?.toLowerCase().contains(
                                        searchText.value.toLowerCase()) ??
                                    false;
                              }).toList();
                            } else {
                              // Handle cases where the value is not a valid list of StatefkModel
                              print(
                                  "multiState.value is not a valid List<StatefkModel>");
                            }

                            // Sort the filtered states to prioritize matches
                            filteredStates.sort((a, b) {
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
                                // Display the name of the multiState
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 8.0, horizontal: 16.0),
                                  child: Text(
                                    multiState.name ?? "",
                                    style: CustomTextStyle.title,
                                  ),
                                ),
                                // Display the corresponding filtered and sorted state values
                                ...filteredStates.map((state) {
                                  return Obx(() {
                                    bool isSelected = _locationController
                                        .selectedStates
                                        .any((element) =>
                                            element.id == state.id);
                                    return ListTile(
                                      trailing: Checkbox(
                                        value: isSelected,
                                        onChanged: (bool? value) {
                                          if (value != null) {
                                            _locationController
                                                .toggleStateSelection(state);
                                          }
                                        },
                                        activeColor: AppTheme
                                            .selectedOptionColor, // Customize the checkbox color if needed
                                      ),
                                      title: Text(
                                        state.name ?? "",
                                        style:
                                            CustomTextStyle.bodytext.copyWith(
                                          color: AppTheme.textColor,
                                        ),
                                      ),
                                      tileColor: Colors.white,
                                      onTap: () {
                                        _locationController
                                            .toggleStateSelection(state);
                                      },
                                    );
                                  });
                                }),
                                const Divider(), // Optional: Add a divider between different multiStates
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
      floatingActionButton: ElevatedButton(
        onPressed: () {
          if (_locationController.selectedStates.isEmpty) {
            //   Get.snackbar("Error", "Please Select State");
          } else {
            _locationController.stateids.value = _locationController
                .selectedStates
                .map((element) => element.id)
                .toList();

            if (_locationController.stateids.isNotEmpty) {
              navigatorKey.currentState!.pushReplacement(MaterialPageRoute(
                builder: (context) => const PartnerSelectCityScreen(),
              ));
            } else {
              //  Get.snackbar("Error", "State IDs could not be updated");
            }
          }
        },
        child: Text(AppLocalizations.of(context)!.next,
            style: CustomTextStyle.elevatedButton),
      ),
    );
  }
}




/// 
/// 
/// 
/// 
/// 
//
