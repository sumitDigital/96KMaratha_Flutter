import 'package:_96kuliapp/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:_96kuliapp/commons/textdecoration.dart';
import 'package:_96kuliapp/controllers/accounts_and_settings_controller/deleteAccountController.dart';
import 'package:_96kuliapp/utils/Apptheme.dart';
import 'package:_96kuliapp/utils/backHeader.dart';
import 'package:_96kuliapp/utils/customtextform.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DeleteAccount extends StatefulWidget {
  const DeleteAccount({super.key});

  @override
  State<DeleteAccount> createState() => _DeleteAccountState();
}

class _DeleteAccountState extends State<DeleteAccount> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final DeleteAccountController _deleteAccountController =
      Get.put(DeleteAccountController());

  String? language = sharedPreferences?.getString("Language");

  @override
  Widget build(BuildContext context) {
    List reasons = [
      "I found a match using this app.",
      "I found a match through family or relatives.",
      "Connected with a match on another platform.",
      "Postponed my marriage plans.",
      "Taking a break from searching for a partner.",
      "I am not satisfied with the profiles available.",
      "Dissatisfied with the app's features.",
      "Experiencing technical issues with the app.",
      "Not enough relevant matches are available.",
      "Privacy concerns.",
      "Too many irrelevant matches.",
      "Overwhelmed by notifications or irrelevant emails/messages.",
      "Other reasons.",
    ];

    List reasonsMar = [
      "ऍपद्वारे लग्न जुळले आहे.",
      "परिवार किंवा नातेवाइकांमार्फत लग्न जुळले आहे.",
      "दुसऱ्या प्लॅटफॉर्मद्वारे लग्न जुळले आहे.",
      "लग्नाचा बेत पुढे ढकलला आहे.",
      "जोडीदार शोधणे काही काळासाठी थांबवत आहे. ",
      "उपलब्ध प्रोफाईल्सवर मी संतुष्ट नाही.",
      "ऍपच्या फीचर्सवर मी संतुष्ट नाही.",
      "ऍप हाताळताना तांत्रिक अडचणी येत आहेत. ",
      "सुयोग्य स्थळे उपलब्ध नाहीत. ",
      "गोपनीय कारण.",
      "खूप अनावश्यक स्थळे दिसतात.",
      "अनावश्यक नोटिफिकेशन्स/ ईमेल/ मेसेजेसचा अतिरेक झाल्याने त्रस्त.",
      "इतर कारण.",
    ];

    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BackHeader(
                  onTap: () {
                    Get.back();
                  },
                  title: AppLocalizations.of(context)!.deleteAccount),
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 16.0),
                          decoration: BoxDecoration(
                            border: Border.all(
                                width: 0,
                                color: Colors.grey), // Set the border color
                            borderRadius: BorderRadius.circular(
                                8.0), // Set the border radius
                          ),
                          child: Text(
                            language == "en"
                                ? "Select Delete Account Reason"
                                : "अकाउंट डिलीट करण्याचे कारण निवडा",
                            style: CustomTextStyle.bodytextLarge,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20.0),
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: language == "en"
                              ? reasons.length
                              : reasonsMar.length,
                          itemBuilder: (context, index) {
                            final field = language == "en"
                                ? reasons[index]
                                : reasonsMar[index];

                            return Obx(() => RadioListTile<int>(
                                  contentPadding: const EdgeInsets.all(0),
                                  value: index +
                                      16, // Set this to the value you want, can be dynamic based on `index`
                                  groupValue: _deleteAccountController
                                      .selectedIndex
                                      .value, // This should bind with the controller's selected index
                                  onChanged: (int? value) {
                                    print("THIS IS INDEX $value");
                                    if (value != null) {
                                      // Update the selected index in your controller
                                      _deleteAccountController
                                          .selectedIndex.value = value;
                                    }
                                  },
                                  title: Text(
                                    field, // Field name to display
                                    style: CustomTextStyle.bodytext.copyWith(
                                      color: AppTheme.textColor,
                                    ),
                                  ),
                                  selected: _deleteAccountController
                                          .selectedIndex.value ==
                                      index + 16,
                                  activeColor: AppTheme
                                      .secondryColor, // Set the active color
                                  tileColor: _deleteAccountController
                                              .selectedIndex.value ==
                                          index + 16
                                      ? AppTheme.selectedOptionColor
                                      : null, // Use the same color for selected state
                                ));
                          },
                        ),
                      ),
                      Obx(
                        () {
                          if (_deleteAccountController.selectedIndex.value ==
                              28) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                RichText(
                                    text: TextSpan(children: <TextSpan>[
                                  TextSpan(
                                      text: language == "en"
                                          ? "Reason for Deleting Account"
                                          : "अकाउंट डिलीट करण्याचे कारण",
                                      style: CustomTextStyle.fieldName),
                                  const TextSpan(
                                      text: "*",
                                      style: TextStyle(color: Colors.red))
                                ])),
                                CustomTextField(
                                    textEditingController:
                                        _deleteAccountController
                                            .descriptionController,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return language == "en"
                                            ? 'Please provide a reason for deleting your account.'
                                            : "कृपया आपले अकाउंट डिलीट करण्याचे कारण सांगा.";
                                      }
                                      return null;
                                    },
                                    HintText: language == "en"
                                        ? "Please specify the reason"
                                        : "कृपया कारण नमूद करा"),
                              ],
                            );
                          } else {
                            return const SizedBox();
                          }
                        },
                      ),
                      Obx(
                        () {
                          if (_deleteAccountController.isSubmitted.value ==
                                  true &&
                              _deleteAccountController.selectedIndex.value ==
                                  -1) {
                            return Padding(
                              padding: const EdgeInsets.only(left: 18.0),
                              child: Text(
                                language == "en"
                                    ? "Please select delete account reason"
                                    : "कृपया तुमचे अकाउंट डिलीट करण्याचे कारण नमूद करा. ",
                                style: CustomTextStyle.errorText,
                              ),
                            );
                          } else {
                            return const SizedBox();
                          }
                        },
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Center(
                        child: Obx(() {
                          return Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 18.0),
                            child: SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: _deleteAccountController
                                        .isdeleteLoading.value
                                    ? null // Disable button when loading
                                    : () {
                                        _deleteAccountController
                                            .isSubmitted.value = true;
                                        if (_deleteAccountController
                                                .selectedIndex.value ==
                                            28) {
                                          if (_formKey.currentState!
                                              .validate()) {}
                                        } else {
                                          if (_deleteAccountController
                                                  .selectedIndex.value ==
                                              -1) {
                                            //  Get.snackbar("Error", "Select Reason to delete account");
                                          } else {
                                            // Call the deleteAccount method
                                            _deleteAccountController
                                                .deleteAccount(
                                              reasonDesc:
                                                  _deleteAccountController
                                                      .descriptionController
                                                      .text
                                                      .trim(),
                                              reasonid: _deleteAccountController
                                                  .selectedIndex.value,
                                            );
                                          }
                                        }
                                      },
                                child: _deleteAccountController
                                        .isdeleteLoading.value
                                    ? const CircularProgressIndicator(
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(Colors
                                                .white), // Customize color
                                      )
                                    : Text(
                                        language == "en"
                                            ? "Delete Account"
                                            : "अकाउंट डिलीट करा",
                                        style: CustomTextStyle.elevatedButton),
                              ),
                            ),
                          );
                        }),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class DeleteAccountDialogue extends StatelessWidget {
  const DeleteAccountDialogue({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    String? language = sharedPreferences?.getString("Language");
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize:
              MainAxisSize.min, // Ensure dialog adjusts to its content
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Image.asset(
                  height: 120, width: 120, "assets/deleteAccount.png"),
            ),
            const SizedBox(
              height: 10,
            ),
            Center(
              child: Text(
                language == "en"
                    ? "Account deleted successfully."
                    : "अकाउंट यशस्वीरित्या डिलीट झाले आहे",
                style: CustomTextStyle.bodytextbold.copyWith(fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 12),
            Center(
              child: Text(
                language == "en"
                    ? "Thank you for your time with us"
                    : "तुमचा टाइम दिल्याबद्दल धन्यवाद ",
                style: CustomTextStyle.bodytext,
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
