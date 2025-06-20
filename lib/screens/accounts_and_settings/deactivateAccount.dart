import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:_96kuliapp/commons/textdecoration.dart';
import 'package:_96kuliapp/controllers/accounts_and_settings_controller/deleteAccountController.dart';
import 'package:_96kuliapp/utils/Apptheme.dart';
import 'package:_96kuliapp/utils/backHeader.dart';

class DeactivateAccount extends StatelessWidget {
  const DeactivateAccount({super.key});

  @override
  Widget build(BuildContext context) {
    final DeleteAccountController deleteaccountController =
        Get.put(DeleteAccountController());
    return Scaffold(
      body: SafeArea(
        child: Obx(() {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BackHeader(onTap: () {}, title: "Deactivate Account"),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 16.0),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: const Text(
                            "Select Deactivate Account Reason",
                            style: CustomTextStyle.bodytextLarge,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      DropdownButtonFormField<int>(
                        dropdownColor: Colors.white,
                        value: deleteaccountController
                                    .selecteddeleteIndex.value >=
                                0
                            ? deleteaccountController.selecteddeleteIndex.value
                            : null,
                        hint: Text('Select a reason',
                            style: CustomTextStyle.hintText),
                        items:
                            deleteaccountController.ListReasonheadings.asMap()
                                .entries
                                .map((entry) {
                          return DropdownMenuItem<int>(
                            value: entry.key,
                            child: Text(entry.value,
                                style: CustomTextStyle.bodytext),
                          );
                        }).toList(),
                        onChanged: (int? newIndex) {
                          if (newIndex != null) {
                            deleteaccountController.selecteddeleteIndex.value =
                                newIndex;
                            // Optional: Clear selected reason when dropdown changes
                            deleteaccountController.selectedReasonId.value = -1;
                          }
                        },
                        decoration: InputDecoration(
                          errorMaxLines: 5,
                          errorStyle: CustomTextStyle.errorText,
                          labelStyle: CustomTextStyle.bodytext,
                          contentPadding: const EdgeInsets.all(20),
                          hintStyle: CustomTextStyle.hintText,
                          filled: true,
                          fillColor: Colors.white,
                          focusedBorder: OutlineInputBorder(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(5)),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(5)),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 18.0),
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount:
                                deleteaccountController.selectedReasons.length,
                            itemBuilder: (context, index) {
                              final reason = deleteaccountController
                                  .selectedReasons[index];

                              // Wrap ListTile in Obx to make it reactive
                              return Obx(() {
                                final isSelected = deleteaccountController
                                        .selectedReasonId.value ==
                                    reason.id;

                                return ListTile(
                                  selected: isSelected,
                                  selectedTileColor:
                                      AppTheme.selectedOptionColor,
                                  leading: CircleAvatar(
                                    backgroundColor: AppTheme.lightPrimaryColor,
                                    child: Text(
                                      "${index + 1}",
                                      style: CustomTextStyle.fieldName,
                                    ),
                                  ),
                                  title: Text(
                                    reason.name ?? "",
                                    style: isSelected
                                        ? CustomTextStyle.title
                                            .copyWith(color: Colors.white)
                                        : CustomTextStyle.title,
                                  ),
                                  onTap: () {
                                    deleteaccountController
                                        .selectReason(reason.id!);
                                  },
                                );
                              });
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      Center(
                        child: Obx(() {
                          return Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 18.0),
                            child: SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: deleteaccountController
                                        .isdeactivateLoading.value
                                    ? null // Disable button when loading
                                    : () {
                                        // Call the deactivateAccount method
                                        deleteaccountController
                                            .deactivateAccount(
                                          reasonid: deleteaccountController
                                              .selectedReasonId.value,
                                        );
                                      },
                                child: deleteaccountController
                                        .isdeactivateLoading.value
                                    ? const CircularProgressIndicator(
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(Colors
                                                .white), // Customize color
                                      )
                                    : const Text("Deactivate Account",
                                        style: CustomTextStyle.elevatedButton),
                              ),
                            ),
                          );
                        }),
                      ),
                      const SizedBox(height: 50),
                    ],
                  ),
                ),
              )
            ],
          );
        }),
      ),
    );
  }
}
