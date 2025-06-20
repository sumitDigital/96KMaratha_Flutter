import 'package:_96kuliapp/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:_96kuliapp/commons/textdecoration.dart';
import 'package:_96kuliapp/controllers/formfields/educationController.dart';
import 'package:_96kuliapp/controllers/formfields/occupationController.dart';
import 'package:_96kuliapp/controllers/locationcontroller/LocationController.dart';
import 'package:_96kuliapp/utils/Apptheme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ShowAllExpectedOccupation extends StatelessWidget {
  final List<dynamic> items;
  const ShowAllExpectedOccupation({
    super.key,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    final OccupationController occupationController =
        Get.find<OccupationController>();
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
                      language == "en"
                          ? "Selected Occupations"
                          : "निवडलेले व्यवसाय",
                      style: CustomTextStyle.bodytextbold.copyWith(
                        color: AppTheme.textColor,
                      ),
                    ),
                  ),
                  Flexible(
                    child: TextButton(
                      onPressed: () {
                        occupationController.selectedOccupationsTemp.clear();
                        // Get.back();
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
                                occupationController
                                    .toggleOccupationSelectionTemp(item);
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
                    onPressed: () {
                      Get.back();
                    },
                    child: Text(
                      AppLocalizations.of(context)!.cancel,
                      style: CustomTextStyle.textbuttonRed,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextButton(
                    onPressed: () {
                      print(
                          "THIS IS TEMP LIST ${occupationController.selectedOccupationsTemp.length}");
                      occupationController.selectedOccupations.clear();
                      occupationController.selectedOccupations.value.addAll(
                          occupationController.selectedOccupationsTemp.where(
                              (newItem) => !occupationController
                                  .selectedOccupations
                                  .any((existingItem) =>
                                      existingItem.id == newItem.id)));
                      Get.back();
                    },
                    child: Text(
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
