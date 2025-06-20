// ignore_for_file: deprecated_member_use

import 'package:_96kuliapp/utils/selectlanguage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:_96kuliapp/commons/textdecoration.dart';
import 'package:_96kuliapp/controllers/dashboardControllers/dashboardController.dart';
import 'package:_96kuliapp/controllers/search/advancefilterController.dart';
import 'package:_96kuliapp/controllers/search/basicfilterController.dart';
import 'package:_96kuliapp/main.dart';
import 'package:_96kuliapp/routes/routenames.dart';
import 'package:_96kuliapp/screens/notifications/notificationScreen.dart';
import 'package:_96kuliapp/screens/search_Screens/search_by_id_result_screen.dart';
import 'package:_96kuliapp/utils/Apptheme.dart';
import 'package:_96kuliapp/utils/appDrawer.dart';
import 'package:_96kuliapp/utils/buttonContainer.dart';
import 'package:_96kuliapp/utils/customtextform.dart';

class BasicSearch extends StatefulWidget {
  const BasicSearch({super.key});

  @override
  State<BasicSearch> createState() => _BasicSearchState();
}

class _BasicSearchState extends State<BasicSearch> {
  final RangeValues _rangeValues = const RangeValues(18, 60);
  String? selectedMinIncome;
  String? selectedMaxIncome;
  final Advancefiltercontroller advancefiltercontroller =
      Get.put(Advancefiltercontroller());
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final DashboardController _dashboardcontroller =
      Get.find<DashboardController>();
  String? language = sharedPreferences?.getString("Language");

  // Default range

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _dashboardcontroller.onItemTapped(0);
        // Add your logic here
        // Return true to allow the screen to close
        // Return false to prevent the screen from closing
        return false; // For example, prevent closing
      },
      child: Scaffold(
        drawer: const AppDrawer(),
        appBar: AppBar(
          centerTitle: true,
          leading: Builder(builder: (context) {
            return GestureDetector(
              onTap: () {
                Scaffold.of(context).openDrawer();
              },
              child: CircleAvatar(
                  radius: 15, // Adjust the radius as per your requirement
                  backgroundColor:
                      Colors.transparent, // Optional: Set a background color
                  child: Icon(
                    Icons.menu,
                    color: AppTheme.secondryColor,
                  )),
            );
          }),
          actions: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // const SelectLanguage(),
                  const SizedBox(
                    width: 5,
                  ),
                  GestureDetector(
                    onTap: () {
                      navigatorKey.currentState!.push(
                        MaterialPageRoute(
                          builder: (context) => const NotificationScreen(),
                        ),
                      );
                    },
                    child: Stack(
                      clipBehavior:
                          Clip.none, // Allow the circle to overflow the bounds
                      children: [
                        CircleAvatar(
                          radius:
                              15, // Adjust the radius as per your requirement
                          backgroundColor: Colors
                              .transparent, // Optional: Set a background color
                          child: Image.asset(
                            "assets/notificationblue.png",
                            fit: BoxFit.cover,
                            width: 20, // Icon size
                            height: 20, // Icon size
                          ),
                        ),
                        // Check if the count for notifications is non-null and greater than 0
                        if (_dashboardcontroller.countData["notification"] !=
                                null &&
                            _dashboardcontroller.countData["notification"] > 0)
                          Positioned(
                            right: 0,
                            top: 0,
                            child: Container(
                              width: 12, // Reduced size of the red circle
                              height: 12, // Reduced size of the red circle
                              decoration: const BoxDecoration(
                                color: Colors.red, // Red color for the circle
                                shape: BoxShape.circle, // Circle shape
                              ),
                              child: Center(
                                child: Text(
                                  '${_dashboardcontroller.countData["notification"]}', // Display the count (e.g., number of new notifications)
                                  style: const TextStyle(
                                    color: Colors
                                        .white, // Text color inside the circle
                                    fontSize:
                                        8, // Smaller font size for the count
                                    fontWeight:
                                        FontWeight.bold, // Make the text bold
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
          automaticallyImplyLeading: false,
          title: Padding(
            padding: const EdgeInsets.all(12.0),
            child: SizedBox(
              width: 100,
              height: 33,
              child: Image.asset("assets/applogo.png"),
            ),
          ),
        ),
        body: SafeArea(
            child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        language == "en" ? "Quick Search" : "प्रोफाईल शोधा ",
                        style: CustomTextStyle.title,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      language == "en"
                          ? "search by profile ID"
                          : "प्रोफाईल आयडी द्वारे सर्च करा ",
                      style: CustomTextStyle.title.copyWith(fontSize: 14),
                    ),
                    const SizedBox(
                      height: 10,
                    ),

                    //   CustomTextField(HintText: "Search By Member ID"),
                    TextFormField(
                      validator: (value) {
                        if (value == null || value.length < 3) {
                          return language == "en"
                              ? 'Please enter a valid Member ID '
                              : "कृपया अचूक प्रोफाईल आयडी टाका ";
                        }

                        // Extract the user input part, ignoring the first two characters
                        String userInput = value.substring(2);

                        // Check if userInput is empty
                        if (userInput.isEmpty) {
                          return 'Please enter a valid Member ID ';
                        }
                        return null;
                      },
                      controller: advancefiltercontroller.textController,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      style: CustomTextStyle.bodytext,
                      decoration: InputDecoration(
                        errorMaxLines: 5,
                        errorStyle: CustomTextStyle.errorText,
                        labelStyle: CustomTextStyle.bodytext,
                        hintText: "Search By Member ID",
                        contentPadding: const EdgeInsets.all(20),
                        hintStyle: CustomTextStyle.hintText,
                        filled: true,
                        fillColor: Colors.white,
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(5)),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(5)),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
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
                          color: Colors.grey.shade300,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () async {
                            if (!advancefiltercontroller
                                .searchbyIDfetching.value) {
                              if (_formKey.currentState!.validate()) {
                                advancefiltercontroller.searchbyIDpage.value =
                                    1;
                                advancefiltercontroller
                                    .searchbyIDListHasMore.value = true;
                                advancefiltercontroller.searchbyIDList.clear();

                                await advancefiltercontroller
                                    .basicSearch()
                                    .then(
                                  (value) {
                                    //   Get.toNamed(AppRouteNames.advancesearchByIDresult);
                                    navigatorKey.currentState!
                                        .push(MaterialPageRoute(
                                      builder: (context) =>
                                          const SearchByIDResultScreen(),
                                    ));
                                  },
                                );
                              }
                            }
                          },
                          icon: Obx(() =>
                              advancefiltercontroller.searchbyIDfetching.value
                                  ? const SizedBox
                                      .shrink() // Hide the icon when loading
                                  : const Icon(
                                      Icons.search,
                                      color: Colors.white,
                                    )),
                          label: Obx(() =>
                              advancefiltercontroller.searchbyIDfetching.value
                                  ? const CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    )
                                  : Text(
                                      language == "en" ? "Search" : "शोधा",
                                      style: CustomTextStyle.elevatedButton,
                                    )),
                        )
                      ],
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        )),
      ),
    );
  }
}
