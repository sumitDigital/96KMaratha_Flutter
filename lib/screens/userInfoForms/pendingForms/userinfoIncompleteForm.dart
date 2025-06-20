// ignore_for_file: deprecated_member_use

import 'package:_96kuliapp/controllers/dashboardControllers/dashboardController.dart';
import 'package:_96kuliapp/controllers/formfields/educationController.dart';
import 'package:_96kuliapp/controllers/formfields/occupationController.dart';
import 'package:_96kuliapp/controllers/formfields/specializationController.dart';
import 'package:_96kuliapp/controllers/locationcontroller/LocationController.dart';
import 'package:_96kuliapp/screens/userInfoForms/location/permanentAdress/permanentCountry.dart';
import 'package:_96kuliapp/screens/userInfoForms/location/presentAddress/presentCountry.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:hive/hive.dart';
import 'package:_96kuliapp/commons/textdecoration.dart';
import 'package:_96kuliapp/controllers/formfields/employedInController.dart';
import 'package:_96kuliapp/controllers/userform/formstep2Controller.dart';
import 'package:_96kuliapp/controllers/userform/userinfoOldController.dart';
import 'package:_96kuliapp/main.dart';
import 'package:_96kuliapp/models/forms/fields/fieldModel.dart';
import 'package:_96kuliapp/utils/Apptheme.dart';
import 'package:_96kuliapp/utils/buttonContainer.dart';
import 'package:_96kuliapp/utils/customtextform.dart';
import 'package:_96kuliapp/utils/formheaderbasic.dart';
import 'package:_96kuliapp/utils/formtitletag.dart';
import 'package:_96kuliapp/utils/selectlanguage.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class userIncomplete_userForm extends StatefulWidget {
  const userIncomplete_userForm({super.key});

  @override
  State<userIncomplete_userForm> createState() => _userinfoOlduserState();
}

class _userinfoOlduserState extends State<userIncomplete_userForm> {
  final userInfo_IncompletController _userInCompletController =
      Get.put(userInfo_IncompletController());

  final GlobalKey<FormFieldState> _employedInKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _designationKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _companyNameKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _AnnualincomeKey =
      GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _specializationKey =
      GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _jobLocationKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _workModeKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _EmpPatnerKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _presentAddressKey =
      GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _permanentAddressKey =
      GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _highestEducationKey =
      GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _OccupationKey = GlobalKey<FormFieldState>();

  final ScrollController _scrollController = ScrollController();
  final StepTwoController _stepTwoController = Get.put(StepTwoController());
  final LocationController _locationController = Get.put(LocationController());
  final DashboardController _dashboardController =
      Get.put(DashboardController());
  final EducationController _educationController =
      Get.put(EducationController());
  final SpecializationController _specializationController =
      Get.put(SpecializationController());
  final userInfo_IncompletController _userInfoController =
      Get.put(userInfo_IncompletController());
  final OccupationController _occupationController =
      Get.put(OccupationController());
  String? language = sharedPreferences?.getString("Language");

  late String gender;
  String? gender2;
  String? gender3;
  String? gender4;
  @override
  void initState() {
    super.initState(); // Call the superclass's method
    gender = selectgender();
    _stepTwoController.fetchEducationInfo();
    // _dashboardController.fetchUserInfo();
  }

  final mybox = Hive.box('myBox');
  String presentlocationText = "";
  final EmplyedInController _emplyedInController =
      Get.put(EmplyedInController());

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

  String selectgender() {
    if (language == "en") {
      if (mybox.get("gender") == 2) {
        return "groom";
      } else {
        return "bride";
      }
    } else {
      if (mybox.get("gender") == 2) {
        gender2 = "वराचा";
        gender3 = "वराच्या";
        gender4 = "वराचे";
        return "वराची";
      } else {
        gender2 = "वधूचा";
        gender3 = "वधूच्या";
        gender4 = "वधूचे";

        return "वधूची";
      }
    }
  }

  final GlobalKey<FormState> _formKeys = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
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
            title: language == "en" ? "STEP 1" : "पहिली पायरी",
            pageName: '',
            arrowback: false,
            styleform: true,
          ),
        ),
        body: SingleChildScrollView(
          controller: _scrollController,
          child: SafeArea(
            child: Obx(
              () {
                String? language = sharedPreferences?.getString("Language");
                if (_userInCompletController.isPageLoading.value) {
                  return Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
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
                                      // navigatorKey.currentState!.pushAndRemoveUntil(
                                      //   MaterialPageRoute(
                                      //     builder: (context) => UserInfoStepOne(),
                                      //   ),
                                      //   (route) => false,
                                      // );
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
                                  Text(
                                    AppLocalizations.of(context)!.step2,
                                    style: CustomTextStyle.bodytextLarge,
                                  ),
                                ],
                              ),
                              const SelectLanguage()
                            ],
                          ),
                        ),
                        StepsFormHeaderBasic(
                            title: AppLocalizations.of(context)!
                                .updateEducationCareerLocation,
                            desc:
                                "Find your soulmate by sharing your education, career, and location. It’s quick and easy.",
                            image: "assets/formstep1.png",
                            statusdesc:
                                "Submit this form to boost your profile visibility by",
                            statusPercent: "40%"),
                      ],
                    ),
                  );
                } else {
                  return Form(
                      key: _formKeys,
                      child: Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                language == "en"
                                    ? Container(
                                        decoration: BoxDecoration(
                                          color: AppTheme.lightPrimaryColor,
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(5)),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            children: [
                                              Center(
                                                child: Text(
                                                  'One step closer to your perfect match!',
                                                  textAlign: TextAlign.center,
                                                  style: CustomTextStyle
                                                      .bodytext
                                                      .copyWith(
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              Center(
                                                child: RichText(
                                                    textAlign: TextAlign.center,
                                                    text: TextSpan(
                                                        children: <TextSpan>[
                                                          TextSpan(
                                                              text:
                                                                  "Some profile details are incomplete. Completing them will help you find better and more relevant matches.",
                                                              style: CustomTextStyle
                                                                  .bodytext
                                                                  .copyWith(
                                                                      fontSize:
                                                                          13,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500)),
                                                          const TextSpan(
                                                              text: "",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .red)),
                                                        ])),
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                    : Container(
                                        decoration: BoxDecoration(
                                          color: AppTheme.lightPrimaryColor,
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(5)),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            children: [
                                              Text(
                                                "योग्य जोडीदारासाठी एक पाऊल पुढे!",
                                                textAlign: TextAlign.center,
                                                style: CustomTextStyle.bodytext
                                                    .copyWith(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.bold),
                                              ),
                                              Center(
                                                child: RichText(
                                                    textAlign: TextAlign.center,
                                                    text: TextSpan(
                                                        children: <TextSpan>[
                                                          TextSpan(
                                                              text: "",
                                                              style: CustomTextStyle
                                                                  .bodytext
                                                                  .copyWith(
                                                                      fontSize:
                                                                          12)),
                                                          const TextSpan(
                                                              text: "",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .red)),
                                                          TextSpan(
                                                              text:
                                                                  " तुमच्या प्रोफाईलची काही माहिती अजूनही अपूर्ण आहे. खाली दिलेली माहिती भरणे आवश्यक आहे. ती पूर्ण केल्यास, जुळणाऱ्या प्रोफाईल्सशी संवाद साधायला मदत होईल.",
                                                              style: CustomTextStyle
                                                                  .bodytext
                                                                  .copyWith(
                                                                      fontSize:
                                                                          13,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500)),
                                                        ])),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                const SizedBox(
                                  height: 10,
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                // FormsTitleTag(
                                //                       pageName: "incompleteForms",
                                //                       title: AppLocalizations.of(context)!.step2,
                                //                       onTap: () {
                                //                         if (navigatorKey.currentState!.canPop()) {
                                //                           Get.back();
                                //                         } else {
                                //                           navigatorKey.currentState!
                                //                               .pushReplacement(MaterialPageRoute(
                                //                             builder: (context) => UserInfoStepOne(),
                                //                           ));
                                //                         }
                                //                       },
                                //                     ),

                                RichText(
                                  key: _employedInKey,
                                  text: TextSpan(
                                    children: <TextSpan>[
                                      TextSpan(
                                          text: AppLocalizations.of(context)!
                                              .employedIn,
                                          style: CustomTextStyle.fieldName),
                                      const TextSpan(
                                          text: "*",
                                          style: TextStyle(color: Colors.red))
                                    ],
                                  ),
                                ),
                                Obx(
                                  () {
                                    final TextEditingController employeedIn =
                                        TextEditingController(
                                            text: _emplyedInController
                                                .selectedOption.value.name);
                                    return CustomTextField(
                                      validator: (value) {
                                        if (language == "en") {
                                          if (value == null || value.isEmpty) {
                                            return 'Please select $gender employed in status';
                                          }
                                        } else {
                                          if (value == null || value.isEmpty) {
                                            return 'कृपया $gender4 जॉब क्षेत्र निवडा'; /* कोणत्या क्षेत्रात नोकरीला आहात ते टाकणे अनिवार्य आहे */
                                          }
                                        }

                                        return null;
                                      },
                                      textEditingController: employeedIn,
                                      HintText: language == "en"
                                          ? "Select Employeed In"
                                          : "वराचे जॉब क्षेत्र निवडा ",
                                      /* वराचे / कोणत्या क्षेत्रात नोकरीला आहात */
                                      ontap: () {
                                        _showEmployeedInBottomSheet(context);
                                      },
                                      readonly: true,
                                    );
                                  },
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                _emplyedInController.selectedOption.value.id ==
                                            7 ||
                                        _emplyedInController
                                                .selectedOption.value.id ==
                                            8 ||
                                        _emplyedInController
                                                .selectedOption.value.id ==
                                            9
                                    ? const SizedBox()
                                    : Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          RichText(
                                            key: _designationKey,
                                            text: TextSpan(children: <TextSpan>[
                                              TextSpan(
                                                  text: AppLocalizations.of(
                                                          context)!
                                                      .designation,
                                                  style: CustomTextStyle
                                                      .fieldName),
                                              const TextSpan(
                                                  text: "*",
                                                  style: TextStyle(
                                                      color: Colors.red))
                                            ]),
                                          ),
                                          CustomTextField(
                                            textEditingController:
                                                _userInfoController
                                                    .designationController,
                                            validator: (value) {
                                              if (language == "en") {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'Please enter $gender designation';
                                                }
                                              } else {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'कृपया $gender4 डेजिग्नेशन टाका'; /* कृपया वराचे डेजिग्नेशन टाकणे अनिवार्य आहे */
                                                }
                                              }

                                              return null;
                                            },
                                            HintText: language == "en"
                                                ? "Enter Designation"
                                                : "$gender4 डेजिग्नेशन टाका",
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          RichText(
                                            key: _companyNameKey,
                                            text: TextSpan(children: <TextSpan>[
                                              TextSpan(
                                                  text: AppLocalizations.of(
                                                          context)!
                                                      .companyName,
                                                  style: CustomTextStyle
                                                      .fieldName),
                                              const TextSpan(
                                                  text: "*",
                                                  style: TextStyle(
                                                      color: Colors.red))
                                            ]),
                                          ),
                                          CustomTextField(
                                            textEditingController:
                                                _userInfoController
                                                    .companyNameController,
                                            validator: (value) {
                                              if (language == "en") {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'Please enter $gender company name';
                                                }
                                              } else {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'कृपया $gender3 कंपनीचे नाव टाका'; /* वराच्या  कंपनीचे नाव टाकणे अनिवार्य आहे */
                                                }
                                              }

                                              return null;
                                            },
                                            HintText: language == "en"
                                                ? "Enter Company Name"
                                                : "$gender3 कंपनीचे नाव टाका",
                                          ),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                        ],
                                      ),

                                RichText(
                                    key: _AnnualincomeKey,
                                    text: TextSpan(children: <TextSpan>[
                                      TextSpan(
                                          text: AppLocalizations.of(context)!
                                              .annualIncome,
                                          style: CustomTextStyle.fieldName),
                                      const TextSpan(
                                          text: "*",
                                          style: TextStyle(color: Colors.red))
                                    ])),
                                Obx(() {
                                  // Controller
                                  final TextEditingController
                                      annualIncomeController =
                                      TextEditingController(
                                    text: _userInCompletController
                                            .selectedAnnualIncome.value?.name ??
                                        '',
                                  );

                                  return CustomTextField(
                                    textEditingController:
                                        annualIncomeController,
                                    readonly: true, // To prevent manual input
                                    HintText: language == "en"
                                        ? 'Select Annual Income'
                                        : "$gender4 वार्षिक उत्पन्न निवडा",
                                    ontap: () {
                                      // Preload the list when opening the dialog
                                      _userInCompletController
                                              .filteredItemsList.value =
                                          _userInCompletController.itemsList;

                                      // When text field is tapped, show dialog with search and options
                                      TextEditingController searchController =
                                          TextEditingController();

                                      // Show the dialog
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
                                              padding:
                                                  const EdgeInsets.all(16.0),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  // Search Field
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            bottom: 8.0,
                                                            top: 8),
                                                    child: TextField(
                                                      controller:
                                                          searchController,
                                                      decoration:
                                                          InputDecoration(
                                                        errorMaxLines: 5,
                                                        errorStyle:
                                                            CustomTextStyle
                                                                .errorText,
                                                        labelStyle:
                                                            CustomTextStyle
                                                                .bodytext,
                                                        hintText: AppLocalizations
                                                                .of(context)!
                                                            .searchAnnualIncome,
                                                        contentPadding:
                                                            const EdgeInsets
                                                                .all(20),
                                                        hintStyle:
                                                            CustomTextStyle
                                                                .hintText,
                                                        filled: true,
                                                        fillColor: Colors.white,
                                                        errorBorder:
                                                            const OutlineInputBorder(
                                                          borderSide:
                                                              BorderSide(
                                                                  color: Colors
                                                                      .red),
                                                          gapPadding: 30,
                                                        ),
                                                        focusedBorder:
                                                            OutlineInputBorder(
                                                          borderRadius:
                                                              const BorderRadius
                                                                  .all(Radius
                                                                      .circular(
                                                                          5)),
                                                          borderSide: BorderSide(
                                                              color: Colors.grey
                                                                  .shade300),
                                                        ),
                                                        enabledBorder:
                                                            OutlineInputBorder(
                                                          borderRadius:
                                                              const BorderRadius
                                                                  .all(Radius
                                                                      .circular(
                                                                          5)),
                                                          borderSide: BorderSide(
                                                              color: Colors.grey
                                                                  .shade300),
                                                        ),
                                                        border:
                                                            OutlineInputBorder(
                                                          borderRadius:
                                                              const BorderRadius
                                                                  .all(Radius
                                                                      .circular(
                                                                          5)),
                                                          borderSide: BorderSide(
                                                              color: Colors.grey
                                                                  .shade300),
                                                        ),
                                                        suffixIcon: Icon(
                                                            Icons.search,
                                                            color: Colors
                                                                .grey.shade500),
                                                      ),
                                                      onChanged: (query) {
                                                        _userInCompletController
                                                            .filterItems(
                                                                query); // Filter the list in the controller
                                                      },
                                                    ),
                                                  ),
                                                  // List of Items
                                                  Container(
                                                    decoration:
                                                        const BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  5)),
                                                      color: Colors.white,
                                                    ),
                                                    height:
                                                        400, // Set a height for the list inside the dialog
                                                    child: Obx(() {
                                                      return ListView.builder(
                                                        shrinkWrap: true,
                                                        itemCount:
                                                            _userInCompletController
                                                                .filteredItemsList
                                                                .length,
                                                        itemBuilder:
                                                            (context, index) {
                                                          final item =
                                                              _userInCompletController
                                                                      .filteredItemsList[
                                                                  index];
                                                          bool isSelected =
                                                              _userInCompletController
                                                                      .selectedAnnualIncome
                                                                      .value
                                                                      ?.id ==
                                                                  item.id;

                                                          return GestureDetector(
                                                            onTap: () {
                                                              // Update the selected value and close the dialog
                                                              _userInCompletController
                                                                  .setSelectedAnnualIncome(
                                                                      item);
                                                              annualIncomeController
                                                                  .text = item
                                                                      .name ??
                                                                  ""; // Update the controller text if needed
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            child: Container(
                                                              color: isSelected
                                                                  ? AppTheme
                                                                      .selectedOptionColor
                                                                  : Colors
                                                                      .white,
                                                              child: ListTile(
                                                                title: Text(
                                                                  item.name ??
                                                                      "",
                                                                  style: CustomTextStyle
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
                                    validator: (value) {
                                      if (language == "en") {
                                        if (value == null ||
                                            value.isEmpty ||
                                            value ==
                                                'Select your Annual Income') {
                                          return 'Please select $gender annual income';
                                        }
                                      } else {
                                        if (value == null ||
                                            value.isEmpty ||
                                            value ==
                                                'Select your Annual Income') {
                                          return 'कृपया $gender4 वार्षिक उत्पन्न टाका'; /* वराचे वार्षिक उत्पन्न टाकणे अनिवार्य आहे */
                                        }
                                      }

                                      return null;
                                    },
                                  );
                                }),

                                _emplyedInController.selectedOption.value.id ==
                                            7 ||
                                        _emplyedInController
                                                .selectedOption.value.id ==
                                            8 ||
                                        _emplyedInController
                                                .selectedOption.value.id ==
                                            9
                                    ? const SizedBox()
                                    : Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          RichText(
                                              key: _jobLocationKey,
                                              text:
                                                  TextSpan(children: <TextSpan>[
                                                TextSpan(
                                                    text: AppLocalizations.of(
                                                            context)!
                                                        .currentJobLocation,
                                                    style: CustomTextStyle
                                                        .fieldName),
                                                const TextSpan(
                                                    text: "*",
                                                    style: TextStyle(
                                                        color: Colors.red))
                                              ])),
                                          CustomTextField(
                                            textEditingController:
                                                _userInCompletController
                                                    .jobLocation,
                                            validator: (value) {
                                              if (language == "en") {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'Please enter $gender job location';
                                                }
                                              } else {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'कृपया सध्याचे जॉबचे ठिकाण टाका'; /* सध्याचा जॉबचा पत्ता टाकणे अनिवार्य आहे */
                                                }
                                              }
                                              return null;
                                            },
                                            HintText: language == "en"
                                                ? "Enter job Location"
                                                : "सध्याचे जॉबचे ठिकाण टाका",
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          RichText(
                                            key: _workModeKey,
                                            text: TextSpan(
                                              children: <TextSpan>[
                                                TextSpan(
                                                    text: AppLocalizations.of(
                                                            context)!
                                                        .workMode,
                                                    style: CustomTextStyle
                                                        .fieldName),
                                                const TextSpan(
                                                    text: "*",
                                                    style: TextStyle(
                                                        color: Colors.red))
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
                                                        _userInfoController
                                                            .updateWorkMode(
                                                                FieldModel(
                                                                    id: 1,
                                                                    name:
                                                                        "Fully Remote"));
                                                      },
                                                      child: CustomContainer(
                                                        height: 60,
                                                        title:
                                                            AppLocalizations.of(
                                                                    context)!
                                                                .fullyremote,
                                                        width: 110,
                                                        color: _userInfoController
                                                                    .selectedWorkMode
                                                                    .value
                                                                    .id ==
                                                                1
                                                            ? AppTheme
                                                                .selectedOptionColor
                                                            : null,
                                                        textColor:
                                                            _userInfoController
                                                                        .selectedWorkMode
                                                                        .value
                                                                        .id ==
                                                                    1
                                                                ? Colors.white
                                                                : null,
                                                      )),
                                                  GestureDetector(
                                                      onTap: () {
                                                        _userInfoController
                                                            .updateWorkMode(
                                                                FieldModel(
                                                                    id: 2,
                                                                    name:
                                                                        "Hybrid"));
                                                      },
                                                      child: CustomContainer(
                                                        height: 60,
                                                        title:
                                                            AppLocalizations.of(
                                                                    context)!
                                                                .hybridMode,
                                                        width: 112,
                                                        color: _userInfoController
                                                                    .selectedWorkMode
                                                                    .value
                                                                    .id ==
                                                                2
                                                            ? AppTheme
                                                                .selectedOptionColor
                                                            : null,
                                                        textColor:
                                                            _userInfoController
                                                                        .selectedWorkMode
                                                                        .value
                                                                        .id ==
                                                                    2
                                                                ? Colors.white
                                                                : null,
                                                      )),
                                                  GestureDetector(
                                                      onTap: () {
                                                        _userInfoController
                                                            .updateWorkMode(
                                                                FieldModel(
                                                                    id: 3,
                                                                    name:
                                                                        "WFO"));
                                                      },
                                                      child: CustomContainer(
                                                        height: 60,
                                                        title:
                                                            AppLocalizations.of(
                                                                    context)!
                                                                .workFromOffice,
                                                        width: 143,
                                                        color: _userInfoController
                                                                    .selectedWorkMode
                                                                    .value
                                                                    .id ==
                                                                3
                                                            ? AppTheme
                                                                .selectedOptionColor
                                                            : null,
                                                        textColor:
                                                            _userInfoController
                                                                        .selectedWorkMode
                                                                        .value
                                                                        .id ==
                                                                    3
                                                                ? Colors.white
                                                                : null,
                                                      )),
                                                ],
                                              );
                                            },
                                          ),
                                          Obx(
                                            () {
                                              print("Valid Mang");
                                              if (_userInfoController
                                                          .selectedWorkModeValidated
                                                          .value ==
                                                      false &&
                                                  _userInfoController
                                                          .isSubmitted.value ==
                                                      true) {
                                                if (_userInfoController
                                                        .selectedWorkMode
                                                        .value
                                                        .id ==
                                                    null) {
                                                  return Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      const SizedBox(
                                                        height: 10,
                                                      ),
                                                      language == "en"
                                                          ? Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      left:
                                                                          18.0),
                                                              child: Text(
                                                                "Please select $gender work mode",
                                                                style: CustomTextStyle
                                                                    .errorText,
                                                              ),
                                                            )
                                                          : Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      left:
                                                                          18.0),
                                                              child: Text(
                                                                "जॉबची पद्धत निवडा",
                                                                style: CustomTextStyle
                                                                    .errorText,
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
                                        ],
                                      ),

                                const SizedBox(
                                  height: 20,
                                ),

                                RichText(
                                    key: _EmpPatnerKey,
                                    text: TextSpan(children: <TextSpan>[
                                      TextSpan(
                                          text: AppLocalizations.of(context)!
                                              .partnerEmployedIn,
                                          style: CustomTextStyle.fieldName),
                                      const TextSpan(
                                          text: "*",
                                          style: TextStyle(color: Colors.red))
                                    ])),
                                Obx(
                                  () {
                                    if (_userInfoController
                                        .selectedItems.isNotEmpty) {
                                      return Padding(
                                        padding:
                                            const EdgeInsets.only(top: 8.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                _showMultiSelectBottomSheet(
                                                    context);
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color:
                                                          Colors.grey.shade300,
                                                      width: 1),
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                          Radius.circular(5)),
                                                ),
                                                child: Padding(
                                                  padding: const EdgeInsets.all(
                                                      12.0),
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
                                                          MainAxisAlignment.end,
                                                      children: [
                                                        Wrap(
                                                          direction:
                                                              Axis.horizontal,

                                                          spacing:
                                                              10, // Spacing between chips horizontally
                                                          runSpacing:
                                                              10, // Spacing between rows vertically
                                                          children: [
                                                            ...List.generate(
                                                              _userInfoController
                                                                          .selectedItems
                                                                          .length >
                                                                      4
                                                                  ? 4
                                                                  : _userInfoController
                                                                      .selectedItems
                                                                      .length,
                                                              (index) {
                                                                final item =
                                                                    _userInfoController
                                                                            .selectedItems[
                                                                        index];
                                                                return Chip(
                                                                  deleteIcon:
                                                                      const Padding(
                                                                    padding:
                                                                        EdgeInsets
                                                                            .all(0),
                                                                    child: Icon(
                                                                        Icons
                                                                            .close,
                                                                        size:
                                                                            12),
                                                                  ),
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .all(
                                                                          2),
                                                                  labelPadding:
                                                                      const EdgeInsets
                                                                          .all(
                                                                          4),
                                                                  backgroundColor:
                                                                      AppTheme
                                                                          .lightPrimaryColor,
                                                                  side:
                                                                      const BorderSide(
                                                                    style:
                                                                        BorderStyle
                                                                            .none,
                                                                    color: Colors
                                                                        .blue,
                                                                  ),
                                                                  label: Text(
                                                                    item.name ??
                                                                        "",
                                                                    style: CustomTextStyle
                                                                        .bodytext
                                                                        .copyWith(
                                                                            fontSize:
                                                                                11),
                                                                  ),
                                                                  onDeleted:
                                                                      () {
                                                                    _userInfoController
                                                                        .toggleSelection(
                                                                            item);
                                                                  },
                                                                );
                                                              },
                                                            ),
                                                            // Add button as a Chip
                                                            Obx(
                                                              () {
                                                                if (_userInfoController
                                                                        .selectedItems
                                                                        .length <=
                                                                    4) {
                                                                  return GestureDetector(
                                                                    onTap: () {
                                                                      // Navigate to view all countries
                                                                      _showMultiSelectBottomSheet(
                                                                          context);
                                                                    },
                                                                    child:
                                                                        Padding(
                                                                      padding: const EdgeInsets
                                                                          .only(
                                                                          bottom:
                                                                              2,
                                                                          top:
                                                                              12.0),
                                                                      child:
                                                                          Text(
                                                                        "+ Add",
                                                                        style: CustomTextStyle
                                                                            .bodytext
                                                                            .copyWith(
                                                                          color:
                                                                              AppTheme.selectedOptionColor,
                                                                          fontWeight:
                                                                              FontWeight.bold,
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
                                                                    child:
                                                                        Padding(
                                                                      padding: const EdgeInsets
                                                                          .only(
                                                                          bottom:
                                                                              2,
                                                                          top:
                                                                              12.0),
                                                                      child:
                                                                          Text(
                                                                        "(+${_userInfoController.selectedItems.length - 4}) More",
                                                                        style: CustomTextStyle
                                                                            .bodytext
                                                                            .copyWith(
                                                                          color:
                                                                              AppTheme.selectedOptionColor,
                                                                          fontWeight:
                                                                              FontWeight.bold,
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
                                            if (value == null ||
                                                value.isEmpty) {
                                              return "Please select partner's expected employed in status";
                                            }
                                          } else {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return "जोडीदार कोणत्या क्षेत्रात जॉबला असावा ते निवडा";
                                            }
                                          }

                                          return null;
                                        },
                                        HintText: language == "en"
                                            ? "Employed In"
                                            : "जोडीदाराचा अपेक्षित जॉब क्षेत्र निवडा",
                                        /* जोडीदार कोणत्या क्षेत्रात जॉबला असावा निवडा  */
                                        ontap: () {
                                          _showMultiSelectBottomSheet(context);
                                        },
                                        readonly: true,
                                      );
                                    }
                                  },
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
//
                                ///
                                ////
                                ////
                                ////
                                ////
                                ///
                                ///
                                if (_dashboardController
                                    .dashboardData["redirection"]
                                        ["incompleteField"]
                                    .any((item) =>
                                        item["table"] == "EducationCareer" &&
                                        item["missing_fields"] is List &&
                                        (item["missing_fields"] as List).any(
                                            (field) =>
                                                field ==
                                                "highest_education_id"))) ...[
                                  Column(
                                    children: [
                                      RichText(
                                        key: _highestEducationKey,
                                        text: TextSpan(children: <TextSpan>[
                                          TextSpan(
                                              text:
                                                  AppLocalizations.of(context)!
                                                      .highestEducation,
                                              style: CustomTextStyle.fieldName),
                                          const TextSpan(
                                              text: "*",
                                              style:
                                                  TextStyle(color: Colors.red))
                                        ]),
                                      ),
                                    ],
                                  ),
                                  Obx(
                                    () {
                                      TextEditingController
                                          textEditingController =
                                          TextEditingController(
                                              text: _educationController
                                                  .selectedEducation
                                                  .value
                                                  .name);
                                      return CustomTextField(
                                          validator: (value) {
                                            if (language == "en") {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'enter $gender education ';
                                              }
                                            } else {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'कृपया $gender4 शिक्षण निवडा';
                                              }
                                            }
                                            return null;
                                          },
                                          textEditingController:
                                              textEditingController,
                                          readonly: true,
                                          ontap: () {
                                            _showEducationBottomSheet(context);
                                          },
                                          HintText: language == "en"
                                              ? "$gender Education"
                                              : "$gender4 शिक्षण");
                                    },
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  _educationController
                                                  .selectedEducation.value.id ==
                                              10 ||
                                          _educationController
                                                  .selectedEducation.value.id ==
                                              15 ||
                                          _educationController
                                                  .selectedEducation.value.id ==
                                              23 ||
                                          _educationController
                                                  .selectedEducation.value.id ==
                                              33 ||
                                          _educationController
                                                  .selectedEducation.value.id ==
                                              36 ||
                                          _educationController
                                                  .selectedEducation.value.id ==
                                              42 ||
                                          _educationController
                                                  .selectedEducation.value.id ==
                                              60 ||
                                          _educationController
                                                  .selectedEducation.value.id ==
                                              68 ||
                                          _educationController
                                                  .selectedEducation.value.id ==
                                              74 ||
                                          _educationController
                                                  .selectedEducation.value.id ==
                                              90 ||
                                          _educationController
                                                  .selectedEducation.value.id ==
                                              94 ||
                                          _educationController
                                                  .selectedEducation.value.id ==
                                              97
                                      ? Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            RichText(
                                                text: const TextSpan(
                                                    children: <TextSpan>[
                                                  TextSpan(
                                                      text: "Other Education ",
                                                      style: CustomTextStyle
                                                          .fieldName),
                                                  TextSpan(
                                                      text: "*",
                                                      style: TextStyle(
                                                          color: Colors.red))
                                                ])),
                                            CustomTextField(
                                              HintText: "Enter other education",
                                              textEditingController:
                                                  _userInCompletController
                                                      .othereducation,
                                              validator: (value) {
                                                if (language == "en") {
                                                  if (value == null ||
                                                      value.isEmpty) {
                                                    return 'Enter $gender education ';
                                                  }
                                                } else {
                                                  if (value == null ||
                                                      value.isEmpty) {
                                                    return '$gender4 शिक्षण टाकणे अनिवार्य आहे';
                                                  }
                                                }

                                                return null;
                                              },
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            )
                                          ],
                                        )
                                      : const SizedBox(),
                                ],

                                //
                                ///
                                /////
                                ////
                                ///
                                ///
                                if (_dashboardController
                                    .dashboardData["redirection"]
                                        ["incompleteField"]
                                    .any((item) =>
                                        item["table"] == "EducationCareer" &&
                                        item["missing_fields"] is List &&
                                        (item["missing_fields"] as List).any(
                                            (field) =>
                                                field ==
                                                "specialization"))) ...[
                                  RichText(
                                    key: _specializationKey,
                                    text: TextSpan(
                                      children: <TextSpan>[
                                        TextSpan(
                                            text: AppLocalizations.of(context)!
                                                .specialization,
                                            style: CustomTextStyle.fieldName),
                                        const TextSpan(
                                            text: "*",
                                            style: TextStyle(color: Colors.red))
                                      ],
                                    ),
                                  ),
                                  Obx(
                                    () {
                                      TextEditingController
                                          textEditingController =
                                          TextEditingController(
                                              text: _specializationController
                                                  .selectedSpecialization
                                                  .value
                                                  .name);
                                      return CustomTextField(
                                          validator: (value) {
                                            if (language == "en") {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'Select specialization of $gender';
                                              }
                                            } else {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'कृपया $gender4 स्पेशलायझेशन निवडा';
                                              }
                                            }

                                            return null;
                                          },
                                          textEditingController:
                                              textEditingController,
                                          readonly: true,
                                          ontap: () {
                                            _showSpecializationBottomSheet(
                                                context);
                                          },
                                          HintText: language == "en"
                                              ? "Select Specialization"
                                              : "$gender4 स्पेशलायझेशन निवडा");
                                    },
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  _specializationController
                                              .selectedSpecialization
                                              .value
                                              .id ==
                                          180
                                      ? Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            RichText(
                                                text: const TextSpan(
                                                    children: <TextSpan>[
                                                  TextSpan(
                                                      text:
                                                          "Other Specialization ",
                                                      style: CustomTextStyle
                                                          .fieldName),
                                                  TextSpan(
                                                      text: "*",
                                                      style: TextStyle(
                                                          color: Colors.red))
                                                ])),
                                            CustomTextField(
                                              HintText:
                                                  "Enter other $gender Specialization",
                                              textEditingController:
                                                  _userInCompletController
                                                      .otherspecialization,
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'Please enter other Specialization ';
                                                }
                                                return null;
                                              },
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            )
                                          ],
                                        )
                                      : const SizedBox(),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                ],
                                // _emplyedInController.selectedOption.value.id ==
                                //             7 ||
                                //         _emplyedInController
                                //                 .selectedOption.value.id ==
                                //             8 ||
                                //         _emplyedInController
                                //                 .selectedOption.value.id ==
                                //             9
                                //     ? const SizedBox()
                                //     :

                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (_dashboardController
                                        .dashboardData["redirection"]
                                            ["incompleteField"]
                                        .any((item) =>
                                            item["table"] ==
                                                "EducationCareer" &&
                                            item["missing_fields"] is List &&
                                            (item["missing_fields"] as List)
                                                .any((field) =>
                                                    field ==
                                                    "occupation"))) ...[
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          RichText(
                                            key: _OccupationKey,
                                            text: TextSpan(children: <TextSpan>[
                                              TextSpan(
                                                  text: AppLocalizations.of(
                                                          context)!
                                                      .occupation,
                                                  style: CustomTextStyle
                                                      .fieldName),
                                              const TextSpan(
                                                  text: "*",
                                                  style: TextStyle(
                                                      color: Colors.red))
                                            ]),
                                          ),
                                          Obx(
                                            () {
                                              TextEditingController
                                                  textEditingController =
                                                  TextEditingController(
                                                      text: _occupationController
                                                          .selectedOccupation
                                                          .value
                                                          .name);
                                              return CustomTextField(
                                                validator: (value) {
                                                  if (language == "en") {
                                                    if (value == null ||
                                                        value.isEmpty) {
                                                      return 'Select Business of $gender';
                                                    }
                                                  } else {
                                                    if (value == null ||
                                                        value.isEmpty) {
                                                      return 'कृपया $gender2 नोकरी/व्यवसाय निवडा';
                                                    }
                                                  }
                                                  return null;
                                                },
                                                textEditingController:
                                                    textEditingController,
                                                readonly: true,
                                                HintText: language == "en"
                                                    ? "Select Business of $gender"
                                                    : "$gender2 नोकरी/व्यवसाय",
                                                ontap: () {
                                                  _showOccupationBottomSheet(
                                                      context);
                                                },
                                              );
                                            },
                                          ),
                                          _occupationController.selectedOccupation
                                                          .value.id ==
                                                      33 ||
                                                  _occupationController
                                                          .selectedOccupation
                                                          .value
                                                          .id ==
                                                      169 ||
                                                  _occupationController
                                                          .selectedOccupation
                                                          .value
                                                          .id ==
                                                      181
                                              ? Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    const SizedBox(
                                                      height: 10,
                                                    ),
                                                    RichText(
                                                        text: const TextSpan(
                                                            children: <TextSpan>[
                                                          TextSpan(
                                                              text:
                                                                  "Other Occupation ",
                                                              style:
                                                                  CustomTextStyle
                                                                      .fieldName),
                                                          TextSpan(
                                                              text: "*",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .red))
                                                        ])),
                                                    CustomTextField(
                                                      HintText:
                                                          "Enter other Occupation",
                                                      textEditingController:
                                                          _stepTwoController
                                                              .otheroccupation,
                                                      validator: (value) {
                                                        if (value == null ||
                                                            value.isEmpty) {
                                                          return 'Please enter $gender other Occupation ';
                                                        }
                                                        return null;
                                                      },
                                                    ),
                                                  ],
                                                )
                                              : const SizedBox(),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                        ],
                                      ),
                                    ],

                                    //
                                    ///
                                    ////
                                    ////
                                    ////
                                    ////
                                    ///
                                    /* New Fields */

                                    if (_dashboardController
                                        .dashboardData["redirection"]
                                            ["incompleteField"]
                                        .any((item) =>
                                                item["table"] ==
                                                "Location" /* &&
                                            item["missing_fields"] is List &&
                                            (item["missing_fields"] as List)
                                                .any((field) =>
                                                    field ==
                                                    "present_city") */
                                            )) ...[
                                      RichText(
                                        key: _presentAddressKey,
                                        text: TextSpan(
                                          children: <TextSpan>[
                                            TextSpan(
                                                text: AppLocalizations.of(
                                                        context)!
                                                    .presentAddress,
                                                style:
                                                    CustomTextStyle.fieldName),
                                            const TextSpan(
                                                text: "*",
                                                style: TextStyle(
                                                    color: Colors.red))
                                          ],
                                        ),
                                      ),
                                      Obx(
                                        () {
                                          // print(
                                          //     "API check ${_dashboardController.dashboardData["redirection"]["incompleteField"].any((item) => item["table"] == "Location" && item["missing_fields"] is List && (item["missing_fields"] as List).any((field) => field == "present_city"))}");
                                          final TextEditingController
                                              locationTextController =
                                              TextEditingController();

                                          final selectedLocation = [
                                            _locationController
                                                .presentselectedCity.value.name,
                                            _locationController
                                                .presentselectedState
                                                .value
                                                .name,
                                            _locationController
                                                .presentselectedCountry
                                                .value
                                                .name
                                          ]
                                              .where((element) =>
                                                  element != null &&
                                                  element
                                                      .isNotEmpty) // Check for null and empty strings
                                              .join(' , ');

                                          locationTextController.text =
                                              selectedLocation.isEmpty
                                                  ? ""
                                                  : selectedLocation;
                                          presentlocationText =
                                              locationTextController.text;

                                          return CustomTextField(
                                            textEditingController:
                                                locationTextController,
                                            validator: /* _dashboardController
                                        .dashboardData["IncompleteProfile"]
                                            ["incompleteField"]
                                        .any((item) =>
                                            item["table"] == "Location")
                                                ? */
                                                (value) {
                                              if (language == "en") {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'Enter $gender present address';
                                                } else if (_locationController
                                                        .presentselectedState
                                                        .value
                                                        .name ==
                                                    null) {
                                                  return 'Please your select $gender present state';
                                                } else if (_locationController
                                                        .presentselectedCity
                                                        .value
                                                        .name ==
                                                    null) {
                                                  return 'Please your select $gender present district';
                                                }
                                              } else {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'कृपया $gender4 सध्याचे ठिकाण निवडा';
                                                } else if (_locationController
                                                        .permanentSelectedState
                                                        .value
                                                        .name ==
                                                    null) {
                                                  return '$gender4 सध्याचे राज्य निवडणे अनिवार्य आहे.';
                                                } else if (_locationController
                                                        .permanentSelectedCity
                                                        .value
                                                        .name ==
                                                    null) {
                                                  return '$gender4 सध्याचा जिल्हा निवडणे अनिवार्य आहे. ';
                                                }
                                              }
                                              return null;
                                            },
                                            // : null,
                                            readonly: true,
                                            ontap: () {
                                              //    Get.toNamed(AppRouteNames.presentselectCountry);
                                              navigatorKey.currentState!
                                                  .push(MaterialPageRoute(
                                                builder: (context) =>
                                                    const PresentCountrySelectScreen(),
                                              ));
                                            },
                                            HintText: language == "en"
                                                ? "$gender present address"
                                                : "$gender4 सध्याचे ठिकाण निवडा",
                                          );
                                        },
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Obx(
                                        () {
                                          return GestureDetector(
                                            onTap: () {
                                              _userInCompletController
                                                  .updateSameAddress();
                                            },
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                SizedBox(
                                                    height: 25,
                                                    width: 25,
                                                    child: Checkbox(
                                                      side: BorderSide(
                                                          color: Colors
                                                              .grey.shade400),
                                                      activeColor:
                                                          const Color.fromARGB(
                                                        255,
                                                        80,
                                                        93,
                                                        126,
                                                      ),
                                                      value:
                                                          _userInCompletController
                                                              .isSameAdress
                                                              .value,
                                                      onChanged: (value) {
                                                        _userInCompletController
                                                            .updateSameAddress();
                                                      },
                                                    )),
                                                Text(
                                                  AppLocalizations.of(context)!
                                                      .sameAddress,
                                                  style: CustomTextStyle
                                                      .textbutton,
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                    ],

                                    if (_dashboardController
                                        .dashboardData["redirection"]
                                            ["incompleteField"]
                                        .any((item) =>
                                                item["table"] ==
                                                "Location" /* &&
                                            item["missing_fields"] is List &&
                                            (item["missing_fields"] as List)
                                                .any((field) =>
                                                    field ==
                                                    "present_city")) */
                                            )) ...[
                                      Obx(
                                        () {
                                          if (_userInCompletController
                                                  .isSameAdress.value ==
                                              false) {
                                            return Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                RichText(
                                                    key: _permanentAddressKey,
                                                    text: TextSpan(
                                                        children: <TextSpan>[
                                                          TextSpan(
                                                              text: AppLocalizations
                                                                      .of(
                                                                          context)!
                                                                  .permanentAddress,
                                                              style:
                                                                  CustomTextStyle
                                                                      .fieldName),
                                                          const TextSpan(
                                                              text: "*",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .red))
                                                        ])),
                                                Obx(
                                                  () {
                                                    final TextEditingController
                                                        locationTextController =
                                                        TextEditingController();

                                                    final selectedLocation = [
                                                      _locationController
                                                          .permanentSelectedCity
                                                          .value
                                                          .name,
                                                      _locationController
                                                          .permanentSelectedState
                                                          .value
                                                          .name,
                                                      _locationController
                                                          .permanentSelectedCountry
                                                          .value
                                                          .name,
                                                    ]
                                                        .where((element) =>
                                                            element != null &&
                                                            element.isNotEmpty)
                                                        .join(' , ');

                                                    locationTextController
                                                            .text =
                                                        selectedLocation.isEmpty
                                                            ? ""
                                                            : selectedLocation;
                                                    presentlocationText =
                                                        locationTextController
                                                            .text;

                                                    return CustomTextField(
                                                        textEditingController:
                                                            locationTextController,
                                                        validator: /*  _dashboardController
                                                    .dashboardData[
                                                        "IncompleteProfile"]
                                                        ["incompleteField"]
                                                    .any((item) =>
                                                        item["table"] ==
                                                        "Location")
                                                ? */
                                                            (value) {
                                                          if (language ==
                                                              "en") {
                                                            if (value == null ||
                                                                value.isEmpty) {
                                                              return 'Enter $gender permanent address';
                                                            } else if (_locationController
                                                                    .permanentSelectedState
                                                                    .value
                                                                    .name ==
                                                                null) {
                                                              return 'Please select your $gender permanent state';
                                                            } else if (_locationController
                                                                    .permanentSelectedCity
                                                                    .value
                                                                    .name ==
                                                                null) {
                                                              return 'Please select your $gender permanent city';
                                                            }
                                                          } else {
                                                            if (value == null ||
                                                                value.isEmpty) {
                                                              return 'कृपया $gender कायमचे ठिकाण निवडा';
                                                            } else if (_locationController
                                                                    .permanentSelectedState
                                                                    .value
                                                                    .name ==
                                                                null) {
                                                              return '$gender4 कायमचे राज्य निवडणे अनिवार्य आहे.';
                                                            } else if (_locationController
                                                                    .permanentSelectedCity
                                                                    .value
                                                                    .name ==
                                                                null) {
                                                              return '$gender4 कायमचा जिल्हा निवडणे अनिवार्य आहे. ';
                                                            }
                                                          }
                                                          return null;
                                                        },
                                                        // : null,
                                                        // validator: (value) {
                                                        //   if (language == "en") {
                                                        //     if (value == null ||
                                                        //         value.isEmpty) {
                                                        //       return 'Enter $gender permanent address';
                                                        //     } else if (_locationController
                                                        //             .permanentSelectedState
                                                        //             .value
                                                        //             .name ==
                                                        //         null) {
                                                        //       return 'Please select your $gender permanent state';
                                                        //     } else if (_locationController
                                                        //             .permanentSelectedCity
                                                        //             .value
                                                        //             .name ==
                                                        //         null) {
                                                        //       return 'Please select your $gender permanent city';
                                                        //     }
                                                        //   } else {
                                                        //     if (value == null ||
                                                        //         value.isEmpty) {
                                                        //       return 'कृपया $gender कायमचे ठिकाण निवडा';
                                                        //     } else if (_locationController
                                                        //             .permanentSelectedState
                                                        //             .value
                                                        //             .name ==
                                                        //         null) {
                                                        //       return '$gender4 कायमचे राज्य निवडणे अनिवार्य आहे.';
                                                        //     } else if (_locationController
                                                        //             .permanentSelectedCity
                                                        //             .value
                                                        //             .name ==
                                                        //         null) {
                                                        //       return '$gender4 कायमचा जिल्हा निवडणे अनिवार्य आहे. ';
                                                        //     }
                                                        //   }
                                                        //   return null;
                                                        // },
                                                        readonly: true,
                                                        ontap: () {
                                                          navigatorKey
                                                              .currentState!
                                                              .push(
                                                                  MaterialPageRoute(
                                                            builder: (context) =>
                                                                const PermanentCountrySelectScreen(),
                                                          ));
                                                        },
                                                        HintText: language ==
                                                                "en"
                                                            ? "$gender permanent address"
                                                            : "$gender2 कायमचे ठिकाण निवडा");
                                                  },
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                              ],
                                            );
                                          } else {
                                            return const SizedBox();
                                          }
                                        },
                                      ),
                                    ],

                                    const SizedBox(height: 15),

                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        // Expanded(
                                        //     child: ElevatedButton(
                                        //         style: ElevatedButton.styleFrom(
                                        //             backgroundColor: Colors.white,
                                        //             side: const BorderSide(
                                        //                 color: Colors.red)),
                                        //         onPressed: () {
                                        //           // navigatorKey.currentState!
                                        //           //     .pushReplacement(
                                        //           //         MaterialPageRoute(
                                        //           //   builder: (context) =>
                                        //           //       UserInfoStepOne(),
                                        //           // ));
                                        //         },
                                        //         child: Text(
                                        //           AppLocalizations.of(context)!.back,
                                        //           style: CustomTextStyle.elevatedButton
                                        //               .copyWith(color: Colors.red),
                                        //         ))),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Expanded(
                                          child: ElevatedButton(
                                            onPressed: () {
                                              //   sharedPreferences?.setString("PageIndex", "4");

                                              _userInfoController
                                                  .isSubmitted.value = true;

                                              bool isSpecialEmployment =
                                                  _emplyedInController
                                                              .selectedOption
                                                              .value
                                                              .id ==
                                                          7 ||
                                                      _emplyedInController
                                                              .selectedOption
                                                              .value
                                                              .id ==
                                                          8 ||
                                                      _emplyedInController
                                                              .selectedOption
                                                              .value
                                                              .id ==
                                                          9;
                                              // if (_stepTwoController
                                              //         .isSameAdress.value ==
                                              //     true) {
                                              // _locationController
                                              //         .permanentSelectedCity.value =
                                              //     _locationController
                                              //         .presentselectedCity.value;
                                              // _locationController
                                              //         .permanentSelectedState
                                              //         .value =
                                              //     _locationController
                                              //         .presentselectedState.value;
                                              // _locationController
                                              //         .permanentSelectedCountry
                                              //         .value =
                                              //     _locationController
                                              //         .presentselectedCountry.value;
                                              // }
                                              // Get.toNamed(AppRouteNames.userInfoStepThree);
                                              bool workmodevalidated =
                                                  _userInfoController
                                                          .selectedWorkMode
                                                          .value
                                                          .id !=
                                                      null;

                                              // if (isSpecialEmployment) {
                                              //   print("CheckPoint 1");
                                              //   bool isEmployedInValid = _employedInKey
                                              //           .currentState
                                              //           ?.validate() ??
                                              //       false;
                                              //   bool isAnnualIncomeValid =
                                              //       _AnnualincomeKey.currentState
                                              //               ?.validate() ??
                                              //           false;
                                              //   bool isPartnerEmpValid = _EmpPatnerKey
                                              //           .currentState
                                              //           ?.validate() ??
                                              //       false;

                                              //   print(
                                              //       "CheckPoint 2 ${isEmployedInValid} ${isAnnualIncomeValid} ${isPartnerEmpValid}");

                                              // if (isEmployedInValid &&
                                              //     isAnnualIncomeValid &&
                                              //     isPartnerEmpValid) {
                                              // if (!workmodevalidated) {
                                              //   _scrollToWidget(_workModeKey);
                                              //   return;
                                              // }

                                              /// ✅ All three validations passed
                                              // _userInfoController.EmployementForm(
                                              //   employedIn: _emplyedInController
                                              //           .selectedOption.value.id ??
                                              //       0,
                                              //   workMode: _userInfoController
                                              //           .selectedWorkMode.value.id ??
                                              //       0,
                                              //   designation: '',
                                              //   companyName: '',
                                              //   annualIncome: _stepTwoController
                                              //           .selectedAnnualIncome
                                              //           .value
                                              //           ?.id ??
                                              //       0,
                                              //   currentJobLocation: '',
                                              //   PatnerEMPIn: _userInfoController
                                              //       .selectedItems
                                              //       .where((field) => field.id != null)
                                              //       .map((field) => field.id!)
                                              //       .toList(),
                                              // );
                                              // print("CheckPoint 3");
                                              // }
                                              // else {
                                              //   // Scroll to the first invalid field
                                              //   if (!isEmployedInValid) {
                                              //     _scrollToWidget(_employedInKey);
                                              //   } else if (!isAnnualIncomeValid) {
                                              //     _scrollToWidget(_AnnualincomeKey);
                                              //   } else if (!isPartnerEmpValid) {
                                              //     _scrollToWidget(_EmpPatnerKey);
                                              //   }
                                              // }

                                              // return; // Don't run the full form validation
                                              // } else {
                                              if (_formKeys.currentState!
                                                  .validate()) {
                                                print("VaLID");
                                                if (!workmodevalidated) {
                                                  print("True");
                                                  // Get.snackbar("Error", "Please Fill all required Fields");
                                                  if (_userInfoController
                                                          .selectedWorkMode
                                                          .value
                                                          .id ==
                                                      null) {
                                                    _scrollToWidget(
                                                        _workModeKey);
                                                  }

                                                  // if (isSpecialEmployment) {
                                                  //   _userInfoController.EmployementForm(
                                                  //     employedIn: _emplyedInController
                                                  //             .selectedOption.value.id ??
                                                  //         0,
                                                  //     // workMode: _userInfoController
                                                  //     //         .selectedWorkMode
                                                  //     //         .value
                                                  //     //         .id ??
                                                  //     //     0,
                                                  //     designation: '',
                                                  //     companyName: '',
                                                  //     annualIncome: _stepTwoController
                                                  //             .selectedAnnualIncome
                                                  //             .value
                                                  //             ?.id ??
                                                  //         0,
                                                  //     currentJobLocation: '',
                                                  //     PatnerEMPIn: _userInfoController
                                                  //         .selectedItems
                                                  //         .where(
                                                  //             (field) => field.id != null)
                                                  //         .map((field) => field.id!)
                                                  //         .toList(),
                                                  //   );
                                                  // }
                                                } else {
                                                  print("API Call");
                                                  _userInfoController
                                                      .EmployementForm(
                                                    employedIn:
                                                        _emplyedInController
                                                                .selectedOption
                                                                .value
                                                                .id ??
                                                            0,
                                                    // nativePlace: _stepTwoController.nativePlace.text.trim(),
                                                    workMode: _userInfoController
                                                            .selectedWorkMode
                                                            .value
                                                            .id ??
                                                        0,
                                                    designation:
                                                        _userInfoController
                                                            .designationController
                                                            .text
                                                            .trim(),
                                                    companyName: _userInfoController
                                                            .companyNameController
                                                            .text
                                                            .trim()
                                                            .isEmpty
                                                        ? ""
                                                        : _userInfoController
                                                            .companyNameController
                                                            .text
                                                            .trim(),
                                                    annualIncome:
                                                        _userInCompletController
                                                                .selectedAnnualIncome
                                                                .value
                                                                ?.id ??
                                                            0,
                                                    currentJobLocation:
                                                        _userInfoController
                                                            .jobLocation.text
                                                            .trim(),
                                                    PatnerEMPIn: _userInfoController
                                                        .selectedItems
                                                        .where((field) =>
                                                            field.id !=
                                                            null) // Filter out null ids
                                                        .map((field) =>
                                                            field.id!)
                                                        .toList(),
                                                    presentCountry:
                                                        _locationController
                                                                .presentselectedCountry
                                                                .value
                                                                .id ??
                                                            null,
                                                    presentState:
                                                        _locationController
                                                                .presentselectedState
                                                                .value
                                                                .id ??
                                                            null,
                                                    presentCity: _locationController
                                                            .presentselectedCity
                                                            .value
                                                            .id ??
                                                        null,
                                                    permanentCountry:
                                                        _locationController
                                                                .permanentSelectedCountry
                                                                .value
                                                                .id ??
                                                            null,
                                                    permanentState:
                                                        _locationController
                                                                .permanentSelectedState
                                                                .value
                                                                .id ??
                                                            null,
                                                    permanentCity:
                                                        _locationController
                                                                .permanentSelectedCity
                                                                .value
                                                                .id ??
                                                            null,
                                                    occupation:
                                                        _occupationController
                                                                .selectedOccupation
                                                                .value
                                                                .id ??
                                                            null,
                                                    otherOccupation:
                                                        _stepTwoController
                                                                .otheroccupation
                                                                .text
                                                                .trim()
                                                                .isEmpty
                                                            ? ""
                                                            : _stepTwoController
                                                                .otheroccupation
                                                                .text
                                                                .trim(),

                                                    specialization:
                                                        _specializationController
                                                                .selectedSpecialization
                                                                .value
                                                                .id ??
                                                            null,
                                                    otherSpecialization:
                                                        _userInCompletController
                                                                .otherspecialization
                                                                .text
                                                                .trim()
                                                                .isEmpty
                                                            ? ""
                                                            : _userInCompletController
                                                                .otherspecialization
                                                                .text
                                                                .trim(),

                                                    highestEducation:
                                                        _educationController
                                                                .selectedEducation
                                                                .value
                                                                .id ??
                                                            null,
                                                    otherEducation:
                                                        _userInCompletController
                                                                .othereducation
                                                                .text
                                                                .trim()
                                                                .isEmpty
                                                            ? ""
                                                            : _userInCompletController
                                                                .othereducation
                                                                .text
                                                                .trim(),
                                                  );
                                                }
                                              } else {
                                                // Get.snackbar("Error",
                                                //     "Please Fill all required Fields");
                                                if (_emplyedInController
                                                        .selectedOption
                                                        .value
                                                        .id ==
                                                    null) {
                                                  _scrollToWidget(
                                                      _employedInKey);
                                                } else if (_userInfoController
                                                    .designationController.text
                                                    .trim()
                                                    .isEmpty) {
                                                  _scrollToWidget(
                                                      _designationKey);
                                                } else if (_userInfoController
                                                    .companyNameController.text
                                                    .trim()
                                                    .isEmpty) {
                                                  _scrollToWidget(
                                                      _companyNameKey);
                                                } else if (_userInCompletController
                                                        .selectedAnnualIncome
                                                        .value
                                                        ?.id ==
                                                    null) {
                                                  _scrollToWidget(
                                                      _AnnualincomeKey);
                                                } else if (_userInfoController
                                                    .jobLocation.text
                                                    .trim()
                                                    .isEmpty) {
                                                  _scrollToWidget(
                                                      _jobLocationKey);
                                                } else if (_userInfoController
                                                        .selectedWorkMode
                                                        .value
                                                        .id ==
                                                    null) {
                                                  _scrollToWidget(_workModeKey);
                                                } else if (_locationController
                                                        .presentselectedCity
                                                        .value
                                                        .id ==
                                                    null) {
                                                  _scrollToWidget(
                                                      _presentAddressKey);
                                                } else if (_locationController
                                                        .permanentSelectedCity
                                                        .value
                                                        .id ==
                                                    null) {
                                                  _scrollToWidget(
                                                      _permanentAddressKey);
                                                }
                                              }
                                              // }
                                            },
                                            child: Obx(() {
                                              return _userInfoController
                                                      .isloading.value
                                                  ? const CircularProgressIndicator(
                                                      color: Color.fromRGBO(
                                                          255,
                                                          255,
                                                          255,
                                                          1), // Set the indicator color if needed
                                                    )
                                                  : Text(
                                                      AppLocalizations.of(
                                                              context)!
                                                          .save,
                                                      style: CustomTextStyle
                                                          .elevatedButton);
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
                                      ]
                                          // : <TextSpan>[
                                          //     TextSpan(
                                          //       text: "सर्व ",
                                          //       style: CustomTextStyle.bodytext
                                          //           .copyWith(fontSize: 12),
                                          //     ),
                                          //     const TextSpan(
                                          //       text: "*",
                                          //       style: TextStyle(color: Colors.red),
                                          //     ),
                                          //     TextSpan(
                                          //       text: " मार्क फील्ड्स भरणे आवश्यक आहे",
                                          //       style: CustomTextStyle.bodytext
                                          //           .copyWith(fontSize: 12),
                                          //     ),
                                          //   ],
                                          ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                  ],
                                ),
                              ])));
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  void _showSpecializationBottomSheet(BuildContext context) {
    final SpecializationController specializationController =
        Get.put(SpecializationController());
    // Fetch specialization data when modal opens
    specializationController.fetchSpecializatiomFromApi();

    // TextEditingController to handle search input
    TextEditingController searchController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.7,
          width: double.infinity,
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(AppLocalizations.of(context)!.selectSpecialization,
                    style: CustomTextStyle.bodytextboldLarge),
                const SizedBox(height: 10),

                // Search field
                TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    errorMaxLines: 5,
                    errorStyle: CustomTextStyle.errorText,
                    labelStyle: CustomTextStyle.bodytext,
                    hintText:
                        AppLocalizations.of(context)!.searchSpecialization,
                    contentPadding: const EdgeInsets.all(20),
                    hintStyle: CustomTextStyle.hintText,
                    filled: true,
                    fillColor: Colors.white,
                    errorBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                        gapPadding: 30),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(Radius.circular(5)),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(Radius.circular(5)),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(Radius.circular(5)),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    suffixIcon: Icon(
                      Icons.search,
                      color: Colors.grey.shade500,
                    ),
                  ),
                  onChanged: (value) {
                    specializationController.filterSpecializations(value);
                  },
                ),
                const SizedBox(height: 10),

                // Use Obx to listen for changes in fetched data and loading state
                Obx(() {
                  if (specializationController.isloading.value) {
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

                  if (specializationController.specializationList.isEmpty) {
                    return const Center(
                        child:
                            Text('No data found')); // Show message if no data
                  }

                  // Use Flexible to allow ListView to take the available space
                  return Flexible(
                    child: ListView.builder(
                      itemCount: specializationController
                          .filteredSpecializations.length,
                      itemBuilder: (context, index) {
                        var education = specializationController
                            .filteredSpecializations[index];
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              education.name.toString(),
                              style: CustomTextStyle.fieldName,
                            ),
                            const SizedBox(
                              height: 10,
                            ),

                            // Wrap to display ChoiceChips for each item
                            Wrap(
                              spacing: 10,
                              runSpacing: 10,
                              children: education.value!.map((e) {
                                return Obx(() {
                                  // Wrap with Obx to reactively update UI
                                  final isSelected = specializationController
                                          .selectedSpecialization.value.id ==
                                      e.id;
                                  return ChoiceChip(
                                    labelPadding: const EdgeInsets.all(4),
                                    checkmarkColor: Colors.white,
                                    disabledColor: AppTheme.lightPrimaryColor,
                                    backgroundColor: AppTheme.lightPrimaryColor,
                                    label: Text(
                                      e.name ?? "", // Display FieldModel name
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
                                        // Update the selected item in controller
                                        specializationController
                                            .selectSpecialization(e);
                                        print("Item is is ${e.id}");
                                      }
                                    },
                                    selectedColor: AppTheme.selectedOptionColor,
                                    labelStyle:
                                        CustomTextStyle.bodytext.copyWith(
                                      fontSize: 14,
                                      color: isSelected
                                          ? Colors.white
                                          : AppTheme.secondryColor,
                                    ),
                                  );
                                });
                              }).toList(),
                            ),
                            const SizedBox(
                              height: 20,
                            )
                          ],
                        );
                      },
                    ),
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

  void _showMultiSelectBottomSheet(BuildContext context) {
    _emplyedInController.fetchemployeedInFromApi();
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
                Text(AppLocalizations.of(context)!.selectEmployedIn,
                    style: CustomTextStyle.bodytextboldLarge),
                const SizedBox(height: 10),
                Obx(
                  () {
                    // Show shimmer effect while data is being loaded
                    if (_emplyedInController.isloading.value) {
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
                          _userInfoController.employedInList.length ==
                              _userInfoController.selectedItems.length;

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
                                _userInfoController.selectAllItems();
                              } else {
                                _userInfoController.clearAllSelections();
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
                            children:
                                _userInfoController.employedInList.map((item) {
                              final isSelected = _userInfoController
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
                                  _userInfoController.toggleSelection(item);
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

  void _showEmployeedInBottomSheet(BuildContext context) {
    final EmplyedInController emplyedInController =
        Get.put(EmplyedInController());
    // Fetch employed in data when modal opens
    emplyedInController.fetchemployeedInFromApi();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return ConstrainedBox(
          constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height *
                  0.7 // Set your desired max height here
              ),
          child: Container(
            //  height: MediaQuery.of(context).size.height * 0.7,
            width: double.infinity,
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(AppLocalizations.of(context)!.selectEmployedIn,
                        style: CustomTextStyle.bodytextboldLarge),
                    const SizedBox(height: 10),

                    // Search bar for filtering
                    TextField(
                      style: CustomTextStyle.bodytext,
                      decoration: InputDecoration(
                        errorMaxLines: 5,
                        errorStyle: CustomTextStyle.errorText,
                        labelStyle: CustomTextStyle.bodytext,
                        hintText:
                            AppLocalizations.of(context)!.searchEmployedIn,
                        contentPadding: const EdgeInsets.all(20),
                        hintStyle: CustomTextStyle.hintText,
                        filled: true,
                        fillColor: Colors.white,
                        errorBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red),
                            gapPadding: 30),
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
                        border: OutlineInputBorder(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(5)),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        suffixIcon: Icon(
                          Icons.search,
                          color: Colors.grey.shade500,
                        ),
                      ),
                      onChanged: (query) {
                        emplyedInController.searchEmployedIn(
                            query); // Call the search function in controller
                      },
                    ),
                    const SizedBox(height: 10),

                    // Use Obx to listen for changes in fetched data and loading state
                    Obx(() {
                      if (emplyedInController.isloading.value) {
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

                      if (emplyedInController.filteredEmployedInList.isEmpty) {
                        return const Center(
                            child: Text(
                                'No data found')); // Show message if no data
                      }

                      // Display the fetched list of items in ChoiceChips (only one can be selected)
                      return Wrap(
                        spacing: 5,
                        runSpacing: 10,
                        children: emplyedInController.filteredEmployedInList
                            .map((FieldModel item) {
                          final isSelected =
                              emplyedInController.selectedOption.value.id ==
                                  item.id;

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
                                emplyedInController.selectEmployeedIn(
                                    item); // Update the selected item
                                print("This is employed in iD ${item.id}");
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
            ),
          ),
        );
      },
    );
  }

  void _showOccupationBottomSheet(BuildContext context) {
    final OccupationController occupationController =
        Get.put(OccupationController());

    // Fetch occupation data when modal opens
    occupationController.fetchOccupationFromApi();
    TextEditingController searchController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        // Add a local TextEditingController for the search field
        return Container(
          height: MediaQuery.of(context).size.height * 0.7,
          width: double.infinity,
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(AppLocalizations.of(context)!.selectOccupation,
                    style: CustomTextStyle.bodytextboldLarge),
                const SizedBox(height: 10),

                // Search Field
                TextField(
                  style: CustomTextStyle.bodytext,
                  controller: searchController,
                  decoration: InputDecoration(
                    errorMaxLines: 5,
                    errorStyle: CustomTextStyle.errorText,
                    labelStyle: CustomTextStyle.bodytext,
                    hintText: AppLocalizations.of(context)!.searchOccupation,
                    contentPadding: const EdgeInsets.all(20),
                    hintStyle: CustomTextStyle.hintText,
                    filled: true,
                    fillColor: Colors.white,
                    errorBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                        gapPadding: 30),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(Radius.circular(5)),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(Radius.circular(5)),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(Radius.circular(5)),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    suffixIcon: Icon(
                      Icons.search,
                      color: Colors.grey.shade500,
                    ),
                  ),
                  onChanged: (query) {
                    occupationController.searchOccupation(
                        query); // Call the search function in controller
                  },
                ),
                const SizedBox(height: 10),

                // Use Obx to listen for changes in fetched data and loading state
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

                  if (occupationController.filteredEducationList.isEmpty) {
                    return const Center(
                        child:
                            Text('No data found')); // Show message if no data
                  }

                  // Use Flexible to allow ListView to take the available space
                  return Flexible(
                    child: ListView.builder(
                      itemCount:
                          occupationController.filteredEducationList.length,
                      itemBuilder: (context, index) {
                        var education =
                            occupationController.filteredEducationList[index];
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(education.name.toString(),
                                style: CustomTextStyle.fieldName),
                            const SizedBox(height: 10),

                            // Wrap to display ChoiceChips for each item
                            Wrap(
                              spacing: 10,
                              runSpacing: 10,
                              children: education.value!.map((e) {
                                return Obx(() {
                                  // Wrap with Obx to reactively update UI
                                  final isSelected = occupationController
                                          .selectedOccupation.value.id ==
                                      e.id;
                                  return ChoiceChip(
                                    labelPadding: const EdgeInsets.all(4),
                                    checkmarkColor: Colors.white,
                                    disabledColor: AppTheme.lightPrimaryColor,
                                    backgroundColor: AppTheme.lightPrimaryColor,
                                    label: Text(
                                      e.name ?? "", // Display FieldModel name
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
                                        // Update the selected item in controller
                                        occupationController
                                            .selectOccupation(e);
                                      }
                                    },
                                    selectedColor: AppTheme.selectedOptionColor,
                                    labelStyle:
                                        CustomTextStyle.bodytext.copyWith(
                                      fontSize: 14,
                                      color: isSelected
                                          ? Colors.white
                                          : AppTheme.secondryColor,
                                    ),
                                  );
                                });
                              }).toList(),
                            ),
                            const SizedBox(
                              height: 20,
                            )
                          ],
                        );
                      },
                    ),
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

  void _showEducationBottomSheet(BuildContext context) {
    final EducationController educationController =
        Get.put(EducationController());
    // Fetch Ras data when modal opens
    educationController.fetcheducationFromApi();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.7,
          width: double.infinity,
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(AppLocalizations.of(context)!.selectHighestEducation,
                    style: CustomTextStyle.bodytextboldLarge),
                const SizedBox(height: 10),

                // Search TextField
                TextField(
                  onChanged: (value) {
                    educationController.searchQuery.value =
                        value; // Update search query
                    educationController
                        .filterEducationList(); // Filter the list
                  },
                  style: CustomTextStyle.bodytext,
                  decoration: InputDecoration(
                    errorMaxLines: 5,
                    errorStyle: CustomTextStyle.errorText,
                    labelStyle: CustomTextStyle.bodytext,
                    hintText: AppLocalizations.of(context)!.searchEducation,
                    contentPadding: const EdgeInsets.all(20),
                    hintStyle: CustomTextStyle.hintText,
                    filled: true,
                    fillColor: Colors.white,
                    errorBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                        gapPadding: 30),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(Radius.circular(5)),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(Radius.circular(5)),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(Radius.circular(5)),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    suffixIcon: Icon(
                      Icons.search,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                Obx(() {
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

                  if (educationController.filteredEducationList.isEmpty) {
                    return const Center(child: Text('No data found'));
                  }

                  return Flexible(
                    child: ListView.builder(
                      itemCount:
                          educationController.filteredEducationList.length,
                      itemBuilder: (context, index) {
                        var education =
                            educationController.filteredEducationList[index];
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(education.name.toString(),
                                style: CustomTextStyle.fieldName),
                            const SizedBox(height: 10),
                            Wrap(
                              spacing: 10,
                              runSpacing: 10,
                              children: education.value!.map((e) {
                                return Obx(() {
                                  final isSelected = educationController
                                          .selectedEducation.value.id ==
                                      e.id;
                                  return ChoiceChip(
                                    labelPadding: const EdgeInsets.all(4),
                                    checkmarkColor: Colors.white,
                                    disabledColor: AppTheme.lightPrimaryColor,
                                    backgroundColor: AppTheme.lightPrimaryColor,
                                    label: Text(
                                      e.name ?? "", // Display FieldModel name
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
                                        educationController.selectEducation(e);
                                        educationController.selectEducationint
                                            .value = e.id ?? 0;
                                      }
                                    },
                                    selectedColor: AppTheme.selectedOptionColor,
                                    labelStyle:
                                        CustomTextStyle.bodytext.copyWith(
                                      fontSize: 14,
                                      color: isSelected
                                          ? Colors.white
                                          : AppTheme.secondryColor,
                                    ),
                                  );
                                });
                              }).toList(),
                            ),
                            const SizedBox(height: 20)
                          ],
                        );
                      },
                    ),
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
}
