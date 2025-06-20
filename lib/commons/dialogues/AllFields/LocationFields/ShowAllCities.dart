import 'package:_96kuliapp/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:_96kuliapp/commons/textdecoration.dart';
import 'package:_96kuliapp/controllers/locationcontroller/LocationController.dart';
import 'package:_96kuliapp/utils/Apptheme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ShowAllCitiesDialogue extends StatelessWidget {
  final List<dynamic> items;
  const ShowAllCitiesDialogue({
    super.key,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    final LocationController locationController =
        Get.find<LocationController>();
    String? language = sharedPreferences?.getString("Language");

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.zero, // Remove default padding
      child: Container(
        width: MediaQuery.of(context).size.width, // Full width
        margin: const EdgeInsets.all(
            16), // Add some margin to avoid touching screen edges
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      // "Selected Districts",
                      AppLocalizations.of(context)!.selectedDistricts,
                      style: CustomTextStyle.bodytextbold.copyWith(
                        color: AppTheme.textColor,
                      ),
                    ),
                  ),
                  Flexible(
                    child: TextButton(
                      onPressed: () {
                        locationController.selectedCitiesTemp.clear();
                        Get.back();
                      },
                      child: Text(
                        language == "en" ? "Clear All" : "सर्व काढून टाका",
                        style: CustomTextStyle.textbuttonRed
                            .copyWith(fontSize: 13),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1, color: Colors.grey),
            Flexible(
              child: SizedBox(
                width: double.infinity,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Obx(() {
                      return Wrap(
                        direction: Axis.horizontal,
                        spacing: 10, // Spacing between chips horizontally
                        runSpacing: 10, // Spacing between rows vertically
                        children: List.generate(
                          items.length,
                          (index) {
                            final item = items[index];
                            return Chip(
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
                                item.name ?? "",
                                style: CustomTextStyle.bodytext
                                    .copyWith(fontSize: 11),
                              ),
                              onDeleted: () {
                                print("CANCLE delete");
                                locationController
                                    .toggleCitySelectionTemp(item);
                              },
                            );
                          },
                        ),
                      );
                    }),
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextButton(
                    onPressed: () {},
                    child: Text(
                      // "Cancel",
                      AppLocalizations.of(context)!.cancel,
                      style: CustomTextStyle.textbuttonRed,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextButton(
                    onPressed: () {
                      locationController.selectedCities.clear();
                      locationController.selectedCities.value.addAll(
                          locationController.selectedCitiesTemp.where(
                              (newItem) => !locationController.selectedCities
                                  .any((existingItem) =>
                                      existingItem.id == newItem.id)));
                      Get.back();
                    },
                    child: Text(
                      // "Save",
                      AppLocalizations.of(context)!.save,
                      style: CustomTextStyle.textbuttonRed,
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
