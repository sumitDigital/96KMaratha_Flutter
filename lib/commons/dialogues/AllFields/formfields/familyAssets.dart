import 'package:_96kuliapp/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:_96kuliapp/commons/textdecoration.dart';
import 'package:_96kuliapp/controllers/editforms_controllers/editFamilyDetailsController.dart';
import 'package:_96kuliapp/controllers/formfields/educationController.dart';
import 'package:_96kuliapp/controllers/locationcontroller/LocationController.dart';
import 'package:_96kuliapp/utils/Apptheme.dart';

class ShowAllFamilyAssets extends StatelessWidget {
  final List<dynamic> items;
  const ShowAllFamilyAssets({
    super.key,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    final EditFamilyFetailsController educationController =
        Get.find<EditFamilyFetailsController>();
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
                      "Selected family assets",
                      style: CustomTextStyle.bodytextbold.copyWith(
                        color: AppTheme.textColor,
                      ),
                    ),
                  ),
                  Flexible(
                    child: TextButton(
                      onPressed: () {
                        educationController.selectedFamilyAssetsList.clear();
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
                                educationController
                                    .toggleSelectionFamilyAssets(item);
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
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text(
                      "OK",
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
