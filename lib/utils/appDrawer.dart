// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:_96kuliapp/utils/selectlanguage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:_96kuliapp/checkupdateFunctions.dart';
import 'package:_96kuliapp/commons/appconstants.dart';
import 'package:_96kuliapp/commons/dialogues/logoutDialogoue.dart';
import 'package:_96kuliapp/commons/textdecoration.dart';
import 'package:_96kuliapp/controllers/auth/casteVerificationBlock.dart';
import 'package:_96kuliapp/controllers/auth/casteVerificationScreen.dart';
import 'package:_96kuliapp/controllers/dashboardControllers/dashboardController.dart';
import 'package:_96kuliapp/controllers/editforms_controllers/editPartnerExpectationController.dart';
import 'package:_96kuliapp/controllers/viewProfileControllers/viewprofileController.dart';
import 'package:_96kuliapp/dummy.dart';
import 'package:_96kuliapp/main.dart';
import 'package:_96kuliapp/routes/routenames.dart';
import 'package:_96kuliapp/screens/ProfilePhotoRequestToChange/ProfilePhotoRequestToChangeScreen.dart';
import 'package:_96kuliapp/screens/accounts_and_settings/deactivateAccount.dart';
import 'package:_96kuliapp/screens/accounts_and_settings/deleteAccount.dart';
import 'package:_96kuliapp/screens/exploreAppScreens/ExploreAppScreen.dart';
import 'package:_96kuliapp/screens/accounts_and_settings/contactPrivacy.dart';
import 'package:_96kuliapp/screens/accounts_and_settings/updatePasswordScreen.dart';
import 'package:_96kuliapp/screens/auth_Screens/loginScreen2.dart';
import 'package:_96kuliapp/screens/auth_Screens/registerOTPScreen.dart';
import 'package:_96kuliapp/screens/editProfile_screens/editPartnerPrefrance.dart';
import 'package:_96kuliapp/screens/exploreAppScreens/ExploreAppTab.dart';
import 'package:_96kuliapp/screens/notifications/notificationScreen.dart';
import 'package:_96kuliapp/screens/plans/addOnPlan.dart';
import 'package:_96kuliapp/screens/plans/limitedOfferPlanScreen.dart';
import 'package:_96kuliapp/screens/plans/myPlan.dart';
import 'package:_96kuliapp/screens/plans/planIntermediateScreen.dart';
import 'package:_96kuliapp/screens/plans/upgradeScreen.dart';
import 'package:_96kuliapp/screens/profile_screens/edit_profile.dart';
import 'package:_96kuliapp/screens/search_Screens/advanced_search.dart';
import 'package:_96kuliapp/screens/userInfoForms/userInfoStepOne.dart';
import 'package:_96kuliapp/screens/userInfoForms/userInfoStepTwo.dart';
import 'package:_96kuliapp/screens/userInfoForms/userinfoStepFour.dart';
import 'package:_96kuliapp/screens/userInfoForms/userinfoStepSix.dart';
import 'package:_96kuliapp/screens/userInfoForms/userinfoStepThree.dart';
import 'package:_96kuliapp/utils/Apptheme.dart';
import 'package:_96kuliapp/utils/bottomnavBar.dart';
import 'package:_96kuliapp/utils/customtile.dart';
import 'package:_96kuliapp/utils/newmatches.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:pub_semver/pub_semver.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // final BottomNavController bottomNavController = Get.put(BottomNavController());
    final DashboardController _dashboardController =
        Get.find<DashboardController>();
    return Drawer(
      width: MediaQuery.of(context).size.width * 0.9,
      backgroundColor: Colors.white,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Obx(
                      () {
                        if (_dashboardController.fetchedPhotoURL.isNotEmpty) {
                          if (_dashboardController.loadingPhoto.value) {
                            return SizedBox(
                              height: 90,
                              width: 90,
                              child: CircleAvatar(
                                radius: 35,
                                backgroundColor:
                                    const Color.fromARGB(255, 80, 93, 126),
                                child: ClipOval(
                                  child: Image.network(
                                    "${Appconstants.baseURL}/public/storage/images/${_dashboardController.dashboardData["photo"][0]["photo_name"]}",
                                    fit: BoxFit
                                        .cover, // Ensures the image covers the entire area
                                    width:
                                        85, // Setting a size to match the CircleAvatar's dimensions
                                    height: 85,
                                  ),
                                ),
                              ),
                            );
                          } else {
                            return SizedBox(
                              height: 120,
                              width: 120,
                              child: CircleAvatar(
                                backgroundImage: NetworkImage(
                                    _dashboardController.fetchedPhotoURL.value),
                                // Optionally add a background color
                                backgroundColor: Colors.grey[
                                    200], // Default background color if image fails to load
                              ),
                            );
                          }
                        } else {
                          return SizedBox(
                            height: 90,
                            width: 90,
                            child: CircleAvatar(
                              radius: 35,
                              backgroundColor:
                                  const Color.fromARGB(255, 80, 93, 126),
                              child: ClipOval(
                                child: Image.network(
                                  "${Appconstants.baseURL}/public/storage/images/${_dashboardController.dashboardData["photo"][0]["photo_name"]}",
                                  fit: BoxFit
                                      .cover, // Ensures the image covers the entire area
                                  width:
                                      85, // Setting a size to match the CircleAvatar's dimensions
                                  height: 85,
                                ),
                              ),
                            ),
                          );
                        }
                      },
                    ),
                    const SizedBox(
                      width: 13,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${_dashboardController.dashboardData["memberData"]["first_name"]} ${_dashboardController.dashboardData["memberData"]["last_name"]}",
                            style: CustomTextStyle.bodytextbold
                                .copyWith(fontSize: 18),
                            softWrap: true,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                          Text(
                            "${AppLocalizations.of(context)!.profileID} - ${_dashboardController.dashboardData["memberData"]["member_profile_id"]}",
                            style: CustomTextStyle.bodytext,
                          ),
                          GestureDetector(
                            onTap: () {
                              navigateWithTransition(
                                  navigatorKey: navigatorKey,
                                  screen: const EditProfile());
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                // rgba(204, 40, 77, 1)
                                SizedBox(
                                  height: 10,
                                  width: 10,
                                  child: Image.asset(
                                      "assets/editProfileRedmenu.png"),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  AppLocalizations.of(context)!.editProfile,
                                  style: const TextStyle(
                                      fontFamily: "WORKSANSMEDIUM",
                                      fontSize: 11,
                                      color: Color.fromARGB(255, 204, 40, 77)),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
          customtile(
            leadingimg: "assets/dashboard.png",
            title: AppLocalizations.of(context)!.dashboard,
            onTap: () {
              if (_dashboardController.selectedIndex.value == 0) {
                Get.back();
              } else {
                _dashboardController.onItemTapped(0);
              }
              // bottomNavController.onItemTapped(2);
            },
          ),
          customtile(
              onTap: () {
                Get.back();
                navigateWithTransition(
                    navigatorKey: navigatorKey, screen: const EditProfile());
              },
              leadingimg: "assets/vieweditprofile.png",
              title: AppLocalizations.of(context)!.myProfile),
          customtile(
            leadingimg: "assets/searchbyprofileid.png",
            title: AppLocalizations.of(context)!.searchProfileById,
            onTap: () async {
              try {
                print('Checking for Update');
                AppUpdateInfo info = await InAppUpdate.checkForUpdate();

                if (info.updateAvailability ==
                    UpdateAvailability.updateAvailable) {
                  print('Update available');
                  await update();
                } else {
                  print('No update available');
                  // _dashboardController.onItemTapped(value);

                  Get.back();
                  _dashboardController.onItemTapped(3);
                }
              } catch (e) {
                print('Error checking for update: ${e.toString()}');
                Get.back();
                _dashboardController.onItemTapped(3);
              }
            },
          ),
          customtile(
            leadingimg: "assets/searchpartner.png",
            title: AppLocalizations.of(context)!.searchMatches,
            onTap: () async {
              try {
                print('Checking for Update');
                AppUpdateInfo info = await InAppUpdate.checkForUpdate();

                if (info.updateAvailability ==
                    UpdateAvailability.updateAvailable) {
                  print('Update available');
                  await update();
                } else {
                  print('No update available');
                  // _dashboardController.onItemTapped(value);

                  Get.back();
                  navigateWithTransition(
                      navigatorKey: navigatorKey,
                      screen: const AdvancedSearch());
                }
              } catch (e) {
                print('Error checking for update: ${e.toString()}');
                Get.back();
                navigateWithTransition(
                    navigatorKey: navigatorKey, screen: const AdvancedSearch());
              }

              //  Get.toNamed(AppRouteNames.userInfoStepThree);
            },
          ),
          ExpansionTile(
            collapsedIconColor: Colors.grey.shade500,
            iconColor: Colors.grey.shade500,
            title: Text(
              AppLocalizations.of(context)!.discoverYourMatches,
              style: CustomTextStyle.bodytext.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            leading: SizedBox(
              height: 18,
              width: 18,
              child: Image.asset("assets/heart 1.png"),
            ),
            children: <Widget>[
              ListTile(
                title: Text(
                  AppLocalizations.of(context)!.recommendedMatches,
                  style: CustomTextStyle.bodytext.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                onTap: () async {
                  try {
                    print('Checking for Update');
                    AppUpdateInfo info = await InAppUpdate.checkForUpdate();

                    if (info.updateAvailability ==
                        UpdateAvailability.updateAvailable) {
                      print('Update available');
                      await update();
                    } else {
                      print('No update available');
                      // _dashboardController.onItemTapped(value);
                      if (_dashboardController.selectedIndex.value == 1 &&
                          _dashboardController.selectedmatchsScreen.value ==
                              0) {
                        Get.back();
                      } else {
                        _dashboardController.updateMathcesScreen(0);

                        _dashboardController.onItemTapped(1);
                      }
                    }
                  } catch (e) {
                    print('Error checking for update: ${e.toString()}');
                    if (_dashboardController.selectedIndex.value == 1 &&
                        _dashboardController.selectedmatchsScreen.value == 0) {
                      Get.back();
                    } else {
                      _dashboardController.updateMathcesScreen(0);

                      _dashboardController.onItemTapped(1);
                    }
                  }
                },
              ),
              ListTile(
                title: Text(
                  AppLocalizations.of(context)!.matchesByEducation,
                  style: CustomTextStyle.bodytext.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                onTap: () async {
                  try {
                    print('Checking for Update');
                    AppUpdateInfo info = await InAppUpdate.checkForUpdate();

                    if (info.updateAvailability ==
                        UpdateAvailability.updateAvailable) {
                      print('Update available');
                      await update();
                    } else {
                      print('No update available');
                      // _dashboardController.onItemTapped(value);
                      if (_dashboardController.selectedIndex.value == 1 &&
                          _dashboardController.selectedmatchsScreen.value ==
                              1) {
                        Get.back();
                      } else {
                        _dashboardController.updateMathcesScreen(1);
                        _dashboardController.onItemTapped(1);
                      }
                    }
                  } catch (e) {
                    print('Error checking for update: ${e.toString()}');
                    if (_dashboardController.selectedIndex.value == 1 &&
                        _dashboardController.selectedmatchsScreen.value == 1) {
                      Get.back();
                    } else {
                      _dashboardController.updateMathcesScreen(1);
                      _dashboardController.onItemTapped(1);
                    }
                  }
                },
              ),
              ListTile(
                title: Text(
                  AppLocalizations.of(context)!.matchesByLocation,
                  style: CustomTextStyle.bodytext.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                onTap: () async {
                  try {
                    print('Checking for Update');
                    AppUpdateInfo info = await InAppUpdate.checkForUpdate();

                    if (info.updateAvailability ==
                        UpdateAvailability.updateAvailable) {
                      print('Update available');
                      await update();
                    } else {
                      print('No update available');
                      // _dashboardController.onItemTapped(value);

                      _dashboardController.updateMathcesScreen(2);
                      _dashboardController.onItemTapped(1);
                    }
                  } catch (e) {
                    print('Error checking for update: ${e.toString()}');
                    _dashboardController.updateMathcesScreen(2);
                    _dashboardController.onItemTapped(1);
                  }
                },
              ),
              ListTile(
                title: Text(
                  AppLocalizations.of(context)!.matchesByOccupation,
                  style: CustomTextStyle.bodytext.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                onTap: () async {
                  try {
                    print('Checking for Update');
                    AppUpdateInfo info = await InAppUpdate.checkForUpdate();

                    if (info.updateAvailability ==
                        UpdateAvailability.updateAvailable) {
                      print('Update available');
                      await update();
                    } else {
                      print('No update available');
                      // _dashboardController.onItemTapped(value);

                      _dashboardController.updateMathcesScreen(3);
                      _dashboardController.onItemTapped(1);
                    }
                  } catch (e) {
                    print('Error checking for update: ${e.toString()}');
                    _dashboardController.updateMathcesScreen(3);
                    _dashboardController.onItemTapped(1);
                  }
                },
              ),
              ListTile(
                title: Text(
                  AppLocalizations.of(context)!.allMatches,
                  style: CustomTextStyle.bodytext.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                onTap: () async {
                  try {
                    print('Checking for Update');
                    AppUpdateInfo info = await InAppUpdate.checkForUpdate();

                    if (info.updateAvailability ==
                        UpdateAvailability.updateAvailable) {
                      print('Update available');
                      await update();
                    } else {
                      print('No update available');
                      // _dashboardController.onItemTapped(value);

                      _dashboardController.updateMathcesScreen(4);
                      _dashboardController.onItemTapped(1);
                    }
                  } catch (e) {
                    print('Error checking for update: ${e.toString()}');
                    _dashboardController.updateMathcesScreen(4);
                    _dashboardController.onItemTapped(1);
                  }
                },
              ),
            ],
          ),
          customtile(
            leadingimg: "assets/inboxdrawer.png",
            title: AppLocalizations.of(context)!.inbox,
            notification: _dashboardController.countData["received"],
            onTap: () async {
              try {
                print('Checking for Update');
                AppUpdateInfo info = await InAppUpdate.checkForUpdate();

                if (info.updateAvailability ==
                    UpdateAvailability.updateAvailable) {
                  print('Update available');
                  await update();
                } else {
                  print('No update available');
                  if (_dashboardController.selectedIndex.value == 2) {
                    Get.back();
                  } else {
                    _dashboardController.onItemTapped(2);
                  }
                }
              } catch (e) {
                print('Error checking for update: ${e.toString()}');
                if (_dashboardController.selectedIndex.value == 2) {
                  Get.back();
                } else {
                  _dashboardController.onItemTapped(2);
                }
              }
            },
          ),
          customtile(
              onTap: () {
                print("Print");
                navigatorKey.currentState!.push(MaterialPageRoute(
                  builder: (context) => const MyPlan(),
                ));
                //  navigatorKey.currentState!.push(MaterialPageRoute(builder: (context) =>  ProfilePhotoRequestToChangeScreen(),));
              },
              leadingimg: "assets/myplan.png",
              title: AppLocalizations.of(context)!.myPlan),
          customtile(
              onTap: () {
                print("Print");
                navigatorKey.currentState!.push(MaterialPageRoute(
                  builder: (context) => const NotificationScreen(),
                ));
                //  navigatorKey.currentState!.push(MaterialPageRoute(builder: (context) =>  ProfilePhotoRequestToChangeScreen(),));
              },
              leadingimg: "assets/notificationdrawer.png",
              title: AppLocalizations.of(context)!.notificatiions),

          /*   Obx(() {
                              if(_dashboardController.dashboardData["memberData"]["is_premium"] == "1"){
return 
                                customtile(
              onTap: (){
                print("Print");
                   Get.back();

                            navigateWithTransition(navigatorKey: navigatorKey, screen: Addonplan());

              } ,
            leadingimg: "assets/add-contactMenu.png",
            title: "Add on Contacts",
          );
                              }else{
                                return 
                              SizedBox();
                              
                              }
                            },),*/

          ExpansionTile(
            collapsedIconColor: Colors.grey.shade500,
            iconColor: Colors.grey.shade500,
            title: Text(
              AppLocalizations.of(context)!.accountAndSettings,
              style: CustomTextStyle.bodytext.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            leading: SizedBox(
              height: 18,
              width: 18,
              child: Image.asset("assets/settingsdrawer.png"),
            ),
            children: <Widget>[
              ListTile(
                onTap: () {
                  Get.back();

                  navigateWithTransition(
                      navigatorKey: navigatorKey,
                      screen: const EditPartnerPrefrances());
                },
                title: Text(
                  AppLocalizations.of(context)!.updatePartnerPreference,
                  style: CustomTextStyle.bodytext.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              ListTile(
                onTap: () {
                  navigateWithTransition(
                      navigatorKey: navigatorKey,
                      screen: const EditContactPrivacy());
                },
                title: Text(
                  AppLocalizations.of(context)!.changePrivacySetting,
                  style: CustomTextStyle.bodytext.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              ListTile(
                onTap: () {
                  navigateWithTransition(
                      navigatorKey: navigatorKey,
                      screen: const UpdatePasswordScreen());
                },
                title: Text(
                  AppLocalizations.of(context)!.changePassword,
                  style: CustomTextStyle.bodytext.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              /*     ListTile(
                onTap: () {
                   Get.back();

                                             navigateWithTransition(navigatorKey: navigatorKey, screen: DeactivateAccount());
              
                },
              title: Text('Deactivate Account' , style: CustomTextStyle.bodytext.copyWith( fontSize: 16,
          fontWeight: FontWeight.w600,),),
            ),*/
              ListTile(
                onTap: () {
                  Get.back();

                  navigateWithTransition(
                      navigatorKey: navigatorKey,
                      screen: const DeleteAccount());
                },
                title: Text(
                  AppLocalizations.of(context)!.deleteAccount,
                  style: CustomTextStyle.bodytext.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          customtile(
              onTap: () {
                // Show a dialog when tapped
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return const Logout(
                      page: "dashBoard",
                    );
                  },
                );
              },
              leadingimg: "assets/logout.png",
              title: AppLocalizations.of(context)!.logout),

          /*  const customtile(
            leadingimg: "assets/notificationdrawer.png",
            title: "Notifications",
          ),
          const Divider(),*/

          const SizedBox(
            height: 80,
          )
        ],
      ),
    );
  }
}
