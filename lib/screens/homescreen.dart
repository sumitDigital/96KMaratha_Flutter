// ignore_for_file: deprecated_member_use

import 'dart:io';

import 'package:_96kuliapp/controllers/editforms_controllers/editAstroDetailsController.dart';
import 'package:_96kuliapp/controllers/editforms_controllers/editEducationController.dart';
import 'package:_96kuliapp/controllers/editforms_controllers/editFamilyDetailsController.dart';
import 'package:_96kuliapp/controllers/editforms_controllers/editLocationController.dart';
import 'package:_96kuliapp/controllers/editforms_controllers/editPartnerExpectationController.dart';
import 'package:_96kuliapp/controllers/editforms_controllers/editPersonalInfoController.dart';
import 'package:_96kuliapp/controllers/editforms_controllers/editSpiritualController.dart';
import 'package:_96kuliapp/controllers/editforms_controllers/editlifestyleController.dart';
import 'package:_96kuliapp/controllers/formfields/castController.dart';
import 'package:_96kuliapp/controllers/formfields/occupationController.dart';
import 'package:_96kuliapp/controllers/locationcontroller/LocationController.dart';
import 'package:_96kuliapp/controllers/search/advancefilterController.dart';
import 'package:_96kuliapp/controllers/viewProfileControllers/myprofileController.dart';
import 'package:_96kuliapp/utils/selectlanguage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:_96kuliapp/checkupdateFunctions.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:_96kuliapp/commons/appconstants.dart';
import 'package:_96kuliapp/commons/dialogues/apidialogues/addonPLanDialogue.dart';
import 'package:_96kuliapp/commons/dialogues/apidialogues/congratulationDialogue.dart';
import 'package:_96kuliapp/commons/dialogues/apidialogues/documentVerificationDialogue.dart';
import 'package:_96kuliapp/commons/dialogues/apidialogues/weeklyLimitExausted.dart';
import 'package:_96kuliapp/commons/dialogues/forceblock.dart';
import 'package:_96kuliapp/commons/dialogues/logoutDialogoue.dart';
import 'package:_96kuliapp/commons/textdecoration.dart';
import 'package:_96kuliapp/controllers/auth/casteVerificationBlock.dart';
import 'package:_96kuliapp/controllers/auth/casteVerificationBlockController.dart';
import 'package:_96kuliapp/controllers/auth/casteVerificationScreen.dart';
import 'package:_96kuliapp/controllers/dashboardControllers/dashboardController.dart';
import 'package:_96kuliapp/controllers/editforms_controllers/editGalleryPhotoController.dart';
import 'package:_96kuliapp/controllers/timer_controller/timer_controller.dart';
import 'package:_96kuliapp/main.dart';
import 'package:_96kuliapp/routes/routenames.dart';
import 'package:_96kuliapp/screens/editProfile_screens/editEducationForm.dart';
import 'package:_96kuliapp/screens/editProfile_screens/editFamilyDetails.dart';
import 'package:_96kuliapp/screens/editProfile_screens/editGalleryPhotos.dart';
import 'package:_96kuliapp/screens/editProfile_screens/editLifestyleDetails.dart';
import 'package:_96kuliapp/screens/editProfile_screens/editPersonalInfo.dart';
import 'package:_96kuliapp/screens/editProfile_screens/editSpiritualDetails.dart';
import 'package:_96kuliapp/screens/editProfile_screens/edit_about_me.dart';
import 'package:_96kuliapp/screens/notifications/notificationScreen.dart';
import 'package:_96kuliapp/screens/plans/addOnPlan.dart';
import 'package:_96kuliapp/screens/plans/upgradeScreen.dart';
import 'package:_96kuliapp/screens/profile_screens/edit_profile.dart';
import 'package:_96kuliapp/screens/profile_screens/user_details.dart';
import 'package:_96kuliapp/screens/userInfoForms/userinfoStepSix.dart';
import 'package:_96kuliapp/utils/Apptheme.dart';
import 'package:_96kuliapp/utils/appDrawer.dart';
import 'package:_96kuliapp/utils/bottomnavBar.dart';
import 'package:_96kuliapp/utils/justJoinMatches.dart';
import 'package:_96kuliapp/utils/newmatches.dart';
import 'package:_96kuliapp/utils/verificationTag.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:pub_semver/pub_semver.dart';
import 'package:shimmer/shimmer.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  final DashboardController _dashboardcontroller =
      Get.find<DashboardController>();
  final EditPersonalInfoController _editPersonalInfoController =
      Get.put(EditPersonalInfoController());
  final EditEducationController _editEducationController =
      Get.put(EditEducationController());
  final MyProfileController _profileController = Get.put(MyProfileController());
  final EditLocationController _editLocationController =
      Get.put(EditLocationController());
  final EditFamilyFetailsController _familyDetailController =
      Get.put(EditFamilyFetailsController());
  final EditSpiritualController _spiritualController =
      Get.put(EditSpiritualController());
  final Editastrodetailscontroller _editastrodetailscontroller =
      Get.put(Editastrodetailscontroller());
  final CastController _castController = Get.put(CastController());
  final EditPartnerExpectation _editpartnerController =
      Get.put(EditPartnerExpectation());
  final EditLifestylecontroller _editLifestylecontroller =
      Get.put(EditLifestylecontroller());
  final OccupationController _occupationController =
      Get.put(OccupationController());
  final Advancefiltercontroller _advanceFilterController =
      Get.put(Advancefiltercontroller());
  final LocationController _locationController = Get.put(LocationController());

  String? language = sharedPreferences?.getString("Language");

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    /*  if(

    _dashboardcontroller.dashboardData["redirection"]["pagename"] == "FORCEPOPUP"
    ){
    WidgetsBinding.instance.addPostFrameCallback((_) {
          Get.dialog(
    barrierColor: Colors.black.withOpacity(0.8), 
    
      const ForceBlockDialogue(),
    
     barrierDismissible: false);
    
    });

    }
  
    else if(_dashboardcontroller.dashboardData["redirection"]["pagename"] == "PENDING"){
    _casteVerificationBlockController.popup.value = _dashboardcontroller.dashboardData["redirection"]["Popup"];
     WidgetsBinding.instance.addPostFrameCallback((_) {
     navigatorKey.currentState!.pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const CasteVerificationBlock(),) ,   (route) => false,);

     });

    }else if(_dashboardcontroller.dashboardData["redirection"]["pagename"] == "CASTE-VERIFICATION"){
          WidgetsBinding.instance.addPostFrameCallback((_) {

     navigatorKey.currentState!.pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const CasteVerificationScreen(),) ,   (route) => false,);

          });

    }else if(_dashboardcontroller.dashboardData["redirection"]["pagename"] == "DOCUMENT-REJECTED"){
       WidgetsBinding.instance.addPostFrameCallback((_) {

     navigatorKey.currentState!.pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const UserInfoStepSix(),) ,   (route) => false,);

          });
    }else if(_dashboardcontroller.dashboardData["redirection"]["pagename"] == "PLAN"){
       WidgetsBinding.instance.addPostFrameCallback((_) {

     navigatorKey.currentState!.pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const UpgradePlan(),) ,   (route) => false,);

          });
    }
*/

    _dashboardcontroller.fetchCountDetails();
  }

  // Method to show the dialog

  @override
  Widget build(BuildContext context) {
    print("THIS IS HOME SCREEN");
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
    return WillPopScope(
      onWillPop: () async {
        // 2. Check if the drawer is open using the GlobalKey
        if (scaffoldKey.currentState?.isDrawerOpen ?? false) {
          // Close the drawer if it's open
          scaffoldKey.currentState?.closeDrawer();
          return false; // Prevent the default back action
        } else {
          // 3. Show the exit confirmation dialog if the drawer is not open
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
                      ? 'Are you sure you want to exit the app  ?'
                      : "तुम्हाला नक्की ॲपमधून बाहेर पडायचे आहे का?",
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
                            exit(0);
                            // SystemNavigator.pop();
                            // Navigator.of(context)
                            //     .pop(true); // User wants to exit
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
        }
      },
      child: Scaffold(
          key: scaffoldKey,
          drawer: const AppDrawer(),
          body: _dashboardcontroller.dashboardData.isEmpty
              ? SafeArea(
                  child: Center(
                      child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Center(child: Text("Server Issue ")),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton(
                            onPressed: () {
                              _dashboardcontroller.fetchUserInfo();
                            },
                            child: const Text(
                              "Retry",
                              style: CustomTextStyle.elevatedButton,
                            )),
                        const SizedBox(
                          height: 10,
                        ),
                        ElevatedButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return const Logout(
                                    page: "dashBoard",
                                  );
                                },
                              );
                            },
                            child: const Text(
                              "Logout",
                              style: CustomTextStyle.elevatedButton,
                            ))
                      ],
                    )
                  ],
                )))
              : RefreshIndicator(
                  onRefresh: () {
                    return Future(
                      () {
                        _dashboardcontroller.fetchIncompleteDetails();
                        _dashboardcontroller.fetchOnlineMembers();
                        _dashboardcontroller.fetchRecomendedMatches();
                        _dashboardcontroller.fetchProfileVisitors();
                        _dashboardcontroller.fetchRecentlyJoinedMatches();
                        _dashboardcontroller.resetAllListsforHome();
                        _dashboardcontroller.fetchCountDetails();
                      },
                    );
                  },
                  child: SingleChildScrollView(
                    child: RefreshIndicator(
                      onRefresh: () {
                        return _dashboardcontroller.fetchOnlineMembers();
                      },
                      child: SafeArea(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: double.infinity,
                            decoration: const BoxDecoration(
                                // rgba(248, 248, 249, 1)
                                borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(15),
                                    bottomRight: Radius.circular(15)),
                                color: Color.fromARGB(255, 248, 248, 249)),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Builder(builder: (context) {
                                        return GestureDetector(
                                          onTap: () async {
                                            try {
                                              print('Checking for Update');
                                              AppUpdateInfo info =
                                                  await InAppUpdate
                                                      .checkForUpdate();

                                              if (info.updateAvailability ==
                                                  UpdateAvailability
                                                      .updateAvailable) {
                                                print('Update available');
                                                await update();
                                              } else {
                                                print('No update available');
                                                // _dashboardController.onItemTapped(value);
                                                Scaffold.of(context)
                                                    .openDrawer();
                                                //   navigatorKey.currentState!.push(MaterialPageRoute(builder: (context) => const NotificationScreen(),));
                                              }
                                            } catch (e) {
                                              Scaffold.of(context).openDrawer();

                                              print(
                                                  'Error checking for update: ${e.toString()}');
                                            }
                                          },
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              const CircleAvatar(
                                                  radius:
                                                      15, // Adjust the radius as per your requirement
                                                  backgroundColor: Colors
                                                      .transparent, // Optional: Set a background color
                                                  child: Icon(
                                                    Icons.menu,
                                                    color: Color.fromARGB(
                                                        255, 80, 93, 126),
                                                  )),
                                              const SizedBox(
                                                width: 5,
                                              ),
                                              Text(
                                                "${AppLocalizations.of(context)!.hello}${_dashboardcontroller.dashboardData["memberData"]["first_name"]}!",
                                                style: CustomTextStyle
                                                    .dashboardtitle,
                                              ),
                                            ],
                                          ),
                                        );
                                      }),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          SelectLanguage(
                                            dashboard: true,
                                            onChanged: () {
                                              _editPersonalInfoController
                                                  .complexions();
                                              _editPersonalInfoController
                                                  .fetchBasicInfo();
                                              _editPersonalInfoController
                                                  .regenerateHeightList();
                                              _editEducationController
                                                  .loadItems();
                                              _editEducationController
                                                  .fetchEducationInfo();
                                              _profileController
                                                  .fetchUserInfo();
                                              _editLocationController
                                                  .fetchLocationInfo();
                                              _familyDetailController
                                                  .fetchBasicInfo();
                                              _familyDetailController
                                                  .fetchfamilyAssetsFromApi();
                                              _familyDetailController
                                                  .siblingList();
                                              _spiritualController
                                                  .zodiacsigList();
                                              _spiritualController
                                                  .nakshatraList();

                                              _spiritualController.ganListing();
                                              _spiritualController
                                                  .charanListing();
                                              _spiritualController
                                                  .nandiListing();
                                              _editastrodetailscontroller
                                                  .fetchBasicInfo();
                                              _castController
                                                  .refreshSectionList();

                                              _editpartnerController
                                                  .updateAgeRange();
                                              _editpartnerController
                                                  .updateStatusOptions();

                                              _editLifestylecontroller
                                                  .languageList();

                                              _editLifestylecontroller
                                                  .mothertoughList();
                                              _editLifestylecontroller
                                                  .fetchBasicInfo();

                                              _editLifestylecontroller
                                                  .fetchhobbiesFromApi();
                                              _editLifestylecontroller
                                                  .fetchInterestFromApi();
                                              _editLifestylecontroller
                                                  .fetchdressStyleFromApi();

                                              _editLifestylecontroller
                                                  .fetchSportsFromApi();
                                              _editLifestylecontroller
                                                  .fetchMusicFromApi();
                                              _editLifestylecontroller
                                                  .fetchFoodFromApi();

                                              _occupationController
                                                  .fetchOccupationFromApi();
                                              _editpartnerController
                                                  .fetchemployeedInFromApi();
                                              _castController
                                                  .refreshSectionList();

                                              _locationController
                                                  .fetchMultiCity();

                                              _editpartnerController
                                                  .annualincomeRangeList();
                                              _editpartnerController
                                                  .maxincomeRangeList();
                                              _editpartnerController
                                                  .fetchPartnerExpectInfo();
                                              _advanceFilterController
                                                  .updateAgeRange();
                                              _advanceFilterController
                                                  .heightList();
                                              _advanceFilterController
                                                  .updateStatusOptions();
                                            },
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          Obx(
                                            () {
                                              return GestureDetector(
                                                onTap: () async {
                                                  try {
                                                    print(
                                                        'Checking for Update');
                                                    AppUpdateInfo info =
                                                        await InAppUpdate
                                                            .checkForUpdate();

                                                    if (info.updateAvailability ==
                                                        UpdateAvailability
                                                            .updateAvailable) {
                                                      print('Update available');
                                                      await update();
                                                    } else {
                                                      print(
                                                          'No update available');
                                                      // _dashboardController.onItemTapped(value);
                                                      navigatorKey.currentState!
                                                          .push(
                                                              MaterialPageRoute(
                                                        builder: (context) =>
                                                            const NotificationScreen(),
                                                      ));
                                                    }
                                                  } catch (e) {
                                                    print(
                                                        'Error checking for update: ${e.toString()}');
                                                    navigatorKey.currentState!
                                                        .push(MaterialPageRoute(
                                                      builder: (context) =>
                                                          const NotificationScreen(),
                                                    ));
                                                  }
                                                },
                                                child: Stack(
                                                  clipBehavior: Clip
                                                      .none, // Allow the circle to overflow the bounds
                                                  children: [
                                                    CircleAvatar(
                                                      radius:
                                                          15, // Adjust the radius as per your requirement
                                                      backgroundColor: Colors
                                                          .transparent, // Optional: Set a background color
                                                      child: Image.asset(
                                                        "assets/notification.png",
                                                        fit: BoxFit.cover,
                                                        width: 20, // Icon size
                                                        height: 20, // Icon size
                                                      ),
                                                    ),
                                                    // Check if the count for notifications is non-null and greater than 0
                                                    if (_dashboardcontroller
                                                                    .countData[
                                                                "notification"] !=
                                                            null &&
                                                        _dashboardcontroller
                                                                    .countData[
                                                                "notification"] >
                                                            0)
                                                      Positioned(
                                                        right: 0,
                                                        top: 0,
                                                        child: Container(
                                                          width:
                                                              12, // Reduced size of the red circle
                                                          height:
                                                              12, // Reduced size of the red circle
                                                          decoration:
                                                              const BoxDecoration(
                                                            color: Colors
                                                                .red, // Red color for the circle
                                                            shape: BoxShape
                                                                .circle, // Circle shape
                                                          ),
                                                          child: Center(
                                                            child: Text(
                                                              '${_dashboardcontroller.countData["notification"]}', // Display the count (e.g., number of new notifications)
                                                              style:
                                                                  const TextStyle(
                                                                color: Colors
                                                                    .white, // Text color inside the circle
                                                                fontSize:
                                                                    8, // Smaller font size for the count
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold, // Make the text bold
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                  ],
                                                ),
                                              );
                                            },
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Divider(
                                      height: 8, color: AppTheme.dividerColor),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Obx(
                                        () {
                                          if (_dashboardcontroller
                                              .fetchedPhotoURL.isNotEmpty) {
                                            if (_dashboardcontroller
                                                .loadingPhoto.value) {
                                              return SizedBox(
                                                height: 120,
                                                width: 120,
                                                child: Shimmer.fromColors(
                                                  baseColor: Colors.grey[300]!,
                                                  highlightColor:
                                                      Colors.grey[100]!,
                                                  child: CircleAvatar(
                                                    backgroundImage:
                                                        NetworkImage(
                                                      _dashboardcontroller
                                                          .fetchedPhotoURL
                                                          .value,
                                                    ),
                                                    backgroundColor: Colors
                                                            .grey[
                                                        200], // Default background color if image fails to load
                                                  ),
                                                ),
                                              );
                                            } else {
                                              return Container(
                                                height: 120,
                                                width: 120,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  image: DecorationImage(
                                                    image: NetworkImage(
                                                      _dashboardcontroller
                                                              .fetchedPhotoURL
                                                              .value ??
                                                          "${Appconstants.baseURL}/public/storage/images/download.png",
                                                    ),
                                                    fit: BoxFit
                                                        .cover, // Ensures the image covers the circle
                                                    alignment: Alignment
                                                        .topCenter, // Aligns the image to the top
                                                  ),
                                                ),
                                              );
                                            }
                                          }
                                          {
                                            return Stack(
                                              clipBehavior: Clip.none,
                                              alignment: Alignment.bottomCenter,
                                              children: [
                                                Container(
                                                  height: 120,
                                                  width: 120,
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    image: DecorationImage(
                                                      image: NetworkImage(
                                                        // Correctly use the fallback inside the NetworkImage
                                                        _dashboardcontroller.dashboardData[
                                                                            "photo"][0]
                                                                        [
                                                                        "photo_name"] !=
                                                                    null &&
                                                                _dashboardcontroller
                                                                    .dashboardData[
                                                                        "photo"]
                                                                        [0][
                                                                        "photo_name"]
                                                                    .isNotEmpty
                                                            ? "${Appconstants.baseURL}/public/storage/images/${_dashboardcontroller.dashboardData["photo"][0]["photo_name"]}"
                                                            : "${Appconstants.baseURL}/public/storage/images/download.png",
                                                      ),
                                                      fit: BoxFit
                                                          .cover, // Ensures the image covers the circle
                                                      alignment: Alignment
                                                          .topCenter, // Aligns the image to the top
                                                    ),
                                                  ),
                                                ),
                                                Positioned(
                                                    bottom: -9,
                                                    child: GestureDetector(
                                                      onTap: () {
                                                        //   Get.toNamed(AppRouteNames.editGalleryPhotos);
                                                        navigatorKey
                                                            .currentState!
                                                            .push(
                                                                MaterialPageRoute(
                                                          builder: (context) =>
                                                              const EditGalleryPhotosScreen(),
                                                        ));
                                                      },
                                                      child: SizedBox(
                                                          height: 25,
                                                          width: 25,
                                                          child: Image.asset(
                                                              "assets/changeProfile.png")),
                                                    )),
                                              ],
                                            );
                                          }
                                        },
                                      )
                                      /*    Center(
  child: Container(
    width: 110, // Diameter of the circle
    height: 110, // Diameter of the circle
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      image: DecorationImage(
        image: NetworkImage(
          visitor["photoUrl"] ??
              "${Appconstants.baseURL}/public/storage/images/download.png",
        ),
        fit: BoxFit.cover, // Ensures the image covers the circle
        alignment: Alignment.topCenter, // Aligns the image to the top
      ),
    ),
  ),
),*/
                                      ,
                                      const SizedBox(
                                        width: 8,
                                      ),
                                      Flexible(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const SizedBox(
                                              height: 7,
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  "${_dashboardcontroller.dashboardData["memberData"]["first_name"]} ${_dashboardcontroller.dashboardData["memberData"]["last_name"]}",
                                                  style: CustomTextStyle
                                                      .dashboardtitle
                                                      .copyWith(fontSize: 16),
                                                ),
                                                const SizedBox(
                                                  width: 5,
                                                ),
                                                Obx(
                                                  () {
                                                    if (_dashboardcontroller
                                                                    .dashboardData[
                                                                "memberData"][
                                                            "is_Document_Verification"] ==
                                                        1) {
                                                      return SizedBox(
                                                        height: 15,
                                                        width: 15,
                                                        child: Image.asset(
                                                            "assets/verified.png"),
                                                      );
                                                    } else {
                                                      return const SizedBox();
                                                    }
                                                  },
                                                )
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  "${AppLocalizations.of(context)!.profileID} - ${_dashboardcontroller.dashboardData["memberData"]["member_profile_id"]}",
                                                  style: CustomTextStyle
                                                      .dashboardsubtitle,
                                                ),
                                                const SizedBox(
                                                  width: 5,
                                                ),
                                                Container(
                                                  height: 10,
                                                  color: Colors.white,
                                                  width: 1,
                                                ),
                                                const SizedBox(
                                                  width: 2,
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                GestureDetector(
                                                  onTap: () {
                                                    navigateWithTransition(
                                                        navigatorKey:
                                                            navigatorKey,
                                                        screen:
                                                            const EditProfile());
                                                  }, // rgba(204, 40, 77, 1)
                                                  child: Text(
                                                    AppLocalizations.of(
                                                            context)!
                                                        .editProfile,
                                                    style: CustomTextStyle
                                                        .dashboardsubtitle
                                                        .copyWith(
                                                            color: const Color
                                                                .fromARGB(255,
                                                                204, 40, 77)),
                                                  ),
                                                )
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            Divider(
                                              height: 10,
                                              color: AppTheme.dividerColor,
                                            ),
                                            const SizedBox(
                                              height: 8,
                                            ),
                                            Obx(
                                              () {
                                                if (_dashboardcontroller
                                                                .dashboardData[
                                                            "memberData"]
                                                        ["is_premium"] ==
                                                    "1") {
                                                  return Text(
                                                    "${AppLocalizations.of(context)!.accountType} -  ${AppLocalizations.of(context)!.premiumMeber}",
                                                    style: CustomTextStyle
                                                        .dashboardtitle
                                                        .copyWith(fontSize: 12),
                                                  );
                                                } else {
                                                  return Text(
                                                    "${AppLocalizations.of(context)!.accountType} -  ${AppLocalizations.of(context)!.freeMember} ",
                                                    style: CustomTextStyle
                                                        .dashboardtitle
                                                        .copyWith(fontSize: 12),
                                                  );
                                                }
                                              },
                                            ),
                                            const SizedBox(
                                              height: 15,
                                            ),
/* GestureDetector ( 
  onTap: () {
                 navigatorKey.currentState!.push(MaterialPageRoute(builder: (context) =>const Addonplan(),));
                    
  },
   child: Container( 
                    decoration:  BoxDecoration(
                    color: AppTheme.primaryColor,
                borderRadius: const BorderRadius.all(Radius.circular(20))
                    ),
                    height: 30, 
                    width: 150,
                    child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                     CircleAvatar(
                           
                             radius: 12, // Adjust the radius as per your requirement
                             backgroundColor: Colors.transparent, // Optional: Set a background color
                             child: Image.asset(
                               "assets/premium.png",
                               fit: BoxFit.cover,
                               width: 12, 
                               height: 12, 
                             ),
                           ), 
                
                  Text("Add On Contacts" ,style: CustomTextStyle.elevatedButton.copyWith(fontSize: 12 , fontWeight: FontWeight.w600),)
                ],),
                  ),
 )
                */
                                          ],
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  height: 10,
                                ),
                                const OnlineMembers(),
                                Obx(
                                  () {
                                    if (_dashboardcontroller.percentage.value ==
                                        100) {
                                      return const SizedBox();
                                    } else {
                                      return ProfileScoreCard(
                                          memberdata: _dashboardcontroller
                                              .dashboardData);
                                    }
                                  },
                                ),
                                const RecentVisitors(),
                                const SizedBox(
                                  height: 18,
                                ),
                                /*    ElevatedButton(onPressed: (){
                        showDialog(
                          
                          context: context, builder: (context) {
                          return AddonPlanDialogue();
                        },);
                       }, child: Text("Show dialogue")), */
                                const NewMatches(),
                                const SizedBox(
                                  height: 18,
                                ),
                                const JustJoinMatches(),
                                const SizedBox(
                                  height: 20,
                                ),
                                /*  Center(child: Container(
                            height: 355, 
                            width: 321, 
                            
                            child: Card(
                            elevation: 5, 
              
                              
                              color: const Color.fromARGB(255, 245, 245, 245),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: RichText(
                                      textAlign: TextAlign.center,
                                      text: TextSpan(children: <TextSpan>[ 
                                      TextSpan(text: "Upgrade Now  \n & Get Upto " , style: CustomTextStyle.bodytextbold.copyWith(fontSize: 18 , )), 
                                      TextSpan(text: "60% Discount " , style: CustomTextStyle.bodytextbold.copyWith(
                                      
                                        fontSize: 22 , color: const Color.fromARGB(255, 234, 52, 74))), 
                                    
                                    ])),
                                  ), 
                                  SizedBox(height: 10,),
                                  Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Container(
                                      height: 85, 
                                      width: 120,
                                      decoration: BoxDecoration(border: Border(
                                        bottom: BorderSide(width: 1 , color: const Color.fromARGB(255, 80, 93, 126).withOpacity(0.5)),
                                        right: BorderSide(width: 1 , color: const Color.fromARGB(255, 80, 93, 126).withOpacity(0.5))
                                        
                                        )
                                        
                                        ),),
                                  )
                                ],),
                              ),
                          ),)*/
                              ],
                            ),
                          ),
                        ],
                      )),
                    ),
                  ),
                )),
    );
  }
}

class OnlineMembers extends StatelessWidget {
  const OnlineMembers({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final DashboardController dashboardController =
        Get.find<DashboardController>();
    dashboardController.fetchOnlineMembers();

    return Obx(() {
      if (dashboardController.onlineMembersFetching.value) {
        // Display Shimmer effect while fetching data
        return SizedBox(
          height: 130,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 8, // Show 8 shimmer items as placeholders
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(4.0),
                child: Column(
                  children: [
                    Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: CircleAvatar(
                        backgroundColor: Colors.grey[300],
                        radius: 40,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Container(
                        width: 60,
                        height: 15,
                        color: Colors.grey[300],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Container(
                        width: 40,
                        height: 10,
                        color: Colors.grey[300],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      } else {
        // Display actual content after fetching is done
        if (dashboardController.onlinemembers.length == 0) {
          return const SizedBox();
        } else {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppLocalizations.of(context)!.onlineMembers,
                style: CustomTextStyle.title,
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                height: 160, // Specify a fixed height for the ListView
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: dashboardController
                      .onlinemembers.length, // Fetch actual number of items
                  itemBuilder: (context, index) {
                    final member = dashboardController.onlinemembers[index];
                    print("Print this $member");
                    return GestureDetector(
                      onTap: () async {
                        try {
                          print('Checking for Update');
                          AppUpdateInfo info =
                              await InAppUpdate.checkForUpdate();

                          if (info.updateAvailability ==
                              UpdateAvailability.updateAvailable) {
                            print('Update available');
                            await update();
                          } else {
                            print('No update available');
                            // _dashboardController.onItemTapped(value);
                            navigatorKey.currentState!.push(MaterialPageRoute(
                              builder: (context) => UserDetails(
                                  notificationID: 0,
                                  memberid: member["member_id"]),
                            ));
                          }
                        } catch (e) {
                          navigatorKey.currentState!.push(
                            MaterialPageRoute(
                              builder: (context) => UserDetails(
                                  notificationID: 0,
                                  memberid: member["member_id"]),
                            ),
                          );
                          print('Error checking for update: ${e.toString()}');
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Column(
                          children: [
                            Center(
                              child: Stack(
                                children: [
                                  Center(
                                    child: Container(
                                      width: 80, // Diameter of the circle
                                      height: 80, // Diameter of the circle
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        image: DecorationImage(
                                          image: NetworkImage(
                                            member["photoUrl"] ??
                                                "${Appconstants.baseURL}/public/storage/images/download.png",
                                          ),
                                          fit: BoxFit
                                              .cover, // Ensures the image covers the circle
                                          alignment: Alignment
                                              .topCenter, // Aligns the image to the top
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    bottom:
                                        7, // Position it at the bottom-right of the CircleAvatar
                                    right: 7,
                                    child: Container(
                                      width: 10, // Size of the green symbol
                                      height: 10,
                                      decoration: const BoxDecoration(
                                        color: Color.fromARGB(
                                            255, 38, 193, 35), // Green color
                                        shape:
                                            BoxShape.circle, // Circular shape
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 8),
                            Center(
                              child: Text(
                                member["short_name"],
                                overflow: TextOverflow.ellipsis,
                                style: CustomTextStyle.bodytextbold,
                              ),
                            ),
                            Center(
                              child: Text(
                                member["member_profile_id"],
                                overflow: TextOverflow.ellipsis,
                                style: CustomTextStyle.bodytext.copyWith(
                                    fontSize: 10, fontWeight: FontWeight.w600),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        }
      }
    });
  }
}

class ProfileScoreCard extends StatelessWidget {
  const ProfileScoreCard({
    super.key,
    this.memberdata,
  });
  final dynamic memberdata;

  @override
  Widget build(BuildContext context) {
    final DashboardController dashboardController =
        Get.find<DashboardController>();
    dashboardController.fetchIncompleteDetails();
    String? language = sharedPreferences?.getString("Language");

    return Obx(() {
      if (dashboardController.incomplteDataFetching.value) {
        // Show shimmer effect while data is loading
        return Padding(
          padding: const EdgeInsets.only(top: 10.0, bottom: 18),
          child: Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                border: Border.all(
                    color: const Color.fromARGB(255, 139, 152, 187)
                        .withOpacity(0.48)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Column(
                  children: [
                    Container(height: 20, width: 150, color: Colors.grey),
                    const SizedBox(height: 10),
                    Container(height: 15, width: 250, color: Colors.grey),
                    const SizedBox(height: 20),
                    Container(
                        height: 150,
                        width: double.infinity,
                        color: Colors.grey),
                    const SizedBox(height: 10),
                    Container(
                        height: 10, width: double.infinity, color: Colors.grey),
                    const SizedBox(height: 20),
                    Container(height: 40, width: 200, color: Colors.grey),
                  ],
                ),
              ),
            ),
          ),
        );
      } else {
        // Show actual content when data is loaded
        return Padding(
          padding: const EdgeInsets.only(top: 10.0, bottom: 18),
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 248, 248, 249),
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              // rgba(248, 248, 249, 1)
              border: Border.all(
                  color: const Color.fromARGB(255, 139, 152, 187)
                      .withOpacity(0.48)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(
                        flex: 6,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            language == "en"
                                ? Center(
                                    child: RichText(
                                        textAlign: TextAlign.center,
                                        text: TextSpan(children: [
                                          const TextSpan(
                                            text: "Update Your ",
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontFamily: "WORKSANS",
                                                fontWeight: FontWeight.w700,
                                                color: Color.fromARGB(
                                                    255, 5, 28, 60)),
                                          ),
                                          TextSpan(
                                            text:
                                                "${dashboardController.incompleteData[0]["FormName"]} Now!!",
                                            style: const TextStyle(
                                                fontSize: 16,
                                                fontFamily: "WORKSANS",
                                                fontWeight: FontWeight.w700,
                                                color: Color.fromARGB(
                                                    255, 5, 28, 60)),
                                          ),
                                        ])),
                                  )
                                : Center(
                                    child: RichText(
                                        textAlign: TextAlign.center,
                                        text: TextSpan(children: [
                                          const TextSpan(
                                            text: "तुमची ",
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontFamily: "WORKSANS",
                                                fontWeight: FontWeight.w700,
                                                color: Color.fromARGB(
                                                    255, 5, 28, 60)),
                                          ),
                                          TextSpan(
                                            text:
                                                "${dashboardController.incompleteData[0]["FormName"]} पूर्ण करा !!",
                                            style: const TextStyle(
                                                fontSize: 16,
                                                fontFamily: "WORKSANS",
                                                fontWeight: FontWeight.w700,
                                                color: Color.fromARGB(
                                                    255, 5, 28, 60)),
                                          ),
                                        ])),
                                  ),
                            const SizedBox(
                              height: 10,
                            ),
                            language == "en"
                                ? Center(
                                    child: RichText(
                                        textAlign: TextAlign.center,
                                        text: TextSpan(children: [
                                          const TextSpan(
                                              text: "Add Your ",
                                              style:
                                                  CustomTextStyle.bodytextfs12),
                                          TextSpan(
                                              text:
                                                  "${dashboardController.incompleteData[0]["FormName"]} ",
                                              style: CustomTextStyle
                                                  .bodytextboldfs12),
                                          const TextSpan(
                                              text:
                                                  "To improve your profile visibility ",
                                              style:
                                                  CustomTextStyle.bodytextfs12),
                                        ])),
                                  )
                                : Center(
                                    child: RichText(
                                        textAlign: TextAlign.center,
                                        text: TextSpan(children: [
                                          const TextSpan(
                                              text: "तुमची ",
                                              style:
                                                  CustomTextStyle.bodytextfs12),
                                          TextSpan(
                                              text:
                                                  "${dashboardController.incompleteData[0]["FormName"]} ",
                                              style: CustomTextStyle
                                                  .bodytextboldfs12),
                                          const TextSpan(
                                              text:
                                                  "भरा जेणेकरून तुमच्या प्रोफाईलला जास्त पसंती मिळेल",
                                              style:
                                                  CustomTextStyle.bodytextfs12),
                                        ])),
                                  ),
                            /*  Center(
                              child: FractionallySizedBox(
                                widthFactor: 0.8, // 80% of the parent width
                                child: Image.asset("assets/updateProfile.png"),
                              ),
                            ),*/
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      height: 10,
                      child: LinearProgressIndicator(
                        value:
                            (dashboardController.percentage.toDouble() ?? 100) /
                                100,
                        backgroundColor: Colors.grey.shade300,
                        color: Colors.green,
                      ),
                    ),
                  ),
                  language == "en"
                      ? Center(
                          child: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(children: <TextSpan>[
                              TextSpan(
                                  text: "Your Profile is ",
                                  style: CustomTextStyle.bodytext
                                      .copyWith(fontSize: 12)),
                              TextSpan(
                                text:
                                    "${dashboardController.percentage.value}%",
                                style: CustomTextStyle.bodytextbold
                                    .copyWith(fontSize: 12),
                              ),
                              TextSpan(
                                  text:
                                      " Complete. Finish Your Profile to Enhance Your Visibility!",
                                  style: CustomTextStyle.bodytext
                                      .copyWith(fontSize: 12))
                            ]),
                          ),
                        )
                      : Center(
                          child: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(children: <TextSpan>[
                              TextSpan(
                                  text: "तुमची प्रोफाईल ",
                                  style: CustomTextStyle.bodytext
                                      .copyWith(fontSize: 12)),
                              TextSpan(
                                text:
                                    "${dashboardController.percentage.value}%",
                                style: CustomTextStyle.bodytextbold
                                    .copyWith(fontSize: 12),
                              ),
                              TextSpan(
                                  text:
                                      " पूर्ण झाली आहे. प्रोफाईलला अधिक पसंती मिळवण्यासाठी तुमची प्रोफाइल पूर्ण करा!",
                                  style: CustomTextStyle.bodytext
                                      .copyWith(fontSize: 12))
                            ]),
                          ),
                        ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                      onPressed: () {
                        if (dashboardController.incompleteData[0]["table"] ==
                            "PersonalInfo") {
                          navigatorKey.currentState!.push(MaterialPageRoute(
                              builder: (context) =>
                                  const EditPersonalInfoScreen()));
                        } else if (dashboardController.incompleteData[0]
                                ["table"] ==
                            "Lifestyle") {
                          navigatorKey.currentState!.push(MaterialPageRoute(
                              builder: (context) =>
                                  const EditLifestyleDetails()));
                        } else if (dashboardController.incompleteData[0]
                                ["table"] ==
                            "Spiritual") {
                          navigatorKey.currentState!.push(MaterialPageRoute(
                              builder: (context) =>
                                  const EditSpiritualDetailsScreen()));
                        } else if (dashboardController.incompleteData[0]
                                ["table"] ==
                            "Introduction") {
                          navigatorKey.currentState!.push(MaterialPageRoute(
                              builder: (context) => const EditAboutMeScreen()));
                        } else if (dashboardController.incompleteData[0]
                                ["table"] ==
                            "EducationCareer") {
                          navigatorKey.currentState!.push(MaterialPageRoute(
                              builder: (context) => const EditEducationForm()));
                        } else if (dashboardController.incompleteData[0]
                                ["table"] ==
                            "Family") {
                          navigatorKey.currentState!.push(MaterialPageRoute(
                              builder: (context) =>
                                  const EditFamilyDetailsScreen()));
                        } else {
                          navigatorKey.currentState!.push(MaterialPageRoute(
                              builder: (context) => const EditProfile()));
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                      ),
                      child: language == "en"
                          ? Text(
                              "Complete Your ${dashboardController.incompleteData[0]["FormName"]}",
                              style: CustomTextStyle.elevatedButtonMedium,
                            )
                          : Text(
                              "${dashboardController.incompleteData[0]["FormName"]} भरा",
                              style: CustomTextStyle.elevatedButtonMedium,
                            )),
                ],
              ),
            ),
          ),
        );
      }
    });
  }
}

class ShortListDialogue extends StatelessWidget {
  const ShortListDialogue({super.key});
  @override
  Widget build(BuildContext context) {
    final DashboardController dashboardcontroller =
        Get.find<DashboardController>();
    return Dialog(
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(8),
                      topRight: Radius.circular(8)),
                  color:
                      const Color.fromARGB(255, 240, 115, 151).withOpacity(0.3),
                ),
                height: 209,
                width: 329,
                child: Stack(
                  children: [
                    SizedBox(
                      height: 180,
                      width: 286,
                      child: Image.asset("assets/popup.png"),
                    ),
                  ],
                )),
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Center(
                      child: Text(
                        textAlign: TextAlign.center,
                        "Add to Your Shortlist?",
                        style: TextStyle(
                            fontFamily: "WORKSANS",
                            color: Colors.black,
                            fontWeight: FontWeight.w700,
                            fontSize: 16),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      textAlign: TextAlign.center,
                      "Want to save this profile for future reference? Click \"Shortlist\" to add it now, or \"Cancel\" if you want to keep browsing.",
                      style: CustomTextStyle.bodytext,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Center(
                      child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  shape: const RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(5))),
                                  backgroundColor: Colors.white,
                                  side: const BorderSide(color: Colors.red)),
                              onPressed: () {
                                Get.back();
                              },
                              child: Text(
                                // "Cancel",
                                AppLocalizations.of(context)!.cancel,
                                style: CustomTextStyle.elevatedButtonSmallRed,
                              ))),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                shape: const RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5))),
                              ),
                              onPressed: () {},
                              child: Text(
                                AppLocalizations.of(context)!.shortlist,
                                // "Shortlist",
                                style: CustomTextStyle.elevatedButtonSmall,
                              ))),
                    ],
                  ))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class CustomDialogue extends StatelessWidget {
  const CustomDialogue({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(8),
                      topRight: Radius.circular(8)),
                  color:
                      const Color.fromARGB(255, 240, 115, 151).withOpacity(0.3),
                ),
                height: 209,
                width: 329,
                child: Stack(
                  children: [
                    SizedBox(
                      height: 180,
                      width: 286,
                      child: Image.asset("assets/popup.png"),
                    ),
                  ],
                )),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Center(
                      child: Text(
                        "Your Profile is Incomplete!!!",
                        style: TextStyle(
                            fontFamily: "WORKSANS",
                            color: Colors.black,
                            fontWeight: FontWeight.w700,
                            fontSize: 16),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      textAlign: TextAlign.center,
                      "Verify your profile using ID Proof Document. to assure others you are genuine and get a badge",
                      style: CustomTextStyle.bodytext,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Center(
                    child: ElevatedButton(
                        onPressed: () {},
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "Add Partner Expectation",
                              style: CustomTextStyle.elevatedButton
                                  .copyWith(fontSize: 14),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: SizedBox(
                                height: 16,
                                width: 16,
                                child: Image.asset(
                                    fit: BoxFit.cover,
                                    "assets/partnerexpectation.png"),
                              ),
                            )
                          ],
                        )),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class RecentVisitors extends StatelessWidget {
  const RecentVisitors({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final DashboardController dashboardController =
        Get.find<DashboardController>();
    dashboardController.fetchProfileVisitors();
    String? language = sharedPreferences?.getString("Language");
    return Obx(() {
      if (dashboardController.profileVisitorsFetching.value) {
        return SizedBox(
          height: 221,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 8,
            itemBuilder: (context, index) {
              return Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Container(
                    width: 150,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      border: Border.all(
                        color: const Color.fromARGB(255, 80, 93, 127)
                            .withOpacity(0.2),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Center(
                            child: CircleAvatar(
                              backgroundColor: Colors.grey,
                              radius: 45,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Center(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 80,
                                  height: 16,
                                  color: Colors.grey,
                                ),
                                const SizedBox(width: 5),
                                SizedBox(
                                  height: 15,
                                  width: 15,
                                  child: Container(color: Colors.grey),
                                )
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                          Center(
                            child: Container(
                              width: 100,
                              height: 12,
                              color: Colors.grey,
                            ),
                          ),
                          Center(
                            child: Container(
                              width: 100,
                              height: 12,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                AppLocalizations.of(context)!.viewProfile,
                                style: const TextStyle(color: Colors.red),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      } else {
        if (dashboardController.profilevisitors.isEmpty) {
          return const SizedBox();
        } else {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppLocalizations.of(context)!.profileVisitors,
                style: CustomTextStyle.title,
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                height: 260,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: dashboardController.profilevisitors.length,
                  itemBuilder: (context, index) {
                    //  print("THis is visitor ${visitor}");
                    // Your actual visitor card widget goes here
                    if (dashboardController.profilevisitors.length > 5) {
                      if (index <
                          dashboardController.profilevisitors.length - 1) {
                        final visitor =
                            dashboardController.profilevisitors[index];
                        return Padding(
                          padding: const EdgeInsets.only(
                              bottom: 8.0, left: 8, right: 0, top: 8),
                          child: GestureDetector(
                            onTap: () async {
                              try {
                                print('Checking for Update');
                                AppUpdateInfo info =
                                    await InAppUpdate.checkForUpdate();

                                if (info.updateAvailability ==
                                    UpdateAvailability.updateAvailable) {
                                  print('Update available');
                                  await update();
                                } else {
                                  print('No update available');
                                  // _dashboardController.onItemTapped(value);
                                  navigatorKey.currentState!
                                      .push(MaterialPageRoute(
                                    builder: (context) => UserDetails(
                                        notificationID: 0,
                                        memberid: visitor["member_id"]),
                                  ));
                                }
                              } catch (e) {
                                print(
                                    'Error checking for update: ${e.toString()}');
                                navigatorKey.currentState!
                                    .push(MaterialPageRoute(
                                  builder: (context) => UserDetails(
                                      notificationID: 0,
                                      memberid: visitor["member_id"]),
                                ));
                              }
                            },
                            child: Container(
                              width: 150,
                              decoration: BoxDecoration(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(10)),
                                border: Border.all(
                                  color: const Color.fromARGB(255, 80, 93, 127)
                                      .withOpacity(0.2),
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Center(
                                      child: Container(
                                        width: 110, // Diameter of the circle
                                        height: 110, // Diameter of the circle
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          image: DecorationImage(
                                            image: NetworkImage(
                                              visitor["photoUrl"] ??
                                                  "${Appconstants.baseURL}/public/storage/images/download.png",
                                            ),
                                            fit: BoxFit
                                                .cover, // Ensures the image covers the circle
                                            alignment: Alignment
                                                .topCenter, // Aligns the image to the top
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Center(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "${visitor["member_profile_id"]}",
                                            style: CustomTextStyle.bodytextbold,
                                          ),
                                          visitor["is_Document_Verification"] ==
                                                  1
                                              ? Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 4.0, top: 4),
                                                  child: SizedBox(
                                                    height: 13,
                                                    width: 13,
                                                    child: Image.asset(
                                                        "assets/verified.png"),
                                                  ),
                                                )
                                              : const SizedBox()
                                        ],
                                      ),
                                    ),
                                    const Spacer(),
                                    Center(
                                      child: Text(
                                        "${visitor["age"]} Yrs, ${visitor["height"]},",
                                        overflow: TextOverflow.ellipsis,
                                        style: CustomTextStyle.bodytext
                                            .copyWith(fontSize: 12),
                                      ),
                                    ),
                                    Center(
                                      child: Text(
                                        "${visitor["present_city_name"]}, ${visitor["marital_status"]}",
                                        overflow: TextOverflow.ellipsis,
                                        style: CustomTextStyle.bodytext
                                            .copyWith(fontSize: 12),
                                      ),
                                    ),
                                    Center(
                                      child: Text(
                                        "${visitor["education"]}",
                                        overflow: TextOverflow.ellipsis,
                                        style: CustomTextStyle.bodytext
                                            .copyWith(fontSize: 12),
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          AppLocalizations.of(context)!
                                              .viewProfile,
                                          style: CustomTextStyle.textbuttonRed,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      } else {
                        //   final BottomNavController bottomNavController = Get.put(BottomNavController());
                        final visitor =
                            dashboardController.profilevisitors[index];

                        return Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: GestureDetector(
                            onTap: () async {
                              try {
                                print('Checking for Update');
                                AppUpdateInfo info =
                                    await InAppUpdate.checkForUpdate();

                                if (info.updateAvailability ==
                                    UpdateAvailability.updateAvailable) {
                                  print('Update available');
                                  await update();
                                } else {
                                  print('No update available');
                                  // _dashboardController.onItemTapped(value);

                                  dashboardController.onItemTapped(2);
                                  dashboardController.onInboxItemTapped(2);
                                }
                              } catch (e) {
                                print(
                                    'Error checking for update: ${e.toString()}');
                                dashboardController.onItemTapped(2);
                                dashboardController.onInboxItemTapped(2);
                              }
                            },
                            child: Stack(
                              children: [
                                Container(
                                  width: 150,
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10)),
                                    border: Border.all(
                                      color:
                                          const Color.fromARGB(255, 80, 93, 127)
                                              .withOpacity(0.2),
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Center(
                                          child: Container(
                                            width:
                                                110, // Diameter of the circle
                                            height:
                                                110, // Diameter of the circle
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              image: DecorationImage(
                                                image: NetworkImage(
                                                  visitor["photoUrl"] ??
                                                      "${Appconstants.baseURL}/public/storage/images/download.png",
                                                ),
                                                fit: BoxFit
                                                    .cover, // Ensures the image covers the circle
                                                alignment: Alignment
                                                    .topCenter, // Aligns the image to the top
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        Center(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "${visitor["member_profile_id"]}",
                                                style: CustomTextStyle
                                                    .bodytextbold,
                                              ),
                                              visitor["is_Document_Verification"] ==
                                                      1
                                                  ? Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 4.0,
                                                              top: 4),
                                                      child: SizedBox(
                                                        height: 13,
                                                        width: 13,
                                                        child: Image.asset(
                                                            "assets/verified.png"),
                                                      ),
                                                    )
                                                  : const SizedBox()
                                            ],
                                          ),
                                        ),
                                        const Spacer(),
                                        Center(
                                          child: Text(
                                            "${visitor["age"]} Yrs, ${visitor["height"]},",
                                            overflow: TextOverflow.ellipsis,
                                            style: CustomTextStyle.bodytext
                                                .copyWith(fontSize: 12),
                                          ),
                                        ),
                                        Center(
                                          child: Text(
                                            "${visitor["present_city_name"]}, ${visitor["marital_status"]}",
                                            overflow: TextOverflow.ellipsis,
                                            style: CustomTextStyle.bodytext
                                                .copyWith(fontSize: 12),
                                          ),
                                        ),
                                        Center(
                                          child: Text(
                                            "${visitor["education"]}",
                                            overflow: TextOverflow.ellipsis,
                                            style: CustomTextStyle.bodytext
                                                .copyWith(fontSize: 12),
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              AppLocalizations.of(context)!
                                                  .viewProfile,
                                              style:
                                                  CustomTextStyle.textbuttonRed,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                // Full overlay
                                Positioned.fill(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(
                                          0.7), // Dark overlay with opacity
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Center(
                                        child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        Text(
                                          language == "en"
                                              ? "View All!!"
                                              : 'सर्व प्रोफाईल्स बघा',
                                          style: CustomTextStyle.bodytextbold
                                              .copyWith(
                                            color: Colors.white,
                                            fontSize: 16,
                                          ),
                                        ),
                                        // Text(
                                        //   "Profiles",
                                        //   maxLines: 2,
                                        //   style: CustomTextStyle.bodytextbold
                                        //       .copyWith(
                                        //     color: Colors.white,
                                        //     fontSize: 16,
                                        //   ),
                                        // ),
                                      ],
                                    )),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                    } else {
                      final visitor =
                          dashboardController.profilevisitors[index];

                      return Padding(
                        padding: const EdgeInsets.only(
                            bottom: 8.0, left: 8, right: 0, top: 8),
                        child: GestureDetector(
                          onTap: () async {
                            try {
                              print('Checking for Update');
                              AppUpdateInfo info =
                                  await InAppUpdate.checkForUpdate();

                              if (info.updateAvailability ==
                                  UpdateAvailability.updateAvailable) {
                                print('Update available');
                                await update();
                              } else {
                                print('No update available');
                                // _dashboardController.onItemTapped(value);
                                navigatorKey.currentState!
                                    .push(MaterialPageRoute(
                                  builder: (context) => UserDetails(
                                      notificationID: 0,
                                      memberid: visitor["member_id"]),
                                ));
                              }
                            } catch (e) {
                              print(
                                  'Error checking for update: ${e.toString()}');
                              navigatorKey.currentState!.push(MaterialPageRoute(
                                builder: (context) => UserDetails(
                                    notificationID: 0,
                                    memberid: visitor["member_id"]),
                              ));
                            }
                          },
                          child: Container(
                            width: 150,
                            decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10)),
                              border: Border.all(
                                color: const Color.fromARGB(255, 80, 93, 127)
                                    .withOpacity(0.2),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Center(
                                    child: Container(
                                      width: 110, // Diameter of the circle
                                      height: 110, // Diameter of the circle
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        image: DecorationImage(
                                          image: NetworkImage(
                                            visitor["photoUrl"] ??
                                                "${Appconstants.baseURL}/public/storage/images/download.png",
                                          ),
                                          fit: BoxFit
                                              .cover, // Ensures the image covers the circle
                                          alignment: Alignment
                                              .topCenter, // Aligns the image to the top
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Center(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "${visitor["member_profile_id"]}",
                                          style: CustomTextStyle.bodytextbold,
                                        ),
                                        visitor["is_Document_Verification"] == 1
                                            ? Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 4.0, top: 4),
                                                child: SizedBox(
                                                  height: 13,
                                                  width: 13,
                                                  child: Image.asset(
                                                      "assets/verified.png"),
                                                ),
                                              )
                                            : const SizedBox()
                                      ],
                                    ),
                                  ),
                                  const Spacer(),
                                  Center(
                                    child: Text(
                                      "${visitor["age"]} Yrs, ${visitor["height"]},",
                                      overflow: TextOverflow.ellipsis,
                                      style: CustomTextStyle.bodytext
                                          .copyWith(fontSize: 12),
                                    ),
                                  ),
                                  Center(
                                    child: Text(
                                      "${visitor["present_city_name"]}, ${visitor["marital_status"]}",
                                      overflow: TextOverflow.ellipsis,
                                      style: CustomTextStyle.bodytext
                                          .copyWith(fontSize: 12),
                                    ),
                                  ),
                                  Center(
                                    child: Text(
                                      "${visitor["education"]}",
                                      overflow: TextOverflow.ellipsis,
                                      style: CustomTextStyle.bodytext
                                          .copyWith(fontSize: 12),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        AppLocalizations.of(context)!
                                            .viewProfile,
                                        style: CustomTextStyle.textbuttonRed,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }
                  },
                ),
              )
            ],
          );
        }
      }
    });
  }
}
