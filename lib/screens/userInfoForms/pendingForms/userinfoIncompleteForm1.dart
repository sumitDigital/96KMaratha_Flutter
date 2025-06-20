// ignore_for_file: deprecated_member_use, camel_case_types, non_constant_identifier_names

import 'package:_96kuliapp/commons/dialogues/AllFields/formfields/expectededucation.dart';
import 'package:_96kuliapp/commons/dialogues/AllFields/formfields/expextedOccupationList.dart';
import 'package:_96kuliapp/commons/textdecoration.dart';
import 'package:_96kuliapp/controllers/dashboardControllers/dashboardController.dart';
import 'package:_96kuliapp/controllers/editforms_controllers/editPartnerExpectationController.dart';
import 'package:_96kuliapp/controllers/formfields/castController.dart';
import 'package:_96kuliapp/controllers/formfields/educationController.dart';
import 'package:_96kuliapp/controllers/formfields/occupationController.dart';
import 'package:_96kuliapp/controllers/locationcontroller/LocationController.dart';
import 'package:_96kuliapp/controllers/userform/formstep3Controller.dart';
import 'package:_96kuliapp/main.dart';
import 'package:_96kuliapp/models/forms/castemultiselectmodel.dart';
import 'package:_96kuliapp/models/forms/fields/fieldModel.dart';
import 'package:_96kuliapp/screens/userInfoForms/location/partnerexpectation/partnerCity.dart';
import 'package:_96kuliapp/screens/userInfoForms/location/partnerexpectation/partnerCountry.dart';
import 'package:_96kuliapp/screens/userInfoForms/location/partnerexpectation/partnerState.dart';
import 'package:_96kuliapp/screens/userInfoForms/userInfoStepTwo.dart';
import 'package:_96kuliapp/utils/Apptheme.dart';
import 'package:_96kuliapp/utils/buttonContainer.dart';
import 'package:_96kuliapp/utils/customtextform.dart';
import 'package:_96kuliapp/utils/formHeader.dart';
import 'package:_96kuliapp/utils/formheaderbasic.dart';
import 'package:_96kuliapp/utils/formtitletag.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shimmer/shimmer.dart';

class userIncomplete_userFormOne extends StatefulWidget {
  const userIncomplete_userFormOne({super.key});

  @override
  State<userIncomplete_userFormOne> createState() =>
      _userIncomplete_userFormOneState();
}

class _userIncomplete_userFormOneState
    extends State<userIncomplete_userFormOne> {
  String? selectedHeight;

  // String? language = sharedPreferences?.getString("Language");

  // final StepThreeController _editPartnerExpeController =
  //     Get.put(StepThreeController());
  final EditPartnerExpectation _editPartnerExpeController =
      Get.put(EditPartnerExpectation());
  final OccupationController _occupationController =
      Get.put(OccupationController());
  final EducationController _educationController =
      Get.put(EducationController());
  final LocationController _locationController = Get.put(LocationController());
  final CastController _castController = Get.put(CastController());
  final ScrollController _scrollController = ScrollController();
  final DashboardController _dashboardController =
      Get.put(DashboardController());

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormFieldState> _minAgeKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _maxAgeKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _minHeightKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _maxHeightKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _partnerSectionKey =
      GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _subSectionKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _casteKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _manglikKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _maritialStatusKey =
      GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _employedInKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _highestDegreeKey =
      GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _occupationKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _MinIncomeKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _MaxIncomeKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _expectedResidenceKey =
      GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _dietryHabitKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _SmokingHabitKey =
      GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _DrinkingHabitKey =
      GlobalKey<FormFieldState>();

  String partnerlocationText = "";
  void _scrollToWidget(GlobalKey key) {
    final RenderObject? renderObject = key.currentContext?.findRenderObject();
    if (renderObject is RenderBox) {
      final offset =
          renderObject.localToGlobal(Offset.zero).dy + _scrollController.offset;

      // Subtract a few pixels (e.g., 40 pixels) to scroll above
      final targetOffset = offset - 80.0;

      _scrollController.animateTo(
        targetOffset,
        duration: const Duration(seconds: 1),
        curve: Curves.easeOutBack,
      );
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    // _dashboardController.fetchUserInfo();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return WillPopScope(
      onWillPop: () async {
        String? language = sharedPreferences?.getString("Language");
        bool? shouldExit = await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0), // Rounded corners
              ),
              title: Text(
                language == "en" ? 'Exit App' : "ॲपमधून बाहेर पडा",
                style: CustomTextStyle.bodytextLarge.copyWith(
                  color: Colors.black, // Title color
                  fontWeight: FontWeight.bold, // Bold title
                ),
              ),
              content: Text(
                language == "en"
                    ? 'Are you sure you want to exit the app?'
                    : "तुम्हाला ॲपमधून बाहेर पडायचे आहे का?",
                style: const TextStyle(
                  fontSize: 16, // Adjusted font size for content
                  color: Colors.black54, // Lighter color for content text
                ),
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(
                      bottom: 10.0), // Padding at the bottom of the buttons
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(true); // User wants to exit
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor:
                              AppTheme.primaryColor, // White text color
                          padding: const EdgeInsets.symmetric(
                              horizontal: 25, vertical: 12), // Button padding
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                8), // Rounded corners for the button
                          ),
                        ),
                        child: Text(AppLocalizations.of(context)!.yes,
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context)
                              .pop(false); // User doesn't want to exit
                          //Get.back();
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor:
                              AppTheme.secondryColor, // White text color
                          padding: const EdgeInsets.symmetric(
                              horizontal: 25, vertical: 12), // Button padding
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                8), // Rounded corners for the button
                          ),
                        ),
                        child: Text(AppLocalizations.of(context)!.no,
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        );
        return shouldExit ??
            false; // Return whether the user wants to exit or not
      },
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: height * 0.085,
          leadingWidth: double.maxFinite,
          leading: FormsTitleTag(
            // title: language == "en" ? 'Update Information' : "माहीती अपडेट करा",
            title: language == "en" ? 'Step 2' : 'दुसरी पायरी',
            pageName: '',
            arrowback: false,
            styleform: true,
          ),
        ),
        body: SingleChildScrollView(
          controller: _scrollController,
          child: SafeArea(
            child: /* Obx(
              () {
                String? language = sharedPreferences?.getString("Language");
                {
                  return */
                Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // सर्व * मार्क फील्ड्स भरणे आवश्यक आहे.
                // const SizedBox(
                //   height: 22,
                // ),
                Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Column(
                    children: [
                      language == "en"
                          ? Container(
                              decoration: BoxDecoration(
                                color: AppTheme.lightPrimaryColor,
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(5)),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Center(
                                      child: Text(
                                        'One step closer to your perfect match!',
                                        textAlign: TextAlign.center,
                                        style: CustomTextStyle.bodytext
                                            .copyWith(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Center(
                                      child: RichText(
                                          textAlign: TextAlign.center,
                                          text: TextSpan(children: <TextSpan>[
                                            TextSpan(
                                                text:
                                                    "Some profile details are incomplete. Completing them will help you find better and more relevant matches.",
                                                style: CustomTextStyle.bodytext
                                                    .copyWith(
                                                        fontSize: 13,
                                                        fontWeight:
                                                            FontWeight.w500)),
                                            const TextSpan(
                                                text: "",
                                                style: TextStyle(
                                                    color: Colors.red)),
                                          ])),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : Container(
                              decoration: BoxDecoration(
                                color: AppTheme.lightPrimaryColor,
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(5)),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Text(
                                      "योग्य जोडीदारासाठी एक पाऊल पुढे!",
                                      textAlign: TextAlign.center,
                                      style: CustomTextStyle.bodytext.copyWith(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Center(
                                      child: RichText(
                                          textAlign: TextAlign.center,
                                          text: TextSpan(children: <TextSpan>[
                                            TextSpan(
                                                text: "",
                                                style: CustomTextStyle.bodytext
                                                    .copyWith(fontSize: 12)),
                                            const TextSpan(
                                                text: "",
                                                style: TextStyle(
                                                    color: Colors.red)),
                                            TextSpan(
                                                text:
                                                    " तुमच्या प्रोफाईलची काही माहिती अजूनही अपूर्ण आहे. खाली दिलेली माहिती भरणे आवश्यक आहे. ती पूर्ण केल्यास, जुळणाऱ्या प्रोफाईल्सशी संवाद साधायला मदत होईल.",
                                                style: CustomTextStyle.bodytext
                                                    .copyWith(
                                                        fontSize: 13,
                                                        fontWeight:
                                                            FontWeight.w500)),
                                          ])),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                    ],
                  ),
                ),

                Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if ((_dashboardController.dashboardData["redirection"]
                                    ?["incompleteField"] as List?)
                                ?.any((item) =>
                                    item["missing_fields"] is List &&
                                    (item["missing_fields"] as List)
                                        .any((field) => field == "min_age")) ??
                            false) ...[
                          RichText(
                              key: _minAgeKey,
                              text: TextSpan(
                                children: <TextSpan>[
                                  TextSpan(
                                      text: AppLocalizations.of(context)!
                                          .partnerMinAge,
                                      style: CustomTextStyle.fieldName),
                                  const TextSpan(
                                      text: "*",
                                      style: TextStyle(color: Colors.red))
                                ],
                              )),
                          Obx(
                            () {
                              final TextEditingController minage =
                                  TextEditingController(
                                      text: _editPartnerExpeController
                                          .selectedMinAge.value.name);
                              return CustomTextField(
                                validator: (value) {
                                  if (language == "en") {
                                    if (value == null || value.isEmpty) {
                                      return "Select your partner's min age";
                                    }
                                  } else {
                                    if (value == null || value.isEmpty) {
                                      return "जोडीदाराचे कमीत कमी वय निवडा";
                                    }
                                  }

                                  return null;
                                },
                                readonly: true,
                                textEditingController: minage,
                                HintText: language == "en"
                                    ? "Select Min Age"
                                    : "जोडीदाराचे कमीत कमी वय निवडा",
                                ontap: () {
                                  _editPartnerExpeController
                                          .searchedMinAgeList.value =
                                      _editPartnerExpeController.ageRange;

                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return Dialog(
                                        backgroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(16.0),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 8.0, top: 8),
                                                child: TextField(
                                                  style:
                                                      CustomTextStyle.bodytext,
                                                  decoration: InputDecoration(
                                                    errorMaxLines: 5,
                                                    errorStyle: CustomTextStyle
                                                        .errorText,
                                                    labelStyle: CustomTextStyle
                                                        .bodytext,
                                                    hintText: language == "en"
                                                        ? "Search Min. Age"
                                                        : "कमीत कमी वय निवडा",
                                                    contentPadding:
                                                        const EdgeInsets.all(
                                                            20),
                                                    hintStyle: CustomTextStyle
                                                        .hintText,
                                                    filled: true,
                                                    fillColor: Colors.white,
                                                    errorBorder:
                                                        const OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: Colors.red),
                                                      gapPadding: 30,
                                                    ),
                                                    focusedBorder:
                                                        OutlineInputBorder(
                                                      borderRadius:
                                                          const BorderRadius
                                                              .all(
                                                              Radius.circular(
                                                                  5)),
                                                      borderSide: BorderSide(
                                                          color: Colors
                                                              .grey.shade300),
                                                    ),
                                                    enabledBorder:
                                                        OutlineInputBorder(
                                                      borderRadius:
                                                          const BorderRadius
                                                              .all(
                                                              Radius.circular(
                                                                  5)),
                                                      borderSide: BorderSide(
                                                          color: Colors
                                                              .grey.shade300),
                                                    ),
                                                    border: OutlineInputBorder(
                                                      borderRadius:
                                                          const BorderRadius
                                                              .all(
                                                              Radius.circular(
                                                                  5)),
                                                      borderSide: BorderSide(
                                                          color: Colors
                                                              .grey.shade300),
                                                    ),
                                                    suffixIcon: Icon(
                                                        Icons.search,
                                                        color: Colors
                                                            .grey.shade500),
                                                  ),
                                                  onChanged: (query) {
                                                    _editPartnerExpeController
                                                        .searchMinAge(
                                                            query); // Filter the list in the controller
                                                  },
                                                ),
                                              ),
                                              Container(
                                                decoration: const BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(5)),
                                                  color: Colors.white,
                                                ),
                                                height:
                                                    400, // Set a height for the list inside the dialog
                                                child: Obx(() {
                                                  return ListView.builder(
                                                    shrinkWrap: true,
                                                    itemCount:
                                                        _editPartnerExpeController
                                                            .searchedMinAgeList
                                                            .length,
                                                    itemBuilder:
                                                        (context, index) {
                                                      final item =
                                                          _editPartnerExpeController
                                                                  .searchedMinAgeList[
                                                              index];
                                                      bool isSelected =
                                                          _editPartnerExpeController
                                                                  .selectedMinAge
                                                                  .value
                                                                  .id ==
                                                              item.id;

                                                      return GestureDetector(
                                                        onTap: () {
                                                          // Update the selected value and close the dialog
                                                          _editPartnerExpeController
                                                              .updateMinAge(
                                                                  item);
                                                          // Update the controller text based on selection

                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: Container(
                                                          color: isSelected
                                                              ? AppTheme
                                                                  .selectedOptionColor
                                                              : Colors.white,
                                                          child: ListTile(
                                                            title: Text(
                                                              item.name ?? "",
                                                              style:
                                                                  CustomTextStyle
                                                                      .bodytext
                                                                      .copyWith(
                                                                color: isSelected
                                                                    ? Colors
                                                                        .white
                                                                    : AppTheme
                                                                        .textColor,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  );
                                                }),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                              );
                            },
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                        ],

                        if ((_dashboardController.dashboardData["redirection"]
                                    ?["incompleteField"] as List?)
                                ?.any((item) =>
                                    item["missing_fields"] is List &&
                                    (item["missing_fields"] as List)
                                        .any((field) => field == "max_age")) ??
                            false) ...[
                          RichText(
                              key: _maxAgeKey,
                              text: TextSpan(
                                children: <TextSpan>[
                                  TextSpan(
                                      text: AppLocalizations.of(context)!
                                          .partnerMaxAge,
                                      style: CustomTextStyle.fieldName),
                                  const TextSpan(
                                      text: "*",
                                      style: TextStyle(color: Colors.red))
                                ],
                              )),
                          Obx(
                            () {
                              final TextEditingController maxage =
                                  TextEditingController(
                                      text: _editPartnerExpeController
                                          .selectedMaxAge.value.name);
                              return CustomTextField(
                                validator: (value) {
                                  if (language == "en") {
                                    if (value == null || value.isEmpty) {
                                      return "Select your partner's max age";
                                    }
                                  } else {
                                    if (value == null || value.isEmpty) {
                                      return "जोडीदाराचे जास्तीत जास्त वय निवडा";
                                    }
                                  }

                                  return null;
                                },
                                readonly: true,
                                textEditingController: maxage,
                                HintText: language == "en"
                                    ? "Select Max Age"
                                    : "जोडीदाराचे जास्तीत जास्त वय निवडा",
                                ontap: () {
                                  _editPartnerExpeController
                                          .searchedMAxAgeList.value =
                                      _editPartnerExpeController
                                          .getFilteredMaxAgeList();

                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return Dialog(
                                        backgroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(16.0),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 8.0, top: 8),
                                                child: TextField(
                                                  style:
                                                      CustomTextStyle.bodytext,
                                                  decoration: InputDecoration(
                                                    errorMaxLines: 5,
                                                    errorStyle: CustomTextStyle
                                                        .errorText,
                                                    labelStyle: CustomTextStyle
                                                        .bodytext,
                                                    hintText: language == "en"
                                                        ? "Search Max Age"
                                                        : "जास्तीत जास्त वय निवडा",
                                                    contentPadding:
                                                        const EdgeInsets.all(
                                                            20),
                                                    hintStyle: CustomTextStyle
                                                        .hintText,
                                                    filled: true,
                                                    fillColor: Colors.white,
                                                    errorBorder:
                                                        const OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: Colors.red),
                                                      gapPadding: 30,
                                                    ),
                                                    focusedBorder:
                                                        OutlineInputBorder(
                                                      borderRadius:
                                                          const BorderRadius
                                                              .all(
                                                              Radius.circular(
                                                                  5)),
                                                      borderSide: BorderSide(
                                                          color: Colors
                                                              .grey.shade300),
                                                    ),
                                                    enabledBorder:
                                                        OutlineInputBorder(
                                                      borderRadius:
                                                          const BorderRadius
                                                              .all(
                                                              Radius.circular(
                                                                  5)),
                                                      borderSide: BorderSide(
                                                          color: Colors
                                                              .grey.shade300),
                                                    ),
                                                    border: OutlineInputBorder(
                                                      borderRadius:
                                                          const BorderRadius
                                                              .all(
                                                              Radius.circular(
                                                                  5)),
                                                      borderSide: BorderSide(
                                                          color: Colors
                                                              .grey.shade300),
                                                    ),
                                                    suffixIcon: Icon(
                                                        Icons.search,
                                                        color: Colors
                                                            .grey.shade500),
                                                  ),
                                                  onChanged: (query) {
                                                    _editPartnerExpeController
                                                        .searchMaxAge(
                                                            query); // Filter the list in the controller
                                                  },
                                                ),
                                              ),
                                              Container(
                                                decoration: const BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(5)),
                                                  color: Colors.white,
                                                ),
                                                height:
                                                    400, // Set a height for the list inside the dialog
                                                child: Obx(() {
                                                  return ListView.builder(
                                                    shrinkWrap: true,
                                                    itemCount:
                                                        _editPartnerExpeController
                                                            .searchedMAxAgeList
                                                            .length,
                                                    itemBuilder:
                                                        (context, index) {
                                                      final item =
                                                          _editPartnerExpeController
                                                                  .searchedMAxAgeList[
                                                              index];
                                                      bool isSelected =
                                                          _editPartnerExpeController
                                                                  .selectedMaxAge
                                                                  .value
                                                                  .id ==
                                                              item.id;

                                                      return GestureDetector(
                                                        onTap: () {
                                                          // Update the selected value and close the dialog
                                                          _editPartnerExpeController
                                                              .updateMaxAge(
                                                                  item);
                                                          // Update the controller text based on selection

                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: Container(
                                                          color: isSelected
                                                              ? AppTheme
                                                                  .selectedOptionColor
                                                              : Colors.white,
                                                          child: ListTile(
                                                            title: Text(
                                                              item.name ?? "",
                                                              style:
                                                                  CustomTextStyle
                                                                      .bodytext
                                                                      .copyWith(
                                                                color: isSelected
                                                                    ? Colors
                                                                        .white
                                                                    : AppTheme
                                                                        .textColor,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  );
                                                }),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                              );
                            },
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                        ],

                        if ((_dashboardController.dashboardData["redirection"]
                                    ?["incompleteField"] as List?)
                                ?.any((item) =>
                                    item["missing_fields"] is List &&
                                    (item["missing_fields"] as List).any(
                                        (field) => field == "min_height")) ??
                            false) ...[
                          RichText(
                              key: _minHeightKey,
                              text: TextSpan(
                                children: <TextSpan>[
                                  TextSpan(
                                      text: AppLocalizations.of(context)!
                                          .partnerMinHeight,
                                      style: CustomTextStyle.fieldName),
                                  const TextSpan(
                                      text: "*",
                                      style: TextStyle(color: Colors.red))
                                ],
                              )),
                          Obx(
                            () {
                              final TextEditingController maxage =
                                  TextEditingController(
                                      text: _editPartnerExpeController
                                          .selectedMinHeight.value.name);
                              return CustomTextField(
                                validator: (value) {
                                  if (language == "en") {
                                    if (value == null || value.isEmpty) {
                                      return "Select your partner's min height";
                                    }
                                  } else {
                                    if (value == null || value.isEmpty) {
                                      return "जोडीदाराची कमीत कमी उंची निवडा";
                                    }
                                  }

                                  return null;
                                },
                                readonly: true,
                                textEditingController: maxage,
                                HintText: language == "en"
                                    ? "Select Min Height"
                                    : "जोडीदाराची कमीत कमी उंची निवडा ",
                                ontap: () {
                                  _editPartnerExpeController
                                          .searchedMinHeightList.value =
                                      _editPartnerExpeController.heightRange;

                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return Dialog(
                                        backgroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(16.0),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 8.0, top: 8),
                                                child: TextField(
                                                  decoration: InputDecoration(
                                                    errorMaxLines: 5,
                                                    errorStyle: CustomTextStyle
                                                        .errorText,
                                                    labelStyle: CustomTextStyle
                                                        .bodytext,
                                                    hintText: language == "en"
                                                        ? "Search Min. Height"
                                                        : "कमीत कमी उंची निवडा",
                                                    contentPadding:
                                                        const EdgeInsets.all(
                                                            20),
                                                    hintStyle: CustomTextStyle
                                                        .hintText,
                                                    filled: true,
                                                    fillColor: Colors.white,
                                                    errorBorder:
                                                        const OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: Colors.red),
                                                      gapPadding: 30,
                                                    ),
                                                    focusedBorder:
                                                        OutlineInputBorder(
                                                      borderRadius:
                                                          const BorderRadius
                                                              .all(
                                                              Radius.circular(
                                                                  5)),
                                                      borderSide: BorderSide(
                                                          color: Colors
                                                              .grey.shade300),
                                                    ),
                                                    enabledBorder:
                                                        OutlineInputBorder(
                                                      borderRadius:
                                                          const BorderRadius
                                                              .all(
                                                              Radius.circular(
                                                                  5)),
                                                      borderSide: BorderSide(
                                                          color: Colors
                                                              .grey.shade300),
                                                    ),
                                                    border: OutlineInputBorder(
                                                      borderRadius:
                                                          const BorderRadius
                                                              .all(
                                                              Radius.circular(
                                                                  5)),
                                                      borderSide: BorderSide(
                                                          color: Colors
                                                              .grey.shade300),
                                                    ),
                                                    suffixIcon: Icon(
                                                        Icons.search,
                                                        color: Colors
                                                            .grey.shade500),
                                                  ),
                                                  onChanged: (query) {
                                                    _editPartnerExpeController
                                                        .searchMinHeight(
                                                            query); // Filter the list in the controller
                                                  },
                                                ),
                                              ),
                                              Container(
                                                decoration: const BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(5)),
                                                  color: Colors.white,
                                                ),
                                                height:
                                                    400, // Set a height for the list inside the dialog
                                                child: Obx(() {
                                                  return ListView.builder(
                                                    shrinkWrap: true,
                                                    itemCount:
                                                        _editPartnerExpeController
                                                            .searchedMinHeightList
                                                            .length,
                                                    itemBuilder:
                                                        (context, index) {
                                                      final item =
                                                          _editPartnerExpeController
                                                                  .searchedMinHeightList[
                                                              index];
                                                      bool isSelected =
                                                          _editPartnerExpeController
                                                                  .selectedMinHeight
                                                                  .value
                                                                  .id ==
                                                              item.id;

                                                      return GestureDetector(
                                                        onTap: () {
                                                          // Update the selected value and close the dialog
                                                          _editPartnerExpeController
                                                              .updateMinHeight(
                                                                  item);
                                                          // Update the controller text based on selection

                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: Container(
                                                          color: isSelected
                                                              ? AppTheme
                                                                  .selectedOptionColor
                                                              : Colors.white,
                                                          child: ListTile(
                                                            title: Text(
                                                              item.name ?? "",
                                                              style:
                                                                  CustomTextStyle
                                                                      .bodytext
                                                                      .copyWith(
                                                                color: isSelected
                                                                    ? Colors
                                                                        .white
                                                                    : AppTheme
                                                                        .textColor,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  );
                                                }),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                              );
                            },
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                        ],

                        if ((_dashboardController.dashboardData["redirection"]
                                    ?["incompleteField"] as List?)
                                ?.any((item) =>
                                    item["missing_fields"] is List &&
                                    (item["missing_fields"] as List).any(
                                        (field) => field == "max_height")) ??
                            false) ...[
                          RichText(
                              key: _maxHeightKey,
                              text: TextSpan(children: <TextSpan>[
                                TextSpan(
                                    text: AppLocalizations.of(context)!
                                        .partnerMaxHeight,
                                    style: CustomTextStyle.fieldName),
                                const TextSpan(
                                    text: "*",
                                    style: TextStyle(color: Colors.red))
                              ])),
                          Obx(
                            () {
                              final TextEditingController maxage =
                                  TextEditingController(
                                      text: _editPartnerExpeController
                                          .selectedMaxHeight.value.name);
                              return CustomTextField(
                                validator: (value) {
                                  if (language == "en") {
                                    if (value == null || value.isEmpty) {
                                      return "Select your partner's max height";
                                    }
                                  } else {
                                    if (value == null || value.isEmpty) {
                                      return "जोडीदाराची जास्तीत जास्त उंची निवडा ";
                                    }
                                  }
                                  return null;
                                },
                                readonly: true,
                                textEditingController: maxage,
                                HintText: language == "en"
                                    ? "Select Max Height"
                                    : "जोडीदाराची जास्तीत जास्त उंची निवडा ",
                                ontap: () {
                                  _editPartnerExpeController
                                          .searchedMAxHeightList.value =
                                      _editPartnerExpeController
                                          .getFilteredMaxHeightList();

                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return Dialog(
                                        backgroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(16.0),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 8.0, top: 8),
                                                child: TextField(
                                                  decoration: InputDecoration(
                                                    errorMaxLines: 5,
                                                    errorStyle: CustomTextStyle
                                                        .errorText,
                                                    labelStyle: CustomTextStyle
                                                        .bodytext,
                                                    hintText: language == "en"
                                                        ? "Search Max. Height"
                                                        : "जास्तीत जास्त उंची निवडा",
                                                    contentPadding:
                                                        const EdgeInsets.all(
                                                            20),
                                                    hintStyle: CustomTextStyle
                                                        .hintText,
                                                    filled: true,
                                                    fillColor: Colors.white,
                                                    errorBorder:
                                                        const OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: Colors.red),
                                                      gapPadding: 30,
                                                    ),
                                                    focusedBorder:
                                                        OutlineInputBorder(
                                                      borderRadius:
                                                          const BorderRadius
                                                              .all(
                                                              Radius.circular(
                                                                  5)),
                                                      borderSide: BorderSide(
                                                          color: Colors
                                                              .grey.shade300),
                                                    ),
                                                    enabledBorder:
                                                        OutlineInputBorder(
                                                      borderRadius:
                                                          const BorderRadius
                                                              .all(
                                                              Radius.circular(
                                                                  5)),
                                                      borderSide: BorderSide(
                                                          color: Colors
                                                              .grey.shade300),
                                                    ),
                                                    border: OutlineInputBorder(
                                                      borderRadius:
                                                          const BorderRadius
                                                              .all(
                                                              Radius.circular(
                                                                  5)),
                                                      borderSide: BorderSide(
                                                          color: Colors
                                                              .grey.shade300),
                                                    ),
                                                    suffixIcon: Icon(
                                                        Icons.search,
                                                        color: Colors
                                                            .grey.shade500),
                                                  ),
                                                  onChanged: (query) {
                                                    _editPartnerExpeController
                                                        .searchMaxHeight(
                                                            query); // Filter the list in the controller
                                                  },
                                                ),
                                              ),
                                              Container(
                                                decoration: const BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(5)),
                                                  color: Colors.white,
                                                ),
                                                height:
                                                    400, // Set a height for the list inside the dialog
                                                child: Obx(() {
                                                  return ListView.builder(
                                                    shrinkWrap: true,
                                                    itemCount:
                                                        _editPartnerExpeController
                                                            .searchedMAxHeightList
                                                            .length,
                                                    itemBuilder:
                                                        (context, index) {
                                                      final item =
                                                          _editPartnerExpeController
                                                                  .searchedMAxHeightList[
                                                              index];
                                                      bool isSelected =
                                                          _editPartnerExpeController
                                                                  .selectedMaxHeight
                                                                  .value
                                                                  .id ==
                                                              item.id;

                                                      return GestureDetector(
                                                        onTap: () {
                                                          // Update the selected value and close the dialog
                                                          _editPartnerExpeController
                                                              .updateMaxHeight(
                                                                  item);
                                                          // Update the controller text based on selection

                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: Container(
                                                          color: isSelected
                                                              ? AppTheme
                                                                  .selectedOptionColor
                                                              : Colors.white,
                                                          child: ListTile(
                                                            title: Text(
                                                              item.name ?? "",
                                                              style:
                                                                  CustomTextStyle
                                                                      .bodytext
                                                                      .copyWith(
                                                                color: isSelected
                                                                    ? Colors
                                                                        .white
                                                                    : AppTheme
                                                                        .textColor,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  );
                                                }),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                              );
                            },
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                        ],
                        /*
         Expanded(
              child: Obx(() {
                return CustomDropdownButton(
                  validator: (value) {
                    if (value == null) {
                      return 'Required';
                    }
                    return null;
                  },
                  items: _editPartnerExpeController.getFilteredMaxAgeList(), // Filtered max age list
                  value: _editPartnerExpeController.selectedMaxAge.id != null
                      ? _editPartnerExpeController
                          .getFilteredMaxAgeList()
                          .firstWhere((item) => item.id == _editPartnerExpeController.selectedMaxAge.id)
                      : null, // Pre-select based on the max age ID
                  onChanged: (FieldModel? newValue) {
                    if (newValue != null) {
                      _editPartnerExpeController.updateMaxAge(newValue.id); // Update max age in controller
                    }
                  },
                  hintText: "Max Age",
                );
              }),
            ),*/

                        /*
        Obx(() {
                return CustomDropdownButton(
                  validator: (value) {
                    if (value == null) {
                      return 'Required';
                    }
                    return null;
                  },
                  items: _editPartnerExpeController.heightRange, // Use the controller's heightRange
                  value: _editPartnerExpeController.selectedMinHeight.value != null
                      ? _editPartnerExpeController.heightRange.firstWhere(
                          (item) => item.id == _editPartnerExpeController.selectedMinHeight.value,
                          orElse: () => FieldModel(id: -1, name: "Select Min Height"), // Default item to avoid error
                        )
                      : null, // Pre-select based on the min height ID
                  onChanged: (FieldModel? newValue) {
                    if (newValue != null) {
                      print("Selected Min Height ID is ${newValue.id}");
                      _editPartnerExpeController.updateMinHeight(newValue); // Update min height in controller
                      _editPartnerExpeController.getFilteredMaxHeightList(); // Filter max height list based on min height
                    }
                  },
                  hintText: "Min Height",
                );
              }),
        
              SizedBox(height: 10,), 
              Obx(() {
                final filteredMaxHeights = _editPartnerExpeController.getFilteredMaxHeightList();
                return CustomDropdownButton(
                  validator: (value) {
                    if (value == null) {
                      return 'Required';
                    }
                    return null;
                  },
                  items: filteredMaxHeights, // Filtered max height list
                  value: _editPartnerExpeController.selectedMaxHeight.value.id != null
                      ? filteredMaxHeights.firstWhere(
                          (item) => item.id == _editPartnerExpeController.selectedMaxHeight.value.id,
                          orElse: () => FieldModel(id: -1, name: "Select Max Height"), // Default item to avoid error
                        )
                      : null, // Pre-select based on the max height ID
                  onChanged: (FieldModel? newValue) {
                    if (newValue != null) {
                      _editPartnerExpeController.updateMaxHeight(newValue); // Update max height in controller
                    }
                  },
                  hintText: "Max Height",
                );
              }),*/

                        /*   Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            alignment: WrapAlignment.center,
            spacing: 10,
            runSpacing: 10,
            children: [
              Container(
                height: 50,
                width: 160,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text("Min. Height", style: CustomTextStyle.bodytext.copyWith(fontSize: 12)),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200, // Background color of the dropdown
                          border: Border.all(color: Colors.grey), // Border for the dropdown
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            style: CustomTextStyle.bodytext.copyWith(fontSize: 12),
                            value: selectedHeight,
                            isExpanded: true, // Make dropdown fill the available width
                            items: heightInFeet
                                .map((item) => DropdownMenuItem<String>(
                                      value: item,
                                      child: Text(item),
                                    ))
                                .toList(),
                            onChanged: (value) {
                              setState(() {
                                selectedHeight = value;
                              });
                            },
                            dropdownColor: Colors.white, // Background color of the dropdown list
                            iconEnabledColor: Colors.grey, // Color of the dropdown icon
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            Container(
                height: 50,
                width: 160,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text("Max. Height", style: CustomTextStyle.bodytext.copyWith(fontSize: 12)),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200, // Background color of the dropdown
                          border: Border.all(color: Colors.grey), // Border for the dropdown
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            style: CustomTextStyle.bodytext.copyWith(fontSize: 12),
                            value: selectedHeight,
                            isExpanded: true, // Make dropdown fill the available width
                            items: heightInFeet
                                .map((item) => DropdownMenuItem<String>(
                                      value: item,
                                      child: Text(item),
                                    ))
                                .toList(),
                            onChanged: (value) {
                              setState(() {
                                selectedHeight = value;
                              });
                            },
                            dropdownColor: Colors.white, // Background color of the dropdown list
                            iconEnabledColor: Colors.grey, // Color of the dropdown icon
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
                ),*/
                        if ((_dashboardController.dashboardData["redirection"]
                                    ?["incompleteField"] as List?)
                                ?.any((item) =>
                                    item["missing_fields"] is List &&
                                    (item["missing_fields"] as List)
                                        .any((field) => field == "subcaste")) ??
                            false) ...[
                          RichText(
                            key: _partnerSectionKey,
                            text: TextSpan(
                              children: <TextSpan>[
                                TextSpan(
                                    text: AppLocalizations.of(context)!
                                        .partnerSubCaste,
                                    style: CustomTextStyle.fieldName),
                                const TextSpan(
                                    text: "*",
                                    style: TextStyle(color: Colors.red))
                              ],
                            ),
                          ),
                          Obx(() {
                            // Check if selectedSectionStringList is empty
                            if (_castController.selectedSectionList.isEmpty) {
                              // If no sections selected, show the CustomTextField to select sections
                              return CustomTextField(
                                validator: (value) {
                                  if (language == "en") {
                                    if (value == null || value.isEmpty) {
                                      return "Select Partner's Subcaste";
                                    }
                                  } else {
                                    if (value == null || value.isEmpty) {
                                      return "जोडीदाराची अपेक्षित पोटजात निवडा";
                                    }
                                  }

                                  return null;
                                },
                                ontap: () {
                                  _showSectionBottomSheet(
                                      context); // Open bottom sheet for section selection
                                },
                                readonly: true,
                                HintText: language == "en"
                                    ? "Select Sub Caste"
                                    : "जोडीदाराची अपेक्षित पोटजात निवडा ",
                              );
                            } else {
                              // If sections are selected, show the container with chips
                              return Padding(
                                padding: const EdgeInsets.only(top: 6.0),
                                child: GestureDetector(
                                  onTap: () {
                                    _showSectionBottomSheet(context);
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.grey.shade300,
                                          width: 1),
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(5)),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: ConstrainedBox(
                                        constraints: const BoxConstraints(
                                            minWidth: double.infinity),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Wrap(
                                              direction: Axis.horizontal,

                                              spacing:
                                                  10, // Spacing between chips horizontally
                                              runSpacing:
                                                  10, // Spacing between rows vertically
                                              children: [
                                                ...List.generate(
                                                  _castController
                                                              .selectedSectionList
                                                              .length >
                                                          4
                                                      ? 4
                                                      : _castController
                                                          .selectedSectionList
                                                          .length,
                                                  (index) {
                                                    final item = _castController
                                                            .selectedSectionList[
                                                        index];
                                                    return Chip(
                                                      deleteIcon: const Padding(
                                                        padding:
                                                            EdgeInsets.all(0),
                                                        child: Icon(Icons.close,
                                                            size: 12),
                                                      ),
                                                      padding:
                                                          const EdgeInsets.all(
                                                              2),
                                                      labelPadding:
                                                          const EdgeInsets.all(
                                                              4),
                                                      backgroundColor: AppTheme
                                                          .lightPrimaryColor,
                                                      side: const BorderSide(
                                                        style: BorderStyle.none,
                                                        color: Colors.blue,
                                                      ),
                                                      label: Text(
                                                        item.name ?? "",
                                                        style: CustomTextStyle
                                                            .bodytext
                                                            .copyWith(
                                                                fontSize: 11),
                                                      ),
                                                      onDeleted: () {
                                                        _castController
                                                            .selectedSectionList
                                                            .remove(item);
                                                      },
                                                    );
                                                  },
                                                ),
                                                // Add button as a Chip
                                                Obx(
                                                  () {
                                                    if (_castController
                                                            .selectedSectionList
                                                            .length ==
                                                        _castController
                                                            .sectionList
                                                            .length) {
                                                      return const SizedBox();
                                                    } else {
                                                      return Obx(
                                                        () {
                                                          if (_castController
                                                                  .selectedSectionList
                                                                  .length <=
                                                              4) {
                                                            return GestureDetector(
                                                              onTap: () {
                                                                // Navigate to view all countries
                                                                _showSectionBottomSheet(
                                                                    context);
                                                              },
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        bottom:
                                                                            2,
                                                                        top:
                                                                            12.0),
                                                                child: Text(
                                                                  language ==
                                                                          "en"
                                                                      ? "+ Add"
                                                                      : "(+1)अधिक",
                                                                  style: CustomTextStyle
                                                                      .bodytext
                                                                      .copyWith(
                                                                    color: AppTheme
                                                                        .selectedOptionColor,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                  ),
                                                                ),
                                                              ),
                                                            );
                                                          } else {
                                                            return GestureDetector(
                                                              onTap: () {
                                                                // Navigate to view all countries
                                                                _showSectionBottomSheet(
                                                                    context);
                                                              },
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        bottom:
                                                                            2,
                                                                        top:
                                                                            12.0),
                                                                child: Text(
                                                                  "(+${_castController.selectedSectionList.length - 4}) ${language == "en" ? "More" : 'अधिक'}   ",
                                                                  style: CustomTextStyle
                                                                      .bodytext
                                                                      .copyWith(
                                                                    color: AppTheme
                                                                        .selectedOptionColor,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                  ),
                                                                ),
                                                              ),
                                                            );
                                                          }
                                                        },
                                                      );
                                                    }
                                                  },
                                                )
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }
                          }),
                          const SizedBox(
                            height: 15,
                          ),
                        ],

                        if ((_dashboardController.dashboardData["redirection"]
                                    ?["incompleteField"] as List?)
                                ?.any((item) =>
                                    item["missing_fields"] is List &&
                                    (item["missing_fields"] as List)
                                        .any((field) => field == "manglik")) ??
                            false) ...[
                          RichText(
                            key: _manglikKey,
                            text: TextSpan(
                              children: <TextSpan>[
                                TextSpan(
                                    text: AppLocalizations.of(context)!
                                        .partnerManglikStatus,
                                    style: CustomTextStyle.fieldName),
                                const TextSpan(
                                    text: "*",
                                    style: TextStyle(color: Colors.red))
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Obx(
                            () {
                              return Wrap(
                                spacing: 10,
                                runSpacing: 10,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      _editPartnerExpeController.updateManglik(
                                          FieldModel(id: 2, name: "Yes"));
                                    },
                                    child: CustomContainer(
                                      height: 60,
                                      width: 89,
                                      color: _editPartnerExpeController
                                                  .manglikSelected.value.id ==
                                              2
                                          ? AppTheme.selectedOptionColor
                                          : null,
                                      title: AppLocalizations.of(context)!.yes,
                                      textColor: _editPartnerExpeController
                                                  .manglikSelected.value.id ==
                                              2
                                          ? Colors.white
                                          : null,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      _editPartnerExpeController.updateManglik(
                                          FieldModel(id: 1, name: "no"));
                                    },
                                    child: CustomContainer(
                                      color: _editPartnerExpeController
                                                  .manglikSelected.value.id ==
                                              1
                                          ? AppTheme.selectedOptionColor
                                          : null,
                                      height: 60,
                                      width: 89,
                                      title: AppLocalizations.of(context)!.no,
                                      textColor: _editPartnerExpeController
                                                  .manglikSelected.value.id ==
                                              1
                                          ? Colors.white
                                          : null,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      _editPartnerExpeController.updateManglik(
                                          FieldModel(
                                              id: 3, name: "Dosent Matter"));
                                    },
                                    child: CustomContainer(
                                      color: _editPartnerExpeController
                                                  .manglikSelected.value.id ==
                                              3
                                          ? AppTheme.selectedOptionColor
                                          : null,
                                      height: 60,
                                      width: 125,
                                      title: AppLocalizations.of(context)!
                                          .dosentmatter,
                                      textColor: _editPartnerExpeController
                                                  .manglikSelected.value.id ==
                                              3
                                          ? Colors.white
                                          : null,
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                          Obx(
                            () {
                              print("Valid Mang");
                              if (_editPartnerExpeController
                                          .selectedManglikValidated.value ==
                                      false &&
                                  _editPartnerExpeController
                                          .isSubmitted.value ==
                                      true) {
                                if (_editPartnerExpeController
                                        .manglikSelected.value.id ==
                                    null) {
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      language == "en"
                                          ? Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 18.0),
                                              child: Text(
                                                "Select Manglik Status",
                                                style:
                                                    CustomTextStyle.errorText,
                                              ),
                                            )
                                          : Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 18.0),
                                              child: Text(
                                                "मंगळ दोष निवडा",
                                                style:
                                                    CustomTextStyle.errorText,
                                              ),
                                            )
                                    ],
                                  );
                                } else {
                                  return const SizedBox();
                                }
                              } else {
                                return const SizedBox();
                              }
                            },
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                        ],

                        if ((_dashboardController.dashboardData["redirection"]
                                    ?["incompleteField"] as List?)
                                ?.any((item) =>
                                    item["missing_fields"] is List &&
                                    (item["missing_fields"] as List).any(
                                        (field) =>
                                            field == "marital_status")) ??
                            false) ...[
                          RichText(
                              key: _maritialStatusKey,
                              text: TextSpan(
                                children: <TextSpan>[
                                  TextSpan(
                                      text: AppLocalizations.of(context)!
                                          .partnerMaritalStatus,
                                      style: CustomTextStyle.fieldName),
                                  const TextSpan(
                                      text: "*",
                                      style: TextStyle(color: Colors.red))
                                ],
                              )),
                          const SizedBox(
                            height: 10,
                          ),
                          Obx(() {
                            return Wrap(
                              spacing: 10,
                              runSpacing: 10,
                              children: [
                                ..._editPartnerExpeController.statusOptions
                                    .map((option) {
                                  return GestureDetector(
                                    onTap: () {
                                      _editPartnerExpeController
                                          .toggleStatusSelection(option['id']);
                                    },
                                    child: CustomContainer(
                                      height: 60,
                                      title: option['label'],
                                      width: 122,
                                      color: _editPartnerExpeController
                                              .selectedStatusIds
                                              .contains(option['id'])
                                          ? AppTheme.selectedOptionColor
                                          : null,
                                      textColor: _editPartnerExpeController
                                              .selectedStatusIds
                                              .contains(option['id'])
                                          ? Colors.white
                                          : null,
                                    ),
                                  );
                                }),
                              ],
                            );
                          }),
                          Obx(
                            () {
                              if (_editPartnerExpeController
                                          .selectedStatusValidated.value ==
                                      false &&
                                  _editPartnerExpeController
                                          .isSubmitted.value ==
                                      true) {
                                if (_editPartnerExpeController
                                    .selectedStatusIds.isEmpty) {
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      language == "en"
                                          ? Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 18.0),
                                              child: Text(
                                                "Select partner's marital status",
                                                style:
                                                    CustomTextStyle.errorText,
                                              ),
                                            )
                                          : Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 18.0),
                                              child: Text(
                                                "जोडीदाराची अपेक्षित वैवाहिक स्तिथी टाका",
                                                style:
                                                    CustomTextStyle.errorText,
                                              ),
                                            )
                                    ],
                                  );
                                } else {
                                  return const SizedBox();
                                }
                              } else {
                                return const SizedBox();
                              }
                            },
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                        ],

                        if ((_dashboardController.dashboardData["redirection"]
                                    ?["incompleteField"] as List?)
                                ?.any((item) =>
                                    item["missing_fields"] is List &&
                                    (item["missing_fields"] as List).any(
                                        (field) => field == "employed_in")) ??
                            false) ...[
                          RichText(
                              key: _employedInKey,
                              text: TextSpan(
                                children: <TextSpan>[
                                  TextSpan(
                                      text: AppLocalizations.of(context)!
                                          .partnerEmployedIn,
                                      style: CustomTextStyle.fieldName),
                                  const TextSpan(
                                      text: "*",
                                      style: TextStyle(color: Colors.red))
                                ],
                              )),
                          Obx(
                            () {
                              if (_editPartnerExpeController
                                  .selectedItems.isNotEmpty) {
                                return Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          _showMultiSelectBottomSheet(context);
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Colors.grey.shade300,
                                                width: 1),
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(5)),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(12.0),
                                            child: ConstrainedBox(
                                              constraints: const BoxConstraints(
                                                  minWidth: double.infinity),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  Wrap(
                                                    direction: Axis.horizontal,

                                                    spacing:
                                                        10, // Spacing between chips horizontally
                                                    runSpacing:
                                                        10, // Spacing between rows vertically
                                                    children: [
                                                      ...List.generate(
                                                        _editPartnerExpeController
                                                                    .selectedItems
                                                                    .length >
                                                                4
                                                            ? 4
                                                            : _editPartnerExpeController
                                                                .selectedItems
                                                                .length,
                                                        (index) {
                                                          final item =
                                                              _editPartnerExpeController
                                                                      .selectedItems[
                                                                  index];
                                                          return Chip(
                                                            deleteIcon:
                                                                const Padding(
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(0),
                                                              child: Icon(
                                                                  Icons.close,
                                                                  size: 12),
                                                            ),
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(2),
                                                            labelPadding:
                                                                const EdgeInsets
                                                                    .all(4),
                                                            backgroundColor:
                                                                AppTheme
                                                                    .lightPrimaryColor,
                                                            side:
                                                                const BorderSide(
                                                              style: BorderStyle
                                                                  .none,
                                                              color:
                                                                  Colors.blue,
                                                            ),
                                                            label: Text(
                                                              item.name ?? "",
                                                              style: CustomTextStyle
                                                                  .bodytext
                                                                  .copyWith(
                                                                      fontSize:
                                                                          11),
                                                            ),
                                                            onDeleted: () {
                                                              _editPartnerExpeController
                                                                  .toggleSelection(
                                                                      item);
                                                            },
                                                          );
                                                        },
                                                      ),
                                                      // Add button as a Chip
                                                      Obx(
                                                        () {
                                                          if (_editPartnerExpeController
                                                                  .selectedItems
                                                                  .length <=
                                                              4) {
                                                            return GestureDetector(
                                                              onTap: () {
                                                                // Navigate to view all countries
                                                                _showMultiSelectBottomSheet(
                                                                    context);
                                                              },
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        bottom:
                                                                            2,
                                                                        top:
                                                                            12.0),
                                                                child: Text(
                                                                  language ==
                                                                          "en"
                                                                      ? "+ Add"
                                                                      : "(+1)अधिक",
                                                                  style: CustomTextStyle
                                                                      .bodytext
                                                                      .copyWith(
                                                                    color: AppTheme
                                                                        .selectedOptionColor,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                  ),
                                                                ),
                                                              ),
                                                            );
                                                          } else {
                                                            return GestureDetector(
                                                              onTap: () {
                                                                // Navigate to view all countries
                                                                _showMultiSelectBottomSheet(
                                                                    context);
                                                              },
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        bottom:
                                                                            2,
                                                                        top:
                                                                            12.0),
                                                                child: Text(
                                                                  "(+${_editPartnerExpeController.selectedItems.length - 4}) ${language == "en" ? "More" : 'अधिक'}",
                                                                  style: CustomTextStyle
                                                                      .bodytext
                                                                      .copyWith(
                                                                    color: AppTheme
                                                                        .selectedOptionColor,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                  ),
                                                                ),
                                                              ),
                                                            );
                                                          }
                                                        },
                                                      )
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              } else {
                                return CustomTextField(
                                  validator: (value) {
                                    if (language == "en") {
                                      if (value == null || value.isEmpty) {
                                        return "Select partner's expected employed in status";
                                      }
                                    } else {
                                      if (value == null || value.isEmpty) {
                                        return "जोडीदार कोणत्या क्षेत्रात जॉबला असावा ते निवडा";
                                      }
                                    }
                                    return null;
                                  },
                                  HintText: language == "en"
                                      ? "Employed In"
                                      : "जोडीदाराचा अपेक्षित जॉब क्षेत्र निवडा",
                                  ontap: () {
                                    _showMultiSelectBottomSheet(context);
                                  },
                                  readonly: true,
                                );
                              }
                            },
                          ),
                          const SizedBox(height: 15),
                        ],

                        if ((_dashboardController.dashboardData["redirection"]
                                    ?["incompleteField"] as List?)
                                ?.any((item) =>
                                    item["missing_fields"] is List &&
                                    (item["missing_fields"] as List).any(
                                        (field) => field == "education")) ??
                            false) ...[
                          RichText(
                              key: _highestDegreeKey,
                              text: TextSpan(children: <TextSpan>[
                                TextSpan(
                                    text: AppLocalizations.of(context)!
                                        .partnerHighestDegree,
                                    style: CustomTextStyle.fieldName),
                                const TextSpan(
                                    text: "*",
                                    style: TextStyle(color: Colors.red))
                              ])),
                          Text(
                            "(${AppLocalizations.of(context)!.pleaseSelectAtLeast4Education})",
                            style:
                                CustomTextStyle.bodytext.copyWith(fontSize: 12),
                          ),
                          Obx(
                            () {
                              if (_educationController
                                  .selectedEducationList.isNotEmpty) {
                                return Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          _showEducationBottomSheet(context);
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Colors.grey.shade300,
                                                width: 1),
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(5)),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(12.0),
                                            child: ConstrainedBox(
                                              constraints: const BoxConstraints(
                                                  minWidth: double.infinity),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  Wrap(
                                                    direction: Axis.horizontal,

                                                    spacing:
                                                        10, // Spacing between chips horizontally
                                                    runSpacing:
                                                        10, // Spacing between rows vertically
                                                    children: [
                                                      ...List.generate(
                                                        _educationController
                                                                    .selectedEducationList
                                                                    .length >
                                                                4
                                                            ? 4
                                                            : _educationController
                                                                .selectedEducationList
                                                                .length,
                                                        (index) {
                                                          final item =
                                                              _educationController
                                                                      .selectedEducationList[
                                                                  index];
                                                          return Chip(
                                                            deleteIcon:
                                                                const Padding(
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(0),
                                                              child: Icon(
                                                                  Icons.close,
                                                                  size: 12),
                                                            ),
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(2),
                                                            labelPadding:
                                                                const EdgeInsets
                                                                    .all(4),
                                                            backgroundColor:
                                                                AppTheme
                                                                    .lightPrimaryColor,
                                                            side:
                                                                const BorderSide(
                                                              style: BorderStyle
                                                                  .none,
                                                              color:
                                                                  Colors.blue,
                                                            ),
                                                            label: Text(
                                                              item.name ?? "",
                                                              style: CustomTextStyle
                                                                  .bodytext
                                                                  .copyWith(
                                                                      fontSize:
                                                                          11),
                                                            ),
                                                            onDeleted: () {
                                                              _educationController
                                                                  .toggleEducationSelection(
                                                                      item);
                                                            },
                                                          );
                                                        },
                                                      ),
                                                      // Add button as a Chip
                                                      Obx(
                                                        () {
                                                          if (_educationController
                                                                  .selectedEducationList
                                                                  .length <=
                                                              4) {
                                                            return GestureDetector(
                                                              onTap: () {
                                                                // Navigate to view all countries
                                                                _showEducationBottomSheet(
                                                                    context);
                                                              },
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        bottom:
                                                                            2,
                                                                        top:
                                                                            12.0),
                                                                child: Text(
                                                                  language ==
                                                                          "en"
                                                                      ? "+ Add"
                                                                      : "(+1)अधिक",
                                                                  style: CustomTextStyle
                                                                      .bodytext
                                                                      .copyWith(
                                                                    color: AppTheme
                                                                        .selectedOptionColor,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                  ),
                                                                ),
                                                              ),
                                                            );
                                                          } else {
                                                            return GestureDetector(
                                                              onTap: () {
                                                                // Navigate to view all countries
                                                                _showEducationBottomSheet(
                                                                    context);
                                                              },
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        bottom:
                                                                            2,
                                                                        top:
                                                                            12.0),
                                                                child: Text(
                                                                  "(+${_educationController.selectedEducationList.length - 4}) ${language == "en" ? "More" : 'अधिक'}",
                                                                  style: CustomTextStyle
                                                                      .bodytext
                                                                      .copyWith(
                                                                    color: AppTheme
                                                                        .selectedOptionColor,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                  ),
                                                                ),
                                                              ),
                                                            );
                                                          }
                                                        },
                                                      )
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Obx(
                                        () {
                                          if (_editPartnerExpeController
                                                      .listLengthValidate
                                                      .value ==
                                                  false &&
                                              _editPartnerExpeController
                                                      .isSubmitted.value ==
                                                  true) {
                                            if (_educationController
                                                    .selectedEducationList
                                                    .length <
                                                4) {
                                              return Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 18.0, top: 10),
                                                child: Text(
                                                  language == "en"
                                                      ? "Please select 4 or More Options to Move Forward"
                                                      : "कमीत कमी ४ पर्याय निवडा ",
                                                  style:
                                                      CustomTextStyle.errorText,
                                                ),
                                              );
                                            } else {
                                              return const SizedBox();
                                            }
                                          } else {
                                            return const SizedBox();
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                );
                              } else {
                                return CustomTextField(
                                  validator: (value) {
                                    if (language == "en") {
                                      if (value == null || value.isEmpty) {
                                        return "Select partner's highest degree";
                                      }
                                    } else {
                                      if (value == null || value.isEmpty) {
                                        return "जोडीदाराचे शिक्षण निवडा";
                                      }
                                    }

                                    return null;
                                  },
                                  HintText: language == "en"
                                      ? "Select Partner's Highest Degree"
                                      : "जोडीदाराचे अपेक्षित शिक्षण निवडा ",
                                  ontap: () {
                                    _showEducationBottomSheet(context);
                                  },
                                  readonly: true,
                                );
                              }
                            },
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                        ],

                        if ((_dashboardController.dashboardData["redirection"]
                                    ?["incompleteField"] as List?)
                                ?.any((item) =>
                                    item["missing_fields"] is List &&
                                    (item["missing_fields"] as List).any(
                                        (field) => field == "occupation")) ??
                            false) ...[
                          RichText(
                            key: _occupationKey,
                            text: TextSpan(children: <TextSpan>[
                              TextSpan(
                                  text: AppLocalizations.of(context)!
                                      .partnerOccupation,
                                  style: CustomTextStyle.fieldName),
                              const TextSpan(
                                  text: "*",
                                  style: TextStyle(color: Colors.red))
                            ]),
                          ),
                          Text(
                            "(${AppLocalizations.of(context)!.pleaseSelectAtLeast4Occupation})",
                            style:
                                CustomTextStyle.bodytext.copyWith(fontSize: 12),
                          ),
                          Obx(
                            () {
                              if (_occupationController
                                  .selectedOccupations.isNotEmpty) {
                                return Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          _showOccupationBottomSheet(context);
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Colors.grey.shade300,
                                                width: 1),
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(5)),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(12.0),
                                            child: ConstrainedBox(
                                              constraints: const BoxConstraints(
                                                  minWidth: double.infinity),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  Wrap(
                                                    direction: Axis.horizontal,

                                                    spacing:
                                                        10, // Spacing between chips horizontally
                                                    runSpacing:
                                                        10, // Spacing between rows vertically
                                                    children: [
                                                      ...List.generate(
                                                        _occupationController
                                                                    .selectedOccupations
                                                                    .length >
                                                                4
                                                            ? 4
                                                            : _occupationController
                                                                .selectedOccupations
                                                                .length,
                                                        (index) {
                                                          final item =
                                                              _occupationController
                                                                      .selectedOccupations[
                                                                  index];
                                                          return Chip(
                                                            deleteIcon:
                                                                const Padding(
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(0),
                                                              child: Icon(
                                                                  Icons.close,
                                                                  size: 12),
                                                            ),
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(2),
                                                            labelPadding:
                                                                const EdgeInsets
                                                                    .all(4),
                                                            backgroundColor:
                                                                AppTheme
                                                                    .lightPrimaryColor,
                                                            side:
                                                                const BorderSide(
                                                              style: BorderStyle
                                                                  .none,
                                                              color:
                                                                  Colors.blue,
                                                            ),
                                                            label: Text(
                                                              item.name ?? "",
                                                              style: CustomTextStyle
                                                                  .bodytext
                                                                  .copyWith(
                                                                      fontSize:
                                                                          11),
                                                            ),
                                                            onDeleted: () {
                                                              _occupationController
                                                                  .toggleOccupationSelection(
                                                                      item);
                                                            },
                                                          );
                                                        },
                                                      ),
                                                      // Add button as a Chip
                                                      Obx(
                                                        () {
                                                          if (_occupationController
                                                                  .selectedOccupations
                                                                  .length <=
                                                              4) {
                                                            return GestureDetector(
                                                              onTap: () {
                                                                // Navigate to view all countries
                                                                _showOccupationBottomSheet(
                                                                    context);
                                                              },
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        bottom:
                                                                            2,
                                                                        top:
                                                                            12.0),
                                                                child: Text(
                                                                  language ==
                                                                          "en"
                                                                      ? "+ Add"
                                                                      : "(+1)अधिक",
                                                                  style: CustomTextStyle
                                                                      .bodytext
                                                                      .copyWith(
                                                                    color: AppTheme
                                                                        .selectedOptionColor,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                  ),
                                                                ),
                                                              ),
                                                            );
                                                          } else {
                                                            return GestureDetector(
                                                              onTap: () {
                                                                // Navigate to view all countries
                                                                _showOccupationBottomSheet(
                                                                    context);
                                                              },
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        bottom:
                                                                            2,
                                                                        top:
                                                                            12.0),
                                                                child: Text(
                                                                  "(+${_occupationController.selectedOccupations.length - 4}) ${language == "en" ? "More" : 'अधिक'}",
                                                                  style: CustomTextStyle
                                                                      .bodytext
                                                                      .copyWith(
                                                                    color: AppTheme
                                                                        .selectedOptionColor,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                  ),
                                                                ),
                                                              ),
                                                            );
                                                          }
                                                        },
                                                      )
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Obx(
                                        () {
                                          if (_editPartnerExpeController
                                                      .listLengthValidate
                                                      .value ==
                                                  false &&
                                              _editPartnerExpeController
                                                      .isSubmitted.value ==
                                                  true) {
                                            if (_occupationController
                                                .selectedOccupations
                                                .any((occupation) =>
                                                    occupation.id == 199)) {
                                              return const SizedBox();
                                            } else {
                                              if (_occupationController
                                                      .selectedOccupations
                                                      .length <
                                                  4) {
                                                return Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 18.0, top: 10),
                                                  child: Text(
                                                    language == "en"
                                                        ? "Please select 4 or More Options to Move Forward"
                                                        : "कमीत कमी ४ पर्याय निवडा ",
                                                    style: CustomTextStyle
                                                        .errorText,
                                                  ),
                                                );
                                              } else {
                                                return const SizedBox();
                                              }
                                            }
                                          } else {
                                            return const SizedBox();
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                );
                              } else {
                                return CustomTextField(
                                  validator: (value) {
                                    if (language == "en") {
                                      if (value == null || value.isEmpty) {
                                        return "Select partner's expected occupation";
                                      }
                                    } else {
                                      if (value == null || value.isEmpty) {
                                        return "जोडीदाराचा अपेक्षित व्यवसाय निवडा";
                                      }
                                    }

                                    return null;
                                  },
                                  HintText: language == "en"
                                      ? "Select Occupation"
                                      : "जोडीदाराचा अपेक्षित व्यवसाय निवडा ",
                                  ontap: () {
                                    _showOccupationBottomSheet(context);
                                  },
                                  readonly: true,
                                );
                              }
                            },
                          ),
                          Obx(
                            () => Wrap(
                              spacing: 10,
                              children: _editPartnerExpeController
                                  .selectedOccupationItems
                                  .map(
                                    (item) => Chip(
                                      label: Text(item),
                                      onDeleted: () {
                                        _editPartnerExpeController
                                            .toggleOccupationSelection(item);
                                      },
                                    ),
                                  )
                                  .toList(),
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                        ],

                        if ((_dashboardController.dashboardData["redirection"]
                                    ?["incompleteField"] as List?)
                                ?.any((item) =>
                                    item["missing_fields"] is List &&
                                    (item["missing_fields"] as List).any(
                                        (field) =>
                                            field == "min_annual_income")) ??
                            false) ...[
                          RichText(
                              key: _MinIncomeKey,
                              text: TextSpan(children: <TextSpan>[
                                TextSpan(
                                    text: AppLocalizations.of(context)!
                                        .partnerMinAnnualIncome,
                                    style: CustomTextStyle.fieldName),
                                const TextSpan(
                                    text: "*",
                                    style: TextStyle(color: Colors.red))
                              ])),
                          Obx(
                            () {
                              final TextEditingController minINC =
                                  TextEditingController(
                                      text: _editPartnerExpeController
                                          .selectedMinIncome.value.name);
                              return CustomTextField(
                                readonly: true,
                                validator: (value) {
                                  if (language == "en") {
                                    if (value == null || value.isEmpty) {
                                      return "Select partner's expected annual income";
                                    }
                                  } else {
                                    if (value == null || value.isEmpty) {
                                      return "जोडीदाराचे किमान वार्षिक उत्पन्न निवडा";
                                    }
                                  }

                                  return null;
                                },
                                textEditingController: minINC,
                                HintText: language == "en"
                                    ? "Min Annual Income"
                                    : "जोडीदाराचे कमीत कमी वार्षिक उत्पन्न निवडा ",
                                ontap: () {
                                  _editPartnerExpeController
                                          .searchedMinAnnualIncomeList.value =
                                      _editPartnerExpeController
                                          .annualIncomeRange;

                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return Dialog(
                                        backgroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(16.0),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 8.0, top: 8),
                                                child: TextField(
                                                  decoration: InputDecoration(
                                                    errorMaxLines: 5,
                                                    errorStyle: CustomTextStyle
                                                        .errorText,
                                                    labelStyle: CustomTextStyle
                                                        .bodytext,
                                                    hintText:
                                                        AppLocalizations.of(
                                                                context)!
                                                            .searchAnnualIncome,
                                                    // "Search Annual Income",
                                                    contentPadding:
                                                        const EdgeInsets.all(
                                                            20),
                                                    hintStyle: CustomTextStyle
                                                        .hintText,
                                                    filled: true,
                                                    fillColor: Colors.white,
                                                    errorBorder:
                                                        const OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: Colors.red),
                                                      gapPadding: 30,
                                                    ),
                                                    focusedBorder:
                                                        OutlineInputBorder(
                                                      borderRadius:
                                                          const BorderRadius
                                                              .all(
                                                              Radius.circular(
                                                                  5)),
                                                      borderSide: BorderSide(
                                                          color: Colors
                                                              .grey.shade300),
                                                    ),
                                                    enabledBorder:
                                                        OutlineInputBorder(
                                                      borderRadius:
                                                          const BorderRadius
                                                              .all(
                                                              Radius.circular(
                                                                  5)),
                                                      borderSide: BorderSide(
                                                          color: Colors
                                                              .grey.shade300),
                                                    ),
                                                    border: OutlineInputBorder(
                                                      borderRadius:
                                                          const BorderRadius
                                                              .all(
                                                              Radius.circular(
                                                                  5)),
                                                      borderSide: BorderSide(
                                                          color: Colors
                                                              .grey.shade300),
                                                    ),
                                                    suffixIcon: Icon(
                                                        Icons.search,
                                                        color: Colors
                                                            .grey.shade500),
                                                  ),
                                                  onChanged: (query) {
                                                    _editPartnerExpeController
                                                        .searchMinAnnualIncome(
                                                            query); // Filter the list in the controller
                                                  },
                                                ),
                                              ),
                                              Container(
                                                decoration: const BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(5)),
                                                  color: Colors.white,
                                                ),
                                                height:
                                                    400, // Set a height for the list inside the dialog
                                                child: Obx(() {
                                                  return ListView.builder(
                                                    shrinkWrap: true,
                                                    itemCount:
                                                        _editPartnerExpeController
                                                            .searchedMinAnnualIncomeList
                                                            .length,
                                                    itemBuilder:
                                                        (context, index) {
                                                      final item =
                                                          _editPartnerExpeController
                                                                  .searchedMinAnnualIncomeList[
                                                              index];
                                                      bool isSelected =
                                                          _editPartnerExpeController
                                                                  .selectedMinIncome
                                                                  .value
                                                                  .id ==
                                                              item.id;

                                                      return GestureDetector(
                                                        onTap: () {
                                                          // Update the selected value and close the dialog
                                                          _editPartnerExpeController
                                                              .updateMinIncome(
                                                                  item);
                                                          // Update the controller text based on selection

                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: Container(
                                                          color: isSelected
                                                              ? AppTheme
                                                                  .selectedOptionColor
                                                              : Colors.white,
                                                          child: ListTile(
                                                            title: Text(
                                                              item.name ?? "",
                                                              style:
                                                                  CustomTextStyle
                                                                      .bodytext
                                                                      .copyWith(
                                                                color: isSelected
                                                                    ? Colors
                                                                        .white
                                                                    : AppTheme
                                                                        .textColor,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  );
                                                }),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                              );
                            },
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                        ],

                        if ((_dashboardController.dashboardData["redirection"]
                                    ?["incompleteField"] as List?)
                                ?.any((item) =>
                                    item["missing_fields"] is List &&
                                    (item["missing_fields"] as List).any(
                                        (field) =>
                                            field == "max_annual_income")) ??
                            false) ...[
                          RichText(
                              key: _MaxIncomeKey,
                              text: TextSpan(children: <TextSpan>[
                                TextSpan(
                                    text: AppLocalizations.of(context)!
                                        .partnerMaxAnnualIncome,
                                    style: CustomTextStyle.fieldName),
                                const TextSpan(
                                    text: "*",
                                    style: TextStyle(color: Colors.red))
                              ])),
                          Obx(
                            () {
                              final TextEditingController minINC =
                                  TextEditingController(
                                      text: _editPartnerExpeController
                                          .selectedMaxIncome.value.name);
                              return CustomTextField(
                                validator: (value) {
                                  if (language == "en") {
                                    if (value == null || value.isEmpty) {
                                      return "Select partner's expected annual income";
                                    }
                                  } else {
                                    if (value == null || value.isEmpty) {
                                      return "जोडीदाराचे कमाल वार्षिक उत्पन्न निवडा ";
                                    }
                                  }

                                  return null;
                                },
                                readonly: true,
                                textEditingController: minINC,
                                HintText: language == "en"
                                    ? "Max Annual Income"
                                    : "जोडीदाराचे जास्तीत जास्त वार्षिक उत्पन्न निवडा ",
                                ontap: () {
                                  _editPartnerExpeController
                                          .searchedMaxAnnualIncomeList.value =
                                      _editPartnerExpeController
                                          .getFilteredMaxIncomeList();

                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return Dialog(
                                        backgroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(16.0),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 8.0, top: 8),
                                                child: TextField(
                                                  decoration: InputDecoration(
                                                    errorMaxLines: 5,
                                                    errorStyle: CustomTextStyle
                                                        .errorText,
                                                    labelStyle: CustomTextStyle
                                                        .bodytext,
                                                    hintText:
                                                        AppLocalizations.of(
                                                                context)!
                                                            .searchAnnualIncome,
                                                    // "Search Height",
                                                    contentPadding:
                                                        const EdgeInsets.all(
                                                            20),
                                                    hintStyle: CustomTextStyle
                                                        .hintText,
                                                    filled: true,
                                                    fillColor: Colors.white,
                                                    errorBorder:
                                                        const OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: Colors.red),
                                                      gapPadding: 30,
                                                    ),
                                                    focusedBorder:
                                                        OutlineInputBorder(
                                                      borderRadius:
                                                          const BorderRadius
                                                              .all(
                                                              Radius.circular(
                                                                  5)),
                                                      borderSide: BorderSide(
                                                          color: Colors
                                                              .grey.shade300),
                                                    ),
                                                    enabledBorder:
                                                        OutlineInputBorder(
                                                      borderRadius:
                                                          const BorderRadius
                                                              .all(
                                                              Radius.circular(
                                                                  5)),
                                                      borderSide: BorderSide(
                                                          color: Colors
                                                              .grey.shade300),
                                                    ),
                                                    border: OutlineInputBorder(
                                                      borderRadius:
                                                          const BorderRadius
                                                              .all(
                                                              Radius.circular(
                                                                  5)),
                                                      borderSide: BorderSide(
                                                          color: Colors
                                                              .grey.shade300),
                                                    ),
                                                    suffixIcon: Icon(
                                                        Icons.search,
                                                        color: Colors
                                                            .grey.shade500),
                                                  ),
                                                  onChanged: (query) {
                                                    _editPartnerExpeController
                                                        .searchMaxAnnualIncome(
                                                            query); // Filter the list in the controller
                                                  },
                                                ),
                                              ),
                                              Container(
                                                decoration: const BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(5)),
                                                  color: Colors.white,
                                                ),
                                                height:
                                                    400, // Set a height for the list inside the dialog
                                                child: Obx(() {
                                                  return ListView.builder(
                                                    shrinkWrap: true,
                                                    itemCount:
                                                        _editPartnerExpeController
                                                            .searchedMaxAnnualIncomeList
                                                            .length,
                                                    itemBuilder:
                                                        (context, index) {
                                                      final item =
                                                          _editPartnerExpeController
                                                                  .searchedMaxAnnualIncomeList[
                                                              index];
                                                      bool isSelected =
                                                          _editPartnerExpeController
                                                                  .selectedMaxIncome
                                                                  .value
                                                                  .id ==
                                                              item.id;

                                                      return GestureDetector(
                                                        onTap: () {
                                                          // Update the selected value and close the dialog
                                                          _editPartnerExpeController
                                                              .updateMaxIncome(
                                                                  item);
                                                          // Update the controller text based on selection

                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: Container(
                                                          color: isSelected
                                                              ? AppTheme
                                                                  .selectedOptionColor
                                                              : Colors.white,
                                                          child: ListTile(
                                                            title: Text(
                                                              item.name ?? "",
                                                              style:
                                                                  CustomTextStyle
                                                                      .bodytext
                                                                      .copyWith(
                                                                color: isSelected
                                                                    ? Colors
                                                                        .white
                                                                    : AppTheme
                                                                        .textColor,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  );
                                                }),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                              );
                            },
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                        ],
                        /*       
        Obx(() {
          return CustomDropdownButton(
        validator: (value) {
          if (value == null) {
            return 'Required';
          }
          return null;
        },
        items: _editPartnerExpeController.annualIncomeRange,
        value: _editPartnerExpeController.selectedMinIncome.value != null
            ? _editPartnerExpeController.annualIncomeRange.firstWhere(
                (item) => item.id == _editPartnerExpeController.selectedMinIncome.value)
            : null,
        onChanged: (FieldModel? newValue) {
          if (newValue != null) {
            _editPartnerExpeController.updateMinIncome(newValue.id);
            _editPartnerExpeController.getFilteredMaxIncomeList(); // Update the max income options
          }
        },
        hintText: "Min Annual Income",
          );
        }),
        SizedBox(height: 10),
        Obx(() {
          return CustomDropdownButton(
        validator: (value) {
          if (value == null) {
            return 'Required';
          }
          return null;
        },
        items: _editPartnerExpeController.getFilteredMaxIncomeList(),
        value: _editPartnerExpeController.selectedMaxIncome.value != null
            ? _editPartnerExpeController.getFilteredMaxIncomeList().firstWhere(
                (item) => item.id == _editPartnerExpeController.selectedMaxIncome.value)
            : null,
        onChanged: (FieldModel? newValue) {
          if (newValue != null) {
            _editPartnerExpeController.updateMaxIncome(newValue.id);
          }
        },
        hintText: "Max Annual Income",
          );
        }),
        */
                        if ((_dashboardController.dashboardData["redirection"]
                                    ?["incompleteField"] as List?)
                                ?.any((item) =>
                                    item["missing_fields"] is List &&
                                    (item["missing_fields"] as List).any(
                                        (field) =>
                                            field == "country" ||
                                            field == "state" ||
                                            field == "city")) ??
                            false) ...[
                          RichText(
                              key: _expectedResidenceKey,
                              text: TextSpan(children: <TextSpan>[
                                TextSpan(
                                    text: AppLocalizations.of(context)!
                                        .partnerExpectedResidence,
                                    style: CustomTextStyle.fieldName),
                                const TextSpan(
                                    text: "*",
                                    style: TextStyle(color: Colors.red))
                              ])),
                          Obx(
                            () {
                              if (_locationController
                                  .selectedCountries.isEmpty) {
                                return CustomTextField(
                                  validator: (value) {
                                    if (language == "en") {
                                      if (value == null || value.isEmpty) {
                                        return "Select partner's expected residance";
                                      }
                                    } else {
                                      if (value == null || value.isEmpty) {
                                        return "जोडीदाराचे अपेक्षित राहण्याचे ठिकाण निवडा";
                                      }
                                    }

                                    return null;
                                  },
                                  readonly: true,
                                  HintText: language == "en"
                                      ? "Select Location"
                                      : "जोडीदाराचे अपेक्षित राहण्याचे ठिकाण निवडा",
                                  ontap: () {
                                    //   Get.toNamed(AppRouteNames.partnerSelectCountry);
                                    navigatorKey.currentState!
                                        .push(MaterialPageRoute(
                                      builder: (context) =>
                                          const PartnerCountrySelectScreen(),
                                    ));
                                  },
                                );
                              } else {
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          navigatorKey.currentState!.push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const PartnerCountrySelectScreen()),
                                          );
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Colors.grey.shade300,
                                                width: 1),
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(5)),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(12.0),
                                            child: ConstrainedBox(
                                              constraints: const BoxConstraints(
                                                  minWidth: double.infinity),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
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
                                                                    .selectedCountries
                                                                    .length >
                                                                4
                                                            ? 4
                                                            : _locationController
                                                                .selectedCountries
                                                                .length,
                                                        (index) {
                                                          final item =
                                                              _locationController
                                                                      .selectedCountries[
                                                                  index];
                                                          return Chip(
                                                            deleteIcon:
                                                                const Padding(
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(0),
                                                              child: Icon(
                                                                  Icons.close,
                                                                  size: 12),
                                                            ),
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(2),
                                                            labelPadding:
                                                                const EdgeInsets
                                                                    .all(4),
                                                            backgroundColor:
                                                                AppTheme
                                                                    .lightPrimaryColor,
                                                            side:
                                                                const BorderSide(
                                                              style: BorderStyle
                                                                  .none,
                                                              color:
                                                                  Colors.blue,
                                                            ),
                                                            label: Text(
                                                              item.name ?? "",
                                                              style: CustomTextStyle
                                                                  .bodytext
                                                                  .copyWith(
                                                                      fontSize:
                                                                          11),
                                                            ),
                                                            onDeleted: () {
                                                              _locationController
                                                                  .toggleCountrySelection(
                                                                      item);
                                                            },
                                                          );
                                                        },
                                                      ),
                                                      // Add button as a Chip
                                                      Obx(
                                                        () {
                                                          if (_locationController
                                                                  .selectedCountries
                                                                  .length <=
                                                              4) {
                                                            return GestureDetector(
                                                              onTap: () {
                                                                // Navigate to view all countries
                                                                navigatorKey
                                                                    .currentState!
                                                                    .push(
                                                                  MaterialPageRoute(
                                                                      builder:
                                                                          (context) =>
                                                                              const PartnerCountrySelectScreen()),
                                                                );
                                                              },
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        bottom:
                                                                            2,
                                                                        top:
                                                                            12.0),
                                                                child: Text(
                                                                  language ==
                                                                          "en"
                                                                      ? "+ Add"
                                                                      : "(+1)अधिक",
                                                                  style: CustomTextStyle
                                                                      .bodytext
                                                                      .copyWith(
                                                                    color: AppTheme
                                                                        .selectedOptionColor,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                  ),
                                                                ),
                                                              ),
                                                            );
                                                          } else {
                                                            return GestureDetector(
                                                              onTap: () {
                                                                // Navigate to view all countries
                                                                navigatorKey
                                                                    .currentState!
                                                                    .push(
                                                                  MaterialPageRoute(
                                                                      builder:
                                                                          (context) =>
                                                                              const PartnerCountrySelectScreen()),
                                                                );
                                                              },
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        bottom:
                                                                            2,
                                                                        top:
                                                                            12.0),
                                                                child: Text(
                                                                  "(+${_locationController.selectedCountries.length - 4}) ${language == "en" ? "More" : 'अधिक'}",
                                                                  style: CustomTextStyle
                                                                      .bodytext
                                                                      .copyWith(
                                                                    color: AppTheme
                                                                        .selectedOptionColor,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                  ),
                                                                ),
                                                              ),
                                                            );
                                                          }
                                                        },
                                                      )
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Obx(
                                        () {
                                          if (_locationController
                                              .selectedCountries.isEmpty) {
                                            return const SizedBox();
                                          } else {
                                            if (_locationController
                                                .selectedStates.isEmpty) {
                                              return Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  Text(
                                                    AppLocalizations.of(
                                                            context)!
                                                        .selectStates,
                                                    style: CustomTextStyle
                                                        .fieldName,
                                                  ),
                                                  CustomTextField(
                                                    validator: (value) {
                                                      if (language == "en") {
                                                        if (value == null ||
                                                            value.isEmpty) {
                                                          return "Please select your partner's expected states";
                                                        }
                                                      } else {
                                                        if (value == null ||
                                                            value.isEmpty) {
                                                          return "जोडीदाराचे अपेक्षित स्थायिक ठिकाण";
                                                        }
                                                      }

                                                      return null;
                                                    },
                                                    readonly: true,
                                                    HintText: language == "en"
                                                        ? "Select States"
                                                        : "राज्य निवडा",
                                                    ontap: () {
                                                      navigatorKey.currentState!
                                                          .push(
                                                              MaterialPageRoute(
                                                        builder: (context) =>
                                                            const PartnerStateScreen(),
                                                      ));
                                                    },
                                                  )
                                                ],
                                              );
                                            } else {
                                              return Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  Text(
                                                    AppLocalizations.of(
                                                            context)!
                                                        .selectedStates,
                                                    style: CustomTextStyle
                                                        .fieldName,
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  GestureDetector(
                                                    onTap: () {
                                                      navigatorKey.currentState!
                                                          .push(
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                const PartnerStateScreen()),
                                                      );
                                                    },
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        border: Border.all(
                                                            color: Colors
                                                                .grey.shade300,
                                                            width: 1),
                                                        borderRadius:
                                                            const BorderRadius
                                                                .all(
                                                                Radius.circular(
                                                                    5)),
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(12.0),
                                                        child: ConstrainedBox(
                                                          constraints:
                                                              const BoxConstraints(
                                                                  minWidth: double
                                                                      .infinity),
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .end,
                                                            children: [
                                                              Wrap(
                                                                direction: Axis
                                                                    .horizontal,

                                                                spacing:
                                                                    10, // Spacing between chips horizontally
                                                                runSpacing:
                                                                    10, // Spacing between rows vertically
                                                                children: [
                                                                  ...List
                                                                      .generate(
                                                                    _locationController.selectedStates.length >
                                                                            4
                                                                        ? 4
                                                                        : _locationController
                                                                            .selectedStates
                                                                            .length,
                                                                    (index) {
                                                                      final item =
                                                                          _locationController
                                                                              .selectedStates[index];
                                                                      return Chip(
                                                                        deleteIcon:
                                                                            const Padding(
                                                                          padding:
                                                                              EdgeInsets.all(0),
                                                                          child: Icon(
                                                                              Icons.close,
                                                                              size: 12),
                                                                        ),
                                                                        padding: const EdgeInsets
                                                                            .all(
                                                                            2),
                                                                        labelPadding: const EdgeInsets
                                                                            .all(
                                                                            4),
                                                                        backgroundColor:
                                                                            AppTheme.lightPrimaryColor,
                                                                        side:
                                                                            const BorderSide(
                                                                          style:
                                                                              BorderStyle.none,
                                                                          color:
                                                                              Colors.blue,
                                                                        ),
                                                                        label:
                                                                            Text(
                                                                          item.name ??
                                                                              "",
                                                                          style: CustomTextStyle
                                                                              .bodytext
                                                                              .copyWith(fontSize: 11),
                                                                        ),
                                                                        onDeleted:
                                                                            () {
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
                                                                              .selectedStates
                                                                              .length <=
                                                                          4) {
                                                                        return GestureDetector(
                                                                          onTap:
                                                                              () {
                                                                            // Navigate to view all countries
                                                                            navigatorKey.currentState!.push(
                                                                              MaterialPageRoute(builder: (context) => const PartnerStateScreen()),
                                                                            );
                                                                          },
                                                                          child:
                                                                              Padding(
                                                                            padding:
                                                                                const EdgeInsets.only(bottom: 2, top: 12.0),
                                                                            child:
                                                                                Text(
                                                                              language == "en" ? "+ Add" : "(+1)अधिक",
                                                                              style: CustomTextStyle.bodytext.copyWith(
                                                                                color: AppTheme.selectedOptionColor,
                                                                                fontWeight: FontWeight.bold,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        );
                                                                      } else {
                                                                        return GestureDetector(
                                                                          onTap:
                                                                              () {
                                                                            // Navigate to view all countries
                                                                            navigatorKey.currentState!.push(
                                                                              MaterialPageRoute(builder: (context) => const PartnerStateScreen()),
                                                                            );
                                                                          },
                                                                          child:
                                                                              Padding(
                                                                            padding:
                                                                                const EdgeInsets.only(bottom: 2, top: 12.0),
                                                                            child:
                                                                                Text(
                                                                              "(+${_locationController.selectedStates.length - 4}) ${language == "en" ? "More" : 'अधिक'}",
                                                                              style: CustomTextStyle.bodytext.copyWith(
                                                                                color: AppTheme.selectedOptionColor,
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
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              );
                                            }
                                          }
                                        },
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),

                                      /* Obx(() {
                        if(_editPartnerExpeController.isSubmitted.value == true && _locationController.selectedStates.isEmpty){
                          return Text("Please Select States" , style: CustomTextStyle.errorText, ); 
                        }else{
                          return const SizedBox();
                        }
                      },),*/
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Obx(
                                        () {
                                          if (_locationController
                                              .selectedStates.isEmpty) {
                                            return const SizedBox();
                                          } else {
                                            if (_locationController
                                                .selectedCities.isEmpty) {
                                              return Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                      AppLocalizations.of(
                                                              context)!
                                                          .selectDistricts,
                                                      style: CustomTextStyle
                                                          .fieldName),
                                                  Text(
                                                    AppLocalizations.of(
                                                            context)!
                                                        .pleaseSelect4orMoreDistricts,
                                                    style: CustomTextStyle
                                                        .bodytext
                                                        .copyWith(fontSize: 12),
                                                  ),
                                                  const SizedBox(height: 10),
                                                  CustomTextField(
                                                    validator: (value) {
                                                      if (language == "en") {
                                                        if (value == null ||
                                                            value.isEmpty) {
                                                          return "Please select your partner's expected district";
                                                        }
                                                      } else {
                                                        if (value == null ||
                                                            value.isEmpty) {
                                                          return "जोडीदाराचे अपेक्षित जिल्हे निवडा ";
                                                        }
                                                      }

                                                      return null;
                                                    },
                                                    readonly: true,
                                                    HintText: language == "en"
                                                        ? "Select Districts"
                                                        : "जिल्हा निवडा ",
                                                    ontap: () {
                                                      navigatorKey.currentState!
                                                          .push(
                                                              MaterialPageRoute(
                                                        builder: (context) =>
                                                            const PartnerSelectCityScreen(),
                                                      ));
                                                    },
                                                  )
                                                ],
                                              );
                                            } else {
                                              return Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                      AppLocalizations.of(
                                                              context)!
                                                          .selectedDistricts,
                                                      style: CustomTextStyle
                                                          .fieldName),
                                                  Text(
                                                    language == "en"
                                                        ? "please select at least 4 district"
                                                        : 'कमीत कमी ४ पर्याय निवडा',
                                                    style: CustomTextStyle
                                                        .bodytext
                                                        .copyWith(fontSize: 12),
                                                  ),
                                                  const SizedBox(height: 10),
                                                  GestureDetector(
                                                    onTap: () {
                                                      navigatorKey.currentState!
                                                          .push(
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                const PartnerSelectCityScreen()),
                                                      );
                                                    },
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        border: Border.all(
                                                            color: Colors
                                                                .grey.shade300,
                                                            width: 1),
                                                        borderRadius:
                                                            const BorderRadius
                                                                .all(
                                                                Radius.circular(
                                                                    5)),
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(12.0),
                                                        child: ConstrainedBox(
                                                          constraints:
                                                              const BoxConstraints(
                                                                  minWidth: double
                                                                      .infinity),
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .end,
                                                            children: [
                                                              Wrap(
                                                                direction: Axis
                                                                    .horizontal,

                                                                spacing:
                                                                    10, // Spacing between chips horizontally
                                                                runSpacing:
                                                                    10, // Spacing between rows vertically
                                                                children: [
                                                                  ...List
                                                                      .generate(
                                                                    _locationController.selectedCities.length >
                                                                            4
                                                                        ? 4
                                                                        : _locationController
                                                                            .selectedCities
                                                                            .length,
                                                                    (index) {
                                                                      final item =
                                                                          _locationController
                                                                              .selectedCities[index];
                                                                      return Chip(
                                                                        deleteIcon:
                                                                            const Padding(
                                                                          padding:
                                                                              EdgeInsets.all(0),
                                                                          child: Icon(
                                                                              Icons.close,
                                                                              size: 12),
                                                                        ),
                                                                        padding: const EdgeInsets
                                                                            .all(
                                                                            2),
                                                                        labelPadding: const EdgeInsets
                                                                            .all(
                                                                            4),
                                                                        backgroundColor:
                                                                            AppTheme.lightPrimaryColor,
                                                                        side:
                                                                            const BorderSide(
                                                                          style:
                                                                              BorderStyle.none,
                                                                          color:
                                                                              Colors.blue,
                                                                        ),
                                                                        label:
                                                                            Text(
                                                                          item.name ??
                                                                              "",
                                                                          style: CustomTextStyle
                                                                              .bodytext
                                                                              .copyWith(fontSize: 11),
                                                                        ),
                                                                        onDeleted:
                                                                            () {
                                                                          _locationController
                                                                              .toggleCitySelection(item);
                                                                        },
                                                                      );
                                                                    },
                                                                  ),
                                                                  // Add button as a Chip
                                                                  Obx(
                                                                    () {
                                                                      if (_locationController
                                                                              .selectedCities
                                                                              .length <=
                                                                          4) {
                                                                        return GestureDetector(
                                                                          onTap:
                                                                              () {
                                                                            // Navigate to view all countries
                                                                            navigatorKey.currentState!.push(
                                                                              MaterialPageRoute(builder: (context) => const PartnerSelectCityScreen()),
                                                                            );
                                                                          },
                                                                          child:
                                                                              Padding(
                                                                            padding:
                                                                                const EdgeInsets.only(bottom: 2, top: 12.0),
                                                                            child:
                                                                                Text(
                                                                              language == "en" ? "+ Add" : "(+1)अधिक",
                                                                              style: CustomTextStyle.bodytext.copyWith(
                                                                                color: AppTheme.selectedOptionColor,
                                                                                fontWeight: FontWeight.bold,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        );
                                                                      } else {
                                                                        return GestureDetector(
                                                                          onTap:
                                                                              () {
                                                                            // Navigate to view all countries
                                                                            navigatorKey.currentState!.push(
                                                                              MaterialPageRoute(builder: (context) => const PartnerSelectCityScreen()),
                                                                            );
                                                                          },
                                                                          child:
                                                                              Padding(
                                                                            padding:
                                                                                const EdgeInsets.only(bottom: 2, top: 12.0),
                                                                            child:
                                                                                Text(
                                                                              "(+${_locationController.selectedCities.length - 4}) ${language == "en" ? "More" : 'अधिक'}",
                                                                              style: CustomTextStyle.bodytext.copyWith(
                                                                                color: AppTheme.selectedOptionColor,
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
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(height: 10),
                                                  Obx(() {
                                                    if (_editPartnerExpeController
                                                                .isSubmitted
                                                                .value ==
                                                            true &&
                                                        _locationController
                                                                .selectedCities
                                                                .length <
                                                            4) {
                                                      return language == "en"
                                                          ? Text(
                                                              "Please select 4 or more districts",
                                                              style:
                                                                  CustomTextStyle
                                                                      .errorText)
                                                          : Text(
                                                              "कमीत कमी ४ पर्याय निवडा",
                                                              style:
                                                                  CustomTextStyle
                                                                      .errorText);
                                                    } else {
                                                      return const SizedBox();
                                                    }
                                                  }),
                                                ],
                                              );
                                            }
                                          }
                                        },
                                      )
                                    ],
                                  ),
                                );
                              }
                            },
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                        ],
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Expanded(
                            //     child: ElevatedButton(
                            //         style: ElevatedButton.styleFrom(
                            //             backgroundColor: Colors.white,
                            //             side: const BorderSide(
                            //                 color: Colors.red)),
                            //         onPressed: () {
                            //           navigatorKey.currentState!
                            //               .pushReplacement(MaterialPageRoute(
                            //             builder: (context) =>
                            //                 const UserInfoStepTwo(),
                            //           ));
                            //         },
                            //         child: Text(
                            //           AppLocalizations.of(context)!.back,
                            //           style: CustomTextStyle.elevatedButton
                            //               .copyWith(color: Colors.red),
                            //         ))),
                            // const SizedBox(
                            //   width: 10,
                            // ),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  //  navigatorKey.currentState!.push(MaterialPageRoute(builder: (context) => UserInfoStepFour(),));
                                  // sharedPreferences?.setString("PageIndex", "5");
                                  try {
                                    // Mark form as submitted
                                    _editPartnerExpeController
                                        .isSubmitted.value = true;

                                    // Perform individual field validations
                                    bool manglikValid =
                                        _editPartnerExpeController
                                                .manglikSelected.value.id !=
                                            null;
                                    bool maritalStatusValid =
                                        _editPartnerExpeController
                                            .selectedStatusIds.isNotEmpty;
                                    // bool smokingHabitValid =
                                    //     _editPartnerExpeController
                                    //             .selectedSmokingHabit
                                    //             .value
                                    //             .id !=
                                    //         null;
                                    // bool drinkingHabitValid =
                                    //     _editPartnerExpeController
                                    //             .selectedDrinkingHabit
                                    //             .value
                                    //             .id !=
                                    //         null;
                                    bool educationValid = _educationController
                                            .selectedEducationList.length >=
                                        4;
                                    bool occupationValid = _occupationController
                                            .selectedOccupations
                                            .any((occupation) =>
                                                occupation.id == 199)
                                        ? true
                                        : _occupationController
                                                .selectedOccupations.length >=
                                            4;
                                    bool cityValid = _locationController
                                            .selectedCities.length >=
                                        4;
                                    bool statesValid = _locationController
                                        .selectedStates.isNotEmpty;
                                    bool citiesValid = _locationController
                                        .selectedCities.isNotEmpty;

                                    // Check if the form is valid and all fields are filled correctly
                                    if (_formKey.currentState!.validate()) {
                                      // Check if lengths and individual validations are correct
                                      // if (educationValid &&
                                      //     occupationValid &&
                                      //     cityValid) {
                                      //   if (manglikValid &&
                                      //       maritalStatusValid &&
                                      //       // smokingHabitValid &&
                                      //       // drinkingHabitValid &&
                                      //       statesValid &&
                                      //       citiesValid) {
                                      // Everything is valid, proceed with data submission
                                      // print(
                                      //     "Selected height id ${_editPartnerExpeController.selectedMinHeight.value} and ${_editPartnerExpeController.selectedMaxHeight.value}");
                                      // print(
                                      //     "Status: ${_editPartnerExpeController.selectedStatusIds}");
                                      // print(
                                      //     "Eployed List ${_editPartnerExpeController.selectedItemsID}");

                                      _editPartnerExpeController.sendUpdateData(
                                        minAge: _editPartnerExpeController
                                                .selectedMinAge.value.id ??
                                            null,
                                        maxAge: _editPartnerExpeController
                                                .selectedMaxAge.value.id ??
                                            null,
                                        minHeight: _editPartnerExpeController
                                                .selectedMinHeight.value.id ??
                                            null,
                                        maxHeight: _editPartnerExpeController
                                                .selectedMaxHeight.value.id ??
                                            null,
                                        // caste: _castController
                                        //     .selectedSectionList
                                        //     .where((field) =>
                                        //         field.id !=
                                        //         null) // Filter out null ids
                                        //     .map((field) => field.id!)
                                        //     .toList(),

                                        caste: _castController
                                                .selectedSectionList.isEmpty
                                            ? null
                                            : _castController
                                                .selectedSectionList
                                                .where(
                                                    (field) => field.id != null)
                                                .map((field) => field.id!)
                                                .toList(),
                                        // /*  */ section: _castController
                                        //     .selectedSectionList
                                        //     .where((field) =>
                                        //         field.id !=
                                        //         null) // Filter out null ids
                                        //     .map((field) => field.id!)
                                        //     .toList(),
                                        /*  */
                                        // subsection: _castController
                                        //     .selectedSubSectionList
                                        //     .where((field) =>
                                        //         field.id !=
                                        //         null) // Filter out null ids
                                        //     .map((field) => field.id!)
                                        //     .toList(),
                                        manglik: _editPartnerExpeController
                                                .manglikSelected.value.id ??
                                            null,
                                        // maritalStatus:
                                        //     _editPartnerExpeController
                                        //             .selectedStatusIds ??
                                        //         null,
                                        // maritalStatus:
                                        //     _editPartnerExpeController
                                        maritalStatus:
                                            _editPartnerExpeController
                                                    .selectedStatusIds.isEmpty
                                                ? null
                                                : _editPartnerExpeController
                                                    .selectedStatusIds,
                                        employedIn: _editPartnerExpeController
                                                .selectedItems.isEmpty
                                            ? null
                                            : _editPartnerExpeController
                                                .selectedItems
                                                .where((field) =>
                                                    field.id !=
                                                    null) // Filter out null ids
                                                .map((field) => field.id!)
                                                .toList(),
                                        education: _educationController
                                                .selectedEducationList.isEmpty
                                            ? null
                                            : _educationController
                                                .selectedEducationList
                                                .where((field) =>
                                                    field.id !=
                                                    null) // Filter out null ids
                                                .map((field) => field.id!)
                                                .toList(),
                                        occupation: _occupationController
                                                .selectedOccupations.isEmpty
                                            ? null
                                            : _occupationController
                                                .selectedOccupations
                                                .where((field) =>
                                                    field.id !=
                                                    null) // Filter out null ids
                                                .map((field) => field.id!)
                                                .toList(),
                                        country: _locationController
                                                .selectedCountries.isEmpty
                                            ? null
                                            : _locationController
                                                .selectedCountries
                                                .where((field) =>
                                                    field.id !=
                                                    null) // Filter out null ids
                                                .map((field) => field.id!)
                                                .toList(),
                                        state: _locationController
                                                .selectedStates.isEmpty
                                            ? null
                                            : _locationController.selectedStates
                                                .where((field) =>
                                                    field.id !=
                                                    null) // Filter out null ids
                                                .map((field) => field.id!)
                                                .toList(),
                                        city: _locationController
                                                .selectedCities.isEmpty
                                            ? null
                                            : _locationController.selectedCities
                                                .where((field) =>
                                                    field.id !=
                                                    null) // Filter out null ids
                                                .map((field) => field.id!)
                                                .toList(),
                                        minAnnualIncome:
                                            _editPartnerExpeController
                                                    .selectedMinIncome
                                                    .value
                                                    .id ??
                                                null,
                                        maxAnnualIncome:
                                            _editPartnerExpeController
                                                    .selectedMaxIncome
                                                    .value
                                                    .id ??
                                                null,
                                        // section: [],
                                        // dietaryHabits:
                                        //     _editPartnerExpeController
                                        //         .selectedEatingHabitIds,
                                        // smokingHabits:
                                        //     _editPartnerExpeController
                                        //             .selectedSmokingHabit
                                        //             .value
                                        //             .id ??
                                        //         0,
                                        // drinkingHabits:
                                        //     _editPartnerExpeController
                                        //             .selectedDrinkingHabit
                                        //             .value
                                        //             .id ??
                                        //         0,
                                      );
                                    }

                                    // else {
                                    //   /* manglikValid && maritalStatusValid && smokingHabitValid
                                    //              && drinkingHabitValid && statesValid && citiesValid*/
                                    //   // Validation failed for specific fields
                                    //   if (!manglikValid) {
                                    //     _scrollToWidget(_manglikKey);
                                    //   } else if (!maritalStatusValid) {
                                    //     _scrollToWidget(_maritialStatusKey);
                                    //   }
                                    //   // else if (!smokingHabitValid) {
                                    //   //   _scrollToWidget(
                                    //   //       _SmokingHabitKey);
                                    //   // }
                                    //   // else if (!drinkingHabitValid) {
                                    //   //   _scrollToWidget(
                                    //   //       _DrinkingHabitKey);
                                    //   // }
                                    //   //      Get.snackbar("Error", "Please fill all required fields");
                                    //   print(
                                    //       "Validation failed in habits or marital status");
                                    // }
                                    // } else {
                                    // List length validation failed
                                    //     _editPartnerExpeController
                                    //         .listLengthValidate.value = false;
                                    //     if (!educationValid) {
                                    //       _scrollToWidget(_highestDegreeKey);
                                    //     } else if (!occupationValid) {
                                    //       _scrollToWidget(_occupationKey);
                                    //     } else if (!cityValid) {
                                    //       _scrollToWidget(
                                    //           _expectedResidenceKey);
                                    //     }
                                    //     //       Get.snackbar("Error", "Please select at least 4 options in each category");
                                    //   }
                                    // }

                                    // else {
                                    //   // Form validation failed
                                    //   //   Get.snackbar("Error", "Please fill all Fields");
                                    //   if (_editPartnerExpeController
                                    //           .selectedMinAge.value.id ==
                                    //       null) {
                                    //     _scrollToWidget(_minAgeKey);
                                    //   } else if (_editPartnerExpeController
                                    //           .selectedMaxAge.value.id ==
                                    //       null) {
                                    //     _scrollToWidget(_maxAgeKey);
                                    //   } else if (_editPartnerExpeController
                                    //           .selectedMinHeight.value.id ==
                                    //       null) {
                                    //     _scrollToWidget(_minHeightKey);
                                    //   } else if (_editPartnerExpeController
                                    //           .selectedMaxHeight.value.id ==
                                    //       null) {
                                    //     _scrollToWidget(_maxHeightKey);
                                    //   } else if (_castController
                                    //       .selectedSectionList
                                    //       .where((field) =>
                                    //           field.id !=
                                    //           null) // Filter out null ids
                                    //       .map((field) => field.id!)
                                    //       .toList()
                                    //       .isEmpty) {
                                    //     _scrollToWidget(_partnerSectionKey);
                                    //   } else if (_castController
                                    //       .selectedSubSectionList
                                    //       .where((field) =>
                                    //           field.id !=
                                    //           null) // Filter out null ids
                                    //       .map((field) => field.id!)
                                    //       .toList()
                                    //       .isEmpty) {
                                    //     _scrollToWidget(_subSectionKey);
                                    //   } else if (_castController
                                    //       .selectedCasteList
                                    //       .where((field) =>
                                    //           field.id !=
                                    //           null) // Filter out null ids
                                    //       .map((field) => field.id!)
                                    //       .toList()
                                    //       .isEmpty) {
                                    //     _scrollToWidget(_casteKey);
                                    //   } else if (_editPartnerExpeController
                                    //       .manglikSelected.value.id
                                    //       .toString()
                                    //       .isEmpty) {
                                    //     _scrollToWidget(_manglikKey);
                                    //   } else if (_editPartnerExpeController
                                    //       .selectedStatusIds.isEmpty) {
                                    //     _scrollToWidget(_maritialStatusKey);
                                    //   } else if (_editPartnerExpeController.selectedItems
                                    //       .where((field) => field.id != null) // Filter out null ids
                                    //       .map((field) => field.id!)
                                    //       .toList()
                                    //       .isEmpty) {
                                    //     _scrollToWidget(_employedInKey);
                                    //   } else if (_educationController.selectedEducationList
                                    //       .where((field) => field.id != null) // Filter out null ids
                                    //       .map((field) => field.id!)
                                    //       .toList()
                                    //       .isEmpty) {
                                    //     _scrollToWidget(_highestDegreeKey);
                                    //   } else if (_occupationController.selectedOccupations
                                    //       .where((field) => field.id != null) // Filter out null ids
                                    //       .map((field) => field.id!)
                                    //       .toList()
                                    //       .isEmpty) {
                                    //     _scrollToWidget(_occupationKey);
                                    //   }
                                    //   // new
                                    //   else if (_editPartnerExpeController
                                    //           .selectedMinIncome.value.id ==
                                    //       null) {
                                    //     _scrollToWidget(_MinIncomeKey);
                                    //   } else if (_editPartnerExpeController
                                    //           .selectedMaxIncome.value.id ==
                                    //       null) {
                                    //     _scrollToWidget(_MaxIncomeKey);
                                    //   } else if (_locationController
                                    //       .selectedCities
                                    //       .where((field) =>
                                    //           field.id !=
                                    //           null) // Filter out null ids
                                    //       .map((field) => field.id!)
                                    //       .toList()
                                    //       .isEmpty) {
                                    //     _scrollToWidget(_expectedResidenceKey);
                                    //   } else if (_editPartnerExpeController
                                    //       .selectedEatingHabitIds.isEmpty) {
                                    //     _scrollToWidget(_dietryHabitKey);
                                    //   } else if (_locationController
                                    //       .selectedCities
                                    //       .where((field) =>
                                    //           field.id !=
                                    //           null) // Filter out null ids
                                    //       .map((field) => field.id!)
                                    //       .toList()
                                    //       .isEmpty) {
                                    //     _scrollToWidget(_expectedResidenceKey);
                                    //   } else if (_editPartnerExpeController
                                    //           .selectedSmokingHabit.value.id ==
                                    //       null) {
                                    //     _scrollToWidget(_SmokingHabitKey);
                                    //   } else if (_editPartnerExpeController
                                    //           .selectedDrinkingHabit.value.id ==
                                    //       null) {
                                    //     _scrollToWidget(_DrinkingHabitKey);
                                    //   }
                                    // }
                                  } catch (e, stackTrace) {
                                    print('Error occurred: $e');
                                    //    Get.snackbar("Error", "An error occurred during submission");
                                    print(stackTrace);
                                  }
                                },
                                child: Obx(() {
                                  return _editPartnerExpeController
                                          .isLoading.value
                                      ? const CircularProgressIndicator(
                                          color: Colors
                                              .white, // Set the indicator color if needed
                                        )
                                      : Text(AppLocalizations.of(context)!.save,
                                          style:
                                              CustomTextStyle.elevatedButton);
                                }),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(
                          height: 10,
                        ),

                        RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(children: <TextSpan>[
                            const TextSpan(
                              text: "()",
                            ),
                            const TextSpan(
                              text: "*",
                              style: TextStyle(color: Colors.red),
                            ),
                            const TextSpan(
                              text: ")",
                            ),
                            TextSpan(
                              text: AppLocalizations.of(context)!
                                  .pleasefillallfieldsmarkedwith,
                              style: CustomTextStyle.bodytext
                                  .copyWith(fontSize: 12),
                            ),
                          ]),
                        ),
                        // ElevatedButton(
                        //     onPressed: () {
                        //       sharedPreferences?.setString(
                        //           "PageIndex", "5");
                        //       navigatorKey.currentState!
                        //           .push(MaterialPageRoute(
                        //         builder: (context) =>
                        //             const UserInfoStepFour(),
                        //       ));
                        //     },
                        //     child: const Text("NEXT PAGE"))
                      ],
                    ),
                  ),
                )
              ],
            ),
            //     }
            //   },
            // ),
          ),
        ),
      ),
    );
  }

  void _showMultiSelectBottomSheet(BuildContext context) {
    _editPartnerExpeController.fetchemployeedInFromApi();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          width: double.infinity,
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(AppLocalizations.of(context)!.employedIn,
                    style: CustomTextStyle.bodytextboldLarge),
                const SizedBox(height: 10),
                Obx(
                  () {
                    // Show shimmer effect while data is being loaded
                    if (_editPartnerExpeController.isloading.value) {
                      return Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: List.generate(
                              6,
                              (index) => Chip(
                                    label: Container(
                                      width: 60,
                                      height: 20,
                                      color: Colors.grey,
                                    ),
                                  )),
                        ),
                      );
                    } else {
                      // Check if all items are selected
                      final isAllSelected =
                          _editPartnerExpeController.employedInList.length ==
                              _editPartnerExpeController.selectedItems.length;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // "Select All" chip at the top
                          ChoiceChip(
                            checkmarkColor: Colors.white,
                            labelPadding: const EdgeInsets.all(4),
                            label: Text(
                              AppLocalizations.of(context)!.selectall,
                              style: CustomTextStyle.bodytext.copyWith(
                                fontSize: 14,
                                color: isAllSelected
                                    ? Colors.white
                                    : AppTheme.secondryColor,
                              ),
                            ),
                            selected: isAllSelected,
                            onSelected: (bool selected) {
                              if (selected) {
                                _editPartnerExpeController.selectAllItems();
                              } else {
                                _editPartnerExpeController.clearAllSelections();
                              }
                            },
                            selectedColor: AppTheme.selectedOptionColor,
                            backgroundColor: AppTheme.lightPrimaryColor,
                            labelStyle: CustomTextStyle.bodytext.copyWith(
                              fontSize: 14,
                              color: isAllSelected
                                  ? Colors.white
                                  : AppTheme.secondryColor,
                            ),
                          ),
                          const SizedBox(height: 10),

                          // Display the actual data once loaded
                          Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children: _editPartnerExpeController.employedInList
                                .map((item) {
                              final isSelected = _editPartnerExpeController
                                  .selectedItems
                                  .any((selectedItem) =>
                                      selectedItem.id == item.id);
                              return ChoiceChip(
                                labelPadding: const EdgeInsets.all(4),
                                checkmarkColor: Colors.white,
                                backgroundColor: AppTheme.lightPrimaryColor,
                                label: Text(
                                  item.name ?? "",
                                  style: CustomTextStyle.bodytext.copyWith(
                                    fontSize: 14,
                                    color: isSelected
                                        ? Colors.white
                                        : AppTheme.secondryColor,
                                  ),
                                ),
                                selected: isSelected,
                                onSelected: (bool selected) {
                                  _editPartnerExpeController
                                      .toggleSelection(item);
                                },
                                selectedColor: AppTheme.selectedOptionColor,
                                labelStyle: CustomTextStyle.bodytext.copyWith(
                                  fontSize: 14,
                                  color: isSelected
                                      ? Colors.white
                                      : AppTheme.secondryColor,
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      );
                    }
                  },
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  side: const BorderSide(color: Colors.red)),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text(
                                AppLocalizations.of(context)!.cancel,
                                style: CustomTextStyle.elevatedButton
                                    .copyWith(color: Colors.red),
                              ))),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            AppLocalizations.of(context)!.done,
                            style: CustomTextStyle.elevatedButton,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  void _showOccupationBottomSheet(BuildContext context) {
    final OccupationController occupationController =
        Get.put(OccupationController());
    occupationController.fetchOccupationFromApi();
    TextEditingController searchController = TextEditingController();
    final GlobalKey<FormState> formKeyOccupation = GlobalKey<FormState>();
    String? language = sharedPreferences?.getString("Language");

    showModalBottomSheet(
      context: context,
      isDismissible:
          occupationController.selectedOccupations.length < 4 ? false : true,
      enableDrag:
          occupationController.selectedOccupations.length < 4 ? false : true,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async {
            if (formKeyOccupation.currentState!.validate()) {
              Navigator.pop(context);
            }
            return false;
          },
          child: Form(
            key: formKeyOccupation,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.9,
              width: double.infinity,
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Center(
                      child: Text(
                          textAlign: TextAlign.center,
                          AppLocalizations.of(context)!
                              .partnerExpectedOccupationSmall,
                          // "Partner's Expected Occupation",
                          style: CustomTextStyle.bodytextboldLarge),
                    ),
                    Center(
                      child: Text(
                          textAlign: TextAlign.center,
                          AppLocalizations.of(context)!
                              .pleaseSelectAtLeast4Occupation,
                          style: CustomTextStyle.bodytextSmall),
                    ),
                    const SizedBox(height: 10),

                    // Search Field
                    Center(
                      child: TextFormField(
                        //   inputFormatters:  [FilteringTextInputFormatter.allow(RegExp(r'^[a-zA-Z0-9 .,!?]*$'))]
                        // Allow only Marathi
                        style: CustomTextStyle.bodytext,
                        controller: searchController,
                        decoration: InputDecoration(
                          hintText: language == "en"
                              ? "Search Occupation"
                              : "व्यवसाय शोधा",
                          contentPadding: const EdgeInsets.all(20),
                          hintStyle: CustomTextStyle.hintText,
                          filled: true,
                          fillColor: Colors.white,
                          suffixIcon:
                              Icon(Icons.search, color: Colors.grey.shade500),
                          border: OutlineInputBorder(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(5)),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(5)),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(5)),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(5)),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                        ),
                        validator: (value) {
                          if (_occupationController.selectedOccupations
                              .any((occupation) => occupation.id == 199)) {
                            return null;
                          } else if (occupationController
                                  .selectedOccupations.length <
                              4) {
                            return AppLocalizations.of(context)!
                                .pleaseSelectAtLeast4Occupation;
                          }
                          return null;
                        },

                        onChanged: (query) {
                          occupationController.searchOccupation(
                              query); // Add search function to filter occupation list
                        },
                      ),
                    ),
                    Obx(() {
                      if (occupationController.selectedOccupations.isNotEmpty) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 12.0, bottom: 4),
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(5)),
                                border: Border.all(
                                    color: AppTheme.dividerDarkColor,
                                    width: 1)),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Wrap(
                                    direction: Axis.horizontal,
                                    alignment: WrapAlignment.start,
                                    crossAxisAlignment:
                                        WrapCrossAlignment.start,
                                    spacing:
                                        10, // Spacing between chips horizontally
                                    runSpacing:
                                        10, // Spacing between rows vertically
                                    children: [
                                      ...List.generate(
                                        occupationController.selectedOccupations
                                                    .length >
                                                2
                                            ? 2
                                            : occupationController
                                                .selectedOccupations.length,
                                        (index) {
                                          final item = occupationController
                                              .selectedOccupations[index];
                                          return Chip(
                                            deleteIcon: const Padding(
                                              padding: EdgeInsets.all(0),
                                              child:
                                                  Icon(Icons.close, size: 12),
                                            ),
                                            padding: const EdgeInsets.all(2),
                                            labelPadding:
                                                const EdgeInsets.all(4),
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
                                              // Handle onDeleted functionality
                                              _occupationController
                                                  .toggleOccupationSelection(
                                                      item);
                                            },
                                          );
                                        },
                                      ),
                                      Obx(() {
                                        if (occupationController
                                                .selectedOccupations.length <=
                                            2) {
                                          return const SizedBox();
                                        } else {
                                          return GestureDetector(
                                            onTap: () {
                                              showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  occupationController
                                                      .selectedOccupationsTemp
                                                      .clear();

                                                  occupationController
                                                      .selectedOccupationsTemp
                                                      .value
                                                      .addAll(occupationController
                                                          .selectedOccupations
                                                          .where((newItem) =>
                                                              !occupationController
                                                                  .selectedOccupationsTemp
                                                                  .any((existingItem) =>
                                                                      existingItem
                                                                          .id ==
                                                                      newItem
                                                                          .id)));
                                                  return ShowAllExpectedOccupation(
                                                      items: _occupationController
                                                          .selectedOccupationsTemp);
                                                },
                                              );
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 2, top: 12.0),
                                              child: Text(
                                                "${language == "en" ? "View" : "बघा"} (+${occupationController.selectedOccupations.length - 2})",
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
                                      }),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      } else {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(5)),
                                border: Border.all(
                                    color: AppTheme.dividerDarkColor,
                                    width: 1)),
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
                      }
                    }),

                    Obx(() {
                      if (occupationController.isloading.value) {
                        return Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: List.generate(10, (index) {
                            return Shimmer.fromColors(
                              baseColor: Colors.grey[300]!,
                              highlightColor: Colors.grey[100]!,
                              child: ChoiceChip(
                                label: Container(
                                  width: 50,
                                  height: 20,
                                  color: Colors.grey[300],
                                ),
                                selected: false,
                                onSelected: (_) {},
                              ),
                            );
                          }),
                        );
                      }

                      if (occupationController.filteredEducationList.isEmpty) {
                        return const Center(child: Text('No data found'));
                      }

                      return Flexible(
                        child: ListView.builder(
                          itemCount:
                              occupationController.filteredEducationList.length,
                          itemBuilder: (context, index) {
                            var occupation = occupationController
                                .filteredEducationList[index];
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        occupation.name ?? "",
                                        style: CustomTextStyle.fieldName,
                                        overflow: TextOverflow
                                            .ellipsis, // Handles overflow with ellipsis
                                        maxLines:
                                            1, // Ensure the text stays on one line
                                      ),
                                    ),
                                    Obx(() {
                                      final allSelected = occupation.value
                                              ?.every((field) =>
                                                  occupationController
                                                      .selectedOccupations
                                                      .any((element) =>
                                                          element.id ==
                                                          field.id)) ??
                                          false;
                                      return Checkbox(
                                        checkColor: Colors.white,
                                        activeColor:
                                            AppTheme.selectedOptionColor,
                                        value: allSelected,
                                        onChanged: (isSelected) {
                                          if (isSelected == true) {
                                            occupationController
                                                .selectAll(occupation.value!);
                                          } else {
                                            occupationController.clearSelection(
                                                occupation.value!);
                                          }
                                        },
                                      );
                                    }),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Wrap(
                                  spacing: 10,
                                  runSpacing: 10,
                                  children: occupation.value?.map((e) {
                                        return Obx(() {
                                          final isSelected =
                                              occupationController
                                                  .selectedOccupations
                                                  .any((element) =>
                                                      element.id == e.id);
                                          return ChoiceChip(
                                            labelPadding:
                                                const EdgeInsets.all(4),
                                            checkmarkColor: Colors.white,
                                            disabledColor:
                                                AppTheme.lightPrimaryColor,
                                            backgroundColor:
                                                AppTheme.lightPrimaryColor,
                                            label: Text(
                                              e.name ?? "",
                                              style: CustomTextStyle.bodytext
                                                  .copyWith(
                                                fontSize: 14,
                                                color: isSelected
                                                    ? AppTheme.lightPrimaryColor
                                                    : AppTheme
                                                        .selectedOptionColor,
                                              ),
                                            ),
                                            selected: isSelected,
                                            onSelected: (bool selected) {
                                              occupationController
                                                  .toggleOccupationSelection(e);
                                            },
                                            selectedColor:
                                                AppTheme.selectedOptionColor,
                                            labelStyle: CustomTextStyle.bodytext
                                                .copyWith(
                                              fontSize: 14,
                                              color: isSelected
                                                  ? Colors.white
                                                  : AppTheme.secondryColor,
                                            ),
                                          );
                                        });
                                      }).toList() ??
                                      [],
                                ),
                                const SizedBox(height: 20),
                              ],
                            );
                          },
                        ),
                      );
                    }),

                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      side:
                                          const BorderSide(color: Colors.red)),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    AppLocalizations.of(context)!.cancel,
                                    style: CustomTextStyle.elevatedButton
                                        .copyWith(color: Colors.red),
                                  ))),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                if (formKeyOccupation.currentState!
                                    .validate()) {
                                  Navigator.pop(context);
                                }
                              },
                              child: Text(
                                AppLocalizations.of(context)!.done,
                                style: CustomTextStyle.elevatedButton,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

// Define the controller outside the function to avoid reinitialization
  final EducationController educationController =
      Get.put(EducationController());
  String? language = sharedPreferences?.getString("Language");

  void _showEducationBottomSheet(BuildContext context) {
    educationController.fetcheducationFromApi();
    final GlobalKey<FormState> formKeyEducation = GlobalKey<FormState>();

    showModalBottomSheet(
      context: context,
      isDismissible:
          educationController.selectedEducationList.length < 4 ? false : true,
      enableDrag:
          educationController.selectedEducationList.length < 4 ? false : true,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async {
            if (educationController.selectedEducationList.length < 4) {
              if (formKeyEducation.currentState!.validate()) {
                Navigator.pop(context);
              }
            } else {
              Navigator.pop(context);
            }
            return false;
          },
          child: Form(
            key: formKeyEducation,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.9,
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.partnerExpectededucation,
                      style: CustomTextStyle.bodytextboldLarge,
                    ),
                    Text(
                      // "please select at least 4 education",
                      AppLocalizations.of(context)!
                          .pleaseSelectAtLeast4Education,
                      style: CustomTextStyle.bodytextSmall,
                    ),
                    const SizedBox(height: 10),

                    // Search TextField
                    TextFormField(
                      validator: (value) {
                        if (_educationController.selectedEducationList.length <
                            4) {
                          return AppLocalizations.of(context)!
                              .pleaseSelectAtLeast4Education;
                        }
                        return null;
                      },
                      onChanged: (value) {
                        educationController.searchQuery.value = value;
                        educationController.filterEducationList();
                      },
                      style: CustomTextStyle.bodytext,
                      decoration: InputDecoration(
                        hintText: language == "en"
                            ? "Search Education"
                            : "शिक्षण निवडा",
                        contentPadding: const EdgeInsets.all(20),
                        hintStyle: CustomTextStyle.hintText,
                        filled: true,
                        fillColor: Colors.white,
                        suffixIcon:
                            Icon(Icons.search, color: Colors.grey.shade500),
                        errorBorder: OutlineInputBorder(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(5)),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        border: OutlineInputBorder(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(5)),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(5)),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(5)),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Scrollable Content
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Obx(() {
                            if (educationController
                                .selectedEducationList.isNotEmpty) {
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(5)),
                                      border: Border.all(
                                          color: AppTheme.dividerDarkColor,
                                          width: 1)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Wrap(
                                          direction: Axis.horizontal,
                                          alignment: WrapAlignment.start,
                                          crossAxisAlignment:
                                              WrapCrossAlignment.start,
                                          spacing:
                                              10, // Spacing between chips horizontally
                                          runSpacing:
                                              10, // Spacing between rows vertically
                                          children: [
                                            ...List.generate(
                                              educationController
                                                          .selectedEducationList
                                                          .length >
                                                      2
                                                  ? 2
                                                  : educationController
                                                      .selectedEducationList
                                                      .length,
                                              (index) {
                                                final item = educationController
                                                        .selectedEducationList[
                                                    index];
                                                return Chip(
                                                  deleteIcon: const Padding(
                                                    padding: EdgeInsets.all(0),
                                                    child: Icon(Icons.close,
                                                        size: 12),
                                                  ),
                                                  padding:
                                                      const EdgeInsets.all(2),
                                                  labelPadding:
                                                      const EdgeInsets.all(4),
                                                  backgroundColor: AppTheme
                                                      .lightPrimaryColor,
                                                  side: const BorderSide(
                                                    style: BorderStyle.none,
                                                    color: Colors.blue,
                                                  ),
                                                  label: Text(
                                                    item.name ?? "",
                                                    style: CustomTextStyle
                                                        .bodytext
                                                        .copyWith(fontSize: 11),
                                                  ),
                                                  onDeleted: () {
                                                    // Handle onDeleted functionality
                                                  },
                                                );
                                              },
                                            ),
                                            Obx(() {
                                              if (educationController
                                                      .selectedEducationList
                                                      .length <=
                                                  2) {
                                                return const SizedBox();
                                              } else {
                                                return GestureDetector(
                                                  onTap: () {
                                                    showDialog(
                                                      context: context,
                                                      builder: (BuildContext
                                                          context) {
                                                        _educationController
                                                            .selectedEducationListTemp
                                                            .clear();

                                                        _educationController
                                                            .selectedEducationListTemp
                                                            .value
                                                            .addAll(_educationController
                                                                .selectedEducationList
                                                                .where((newItem) => !_educationController
                                                                    .selectedEducationListTemp
                                                                    .any((existingItem) =>
                                                                        existingItem
                                                                            .id ==
                                                                        newItem
                                                                            .id)));
                                                        return ShowAllExpectedEducation(
                                                          items: _educationController
                                                              .selectedEducationListTemp,
                                                        );
                                                      },
                                                    );
                                                  },
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            bottom: 2,
                                                            top: 12.0),
                                                    child: Text(
                                                      "${language == "en" ? "View" : "बघा"} (+${educationController.selectedEducationList.length - 2})",
                                                      style: CustomTextStyle
                                                          .bodytext
                                                          .copyWith(
                                                        color: AppTheme
                                                            .selectedOptionColor,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              }
                                            }),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            } else {
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(5)),
                                      border: Border.all(
                                          color: AppTheme.dividerDarkColor,
                                          width: 1)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          AppLocalizations.of(context)!
                                              .selectvisible,
                                          style: CustomTextStyle.hintText,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }
                          }),
                          Expanded(
                            child: SingleChildScrollView(
                              child: Obx(() {
                                if (educationController.isloading.value) {
                                  return Wrap(
                                    spacing: 10,
                                    runSpacing: 10,
                                    children: List.generate(10, (index) {
                                      return Shimmer.fromColors(
                                        baseColor: Colors.grey[300]!,
                                        highlightColor: Colors.grey[100]!,
                                        child: ChoiceChip(
                                          label: Container(
                                            width: 50,
                                            height: 20,
                                            color: Colors.grey[300],
                                          ),
                                          selected: false,
                                          onSelected: (_) {},
                                        ),
                                      );
                                    }),
                                  );
                                }

                                if (educationController
                                    .filteredEducationList.isEmpty) {
                                  return const Center(
                                      child: Text('No data found'));
                                }

                                return ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: educationController
                                      .filteredEducationList.length,
                                  itemBuilder: (context, index) {
                                    var education = educationController
                                        .filteredEducationList[index];
                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Text(
                                                education.name ?? "",
                                                style:
                                                    CustomTextStyle.fieldName,
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                              ),
                                            ),
                                            Obx(() {
                                              final allSelected = education
                                                      .value
                                                      ?.every((field) =>
                                                          educationController
                                                              .selectedEducationList
                                                              .any((element) =>
                                                                  element.id ==
                                                                  field.id)) ??
                                                  false;
                                              return Checkbox(
                                                checkColor: Colors.white,
                                                activeColor: AppTheme
                                                    .selectedOptionColor,
                                                value: allSelected,
                                                onChanged: (isSelected) {
                                                  if (isSelected == true) {
                                                    educationController
                                                        .selectAll(
                                                            education.value!);
                                                  } else {
                                                    educationController
                                                        .clearSelection(
                                                            education.value!);
                                                  }
                                                },
                                              );
                                            }),
                                          ],
                                        ),
                                        const SizedBox(height: 10),
                                        Wrap(
                                          spacing: 10,
                                          runSpacing: 10,
                                          children: education.value
                                                  ?.map((field) {
                                                return Obx(() {
                                                  final isSelected =
                                                      educationController
                                                          .selectedEducationList
                                                          .any((element) =>
                                                              element.id ==
                                                              field.id);
                                                  return ChoiceChip(
                                                    labelPadding:
                                                        const EdgeInsets.all(4),
                                                    label: Text(
                                                      field.name ?? "",
                                                      style: CustomTextStyle
                                                          .bodytext
                                                          .copyWith(
                                                        fontSize: 14,
                                                        color: isSelected
                                                            ? Colors.white
                                                            : AppTheme
                                                                .secondryColor,
                                                      ),
                                                    ),
                                                    selected: isSelected,
                                                    backgroundColor: AppTheme
                                                        .lightPrimaryColor,
                                                    selectedColor: AppTheme
                                                        .selectedOptionColor,
                                                    checkmarkColor:
                                                        Colors.white,
                                                    onSelected:
                                                        (bool selected) {
                                                      if (selected) {
                                                        educationController
                                                            .selectedEducationList
                                                            .add(field);
                                                        educationController
                                                            .selectedEducationList
                                                            .sort(
                                                          (a, b) => (a.name
                                                                      ?.length ??
                                                                  0)
                                                              .compareTo(b.name
                                                                      ?.length ??
                                                                  0),
                                                        );
                                                      } else {
                                                        educationController
                                                            .selectedEducationList
                                                            .removeWhere(
                                                                (item) =>
                                                                    item.id ==
                                                                    field.id);
                                                      }
                                                    },
                                                  );
                                                });
                                              }).toList() ??
                                              [],
                                        ),
                                        const SizedBox(height: 20),
                                      ],
                                    );
                                  },
                                );
                              }),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Submit Button
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      side:
                                          const BorderSide(color: Colors.red)),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    AppLocalizations.of(context)!.cancel,
                                    style: CustomTextStyle.elevatedButton
                                        .copyWith(color: Colors.red),
                                  ))),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                if (formKeyEducation.currentState!.validate()) {
                                  Navigator.pop(context);
                                }
                              },
                              child: Text(
                                AppLocalizations.of(context)!.done,
                                style: CustomTextStyle.elevatedButton,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    /*   Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                print("checking");
                
              /*  if (educationController.selectedEducationList.length < 4) {
                  showCustomSnackBar(
                    context,
                    'Kindly Select at least 4 options',
                    '',
                    'assets/error.png',
                  );
                } else {
                  Navigator.pop(context);
                }*/
              },
              child: const Text(
                "Done",
                style: CustomTextStyle.elevatedButton,
              ),
            ),
          ),*/
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _showSectionBottomSheet(BuildContext context) {
    final CastController castController = Get.put(CastController());
    // Fetch Section data when modal opens
    castController.fetchSectionFromApi();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          width: double.infinity,
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(AppLocalizations.of(context)!.selectsubcaste,
                    style: CustomTextStyle.bodytextboldLarge),
                Text(AppLocalizations.of(context)!.youCanSelectMultipleOptions,
                    style: CustomTextStyle.bodytextSmall),
                const SizedBox(height: 10),

                // Use Obx to listen for changes in fetched data and loading state
                Obx(() {
                  if (castController.isloading.value) {
                    return Wrap(
                      spacing: 10,
                      direction: Axis.vertical,
                      runSpacing: 10,
                      children: List.generate(3, (index) {
                        return Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: ChoiceChip(
                            label: Container(
                              width: 50,
                              height: 20,
                              color: Colors
                                  .grey[300], // Placeholder color for shimmer
                            ),
                            selected: false,
                            onSelected: (_) {},
                          ),
                        );
                      }),
                    );
                  }

                  if (castController.sectionList.isEmpty) {
                    return const Center(
                        child:
                            Text('No data found')); // Show message if no data
                  }

                  // Display the fetched list of items in ChoiceChips (multiple can be selected)
                  return Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: castController.sectionList.map((FieldModel item) {
                      // Check if the current section ID is in the selectedSectionInt list
                      final isSelected = castController.selectedSectionList
                          .any((selectedItem) => selectedItem.id == item.id);

                      return ChoiceChip(
                        labelPadding: const EdgeInsets.all(4),
                        checkmarkColor: Colors.white,
                        disabledColor: AppTheme.lightPrimaryColor,
                        backgroundColor: AppTheme.lightPrimaryColor,
                        label: Text(
                          item.name ?? "", // Display FieldModel name
                          style: CustomTextStyle.bodytext.copyWith(
                            fontSize: 14,
                            color: isSelected
                                ? AppTheme.lightPrimaryColor
                                : AppTheme.selectedOptionColor,
                          ),
                        ),
                        selected: isSelected,
                        onSelected: (bool selected) {
                          if (selected) {
                            // Add the item ID to the selectedSectionInt list if selected
                            castController.selectedSectionList.add(item);
                          } else {
                            // Remove the item ID from the selectedSectionInt list if deselected
                            //        castController.selectedSectionList.remove(item);
                            castController.selectedSectionList.removeWhere(
                                (selectedItem) => selectedItem.id == item.id);

                            print("elemnt key ${item.id}");
                            castController.selectedSubSectionList.removeWhere(
                              (element) => element.foreignKey == item.id,
                            );
                            castController.selectedCasteList.removeWhere(
                              (element) => element.foreignKey == item.id,
                            );
                          }
                        },
                        selectedColor: AppTheme.selectedOptionColor,
                        labelStyle: CustomTextStyle.bodytext.copyWith(
                          fontSize: 14,
                          color: isSelected
                              ? Colors.white
                              : AppTheme.secondryColor,
                        ),
                      );
                    }).toList(),
                  );
                }),

                const SizedBox(height: 20),

                // Done button to close the modal
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                side: const BorderSide(color: Colors.red)),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              AppLocalizations.of(context)!.cancel,
                              style: CustomTextStyle.elevatedButton
                                  .copyWith(color: Colors.red),
                            ))),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          AppLocalizations.of(context)!.done,
                          style: CustomTextStyle.elevatedButton,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  void _showSubSectionBottomSheet(BuildContext context) {
    final CastController castController = Get.put(CastController());

    // Fetch Section data when modal opens
    castController.fetchMultiSectionFromApi();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height * 0.7,
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Center(
                      child: Text("Select Sub Section",
                          style: CustomTextStyle.bodytextboldLarge),
                    ),
                    Center(
                      child: Text(
                          AppLocalizations.of(context)!
                              .youCanSelectMultipleOptions,
                          style: CustomTextStyle.bodytextSmall),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  // Make the modal scrollable
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Obx(() {
                      if (castController.isloading.value) {
                        return Wrap(
                          spacing: 10,
                          direction: Axis.vertical,
                          runSpacing: 10,
                          children: List.generate(3, (index) {
                            return Shimmer.fromColors(
                              baseColor: Colors.grey[300]!,
                              highlightColor: Colors.grey[100]!,
                              child: ChoiceChip(
                                label: Container(
                                  width: 50,
                                  height: 20,
                                  color: Colors.grey[
                                      300], // Placeholder color for shimmer
                                ),
                                selected: false,
                                onSelected: (_) {},
                              ),
                            );
                          }),
                        );
                      }

                      if (castController.sectionMultiList.isEmpty) {
                        return const Center(
                            child: Text(
                                'No data found')); // Show message if no data
                      }

                      // Function to check if all items are selected
                      bool allSelected(List<CasteMultiSelectModel> section) {
                        return section.every((item) => castController
                            .selectedSubSectionList
                            .any((selectedItem) => selectedItem.id == item.id));
                      }

                      // Display the fetched list of items in ChoiceChips (multiple can be selected)
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // For ForeignKey 1
                          castController.sectionFKone.isNotEmpty
                              ? const Text("Shvetambar",
                                  style: CustomTextStyle.bodytextboldLarge)
                              : const SizedBox(),
                          const SizedBox(height: 5),
                          // Select All chip for Shvetambar
                          castController.sectionFKone.isNotEmpty
                              ? ChoiceChip(
                                  labelPadding: const EdgeInsets.all(4),
                                  checkmarkColor: Colors.white,
                                  disabledColor: AppTheme.lightPrimaryColor,
                                  backgroundColor: AppTheme.lightPrimaryColor,
                                  label:
                                      allSelected(castController.sectionFKone)
                                          ? const Text("Disselect All")
                                          : const Text("Select All"),
                                  selected:
                                      allSelected(castController.sectionFKone),
                                  onSelected: (bool selected) {
                                    if (selected) {
                                      castController.selectedSubSectionList
                                          .addAll(castController.sectionFKone);
                                    } else {
                                      castController.selectedSubSectionList
                                          .removeWhere((item) =>
                                              castController.sectionFKone.any(
                                                (element) =>
                                                    element.id == item.id,
                                              ));
                                    }
                                  },
                                  selectedColor: AppTheme.selectedOptionColor,
                                  labelStyle: CustomTextStyle.bodytext.copyWith(
                                    fontSize: 14,
                                    color:
                                        allSelected(castController.sectionFKone)
                                            ? Colors.white
                                            : AppTheme.secondryColor,
                                  ),
                                )
                              : const SizedBox(),
                          const SizedBox(height: 10),
                          Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children: castController.sectionFKone
                                .map((CasteMultiSelectModel item) {
                              final isSelected =
                                  castController.selectedSubSectionList.any(
                                (element) => element.id == item.id,
                              );
                              return ChoiceChip(
                                labelPadding: const EdgeInsets.all(4),
                                checkmarkColor: Colors.white,
                                disabledColor: AppTheme.lightPrimaryColor,
                                backgroundColor: AppTheme.lightPrimaryColor,
                                label: Text(
                                  item.name ?? "", // Display FieldModel name
                                  style: CustomTextStyle.bodytext.copyWith(
                                    fontSize: 14,
                                    color: isSelected
                                        ? Colors.white
                                        : AppTheme.selectedOptionColor,
                                  ),
                                ),
                                selected: isSelected,
                                onSelected: (bool selected) {
                                  if (selected) {
                                    print("print selected");

                                    // Add the item to the selectedSubSectionList if it's not already in the list
                                    if (!castController.selectedSubSectionList
                                        .any((element) =>
                                            element.id == item.id)) {
                                      castController.selectedSubSectionList
                                          .add(item);
                                    }
                                  } else {
                                    // Remove the specific item from the selectedSubSectionList by matching the id
                                    castController.selectedSubSectionList
                                        .removeWhere((selectedItem) =>
                                            selectedItem.id == item.id);
                                  }
                                },
                                selectedColor: AppTheme.selectedOptionColor,
                                labelStyle: CustomTextStyle.bodytext.copyWith(
                                  fontSize: 14,
                                  color: isSelected
                                      ? Colors.white
                                      : AppTheme.secondryColor,
                                ),
                              );
                            }).toList(),
                          ),

                          const SizedBox(height: 20),

                          // For ForeignKey 2
                          castController.sectionFKtwo.isNotEmpty
                              ? const Text("Digambar",
                                  style: CustomTextStyle.bodytextboldLarge)
                              : const SizedBox(),
                          const SizedBox(height: 5),
                          // Select All chip for Digambar
                          castController.sectionFKtwo.isNotEmpty
                              ? ChoiceChip(
                                  labelPadding: const EdgeInsets.all(4),
                                  checkmarkColor: Colors.white,
                                  disabledColor: AppTheme.lightPrimaryColor,
                                  backgroundColor: AppTheme.lightPrimaryColor,
                                  label:
                                      allSelected(castController.sectionFKtwo)
                                          ? const Text("Disselect All")
                                          : const Text("Select All"),
                                  selected:
                                      allSelected(castController.sectionFKtwo),
                                  onSelected: (bool selected) {
                                    if (selected) {
                                      castController.selectedSubSectionList
                                          .addAll(castController.sectionFKtwo);
                                    } else {
                                      castController.selectedSubSectionList
                                          .removeWhere((item) =>
                                              castController.sectionFKtwo.any(
                                                (element) =>
                                                    element.id == item.id,
                                              ));
                                    }
                                  },
                                  selectedColor: AppTheme.selectedOptionColor,
                                  labelStyle: CustomTextStyle.bodytext.copyWith(
                                    fontSize: 14,
                                    color:
                                        allSelected(castController.sectionFKtwo)
                                            ? Colors.white
                                            : AppTheme.secondryColor,
                                  ),
                                )
                              : const SizedBox(),
                          const SizedBox(height: 10),
                          Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children: castController.sectionFKtwo
                                .map((CasteMultiSelectModel item) {
                              final isSelected =
                                  castController.selectedSubSectionList.any(
                                (element) => element.id == item.id,
                              );
                              return ChoiceChip(
                                labelPadding: const EdgeInsets.all(4),
                                checkmarkColor: Colors.white,
                                disabledColor: AppTheme.lightPrimaryColor,
                                backgroundColor: AppTheme.lightPrimaryColor,
                                label: Text(
                                  item.name ?? "", // Display FieldModel name
                                  style: CustomTextStyle.bodytext.copyWith(
                                    fontSize: 14,
                                    color: isSelected
                                        ? Colors.white
                                        : AppTheme.selectedOptionColor,
                                  ),
                                ),
                                selected: isSelected,
                                onSelected: (bool selected) {
                                  if (selected) {
                                    print("print selected");

                                    // Add the item to the selectedSubSectionList if it's not already in the list
                                    if (!castController.selectedSubSectionList
                                        .any((element) =>
                                            element.id == item.id)) {
                                      castController.selectedSubSectionList
                                          .add(item);
                                    }
                                  } else {
                                    // Remove the specific item from the selectedSubSectionList by matching the id
                                    castController.selectedSubSectionList
                                        .removeWhere((selectedItem) =>
                                            selectedItem.id == item.id);
                                  }
                                },
                                selectedColor: AppTheme.selectedOptionColor,
                                labelStyle: CustomTextStyle.bodytext.copyWith(
                                  fontSize: 14,
                                  color: isSelected
                                      ? Colors.white
                                      : AppTheme.secondryColor,
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      );
                    }),
                  ),
                ),
              ),

              // Done button to close the modal
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                side: const BorderSide(color: Colors.red)),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              AppLocalizations.of(context)!.cancel,
                              style: CustomTextStyle.elevatedButton
                                  .copyWith(color: Colors.red),
                            ))),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          AppLocalizations.of(context)!.done,
                          style: CustomTextStyle.elevatedButton,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }

  void _showCasteBottomSheet(BuildContext context) {
    final CastController castController = Get.put(CastController());

    // Fetch Section data when modal opens
    castController.fetchMultiCasteFromApi();
    bool allSelected(List<CasteMultiSelectModel> section) {
      return section.every((item) => castController.selectedCasteList
          .any((selectedItem) => selectedItem.id == item.id));
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height * 0.7,
          color: Colors.white,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text("Select Caste",
                        style: CustomTextStyle.bodytextboldLarge),
                    Text(
                        AppLocalizations.of(context)!
                            .youCanSelectMultipleOptions,
                        style: CustomTextStyle.bodytextSmall),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  // Make the modal scrollable
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Obx(() {
                      if (castController.isloading.value) {
                        return Wrap(
                          spacing: 10,
                          direction: Axis.vertical,
                          runSpacing: 10,
                          children: List.generate(3, (index) {
                            return Shimmer.fromColors(
                              baseColor: Colors.grey[300]!,
                              highlightColor: Colors.grey[100]!,
                              child: ChoiceChip(
                                label: Container(
                                  width: 50,
                                  height: 20,
                                  color: Colors.grey[
                                      300], // Placeholder color for shimmer
                                ),
                                selected: false,
                                onSelected: (_) {},
                              ),
                            );
                          }),
                        );
                      }

                      if (castController.casteMultiList.isEmpty) {
                        return const Center(
                            child: Text(
                                'No data found')); // Show message if no data
                      }

                      // Display the fetched list of items in ChoiceChips (multiple can be selected)
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // For ForeignKey 1
                          castController.casteFKone.isNotEmpty
                              ? const Text("Shvetambar",
                                  style: CustomTextStyle.bodytextboldLarge)
                              : const SizedBox(),
                          const SizedBox(height: 5),
                          castController.casteFKone.isNotEmpty
                              ? ChoiceChip(
                                  labelPadding: const EdgeInsets.all(4),
                                  checkmarkColor: Colors.white,
                                  disabledColor: AppTheme.lightPrimaryColor,
                                  backgroundColor: AppTheme.lightPrimaryColor,
                                  label: allSelected(castController.casteFKone)
                                      ? const Text("Disselect All")
                                      : const Text("Select All"),
                                  selected:
                                      allSelected(castController.casteFKone),
                                  onSelected: (selected) {
                                    if (selected) {
                                      castController.selectedCasteList
                                          .addAll(castController.casteFKone);
                                    } else {
                                      castController.selectedCasteList
                                          .removeWhere((item) =>
                                              castController.casteFKone.any(
                                                (element) =>
                                                    element.id == item.id,
                                              ));
                                    }
                                  },
                                  selectedColor: AppTheme.selectedOptionColor,
                                  labelStyle: CustomTextStyle.bodytext.copyWith(
                                    fontSize: 14,
                                    color:
                                        allSelected(castController.casteFKone)
                                            ? Colors.white
                                            : AppTheme.secondryColor,
                                  ),
                                )
                              : const SizedBox(),
                          // Select All Chip for Shvetambar
                          /*    ChoiceChip(
                          label:  const Text("Select All"),
                          selected: castController.selectedCasteList.length == castController.casteFKone.length,
                          onSelected: 
                          selectedColor: AppTheme.selectedOptionColor,
                          backgroundColor: AppTheme.lightPrimaryColor,
                        ),
*/
                          const SizedBox(height: 5),
                          Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children: castController.casteFKone
                                .map((CasteMultiSelectModel item) {
                              final isSelected = castController
                                  .selectedCasteList
                                  .any((selectedItem) =>
                                      selectedItem.id == item.id);
                              return ChoiceChip(
                                labelPadding: const EdgeInsets.all(4),
                                checkmarkColor: Colors.white,
                                disabledColor: AppTheme.lightPrimaryColor,
                                backgroundColor: AppTheme.lightPrimaryColor,
                                label: Text(
                                  item.name ?? "", // Display FieldModel name
                                  style: CustomTextStyle.bodytext.copyWith(
                                    fontSize: 14,
                                    color: isSelected
                                        ? Colors.white
                                        : AppTheme.selectedOptionColor,
                                  ),
                                ),
                                selected: isSelected,
                                onSelected: (bool selected) {
                                  if (selected) {
                                    // Add the item ID to the selectedSectionInt list if selected
                                    castController.selectedCasteList.add(item);
                                  } else {
                                    // Remove the item ID from the selectedSectionInt list if deselected
                                    // castController.selectedCasteList.remove(item);
                                    castController.selectedCasteList
                                        .removeWhere((selectedItem) =>
                                            selectedItem.id == item.id);
                                  }
                                },
                                selectedColor: AppTheme.selectedOptionColor,
                                labelStyle: CustomTextStyle.bodytext.copyWith(
                                  fontSize: 14,
                                  color: isSelected
                                      ? Colors.white
                                      : AppTheme.secondryColor,
                                ),
                              );
                            }).toList(),
                          ),

                          const SizedBox(height: 20),

                          // For ForeignKey 2
                          castController.casteFKtwo.isNotEmpty
                              ? const Text(
                                  "Digambar",
                                  style: CustomTextStyle.bodytextboldLarge,
                                )
                              : const SizedBox(),
                          const SizedBox(height: 5),

                          // Select All Chip for Digambar
                          castController.casteFKtwo.isNotEmpty
                              ? ChoiceChip(
                                  labelPadding: const EdgeInsets.all(4),
                                  checkmarkColor: Colors.white,
                                  disabledColor: AppTheme.lightPrimaryColor,
                                  backgroundColor: AppTheme.lightPrimaryColor,
                                  label: allSelected(castController.casteFKtwo)
                                      ? const Text("Disselect All")
                                      : const Text("Select All"),
                                  selected:
                                      allSelected(castController.casteFKtwo),
                                  onSelected: (selected) {
                                    if (selected) {
                                      castController.selectedCasteList
                                          .addAll(castController.casteFKtwo);
                                    } else {
                                      castController.selectedCasteList
                                          .removeWhere((item) =>
                                              castController.casteFKtwo.any(
                                                (element) =>
                                                    element.id == item.id,
                                              ));
                                    }
                                  },
                                  selectedColor: AppTheme.selectedOptionColor,
                                  labelStyle: CustomTextStyle.bodytext.copyWith(
                                    fontSize: 14,
                                    color:
                                        allSelected(castController.casteFKtwo)
                                            ? Colors.white
                                            : AppTheme.secondryColor,
                                  ),
                                )
                              : const SizedBox(),

                          const SizedBox(height: 5),
                          Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children: castController.casteFKtwo
                                .map((CasteMultiSelectModel item) {
                              final isSelected =
                                  castController.selectedCasteList.any(
                                (element) => element.id == item.id,
                              );
                              return ChoiceChip(
                                labelPadding: const EdgeInsets.all(4),
                                checkmarkColor: Colors.white,
                                disabledColor: AppTheme.lightPrimaryColor,
                                backgroundColor: AppTheme.lightPrimaryColor,
                                label: Text(
                                  item.name ?? "", // Display FieldModel name
                                  style: CustomTextStyle.bodytext.copyWith(
                                    fontSize: 14,
                                    color: isSelected
                                        ? Colors.white
                                        : AppTheme.selectedOptionColor,
                                  ),
                                ),
                                selected: isSelected,
                                onSelected: (bool selected) {
                                  if (selected) {
                                    // Add the item ID to the selectedSectionInt list if selected
                                    castController.selectedCasteList.add(item);
                                  } else {
                                    // Remove the item ID from the selectedSectionInt list if deselected
                                    //    castController.selectedCasteList.remove(item);
                                    castController.selectedCasteList
                                        .removeWhere((selectedItem) =>
                                            selectedItem.id == item.id);
                                  }
                                },
                                selectedColor: AppTheme.selectedOptionColor,
                                labelStyle: CustomTextStyle.bodytext.copyWith(
                                  fontSize: 14,
                                  color: isSelected
                                      ? Colors.white
                                      : AppTheme.secondryColor,
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      );
                    }),
                  ),
                ),
              ),

              // Done button to close the modal
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                side: const BorderSide(color: Colors.red)),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              AppLocalizations.of(context)!.cancel,
                              style: CustomTextStyle.elevatedButton
                                  .copyWith(color: Colors.red),
                            ))),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          AppLocalizations.of(context)!.done,
                          style: CustomTextStyle.elevatedButton,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
