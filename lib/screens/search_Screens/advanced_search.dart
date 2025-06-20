//import 'package:csc_picker/csc_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:_96kuliapp/commons/dialogues/AllFields/formfields/expectededucation.dart';
import 'package:_96kuliapp/commons/dialogues/AllFields/formfields/expextedOccupationList.dart';
import 'package:_96kuliapp/commons/textdecoration.dart';
import 'package:_96kuliapp/controllers/formfields/castController.dart';
import 'package:_96kuliapp/controllers/formfields/educationController.dart';
import 'package:_96kuliapp/controllers/formfields/occupationController.dart';
import 'package:_96kuliapp/controllers/locationcontroller/LocationController.dart';
import 'package:_96kuliapp/controllers/search/advancefilterController.dart';
import 'package:_96kuliapp/main.dart';
import 'package:_96kuliapp/models/forms/castemultiselectmodel.dart';
import 'package:_96kuliapp/models/forms/fields/fieldModel.dart';
import 'package:_96kuliapp/routes/routenames.dart';
import 'package:_96kuliapp/screens/search_Screens/searchResultScreen.dart';
import 'package:_96kuliapp/screens/userInfoForms/location/partnerexpectation/partnerCity.dart';
import 'package:_96kuliapp/screens/userInfoForms/location/partnerexpectation/partnerCountry.dart';
import 'package:_96kuliapp/screens/userInfoForms/location/partnerexpectation/partnerState.dart';
import 'package:_96kuliapp/utils/Apptheme.dart';
import 'package:_96kuliapp/utils/backHeader.dart';
import 'package:_96kuliapp/utils/buttonContainer.dart';
import 'package:_96kuliapp/utils/customdropdown.dart';
import 'package:_96kuliapp/utils/customtextform.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AdvancedSearch extends StatefulWidget {
  const AdvancedSearch({super.key});

  @override
  State<AdvancedSearch> createState() => _AdvancedSearchState();
}

class _AdvancedSearchState extends State<AdvancedSearch> {
  final Advancefiltercontroller _stepThreeController =
      Get.put(Advancefiltercontroller());
  final OccupationController _occupationController =
      Get.put(OccupationController());
  final EducationController _educationController =
      Get.put(EducationController());
  final LocationController _locationController = Get.put(LocationController());
  final CastController _castController = Get.put(CastController());
  final ScrollController _scrollController = ScrollController();

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
    super.initState();
    _castController.selectedCasteList.value = [];
    _castController.selectedSectionList.value = [];
    _castController.selectedSubSectionList.value = [];
    _educationController.selectedEducationList.value = [];
    _occupationController.selectedOccupations.value = [];
    _locationController.selectedCities.value = [];
    _locationController.selectedCountries.value = [];
    _locationController.selectedStates.value = [];
  }

  @override
  Widget build(BuildContext context) {
    String? language = sharedPreferences?.getString("Language");
    /*
   ScrollController controller = ScrollController(
      initialScrollOffset: _stepThreeController.scrollOffset.value,
    );*/

    return WillPopScope(
      onWillPop: () async {
        _castController.selectedCasteList.value = [];
        _castController.selectedSectionList.value = [];
        _castController.selectedSubSectionList.value = [];
        _educationController.selectedEducationList.value = [];
        _occupationController.selectedOccupations.value = [];
        _locationController.selectedCities.value = [];
        _locationController.selectedCountries.value = [];
        _locationController.selectedStates.value = [];
        return true;
      },
      child: Scaffold(
        body: SingleChildScrollView(
          controller: _scrollController,
          child: SafeArea(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BackHeader(
                  onTap: () {
                    _castController.selectedCasteList.value = [];
                    _castController.selectedSectionList.value = [];
                    _castController.selectedSubSectionList.value = [];
                    _educationController.selectedEducationList.value = [];
                    _occupationController.selectedOccupations.value = [];
                    _locationController.selectedCities.value = [];
                    _locationController.selectedCountries.value = [];
                    _locationController.selectedStates.value = [];
                    Get.back();
                  },
                  title: language == "en"
                      ? "Advance Search"
                      : "अद्यावत सर्च ऑप्शन "),
              Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                            key: _minAgeKey,
                            text: TextSpan(children: <TextSpan>[
                              TextSpan(
                                  text: AppLocalizations.of(context)!
                                      .partnerMinAge,
                                  // "Partner's Min Age",
                                  style: CustomTextStyle.fieldName),
                              const TextSpan(
                                  text: "*",
                                  style: TextStyle(color: Colors.red))
                            ])),
                        Obx(
                          () {
                            final TextEditingController minage =
                                TextEditingController(
                                    text: _stepThreeController
                                        .selectedMinAge.value.name);
                            return CustomTextField(
                              validator: (value) {
                                if (language == "en") {
                                  if (value == null || value.isEmpty) {
                                    return "Please select your partner's min age ";
                                  }
                                } else {
                                  if (value == null || value.isEmpty) {
                                    return "जोडीदाराचे किमान वय निवडा";
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
                                _stepThreeController.searchedMinAgeList.value =
                                    _stepThreeController.ageRange;

                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return Dialog(
                                      backgroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
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
                                                style: CustomTextStyle.bodytext,
                                                decoration: InputDecoration(
                                                  errorMaxLines: 5,
                                                  errorStyle:
                                                      CustomTextStyle.errorText,
                                                  labelStyle:
                                                      CustomTextStyle.bodytext,
                                                  hintText: language == "en"
                                                      ? "Search Min. Age"
                                                      : "कमीत कमी वय निवडा",
                                                  contentPadding:
                                                      const EdgeInsets.all(20),
                                                  hintStyle:
                                                      CustomTextStyle.hintText,
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
                                                        const BorderRadius.all(
                                                            Radius.circular(5)),
                                                    borderSide: BorderSide(
                                                        color: Colors
                                                            .grey.shade300),
                                                  ),
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                    borderRadius:
                                                        const BorderRadius.all(
                                                            Radius.circular(5)),
                                                    borderSide: BorderSide(
                                                        color: Colors
                                                            .grey.shade300),
                                                  ),
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        const BorderRadius.all(
                                                            Radius.circular(5)),
                                                    borderSide: BorderSide(
                                                        color: Colors
                                                            .grey.shade300),
                                                  ),
                                                  suffixIcon: Icon(Icons.search,
                                                      color:
                                                          Colors.grey.shade500),
                                                ),
                                                onChanged: (query) {
                                                  _stepThreeController.searchMinAge(
                                                      query); // Filter the list in the controller
                                                },
                                              ),
                                            ),
                                            Container(
                                              decoration: const BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(5)),
                                                color: Colors.white,
                                              ),
                                              height:
                                                  400, // Set a height for the list inside the dialog
                                              child: Obx(() {
                                                return ListView.builder(
                                                  shrinkWrap: true,
                                                  itemCount:
                                                      _stepThreeController
                                                          .searchedMinAgeList
                                                          .length,
                                                  itemBuilder:
                                                      (context, index) {
                                                    final item =
                                                        _stepThreeController
                                                                .searchedMinAgeList[
                                                            index];
                                                    bool isSelected =
                                                        _stepThreeController
                                                                .selectedMinAge
                                                                .value
                                                                .id ==
                                                            item.id;

                                                    return GestureDetector(
                                                      onTap: () {
                                                        // Update the selected value and close the dialog
                                                        _stepThreeController
                                                            .updateMinAge(item);
                                                        // Update the controller text based on selection

                                                        Navigator.pop(context);
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
                                                                  ? Colors.white
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
                        RichText(
                            key: _maxAgeKey,
                            text: TextSpan(children: <TextSpan>[
                              TextSpan(
                                  text: AppLocalizations.of(context)!
                                      .partnerMaxAge,
                                  style: CustomTextStyle.fieldName),
                              const TextSpan(
                                  text: "*",
                                  style: TextStyle(color: Colors.red))
                            ])),
                        Obx(
                          () {
                            final TextEditingController maxage =
                                TextEditingController(
                                    text: _stepThreeController
                                        .selectedMaxAge.value.name);
                            return CustomTextField(
                              validator: (value) {
                                if (language == "en") {
                                  if (value == null || value.isEmpty) {
                                    return "Select your partner's max age";
                                  }
                                } else {
                                  if (value == null || value.isEmpty) {
                                    return "जोडीदाराचे कमाल वय निवडा";
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
                                _stepThreeController.searchedMAxAgeList.value =
                                    _stepThreeController
                                        .getFilteredMaxAgeList();

                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return Dialog(
                                      backgroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
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
                                                style: CustomTextStyle.bodytext,
                                                decoration: InputDecoration(
                                                  errorMaxLines: 5,
                                                  errorStyle:
                                                      CustomTextStyle.errorText,
                                                  labelStyle:
                                                      CustomTextStyle.bodytext,
                                                  hintText: language == "en"
                                                      ? "Search Max Age"
                                                      : "जास्तीत जास्त वय निवडा",
                                                  contentPadding:
                                                      const EdgeInsets.all(20),
                                                  hintStyle:
                                                      CustomTextStyle.hintText,
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
                                                        const BorderRadius.all(
                                                            Radius.circular(5)),
                                                    borderSide: BorderSide(
                                                        color: Colors
                                                            .grey.shade300),
                                                  ),
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                    borderRadius:
                                                        const BorderRadius.all(
                                                            Radius.circular(5)),
                                                    borderSide: BorderSide(
                                                        color: Colors
                                                            .grey.shade300),
                                                  ),
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        const BorderRadius.all(
                                                            Radius.circular(5)),
                                                    borderSide: BorderSide(
                                                        color: Colors
                                                            .grey.shade300),
                                                  ),
                                                  suffixIcon: Icon(Icons.search,
                                                      color:
                                                          Colors.grey.shade500),
                                                ),
                                                onChanged: (query) {
                                                  _stepThreeController.searchMaxAge(
                                                      query); // Filter the list in the controller
                                                },
                                              ),
                                            ),
                                            Container(
                                              decoration: const BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(5)),
                                                color: Colors.white,
                                              ),
                                              height:
                                                  400, // Set a height for the list inside the dialog
                                              child: Obx(() {
                                                return ListView.builder(
                                                  shrinkWrap: true,
                                                  itemCount:
                                                      _stepThreeController
                                                          .searchedMAxAgeList
                                                          .length,
                                                  itemBuilder:
                                                      (context, index) {
                                                    final item =
                                                        _stepThreeController
                                                                .searchedMAxAgeList[
                                                            index];
                                                    bool isSelected =
                                                        _stepThreeController
                                                                .selectedMaxAge
                                                                .value
                                                                .id ==
                                                            item.id;

                                                    return GestureDetector(
                                                      onTap: () {
                                                        // Update the selected value and close the dialog
                                                        _stepThreeController
                                                            .updateMaxAge(item);
                                                        // Update the controller text based on selection

                                                        Navigator.pop(context);
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
                                                                  ? Colors.white
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
                        RichText(
                            key: _minHeightKey,
                            text: TextSpan(children: <TextSpan>[
                              TextSpan(
                                  text: AppLocalizations.of(context)!
                                      .partnerMinHeight,
                                  style: CustomTextStyle.fieldName),
                              const TextSpan(
                                  text: "*",
                                  style: TextStyle(color: Colors.red))
                            ])),
                        Obx(
                          () {
                            final TextEditingController maxage =
                                TextEditingController(
                                    text: _stepThreeController
                                        .selectedMinHeight.value.name);
                            return CustomTextField(
                              validator: (value) {
                                if (language == "en") {
                                  if (value == null || value.isEmpty) {
                                    return "Select your partner's min height";
                                  }
                                } else {
                                  if (value == null || value.isEmpty) {
                                    return "जोडीदाराची किमान उंची निवडा";
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
                                _stepThreeController.searchedMinHeightList
                                    .value = _stepThreeController.heightRange;

                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return Dialog(
                                      backgroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
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
                                                  errorStyle:
                                                      CustomTextStyle.errorText,
                                                  labelStyle:
                                                      CustomTextStyle.bodytext,
                                                  hintText:
                                                      "Search Min. Height",
                                                  contentPadding:
                                                      const EdgeInsets.all(20),
                                                  hintStyle:
                                                      CustomTextStyle.hintText,
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
                                                        const BorderRadius.all(
                                                            Radius.circular(5)),
                                                    borderSide: BorderSide(
                                                        color: Colors
                                                            .grey.shade300),
                                                  ),
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                    borderRadius:
                                                        const BorderRadius.all(
                                                            Radius.circular(5)),
                                                    borderSide: BorderSide(
                                                        color: Colors
                                                            .grey.shade300),
                                                  ),
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        const BorderRadius.all(
                                                            Radius.circular(5)),
                                                    borderSide: BorderSide(
                                                        color: Colors
                                                            .grey.shade300),
                                                  ),
                                                  suffixIcon: Icon(Icons.search,
                                                      color:
                                                          Colors.grey.shade500),
                                                ),
                                                onChanged: (query) {
                                                  _stepThreeController
                                                      .searchMinHeight(
                                                          query); // Filter the list in the controller
                                                },
                                              ),
                                            ),
                                            Container(
                                              decoration: const BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(5)),
                                                color: Colors.white,
                                              ),
                                              height:
                                                  400, // Set a height for the list inside the dialog
                                              child: Obx(() {
                                                return ListView.builder(
                                                  shrinkWrap: true,
                                                  itemCount:
                                                      _stepThreeController
                                                          .searchedMinHeightList
                                                          .length,
                                                  itemBuilder:
                                                      (context, index) {
                                                    final item =
                                                        _stepThreeController
                                                                .searchedMinHeightList[
                                                            index];
                                                    bool isSelected =
                                                        _stepThreeController
                                                                .selectedMinHeight
                                                                .value
                                                                .id ==
                                                            item.id;

                                                    return GestureDetector(
                                                      onTap: () {
                                                        // Update the selected value and close the dialog
                                                        _stepThreeController
                                                            .updateMinHeight(
                                                                item);
                                                        // Update the controller text based on selection

                                                        Navigator.pop(context);
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
                                                                  ? Colors.white
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
                        RichText(
                          key: _maxHeightKey,
                          text: TextSpan(children: <TextSpan>[
                            TextSpan(
                                text: AppLocalizations.of(context)!
                                    .partnerMaxHeight,
                                style: CustomTextStyle.fieldName),
                            const TextSpan(
                                text: "*", style: TextStyle(color: Colors.red))
                          ]),
                        ),
                        Obx(
                          () {
                            final TextEditingController maxage =
                                TextEditingController(
                                    text: _stepThreeController
                                        .selectedMaxHeight.value.name);
                            return CustomTextField(
                              validator: (value) {
                                if (language == "en") {
                                  if (value == null || value.isEmpty) {
                                    return "Select your partner's max height";
                                  }
                                } else {
                                  if (value == null || value.isEmpty) {
                                    return "जोडीदाराची कमाल उंची निवडा";
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
                                _stepThreeController
                                        .searchedMAxHeightList.value =
                                    _stepThreeController
                                        .getFilteredMaxHeightList();

                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return Dialog(
                                      backgroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
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
                                                  errorStyle:
                                                      CustomTextStyle.errorText,
                                                  labelStyle:
                                                      CustomTextStyle.bodytext,
                                                  hintText:
                                                      "Search Max. Height",
                                                  contentPadding:
                                                      const EdgeInsets.all(20),
                                                  hintStyle:
                                                      CustomTextStyle.hintText,
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
                                                        const BorderRadius.all(
                                                            Radius.circular(5)),
                                                    borderSide: BorderSide(
                                                        color: Colors
                                                            .grey.shade300),
                                                  ),
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                    borderRadius:
                                                        const BorderRadius.all(
                                                            Radius.circular(5)),
                                                    borderSide: BorderSide(
                                                        color: Colors
                                                            .grey.shade300),
                                                  ),
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        const BorderRadius.all(
                                                            Radius.circular(5)),
                                                    borderSide: BorderSide(
                                                        color: Colors
                                                            .grey.shade300),
                                                  ),
                                                  suffixIcon: Icon(Icons.search,
                                                      color:
                                                          Colors.grey.shade500),
                                                ),
                                                onChanged: (query) {
                                                  _stepThreeController
                                                      .searchMaxHeight(
                                                          query); // Filter the list in the controller
                                                },
                                              ),
                                            ),
                                            Container(
                                              decoration: const BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(5)),
                                                color: Colors.white,
                                              ),
                                              height:
                                                  400, // Set a height for the list inside the dialog
                                              child: Obx(() {
                                                return ListView.builder(
                                                  shrinkWrap: true,
                                                  itemCount:
                                                      _stepThreeController
                                                          .searchedMAxHeightList
                                                          .length,
                                                  itemBuilder:
                                                      (context, index) {
                                                    final item =
                                                        _stepThreeController
                                                                .searchedMAxHeightList[
                                                            index];
                                                    bool isSelected =
                                                        _stepThreeController
                                                                .selectedMaxHeight
                                                                .value
                                                                .id ==
                                                            item.id;

                                                    return GestureDetector(
                                                      onTap: () {
                                                        // Update the selected value and close the dialog
                                                        _stepThreeController
                                                            .updateMaxHeight(
                                                                item);
                                                        // Update the controller text based on selection

                                                        Navigator.pop(context);
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
                                                                  ? Colors.white
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
                items: _stepThreeController.getFilteredMaxAgeList(), // Filtered max age list
                value: _stepThreeController.selectedMaxAge.id != null
                    ? _stepThreeController
                        .getFilteredMaxAgeList()
                        .firstWhere((item) => item.id == _stepThreeController.selectedMaxAge.id)
                    : null, // Pre-select based on the max age ID
                onChanged: (FieldModel? newValue) {
                  if (newValue != null) {
                    _stepThreeController.updateMaxAge(newValue.id); // Update max age in controller
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
                items: _stepThreeController.heightRange, // Use the controller's heightRange
                value: _stepThreeController.selectedMinHeight.value != null
                    ? _stepThreeController.heightRange.firstWhere(
                        (item) => item.id == _stepThreeController.selectedMinHeight.value,
                        orElse: () => FieldModel(id: -1, name: "Select Min Height"), // Default item to avoid error
                      )
                    : null, // Pre-select based on the min height ID
                onChanged: (FieldModel? newValue) {
                  if (newValue != null) {
                    print("Selected Min Height ID is ${newValue.id}");
                    _stepThreeController.updateMinHeight(newValue); // Update min height in controller
                    _stepThreeController.getFilteredMaxHeightList(); // Filter max height list based on min height
                  }
                },
                hintText: "Min Height",
              );
            }),
      
            SizedBox(height: 10,), 
            Obx(() {
              final filteredMaxHeights = _stepThreeController.getFilteredMaxHeightList();
              return CustomDropdownButton(
                validator: (value) {
                  if (value == null) {
                    return 'Required';
                  }
                  return null;
                },
                items: filteredMaxHeights, // Filtered max height list
                value: _stepThreeController.selectedMaxHeight.value.id != null
                    ? filteredMaxHeights.firstWhere(
                        (item) => item.id == _stepThreeController.selectedMaxHeight.value.id,
                        orElse: () => FieldModel(id: -1, name: "Select Max Height"), // Default item to avoid error
                      )
                    : null, // Pre-select based on the max height ID
                onChanged: (FieldModel? newValue) {
                  if (newValue != null) {
                    _stepThreeController.updateMaxHeight(newValue); // Update max height in controller
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
                        const SizedBox(
                          height: 15,
                        ),
                        RichText(
                            key: _partnerSectionKey,
                            text: TextSpan(children: <TextSpan>[
                              TextSpan(
                                  text: AppLocalizations.of(context)!
                                      .partnerSubCaste,
                                  style: CustomTextStyle.fieldName),
                              const TextSpan(
                                  text: "*",
                                  style: TextStyle(color: Colors.red))
                            ])),
                        Obx(() {
                          // Check if selectedSectionStringList is empty
                          if (_castController.selectedSectionList.isEmpty) {
                            // If no sections selected, show the CustomTextField to select sections
                            return CustomTextField(
                              validator: (value) {
                                if (language == "en") {
                                  if (value == null || value.isEmpty) {
                                    return "Select partner's subcaste";
                                  }
                                } else {
                                  if (value == null || value.isEmpty) {
                                    return "जोडीदाराची पोटजात निवडा";
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
                                        color: Colors.grey.shade300, width: 1),
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
                                                          .sectionList.length) {
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
                                                                      bottom: 2,
                                                                      top:
                                                                          12.0),
                                                              child: Text(
                                                                "+ Add",
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
                                                                      bottom: 2,
                                                                      top:
                                                                          12.0),
                                                              child: Text(
                                                                "(+${_castController.selectedSectionList.length - 4}) More",
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
                        // const SizedBox(
                        //   height: 15,
                        // ),
                        // RichText(
                        //     key: _subSectionKey,
                        //     text: const TextSpan(children: <TextSpan>[
                        //       TextSpan(
                        //           text: "Partner's Sub Section ",
                        //           style: CustomTextStyle.fieldName),
                        //       TextSpan(
                        //           text: "*",
                        //           style: TextStyle(color: Colors.red))
                        //     ])),
                        // Obx(() {
                        //   // Check if selectedSectionStringList is empty
                        //   if (_castController.selectedSubSectionList.isEmpty) {
                        //     // If no sections selected, show the CustomTextField to select sections
                        //     return CustomTextField(
                        //       validator: (value) {
                        //         if (value == null || value.isEmpty) {
                        //           return "Please select your partner's  sub section";
                        //         }
                        //         return null;
                        //       },
                        //       ontap: () {
                        //         _showSubSectionBottomSheet(context);
                        //       },
                        //       readonly: true,
                        //       HintText: "Select Sub Section",
                        //     );
                        //   } else {
                        //     // If sections are selected, show the container with chips
                        //     return Padding(
                        //       padding: const EdgeInsets.only(top: 10),
                        //       child: GestureDetector(
                        //         onTap: () {
                        //           _showSubSectionBottomSheet(context);
                        //         },
                        //         child: Container(
                        //           decoration: BoxDecoration(
                        //             border: Border.all(
                        //                 color: Colors.grey.shade300, width: 1),
                        //             borderRadius: const BorderRadius.all(
                        //                 Radius.circular(5)),
                        //           ),
                        //           child: Padding(
                        //             padding: const EdgeInsets.all(12.0),
                        //             child: ConstrainedBox(
                        //               constraints: BoxConstraints(
                        //                   minWidth: double.infinity),
                        //               child: Column(
                        //                 crossAxisAlignment:
                        //                     CrossAxisAlignment.start,
                        //                 mainAxisAlignment:
                        //                     MainAxisAlignment.end,
                        //                 children: [
                        //                   Wrap(
                        //                     direction: Axis.horizontal,

                        //                     spacing:
                        //                         10, // Spacing between chips horizontally
                        //                     runSpacing:
                        //                         10, // Spacing between rows vertically
                        //                     children: [
                        //                       ...List.generate(
                        //                         _castController
                        //                                     .selectedSubSectionList
                        //                                     .length >
                        //                                 4
                        //                             ? 4
                        //                             : _castController
                        //                                 .selectedSubSectionList
                        //                                 .length,
                        //                         (index) {
                        //                           final item = _castController
                        //                                   .selectedSubSectionList[
                        //                               index];
                        //                           return Chip(
                        //                             deleteIcon: const Padding(
                        //                               padding:
                        //                                   EdgeInsets.all(0),
                        //                               child: Icon(Icons.close,
                        //                                   size: 12),
                        //                             ),
                        //                             padding:
                        //                                 const EdgeInsets.all(2),
                        //                             labelPadding:
                        //                                 const EdgeInsets.all(4),
                        //                             backgroundColor: AppTheme
                        //                                 .lightPrimaryColor,
                        //                             side: const BorderSide(
                        //                               style: BorderStyle.none,
                        //                               color: Colors.blue,
                        //                             ),
                        //                             label: Text(
                        //                               item.name ?? "",
                        //                               style: CustomTextStyle
                        //                                   .bodytext
                        //                                   .copyWith(
                        //                                       fontSize: 11),
                        //                             ),
                        //                             onDeleted: () {
                        //                               _castController
                        //                                   .selectedSubSectionList
                        //                                   .remove(item);
                        //                             },
                        //                           );
                        //                         },
                        //                       ),
                        //                       // Add button as a Chip
                        //                       Obx(
                        //                         () {
                        //                           if (_castController
                        //                                   .selectedSubSectionList
                        //                                   .length <=
                        //                               4) {
                        //                             return GestureDetector(
                        //                               onTap: () {
                        //                                 // Navigate to view all countries
                        //                                 _showCasteBottomSheet(
                        //                                     context);
                        //                               },
                        //                               child: Padding(
                        //                                 padding:
                        //                                     const EdgeInsets
                        //                                         .only(
                        //                                         bottom: 2,
                        //                                         top: 12.0),
                        //                                 child: Text(
                        //                                   "+ Add",
                        //                                   style: CustomTextStyle
                        //                                       .bodytext
                        //                                       .copyWith(
                        //                                     color: AppTheme
                        //                                         .selectedOptionColor,
                        //                                     fontWeight:
                        //                                         FontWeight.bold,
                        //                                   ),
                        //                                 ),
                        //                               ),
                        //                             );
                        //                           } else {
                        //                             return GestureDetector(
                        //                               onTap: () {
                        //                                 // Navigate to view all countries
                        //                                 _showSubSectionBottomSheet(
                        //                                     context);
                        //                               },
                        //                               child: Padding(
                        //                                 padding:
                        //                                     const EdgeInsets
                        //                                         .only(
                        //                                         bottom: 2,
                        //                                         top: 12.0),
                        //                                 child: Text(
                        //                                   "(+${_castController.selectedSubSectionList.length - 4}) More",
                        //                                   style: CustomTextStyle
                        //                                       .bodytext
                        //                                       .copyWith(
                        //                                     color: AppTheme
                        //                                         .selectedOptionColor,
                        //                                     fontWeight:
                        //                                         FontWeight.bold,
                        //                                   ),
                        //                                 ),
                        //                               ),
                        //                             );
                        //                           }
                        //                         },
                        //                       )
                        //                     ],
                        //                   ),
                        //                 ],
                        //               ),
                        //             ),
                        //           ),
                        //         ),
                        //       ),
                        //     );
                        //   }
                        // }),
                        // const SizedBox(
                        //   height: 15,
                        // ),
                        // RichText(
                        //     key: _casteKey,
                        //     text: const TextSpan(children: <TextSpan>[
                        //       TextSpan(
                        //           text: "Partner's Caste ",
                        //           style: CustomTextStyle.fieldName),
                        //       TextSpan(
                        //           text: "*",
                        //           style: TextStyle(color: Colors.red))
                        //     ])),
                        // Obx(() {
                        //   // Check if selectedSectionStringList is empty
                        //   if (_castController.selectedCasteList.isEmpty) {
                        //     // If no sections selected, show the CustomTextField to select sections
                        //     return CustomTextField(
                        //       validator: (value) {
                        //         if (value == null || value.isEmpty) {
                        //           return "Please select your partner's caste";
                        //         }
                        //         return null;
                        //       },
                        //       ontap: () {
                        //         _showCasteBottomSheet(
                        //             context); // Open bottom sheet for section selection
                        //       },
                        //       readonly: true,
                        //       HintText: "Select Caste",
                        //     );
                        //   } else {
                        //     // If sections are selected, show the container with chips
                        //     return Padding(
                        //       padding: const EdgeInsets.only(top: 10.0),
                        //       child: GestureDetector(
                        //         onTap: () {
                        //           _showCasteBottomSheet(context);
                        //         },
                        //         child: Container(
                        //           decoration: BoxDecoration(
                        //             border: Border.all(
                        //                 color: Colors.grey.shade300, width: 1),
                        //             borderRadius: const BorderRadius.all(
                        //                 Radius.circular(5)),
                        //           ),
                        //           child: Padding(
                        //             padding: const EdgeInsets.all(12.0),
                        //             child: ConstrainedBox(
                        //               constraints: BoxConstraints(
                        //                   minWidth: double.infinity),
                        //               child: Column(
                        //                 crossAxisAlignment:
                        //                     CrossAxisAlignment.start,
                        //                 mainAxisAlignment:
                        //                     MainAxisAlignment.end,
                        //                 children: [
                        //                   Wrap(
                        //                     direction: Axis.horizontal,

                        //                     spacing:
                        //                         10, // Spacing between chips horizontally
                        //                     runSpacing:
                        //                         10, // Spacing between rows vertically
                        //                     children: [
                        //                       ...List.generate(
                        //                         _castController
                        //                                     .selectedCasteList
                        //                                     .length >
                        //                                 4
                        //                             ? 4
                        //                             : _castController
                        //                                 .selectedCasteList
                        //                                 .length,
                        //                         (index) {
                        //                           final item = _castController
                        //                               .selectedCasteList[index];
                        //                           return Chip(
                        //                             deleteIcon: const Padding(
                        //                               padding:
                        //                                   EdgeInsets.all(0),
                        //                               child: Icon(Icons.close,
                        //                                   size: 12),
                        //                             ),
                        //                             padding:
                        //                                 const EdgeInsets.all(2),
                        //                             labelPadding:
                        //                                 const EdgeInsets.all(4),
                        //                             backgroundColor: AppTheme
                        //                                 .lightPrimaryColor,
                        //                             side: const BorderSide(
                        //                               style: BorderStyle.none,
                        //                               color: Colors.blue,
                        //                             ),
                        //                             label: Text(
                        //                               item.name ?? "",
                        //                               style: CustomTextStyle
                        //                                   .bodytext
                        //                                   .copyWith(
                        //                                       fontSize: 11),
                        //                             ),
                        //                             onDeleted: () {
                        //                               _castController
                        //                                   .selectedCasteList
                        //                                   .remove(item);
                        //                             },
                        //                           );
                        //                         },
                        //                       ),
                        //                       // Add button as a Chip
                        //                       Obx(
                        //                         () {
                        //                           if (_castController
                        //                                   .selectedCasteList
                        //                                   .length <=
                        //                               4) {
                        //                             return GestureDetector(
                        //                               onTap: () {
                        //                                 // Navigate to view all countries
                        //                                 _showCasteBottomSheet(
                        //                                     context);
                        //                               },
                        //                               child: Padding(
                        //                                 padding:
                        //                                     const EdgeInsets
                        //                                         .only(
                        //                                         bottom: 2,
                        //                                         top: 12.0),
                        //                                 child: Text(
                        //                                   "+ Add",
                        //                                   style: CustomTextStyle
                        //                                       .bodytext
                        //                                       .copyWith(
                        //                                     color: AppTheme
                        //                                         .selectedOptionColor,
                        //                                     fontWeight:
                        //                                         FontWeight.bold,
                        //                                   ),
                        //                                 ),
                        //                               ),
                        //                             );
                        //                           } else {
                        //                             return GestureDetector(
                        //                               onTap: () {
                        //                                 // Navigate to view all countries
                        //                                 _showCasteBottomSheet(
                        //                                     context);
                        //                               },
                        //                               child: Padding(
                        //                                 padding:
                        //                                     const EdgeInsets
                        //                                         .only(
                        //                                         bottom: 2,
                        //                                         top: 12.0),
                        //                                 child: Text(
                        //                                   "(+${_castController.selectedCasteList.length - 4}) More",
                        //                                   style: CustomTextStyle
                        //                                       .bodytext
                        //                                       .copyWith(
                        //                                     color: AppTheme
                        //                                         .selectedOptionColor,
                        //                                     fontWeight:
                        //                                         FontWeight.bold,
                        //                                   ),
                        //                                 ),
                        //                               ),
                        //                             );
                        //                           }
                        //                         },
                        //                       )
                        //                     ],
                        //                   ),
                        //                 ],
                        //               ),
                        //             ),
                        //           ),
                        //         ),
                        //       ),
                        //     );
                        //   }
                        // }),
                        const SizedBox(
                          height: 15,
                        ),
                        RichText(
                            key: _manglikKey,
                            text: TextSpan(children: <TextSpan>[
                              TextSpan(
                                  text: AppLocalizations.of(context)!
                                      .partnerManglikStatus,
                                  style: CustomTextStyle.fieldName),
                              const TextSpan(
                                  text: "*",
                                  style: TextStyle(color: Colors.red))
                            ])),
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
                                    _stepThreeController.updateManglik(
                                        FieldModel(id: 2, name: "Yes"));
                                  },
                                  child: CustomContainer(
                                    height: 60,
                                    width: 89,
                                    color: _stepThreeController
                                                .manglikSelected.value.id ==
                                            2
                                        ? AppTheme.selectedOptionColor
                                        : null,
                                    title: AppLocalizations.of(context)!.yes,
                                    textColor: _stepThreeController
                                                .manglikSelected.value.id ==
                                            2
                                        ? Colors.white
                                        : null,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    _stepThreeController.updateManglik(
                                        FieldModel(id: 1, name: "no"));
                                  },
                                  child: CustomContainer(
                                    color: _stepThreeController
                                                .manglikSelected.value.id ==
                                            1
                                        ? AppTheme.selectedOptionColor
                                        : null,
                                    height: 60,
                                    width: 89,
                                    title: AppLocalizations.of(context)!.no,
                                    textColor: _stepThreeController
                                                .manglikSelected.value.id ==
                                            1
                                        ? Colors.white
                                        : null,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    _stepThreeController.updateManglik(
                                        FieldModel(
                                            id: 3, name: "Dosent Matter"));
                                  },
                                  child: CustomContainer(
                                    color: _stepThreeController
                                                .manglikSelected.value.id ==
                                            3
                                        ? AppTheme.selectedOptionColor
                                        : null,
                                    height: 60,
                                    width: 125,
                                    title: AppLocalizations.of(context)!
                                        .dosentmatter,
                                    textColor: _stepThreeController
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
                        const SizedBox(
                          height: 20,
                        ),
                        RichText(
                            key: _maritialStatusKey,
                            text: TextSpan(children: <TextSpan>[
                              TextSpan(
                                  text: AppLocalizations.of(context)!
                                      .partnerMaritalStatus,
                                  style: CustomTextStyle.fieldName),
                              const TextSpan(
                                  text: "*",
                                  style: TextStyle(color: Colors.red))
                            ])),
                        const SizedBox(
                          height: 10,
                        ),
                        Obx(() {
                          return Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children: [
                              ..._stepThreeController.statusOptions
                                  .map((option) {
                                return GestureDetector(
                                  onTap: () {
                                    _stepThreeController
                                        .toggleStatusSelection(option['id']);
                                  },
                                  child: CustomContainer(
                                    height: 60,
                                    title: option['label'],
                                    width: 122,
                                    color: _stepThreeController
                                            .selectedStatusIds
                                            .contains(option['id'])
                                        ? AppTheme.selectedOptionColor
                                        : null,
                                    textColor: _stepThreeController
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
                        const SizedBox(
                          height: 15,
                        ),
                        RichText(
                            key: _employedInKey,
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
                            if (_stepThreeController.selectedItems.isNotEmpty) {
                              return Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                                      _stepThreeController
                                                                  .selectedItems
                                                                  .length >
                                                              4
                                                          ? 4
                                                          : _stepThreeController
                                                              .selectedItems
                                                              .length,
                                                      (index) {
                                                        final item =
                                                            _stepThreeController
                                                                    .selectedItems[
                                                                index];
                                                        return Chip(
                                                          deleteIcon:
                                                              const Padding(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    0),
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
                                                          backgroundColor: AppTheme
                                                              .lightPrimaryColor,
                                                          side:
                                                              const BorderSide(
                                                            style: BorderStyle
                                                                .none,
                                                            color: Colors.blue,
                                                          ),
                                                          label: Text(
                                                            item.name ?? "",
                                                            style:
                                                                CustomTextStyle
                                                                    .bodytext
                                                                    .copyWith(
                                                                        fontSize:
                                                                            11),
                                                          ),
                                                          onDeleted: () {
                                                            _stepThreeController
                                                                .toggleSelection(
                                                                    item);
                                                          },
                                                        );
                                                      },
                                                    ),
                                                    // Add button as a Chip
                                                    Obx(
                                                      () {
                                                        if (_stepThreeController
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
                                                                      bottom: 2,
                                                                      top:
                                                                          12.0),
                                                              child: Text(
                                                                "+ Add",
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
                                                                      bottom: 2,
                                                                      top:
                                                                          12.0),
                                                              child: Text(
                                                                "(+${_stepThreeController.selectedItems.length - 4}) More",
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
                        RichText(
                          key: _highestDegreeKey,
                          text: TextSpan(children: <TextSpan>[
                            TextSpan(
                                text: AppLocalizations.of(context)!
                                    .partnerHighestDegree,
                                style: CustomTextStyle.fieldName),
                            const TextSpan(
                                text: "*", style: TextStyle(color: Colors.red))
                          ]),
                        ),
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                                                EdgeInsets.all(
                                                                    0),
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
                                                          backgroundColor: AppTheme
                                                              .lightPrimaryColor,
                                                          side:
                                                              const BorderSide(
                                                            style: BorderStyle
                                                                .none,
                                                            color: Colors.blue,
                                                          ),
                                                          label: Text(
                                                            item.name ?? "",
                                                            style:
                                                                CustomTextStyle
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
                                                                      bottom: 2,
                                                                      top:
                                                                          12.0),
                                                              child: Text(
                                                                "+ Add",
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
                                                                      bottom: 2,
                                                                      top:
                                                                          12.0),
                                                              child: Text(
                                                                "(+${_educationController.selectedEducationList.length - 4}) More",
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
                                  if (value == null || value.isEmpty) {
                                    return "Please select your partner's expected highest education";
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
                            ])),
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                                                EdgeInsets.all(
                                                                    0),
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
                                                          backgroundColor: AppTheme
                                                              .lightPrimaryColor,
                                                          side:
                                                              const BorderSide(
                                                            style: BorderStyle
                                                                .none,
                                                            color: Colors.blue,
                                                          ),
                                                          label: Text(
                                                            item.name ?? "",
                                                            style:
                                                                CustomTextStyle
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
                                                                      bottom: 2,
                                                                      top:
                                                                          12.0),
                                                              child: Text(
                                                                "+ Add",
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
                                                                      bottom: 2,
                                                                      top:
                                                                          12.0),
                                                              child: Text(
                                                                "(+${_occupationController.selectedOccupations.length - 4}) More",
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
                            children:
                                _stepThreeController.selectedOccupationItems
                                    .map(
                                      (item) => Chip(
                                        label: Text(item),
                                        onDeleted: () {
                                          _stepThreeController
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
                                    text: _stepThreeController
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
                                _stepThreeController
                                        .searchedMinAnnualIncomeList.value =
                                    _stepThreeController.annualIncomeRange;

                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return Dialog(
                                      backgroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
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
                                                  errorStyle:
                                                      CustomTextStyle.errorText,
                                                  labelStyle:
                                                      CustomTextStyle.bodytext,
                                                  hintText:
                                                      "Search Annual Income",
                                                  contentPadding:
                                                      const EdgeInsets.all(20),
                                                  hintStyle:
                                                      CustomTextStyle.hintText,
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
                                                        const BorderRadius.all(
                                                            Radius.circular(5)),
                                                    borderSide: BorderSide(
                                                        color: Colors
                                                            .grey.shade300),
                                                  ),
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                    borderRadius:
                                                        const BorderRadius.all(
                                                            Radius.circular(5)),
                                                    borderSide: BorderSide(
                                                        color: Colors
                                                            .grey.shade300),
                                                  ),
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        const BorderRadius.all(
                                                            Radius.circular(5)),
                                                    borderSide: BorderSide(
                                                        color: Colors
                                                            .grey.shade300),
                                                  ),
                                                  suffixIcon: Icon(Icons.search,
                                                      color:
                                                          Colors.grey.shade500),
                                                ),
                                                onChanged: (query) {
                                                  _stepThreeController
                                                      .searchMinAnnualIncome(
                                                          query); // Filter the list in the controller
                                                },
                                              ),
                                            ),
                                            Container(
                                              decoration: const BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(5)),
                                                color: Colors.white,
                                              ),
                                              height:
                                                  400, // Set a height for the list inside the dialog
                                              child: Obx(() {
                                                return ListView.builder(
                                                  shrinkWrap: true,
                                                  itemCount: _stepThreeController
                                                      .searchedMinAnnualIncomeList
                                                      .length,
                                                  itemBuilder:
                                                      (context, index) {
                                                    final item =
                                                        _stepThreeController
                                                                .searchedMinAnnualIncomeList[
                                                            index];
                                                    bool isSelected =
                                                        _stepThreeController
                                                                .selectedMinIncome
                                                                .value
                                                                .id ==
                                                            item.id;

                                                    return GestureDetector(
                                                      onTap: () {
                                                        // Update the selected value and close the dialog
                                                        _stepThreeController
                                                            .updateMinIncome(
                                                                item);
                                                        // Update the controller text based on selection

                                                        Navigator.pop(context);
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
                                                                  ? Colors.white
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
                                    text: _stepThreeController
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
                                _stepThreeController
                                        .searchedMaxAnnualIncomeList.value =
                                    _stepThreeController
                                        .getFilteredMaxIncomeList();

                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return Dialog(
                                      backgroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
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
                                                  errorStyle:
                                                      CustomTextStyle.errorText,
                                                  labelStyle:
                                                      CustomTextStyle.bodytext,
                                                  hintText: "Search Height",
                                                  contentPadding:
                                                      const EdgeInsets.all(20),
                                                  hintStyle:
                                                      CustomTextStyle.hintText,
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
                                                        const BorderRadius.all(
                                                            Radius.circular(5)),
                                                    borderSide: BorderSide(
                                                        color: Colors
                                                            .grey.shade300),
                                                  ),
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                    borderRadius:
                                                        const BorderRadius.all(
                                                            Radius.circular(5)),
                                                    borderSide: BorderSide(
                                                        color: Colors
                                                            .grey.shade300),
                                                  ),
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        const BorderRadius.all(
                                                            Radius.circular(5)),
                                                    borderSide: BorderSide(
                                                        color: Colors
                                                            .grey.shade300),
                                                  ),
                                                  suffixIcon: Icon(Icons.search,
                                                      color:
                                                          Colors.grey.shade500),
                                                ),
                                                onChanged: (query) {
                                                  _stepThreeController
                                                      .searchMaxAnnualIncome(
                                                          query); // Filter the list in the controller
                                                },
                                              ),
                                            ),
                                            Container(
                                              decoration: const BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(5)),
                                                color: Colors.white,
                                              ),
                                              height:
                                                  400, // Set a height for the list inside the dialog
                                              child: Obx(() {
                                                return ListView.builder(
                                                  shrinkWrap: true,
                                                  itemCount: _stepThreeController
                                                      .searchedMaxAnnualIncomeList
                                                      .length,
                                                  itemBuilder:
                                                      (context, index) {
                                                    final item =
                                                        _stepThreeController
                                                                .searchedMaxAnnualIncomeList[
                                                            index];
                                                    bool isSelected =
                                                        _stepThreeController
                                                                .selectedMaxIncome
                                                                .value
                                                                .id ==
                                                            item.id;

                                                    return GestureDetector(
                                                      onTap: () {
                                                        // Update the selected value and close the dialog
                                                        _stepThreeController
                                                            .updateMaxIncome(
                                                                item);
                                                        // Update the controller text based on selection

                                                        Navigator.pop(context);
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
                                                                  ? Colors.white
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

                        /*       
      Obx(() {
        return CustomDropdownButton(
      validator: (value) {
        if (value == null) {
          return 'Required';
        }
        return null;
      },
      items: _stepThreeController.annualIncomeRange,
      value: _stepThreeController.selectedMinIncome.value != null
          ? _stepThreeController.annualIncomeRange.firstWhere(
              (item) => item.id == _stepThreeController.selectedMinIncome.value)
          : null,
      onChanged: (FieldModel? newValue) {
        if (newValue != null) {
          _stepThreeController.updateMinIncome(newValue.id);
          _stepThreeController.getFilteredMaxIncomeList(); // Update the max income options
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
      items: _stepThreeController.getFilteredMaxIncomeList(),
      value: _stepThreeController.selectedMaxIncome.value != null
          ? _stepThreeController.getFilteredMaxIncomeList().firstWhere(
              (item) => item.id == _stepThreeController.selectedMaxIncome.value)
          : null,
      onChanged: (FieldModel? newValue) {
        if (newValue != null) {
          _stepThreeController.updateMaxIncome(newValue.id);
        }
      },
      hintText: "Max Annual Income",
        );
      }),
      */

                        const SizedBox(
                          height: 15,
                        ),
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
                            if (_locationController.selectedCountries.isEmpty) {
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                                                EdgeInsets.all(
                                                                    0),
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
                                                          backgroundColor: AppTheme
                                                              .lightPrimaryColor,
                                                          side:
                                                              const BorderSide(
                                                            style: BorderStyle
                                                                .none,
                                                            color: Colors.blue,
                                                          ),
                                                          label: Text(
                                                            item.name ?? "",
                                                            style:
                                                                CustomTextStyle
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
                                                                      bottom: 2,
                                                                      top:
                                                                          12.0),
                                                              child: Text(
                                                                "+ Add",
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
                                                                      bottom: 2,
                                                                      top:
                                                                          12.0),
                                                              child: Text(
                                                                "(+${_locationController.selectedCountries.length - 4}) More",
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
                                                const Text(
                                                  "Select States",
                                                  style:
                                                      CustomTextStyle.fieldName,
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                CustomTextField(
                                                  validator: (value) {
                                                    if (value == null ||
                                                        value.isEmpty) {
                                                      return "Please select your partner's expected states";
                                                    }
                                                    return null;
                                                  },
                                                  readonly: true,
                                                  HintText: "Select States",
                                                  ontap: () {
                                                    navigatorKey.currentState!
                                                        .push(MaterialPageRoute(
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
                                                const Text(
                                                  "Selected States",
                                                  style:
                                                      CustomTextStyle.fieldName,
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
                                                          const EdgeInsets.all(
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
                                                                  _locationController
                                                                              .selectedStates
                                                                              .length >
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
                                                                        style: BorderStyle
                                                                            .none,
                                                                        color: Colors
                                                                            .blue,
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
                                                                          navigatorKey
                                                                              .currentState!
                                                                              .push(
                                                                            MaterialPageRoute(builder: (context) => const PartnerStateScreen()),
                                                                          );
                                                                        },
                                                                        child:
                                                                            Padding(
                                                                          padding: const EdgeInsets
                                                                              .only(
                                                                              bottom: 2,
                                                                              top: 12.0),
                                                                          child:
                                                                              Text(
                                                                            "+ Add",
                                                                            style:
                                                                                CustomTextStyle.bodytext.copyWith(
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
                                                                          navigatorKey
                                                                              .currentState!
                                                                              .push(
                                                                            MaterialPageRoute(builder: (context) => const PartnerStateScreen()),
                                                                          );
                                                                        },
                                                                        child:
                                                                            Padding(
                                                                          padding: const EdgeInsets
                                                                              .only(
                                                                              bottom: 2,
                                                                              top: 12.0),
                                                                          child:
                                                                              Text(
                                                                            "(+${_locationController.selectedStates.length - 4}) More",
                                                                            style:
                                                                                CustomTextStyle.bodytext.copyWith(
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
                                                const Text("Select Districts",
                                                    style: CustomTextStyle
                                                        .fieldName),
                                                Text(
                                                  "please select at least 4 district",
                                                  style: CustomTextStyle
                                                      .bodytext
                                                      .copyWith(fontSize: 12),
                                                ),
                                                const SizedBox(height: 10),
                                                CustomTextField(
                                                  validator: (value) {
                                                    if (value == null ||
                                                        value.isEmpty) {
                                                      return "Please select your partner's expected district";
                                                    }
                                                    return null;
                                                  },
                                                  readonly: true,
                                                  HintText: "Select Districts",
                                                  ontap: () {
                                                    navigatorKey.currentState!
                                                        .push(MaterialPageRoute(
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
                                                    // "Selected Districts",
                                                    AppLocalizations.of(
                                                            context)!
                                                        .selectedDistricts,
                                                    style: CustomTextStyle
                                                        .fieldName),
                                                Text(
                                                  "please select at least 4 district",
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
                                                          const EdgeInsets.all(
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
                                                                  _locationController
                                                                              .selectedCities
                                                                              .length >
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
                                                                        style: BorderStyle
                                                                            .none,
                                                                        color: Colors
                                                                            .blue,
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
                                                                          navigatorKey
                                                                              .currentState!
                                                                              .push(
                                                                            MaterialPageRoute(builder: (context) => const PartnerSelectCityScreen()),
                                                                          );
                                                                        },
                                                                        child:
                                                                            Padding(
                                                                          padding: const EdgeInsets
                                                                              .only(
                                                                              bottom: 2,
                                                                              top: 12.0),
                                                                          child:
                                                                              Text(
                                                                            "+ Add",
                                                                            style:
                                                                                CustomTextStyle.bodytext.copyWith(
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
                                                                          navigatorKey
                                                                              .currentState!
                                                                              .push(
                                                                            MaterialPageRoute(builder: (context) => const PartnerSelectCityScreen()),
                                                                          );
                                                                        },
                                                                        child:
                                                                            Padding(
                                                                          padding: const EdgeInsets
                                                                              .only(
                                                                              bottom: 2,
                                                                              top: 12.0),
                                                                          child:
                                                                              Text(
                                                                            "(+${_locationController.selectedCities.length - 4}) More",
                                                                            style:
                                                                                CustomTextStyle.bodytext.copyWith(
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
                        // const SizedBox(
                        //   height: 20,
                        // ),
                        // RichText(
                        //     key: _dietryHabitKey,
                        //     text: const TextSpan(children: <TextSpan>[
                        //       TextSpan(
                        //           text: "Partner's Dietary Habits ",
                        //           style: CustomTextStyle.fieldName),
                        //       TextSpan(
                        //           text: "*",
                        //           style: TextStyle(color: Colors.red))
                        //     ])),
                        // const SizedBox(
                        //   height: 10,
                        // ),
                        // Obx(() {
                        //   return Wrap(
                        //     spacing: 10,
                        //     runSpacing: 10,
                        //     children: [
                        //       GestureDetector(
                        //         onTap: () {
                        //           _stepThreeController.updateEatingHabits(
                        //               1); // ID for "Vegetarian"
                        //         },
                        //         child: CustomContainer(
                        //           height: 60,
                        //           title: _stepThreeController
                        //               .eatingHabitOptions[1]!, // "Vegetarian"
                        //           width: 105,
                        //           color: _stepThreeController
                        //                   .selectedEatingHabitIds
                        //                   .contains(1)
                        //               ? AppTheme.selectedOptionColor
                        //               : null,
                        //           textColor: _stepThreeController
                        //                   .selectedEatingHabitIds
                        //                   .contains(1)
                        //               ? Colors.white
                        //               : null,
                        //         ),
                        //       ),
                        //       GestureDetector(
                        //         onTap: () {
                        //           _stepThreeController.updateEatingHabits(
                        //               2); // ID for "Non-Vegetarian"
                        //         },
                        //         child: CustomContainer(
                        //           height: 60,
                        //           title:
                        //               _stepThreeController.eatingHabitOptions[
                        //                   2]!, // "Non-Vegetarian"
                        //           width: 138,
                        //           color: _stepThreeController
                        //                   .selectedEatingHabitIds
                        //                   .contains(2)
                        //               ? AppTheme.selectedOptionColor
                        //               : null,
                        //           textColor: _stepThreeController
                        //                   .selectedEatingHabitIds
                        //                   .contains(2)
                        //               ? Colors.white
                        //               : null,
                        //         ),
                        //       ),
                        //       GestureDetector(
                        //         onTap: () {
                        //           _stepThreeController.updateEatingHabits(
                        //               3); // ID for "Non-Vegetarian"
                        //         },
                        //         child: CustomContainer(
                        //           height: 60,
                        //           title:
                        //               _stepThreeController.eatingHabitOptions[
                        //                   3]!, // "Non-Vegetarian"
                        //           width: 138,
                        //           color: _stepThreeController
                        //                   .selectedEatingHabitIds
                        //                   .contains(3)
                        //               ? AppTheme.selectedOptionColor
                        //               : null,
                        //           textColor: _stepThreeController
                        //                   .selectedEatingHabitIds
                        //                   .contains(3)
                        //               ? Colors.white
                        //               : null,
                        //         ),
                        //       ),
                        //       GestureDetector(
                        //         onTap: () {
                        //           _stepThreeController
                        //               .updateEatingHabits(4); // ID for "Vegan"
                        //         },
                        //         child: CustomContainer(
                        //           height: 60,
                        //           title: _stepThreeController
                        //               .eatingHabitOptions[4]!, // "Vegan"
                        //           width: 105,
                        //           color: _stepThreeController
                        //                   .selectedEatingHabitIds
                        //                   .contains(4)
                        //               ? AppTheme.selectedOptionColor
                        //               : null,
                        //           textColor: _stepThreeController
                        //                   .selectedEatingHabitIds
                        //                   .contains(4)
                        //               ? Colors.white
                        //               : null,
                        //         ),
                        //       ),
                        //       GestureDetector(
                        //         onTap: () {
                        //           _stepThreeController.updateEatingHabits(
                        //               5); // ID for "Eggetarian"
                        //         },
                        //         child: CustomContainer(
                        //           height: 60,
                        //           title: _stepThreeController
                        //               .eatingHabitOptions[5]!, // "Eggetarian"
                        //           width: 105,
                        //           color: _stepThreeController
                        //                   .selectedEatingHabitIds
                        //                   .contains(5)
                        //               ? AppTheme.selectedOptionColor
                        //               : null,
                        //           textColor: _stepThreeController
                        //                   .selectedEatingHabitIds
                        //                   .contains(5)
                        //               ? Colors.white
                        //               : null,
                        //         ),
                        //       ),
                        //       GestureDetector(
                        //         onTap: () {
                        //           _stepThreeController
                        //               .updateEatingHabits(6); // ID for "Other"
                        //         },
                        //         child: CustomContainer(
                        //           height: 60,
                        //           title: _stepThreeController
                        //               .eatingHabitOptions[6]!, // "Other"
                        //           width: 105,
                        //           color: _stepThreeController
                        //                   .selectedEatingHabitIds
                        //                   .contains(6)
                        //               ? AppTheme.selectedOptionColor
                        //               : null,
                        //           textColor: _stepThreeController
                        //                   .selectedEatingHabitIds
                        //                   .contains(6)
                        //               ? Colors.white
                        //               : null,
                        //         ),
                        //       ),
                        //     ],
                        //   );
                        // }),
                        // const SizedBox(
                        //   height: 20,
                        // ),
                        // RichText(
                        //     key: _SmokingHabitKey,
                        //     text: const TextSpan(children: <TextSpan>[
                        //       TextSpan(
                        //           text: "Partner's Smoking Habits ",
                        //           style: CustomTextStyle.fieldName),
                        //       TextSpan(
                        //           text: "*",
                        //           style: TextStyle(color: Colors.red))
                        //     ])),
                        // const SizedBox(
                        //   height: 10,
                        // ),
                        // Obx(() {
                        //   return Wrap(
                        //     spacing: 10,
                        //     runSpacing: 10,
                        //     children: [
                        //       GestureDetector(
                        //         onTap: () {
                        //           _stepThreeController.updateSmokingHabit(1);
                        //         },
                        //         child: CustomContainer(
                        //           textColor: _stepThreeController
                        //                   .selectedSmokingHabit
                        //                   .contains(1)
                        //               ? Colors.white
                        //               : null,
                        //           height: 60,
                        //           title: "Yes",
                        //           width: 89,
                        //           color: _stepThreeController
                        //                   .selectedSmokingHabit
                        //                   .contains(1)
                        //               ? AppTheme.selectedOptionColor
                        //               : null,
                        //         ),
                        //       ),
                        //       GestureDetector(
                        //         onTap: () {
                        //           _stepThreeController.updateSmokingHabit(2);
                        //         },
                        //         child: CustomContainer(
                        //           textColor: _stepThreeController
                        //                   .selectedSmokingHabit
                        //                   .contains(2)
                        //               ? Colors.white
                        //               : null,
                        //           height: 60,
                        //           title: "No",
                        //           width: 89,
                        //           color: _stepThreeController
                        //                   .selectedSmokingHabit
                        //                   .contains(2)
                        //               ? AppTheme.selectedOptionColor
                        //               : null,
                        //         ),
                        //       ),
                        //       GestureDetector(
                        //         onTap: () {
                        //           _stepThreeController.updateSmokingHabit(3);
                        //         },
                        //         child: CustomContainer(
                        //           textColor: _stepThreeController
                        //                   .selectedSmokingHabit
                        //                   .contains(3)
                        //               ? Colors.white
                        //               : null,
                        //           height: 60,
                        //           title: "Occasionally",
                        //           width: 117,
                        //           color: _stepThreeController
                        //                   .selectedSmokingHabit
                        //                   .contains(3)
                        //               ? AppTheme.selectedOptionColor
                        //               : null,
                        //         ),
                        //       ),
                        //     ],
                        //   );
                        // }),
                        // const SizedBox(
                        //   height: 20,
                        // ),
                        // RichText(
                        //     key: _DrinkingHabitKey,
                        //     text: const TextSpan(children: <TextSpan>[
                        //       TextSpan(
                        //           text: "Partner's Drinking Habits ",
                        //           style: CustomTextStyle.fieldName),
                        //       TextSpan(
                        //           text: "*",
                        //           style: TextStyle(color: Colors.red))
                        //     ])),
                        // const SizedBox(
                        //   height: 10,
                        // ),
                        // Obx(
                        //   () {
                        //     return Wrap(
                        //       spacing: 10,
                        //       runSpacing: 10,
                        //       children: [
                        //         GestureDetector(
                        //           onTap: () {
                        //             _stepThreeController.updateDrinkingHabit(1);
                        //           },
                        //           child: CustomContainer(
                        //             textColor: _stepThreeController
                        //                     .selectedDrinkingHabit
                        //                     .contains(1)
                        //                 ? Colors.white
                        //                 : null,
                        //             height: 60,
                        //             title: "Yes",
                        //             width: 89,
                        //             color: _stepThreeController
                        //                     .selectedDrinkingHabit
                        //                     .contains(1)
                        //                 ? AppTheme.selectedOptionColor
                        //                 : null,
                        //           ),
                        //         ),
                        //         GestureDetector(
                        //           onTap: () {
                        //             _stepThreeController.updateDrinkingHabit(2);
                        //           },
                        //           child: CustomContainer(
                        //             textColor: _stepThreeController
                        //                     .selectedDrinkingHabit
                        //                     .contains(2)
                        //                 ? Colors.white
                        //                 : null,
                        //             height: 60,
                        //             title: "No",
                        //             width: 89,
                        //             color: _stepThreeController
                        //                     .selectedDrinkingHabit
                        //                     .contains(2)
                        //                 ? AppTheme.selectedOptionColor
                        //                 : null,
                        //           ),
                        //         ),
                        //         GestureDetector(
                        //           onTap: () {
                        //             _stepThreeController.updateDrinkingHabit(3);
                        //           },
                        //           child: CustomContainer(
                        //             textColor: _stepThreeController
                        //                     .selectedDrinkingHabit
                        //                     .contains(3)
                        //                 ? Colors.white
                        //                 : null,
                        //             height: 60,
                        //             title: "Occasionally",
                        //             width: 117,
                        //             color: _stepThreeController
                        //                     .selectedDrinkingHabit
                        //                     .contains(3)
                        //                 ? AppTheme.selectedOptionColor
                        //                 : null,
                        //           ),
                        //         ),
                        //       ],
                        //     );
                        //   },
                        // ),
                        const SizedBox(
                          height: 50,
                        ),
                        Center(
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(
                                    5)), // This ensures a rectangular button (sharp corners)
                              ),
                            ),
                            onPressed: () async {
                              if (!_stepThreeController.searchfetching.value) {
                                _stepThreeController.searchpage.value = 1;
                                _stepThreeController.searchListHasMore.value =
                                    true;
                                _stepThreeController.searchList.clear();

                                await _stepThreeController.advanceSearch().then(
                                  (value) {
                                    navigatorKey.currentState!
                                        .push(MaterialPageRoute(
                                      builder: (context) =>
                                          const SearchResultScreen(),
                                    ));
                                  },
                                );
                              }
                            },
                            label: Obx(
                                () => _stepThreeController.searchfetching.value
                                    ? const CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2,
                                      )
                                    : Text(
                                        // "Search",
                                        AppLocalizations.of(context)!.search,
                                        style: CustomTextStyle.elevatedButton,
                                      )),
                            icon: Obx(() =>
                                _stepThreeController.searchfetching.value
                                    ? const SizedBox
                                        .shrink() // Hide the icon when loading
                                    : const Icon(
                                        Icons.search,
                                        color: Colors.white,
                                      )),
                          ),
                        ),
                        Center(
                          child: TextButton(
                              onPressed: () {
                                _stepThreeController.selectedMinAge.value =
                                    FieldModel();
                                _stepThreeController.selectedMaxAge.value =
                                    FieldModel();
                                _stepThreeController.selectedMinHeight.value =
                                    FieldModel();
                                _stepThreeController.selectedMaxHeight.value =
                                    FieldModel();
                                _stepThreeController.manglikSelectedList.value =
                                    [];
                                _locationController.selectedCities.value = [];
                                _locationController.selectedCountries.value =
                                    [];
                                _locationController.selectedStates.value = [];
                                _castController.selectedCasteList.value = [];
                                _castController.selectedSectionList.value = [];
                                _castController.selectedSubSectionList.value =
                                    [];
                                _stepThreeController.selectedItems.value = [];
                                _stepThreeController.selectedMinIncome.value =
                                    FieldModel();
                                _stepThreeController.selectedMaxIncome.value =
                                    FieldModel();
                                _educationController
                                    .selectedEducationList.value = [];
                                _stepThreeController
                                    .selectedEatingHabitIds.value = [];
                                _stepThreeController
                                    .selectedSmokingHabit.value = [];
                                _stepThreeController.selectedStatusIds.value =
                                    [];
                                _stepThreeController
                                    .selectedDrinkingHabit.value = [];
                              },
                              child: Text(
                                language == "en" ? "Reset" : "रिसेट करा",
                                style: CustomTextStyle.textbuttonRedLarge,
                              )),
                        ),
                        /*    Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
      Expanded(child: ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: Colors.white , side: const BorderSide(color: Colors.red )  ), 
        onPressed: (){
         navigatorKey.currentState!.pushReplacement(MaterialPageRoute(builder: (context) => UserInfoStepTwo(),));
      
      
      }, child:  Text("Back" , style: CustomTextStyle.elevatedButton.copyWith(color: Colors.red),))),
      const SizedBox(width: 10,), 
      Expanded(child: ElevatedButton(
        onPressed: () {
      try {
        // Mark form as submitted
        _stepThreeController.isSubmitted.value = true; 
        
        // Perform individual field validations
        bool manglikValid = _stepThreeController.manglikSelected.value.id != null;
        bool maritalStatusValid = _stepThreeController.selectedStatusIds.isNotEmpty; 
        bool smokingHabitValid = _stepThreeController.selectedSmokingHabit.value.id != null; 
        bool drinkingHabitValid = _stepThreeController.selectedDrinkingHabit.value.id != null;
        bool educationValid = _educationController.selectedEducationList.length >= 4; 
        bool occupationValid = _occupationController.selectedOccupations.any((occupation) => occupation.id == 199) ? true : _occupationController.selectedOccupations.length >= 4; 
        bool cityValid = _locationController.selectedCities.length  >= 4;
        bool statesValid = _locationController.selectedStates.isNotEmpty;
        bool citiesValid = _locationController.selectedCities.isNotEmpty;
      
      
        // Check if the form is valid and all fields are filled correctly
        if (_formKey.currentState!.validate()) {
          // Check if lengths and individual validations are correct
          if (educationValid && occupationValid && cityValid) {
            if (manglikValid && maritalStatusValid && smokingHabitValid && drinkingHabitValid && statesValid && citiesValid) {
              // Everything is valid, proceed with data submission
              print("Selected height id ${_stepThreeController.selectedMinHeight.value } and ${_stepThreeController.selectedMaxHeight.value}");
              print("Status: ${_stepThreeController.selectedStatusIds}");
      print("Eployed List ${_stepThreeController.selectedItemsID}");
              _stepThreeController.sendData(
                minAge: _stepThreeController.selectedMinAge.value.id ?? 0,
                maxAge: _stepThreeController.selectedMaxAge.value.id ?? 0,
                minHeight: _stepThreeController.selectedMinHeight.value.id ?? 0,
                maxHeight: _stepThreeController.selectedMaxHeight.value.id ?? 0,
                caste: _castController.selectedCasteList 
      .where((field) => field.id != null) // Filter out null ids
      .map((field) => field.id!)
      .toList(),
                section: _castController.selectedSectionList 
      .where((field) => field.id != null) // Filter out null ids
      .map((field) => field.id!)
      .toList(),
                subsection: _castController.selectedSubSectionList 
      .where((field) => field.id != null) // Filter out null ids
      .map((field) => field.id!)
      .toList(),
                manglik: _stepThreeController.manglikSelected.value.id.toString(),
                maritalStatus: _stepThreeController.selectedStatusIds,
                employedIn: _stepThreeController.selectedItems
      .where((field) => field.id != null) // Filter out null ids
      .map((field) => field.id!)
      .toList(),
                education: _educationController. selectedEducationList
      .where((field) => field.id != null) // Filter out null ids
      .map((field) => field.id!)
      .toList(),
                occupation: _occupationController. selectedOccupations
      .where((field) => field.id != null) // Filter out null ids
      .map((field) => field.id!)
      .toList(),
                country: _locationController.selectedCountries 
      .where((field) => field.id != null) // Filter out null ids
      .map((field) => field.id!)
      .toList(), 
                state: _locationController.selectedStates 
      .where((field) => field.id != null) // Filter out null ids
      .map((field) => field.id!)
      .toList(), 
                city: _locationController.selectedCities 
      .where((field) => field.id != null) // Filter out null ids
      .map((field) => field.id!)
      .toList(), 
                minAnnualIncome: _stepThreeController.selectedMinIncome.value.id ?? 0,
                maxAnnualIncome: _stepThreeController.selectedMaxIncome.value.id ?? 0,
                dietaryHabits: _stepThreeController.selectedEatingHabitIds,
                smokingHabits: _stepThreeController.selectedSmokingHabit.value.id ?? 0,
                drinkingHabits: _stepThreeController.selectedDrinkingHabit.value.id ?? 0,
              );
            } else {
             /* manglikValid && maritalStatusValid && smokingHabitValid
               && drinkingHabitValid && statesValid && citiesValid*/
              // Validation failed for specific fields
                  if (!manglikValid) {
                   
          _scrollToWidget(_manglikKey);
                    } else if(!maritalStatusValid){
          _scrollToWidget(_maritialStatusKey);
      
                    }else if(!smokingHabitValid){
          _scrollToWidget(_SmokingHabitKey);
      
                    }else if(!drinkingHabitValid){
          _scrollToWidget(_DrinkingHabitKey);
      
                    }
        //      Get.snackbar("Error", "Please fill all required fields");
              print("Validation failed in habits or marital status");
            }
          } else {
            // List length validation failed
            _stepThreeController.listLengthValidate.value = false;
             if (!educationValid) {
                   
          _scrollToWidget(_highestDegreeKey);
                    }else if(!occupationValid){
      _scrollToWidget(_occupationKey);
                    }else if(!cityValid){
                      _scrollToWidget(_expectedResidenceKey);
      
                    }
         //       Get.snackbar("Error", "Please select at least 4 options in each category");
          }
        } else {
          // Form validation failed
       //   Get.snackbar("Error", "Please fill all Fields");
              if (_stepThreeController.selectedMinAge.value.id == null ) {
                   
          _scrollToWidget(_minAgeKey);
                    } else if( _stepThreeController.selectedMaxAge.value.id == null ){
                      _scrollToWidget(_maxAgeKey);
                    } else if(_stepThreeController.selectedMinHeight.value.id == null){
                      _scrollToWidget(_minHeightKey);
                    }else if (_stepThreeController.selectedMaxHeight.value.id == null ) {
                   
          _scrollToWidget(_maxHeightKey);
                    }else if(_castController.selectedSectionList 
      .where((field) => field.id != null) // Filter out null ids
      .map((field) => field.id!)
      .toList().isEmpty){
                      _scrollToWidget(_partnerSectionKey);
                    }else if(_castController.selectedSubSectionList 
      .where((field) => field.id != null) // Filter out null ids
      .map((field) => field.id!)
      .toList().isEmpty ){
                      _scrollToWidget(_subSectionKey);
                    }else if(_castController.selectedCasteList 
      .where((field) => field.id != null) // Filter out null ids
      .map((field) => field.id!)
      .toList().isEmpty){
                      _scrollToWidget(_casteKey);
                    }else if(_stepThreeController.manglikSelected.value.id.toString().isEmpty){
                      _scrollToWidget(_manglikKey);
                    }else if( _stepThreeController.selectedStatusIds.isEmpty){
                      _scrollToWidget(_maritialStatusKey);
                    }else if(_stepThreeController.selectedItems
      .where((field) => field.id != null) // Filter out null ids
      .map((field) => field.id!)
      .toList().isEmpty){
                      _scrollToWidget(_employedInKey);
                    } else if(_educationController. selectedEducationList
      .where((field) => field.id != null) // Filter out null ids
      .map((field) => field.id!)
      .toList().isEmpty){
                      _scrollToWidget(_highestDegreeKey);
                    }else if(_occupationController. selectedOccupations
      .where((field) => field.id != null) // Filter out null ids
      .map((field) => field.id!)
      .toList().isEmpty){
                      _scrollToWidget(_occupationKey);
                    }
                    // new 
                    else if(_stepThreeController.selectedMinIncome.value.id == null){
                      _scrollToWidget(_MinIncomeKey);
                    }else if(_stepThreeController.selectedMaxIncome.value.id == null){
                      _scrollToWidget(_MaxIncomeKey);
                    }else if(_locationController.selectedCities 
      .where((field) => field.id != null) // Filter out null ids
      .map((field) => field.id!)
      .toList().isEmpty){
                      _scrollToWidget(_expectedResidenceKey);
                    }else if(_stepThreeController.selectedEatingHabitIds.isEmpty){
                      _scrollToWidget(_dietryHabitKey);
                    }else if(_locationController.selectedCities 
      .where((field) => field.id != null) // Filter out null ids
      .map((field) => field.id!)
      .toList().isEmpty){
                      _scrollToWidget(_expectedResidenceKey);
                    }else if(_stepThreeController.selectedSmokingHabit.value.id == null){
                      _scrollToWidget(_SmokingHabitKey);
                    }else if(_stepThreeController.selectedDrinkingHabit.value.id== null){
                      _scrollToWidget(_DrinkingHabitKey);
                    }
        }
      } catch (e, stackTrace) {
        print('Error occurred: $e');
        //    Get.snackbar("Error", "An error occurred during submission");
        print(stackTrace);
      }
        },
        child: Obx(() {
      return _stepThreeController.isLoading.value
          ? const CircularProgressIndicator(
              color: Colors.white, // Set the indicator color if needed
            )
          : const Text("Save", style: CustomTextStyle.elevatedButton);
        }),
      ),
      
      
      ),
        ],), */
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ))
            ],
          )),
        ),
      ),
    );
  }

  void _showMultiSelectBottomSheet(BuildContext context) {
    _stepThreeController.fetchemployeedInFromApi();
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
                const Text("Employed In",
                    style: CustomTextStyle.bodytextboldLarge),
                const SizedBox(height: 10),
                Obx(
                  () {
                    // Show shimmer effect while data is being loaded
                    if (_stepThreeController.isloading.value) {
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
                          _stepThreeController.employedInList.length ==
                              _stepThreeController.selectedItems.length;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // "Select All" chip at the top
                          ChoiceChip(
                            checkmarkColor: Colors.white,
                            labelPadding: const EdgeInsets.all(4),
                            label: Text(
                              "Select All",
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
                                _stepThreeController.selectAllItems();
                              } else {
                                _stepThreeController.clearAllSelections();
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
                                _stepThreeController.employedInList.map((item) {
                              final isSelected = _stepThreeController
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
                                  _stepThreeController.toggleSelection(item);
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
                          ),
                        ),
                      ),
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
                          language == "en"
                              ? "Please select at least 4 occupations"
                              : "कृपया कमीत कमी ४ व्यवसाय निवडा",
                          style: CustomTextStyle.bodytextSmall),
                    ),
                    const SizedBox(height: 10),

                    // Search Field
                    Center(
                      child: TextFormField(
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
                          if (occupationController.selectedOccupations.length <
                              4) {
                            return language == "en"
                                ? "Please select at least 4 occupations"
                                : "कृपया कमीत कमी ४ व्यवसाय निवडा";
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
                                  side: const BorderSide(color: Colors.red)),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text(
                                AppLocalizations.of(context)!.cancel,
                                style: CustomTextStyle.elevatedButton
                                    .copyWith(color: Colors.red),
                              ),
                            ),
                          ),
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
                      // "Partner's Expected Education",
                      style: CustomTextStyle.bodytextboldLarge,
                    ),
                    Text(
                      language == "en"
                          ? "please select at least 4 education"
                          : "कमीत कमी ४ शिक्षण निवडा",
                      style: CustomTextStyle.bodytextSmall,
                    ),
                    const SizedBox(height: 10),

                    // Search TextField
                    TextFormField(
                      validator: (value) {
                        if (_educationController.selectedEducationList.length <
                            4) {
                          return language == "en"
                              ? "please select at least 4 education"
                              : "कमीत कमी ४ शिक्षण निवडा";
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
                                          // "Selected items will be visible here.",
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
              const Padding(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text("Select Sub Section",
                          style: CustomTextStyle.bodytextboldLarge),
                    ),
                    Center(
                      child: Text("You can select multiple options",
                          style: CustomTextStyle.bodytextSmall),
                    ),
                    SizedBox(height: 10),
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
                              // " Cancel",
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
                          // "Done",
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
              const Padding(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("Select Caste",
                        style: CustomTextStyle.bodytextboldLarge),
                    Text("You can select multiple options",
                        style: CustomTextStyle.bodytextSmall),
                    SizedBox(height: 10),
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
                              // " Cancel",
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
                          // "Done",
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
