import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:_96kuliapp/commons/textdecoration.dart';
import 'package:_96kuliapp/controllers/locationcontroller/LocationController.dart';
import 'package:_96kuliapp/utils/Apptheme.dart';
import 'package:_96kuliapp/utils/customtextform.dart';
import 'package:shimmer/shimmer.dart';

class SelectSateScreen extends StatefulWidget {
  const SelectSateScreen({super.key});

  @override
  State<SelectSateScreen> createState() => _SelectSateScreenState();
}

class _SelectSateScreenState extends State<SelectSateScreen> {
  final String countryId = Get.arguments();
  final LocationController _locationController = Get.find<LocationController>();
  final TextEditingController searchController =
      TextEditingController(); // Controller for search text
  final RxString searchText = ''.obs; // Observable for search text
  final RxString selectedStateId =
      ''.obs; // Observable to track the selected state

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _locationController.fetchState(countryId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
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
                    const SizedBox(
                      width: 10,
                    ),
                    const Text(
                      "Select State",
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
              HintText: "Search State",
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
            // Filter states based on search text
            var filteredStates = _locationController.states.where((state) {
              return state.name!
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
                              tileColor:
                                  _locationController.selectedState.value ==
                                          state.name.toString()
                                      ? AppTheme.selectedOptionColor
                                      : Colors.white,
                              title: Text(
                                state.name ?? "",
                                style: CustomTextStyle.bodytextbold.copyWith(
                                    color: _locationController
                                                .selectedState.value ==
                                            state.name.toString()
                                        ? Colors.white
                                        : AppTheme.textColor),
                              ),
                              onTap: () {
                                selectedStateId.value = state.id.toString();
                                _locationController.selectedState.value =
                                    state.name.toString();
                                _locationController.stateID.value =
                                    state.id ?? 0;
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
            if (_locationController.selectedState.value == "") {
              Get.snackbar("Error", "Please Select State");
            } else {
              //  Get.toNamed(AppRouteNames.selectCity , arguments: selectedStateId);
            }
          },
          child: const Text(
            "Next",
            style: CustomTextStyle.elevatedButton,
          )),
    );
  }
}
