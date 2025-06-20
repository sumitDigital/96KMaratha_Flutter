import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:_96kuliapp/checkupdateFunctions.dart';
import 'package:_96kuliapp/commons/appconstants.dart';
import 'package:_96kuliapp/commons/textdecoration.dart';
import 'package:_96kuliapp/controllers/dashboardControllers/dashboardController.dart';
import 'package:_96kuliapp/main.dart';
import 'package:_96kuliapp/screens/profile_screens/user_details.dart';
import 'package:shimmer/shimmer.dart';

class RecentVisitorsOnPlan extends StatelessWidget {
  const RecentVisitorsOnPlan({
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
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "View Profile",
                                style: TextStyle(color: Colors.red),
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
              const Text(
                "Profile Visitors",
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
                                      child: CircleAvatar(
                                        backgroundImage: NetworkImage(visitor[
                                                "photoUrl"] ??
                                            "${Appconstants.baseURL}/public/storage/images/download.png"),
                                        radius: 55,
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
                                    const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          "View Profile",
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
                                          child: CircleAvatar(
                                            backgroundImage: NetworkImage(visitor[
                                                    "photoUrl"] ??
                                                "${Appconstants.baseURL}/public/storage/images/download.png"),
                                            radius: 55,
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
                                        const Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              "View Profile",
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
                                        Text(
                                          "Profiles",
                                          maxLines: 2,
                                          style: CustomTextStyle.bodytextbold
                                              .copyWith(
                                            color: Colors.white,
                                            fontSize: 16,
                                          ),
                                        ),
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
                                    child: CircleAvatar(
                                      backgroundImage: NetworkImage(visitor[
                                              "photoUrl"] ??
                                          "${Appconstants.baseURL}/public/storage/images/download.png"),
                                      radius: 55,
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
                                  const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        "View Profile",
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
