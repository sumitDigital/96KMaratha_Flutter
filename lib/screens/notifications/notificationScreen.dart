import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:_96kuliapp/commons/textdecoration.dart';
import 'package:_96kuliapp/controllers/dashboardControllers/dashboardController.dart';
import 'package:_96kuliapp/controllers/notificationController.dart';
import 'package:_96kuliapp/main.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:_96kuliapp/routes/routenames.dart';
import 'package:_96kuliapp/screens/profile_screens/user_details.dart';
import 'package:_96kuliapp/utils/Apptheme.dart';
import 'package:_96kuliapp/utils/backHeader.dart';
import 'package:shimmer/shimmer.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    String? language = sharedPreferences?.getString("Language");
    final controller = Get.put(NotificationController());
    controller.fetchNotifications();
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          await controller.fetchNotifications();
        },
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              Expanded(
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(AppLocalizations.of(context)!.today),
                          ListView.builder(
                            shrinkWrap: true,
                            itemCount: 5,
                            itemBuilder: (context, index) {
                              return ListTile(
                                title: Container(
                                  color: Colors.grey[300],
                                  height: 20.0,
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    );
                  }

                  final hasNotifications =
                      (controller.notifications['today'] ?? []).isNotEmpty ||
                          (controller.notifications['yesterday'] ?? [])
                              .isNotEmpty ||
                          (controller.notifications['this_week'] ?? [])
                              .isNotEmpty ||
                          (controller.notifications['other'] ?? []).isNotEmpty;

                  if (!hasNotifications) {
                    return SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Container(
                        height:
                            MediaQuery.of(context).size.height - kToolbarHeight,
                        alignment: Alignment.center,
                        child: Text(language == "en"
                            ? "No Notifications Found"
                            : "कोणतेही नोटिफिकेशन आढळले नाही"),
                      ),
                    );
                  }

                  return SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if ((controller.notifications['today'] ?? [])
                            .isNotEmpty) ...[
                          Padding(
                            padding: const EdgeInsets.only(left: 18.0, top: 10),
                            child: Text(AppLocalizations.of(context)!.today,
                                style: CustomTextStyle.fieldName),
                          ),
                          _buildNotificationList(
                              controller.notifications['today'] ?? []),
                        ],
                        if ((controller.notifications['yesterday'] ?? [])
                            .isNotEmpty) ...[
                          Padding(
                            padding: const EdgeInsets.only(left: 18.0, top: 20),
                            child: Text(AppLocalizations.of(context)!.yesterday,
                                style: CustomTextStyle.fieldName),
                          ),
                          _buildNotificationList(
                              controller.notifications['yesterday'] ?? []),
                        ],
                        if ((controller.notifications['this_week'] ?? [])
                            .isNotEmpty) ...[
                          Padding(
                            padding: const EdgeInsets.only(left: 18.0, top: 20),
                            child: Text(AppLocalizations.of(context)!.thisWeek,
                                style: CustomTextStyle.fieldName),
                          ),
                          _buildNotificationList(
                              controller.notifications['this_week'] ?? []),
                        ],
                        if ((controller.notifications['other'] ?? [])
                            .isNotEmpty) ...[
                          Padding(
                            padding: const EdgeInsets.only(left: 18.0, top: 20),
                            child: Text(AppLocalizations.of(context)!.others,
                                style: CustomTextStyle.fieldName),
                          ),
                          _buildNotificationList(
                              controller.notifications['other'] ?? []),
                        ],
                      ],
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // _buildHeader and _buildNotificationList remain unchanged
}

Widget _buildHeader(BuildContext context) {
  return BackHeader(
      onTap: () {
        Get.back();
      },
      title: AppLocalizations.of(context)!.notificatiions);
}

Widget _buildNotificationList(List notifications) {
  return Padding(
    padding: const EdgeInsets.only(top: 8.0),
    child: ListView.builder(
      itemCount: notifications.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final notification = notifications[index];
        return _buildNotificationItem(context, notification);
      },
    ),
  );
}

Widget _buildNotificationItem(
  BuildContext context,
  Map<String, dynamic> notification,
) {
  return GestureDetector(
    onTap: () {
      navigatorKey.currentState!.pushReplacement(MaterialPageRoute(
        builder: (context) => UserDetails(
          memberid: notification["notification_by"],
          notificationID: notification["notification_id"],
        ),
      ));
    },
    child: Container(
      decoration: BoxDecoration(
        color: notification["isRead"] == 1
            ? Colors.white
            : /* AppTheme.dividerColor */ Colors.grey.shade300,
        border: Border(
          bottom: BorderSide(color: AppTheme.dividerColor, width: 2.0),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            CircleAvatar(
              backgroundImage:
                  NetworkImage(notification['profile_picture_url']),
              radius: 30,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  notification["notification_type_id"] == 1
                      ? (notification["interest_received_status"] == "2"
                          ? Text(
                              "You Declined Request from ${notification["member_name"]}",
                              style: CustomTextStyle.bodytextSmall,
                            )
                          : notification["interest_received_status"] == "3"
                              ? Text(
                                  "You Accepted request from ${notification["member_name"]}",
                                  style: CustomTextStyle.bodytextSmall,
                                )
                              : Text(
                                  notification['notification_text'] ?? "",
                                  style: CustomTextStyle.bodytextSmall,
                                ))
                      : Text(
                          notification['notification_text'] ?? "",
                          style: CustomTextStyle.bodytextSmall,
                        ),
                  Text(
                    notification['timestamp'] ?? "",
                    style: CustomTextStyle.lighttext,
                  ),
                  notification['notification_type_id'] == 1
                      ? (notification['interest_received_status'] == "1"
                          ? Row(
                              children: [
                                TextButton(
                                  onPressed: () {
                                    showDialog(
                                      barrierDismissible: false,
                                      context: context,
                                      builder: (context) {
                                        return AcceptInterestDialogueForNotification(
                                            matchid: notification[
                                                "notification_by"]);
                                      },
                                    );
                                  },
                                  child: Text(
                                      AppLocalizations.of(context)!.accept,
                                      style: CustomTextStyle.textbuttonRed),
                                ),
                                const SizedBox(width: 10),
                                TextButton(
                                  onPressed: () {
                                    showDialog(
                                      barrierDismissible: false,
                                      context: context,
                                      builder: (context) {
                                        return DeclineInterestDialogueForNotification(
                                            matchid: notification[
                                                "notification_by"]);
                                      },
                                    );
                                  },
                                  child: Text(
                                      AppLocalizations.of(context)!.decline,
                                      style: CustomTextStyle.textbuttonRed),
                                ),
                              ],
                            )
                          : const SizedBox())
                      : const SizedBox(),
                  notification["interest_received_status"] != "1" ||
                          notification["interest_sent_status"] == "2"
                      ? TextButton(
                          onPressed: () {
                            navigatorKey.currentState!
                                .pushReplacement(MaterialPageRoute(
                              builder: (context) => UserDetails(
                                memberid: notification["notification_by"],
                                notificationID: notification["notification_id"],
                              ),
                            ));
                          },
                          child: Text(
                            AppLocalizations.of(context)!.viewProfile,
                            style: CustomTextStyle.bodytextbold,
                          ))
                      : const SizedBox()
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

class AcceptInterestDialogueForNotification extends StatelessWidget {
  const AcceptInterestDialogueForNotification(
      {super.key, required this.matchid});
  final int matchid;

  @override
  Widget build(BuildContext context) {
    final DashboardController dashboardController =
        Get.put(DashboardController());
    final NotificationController notificationController =
        Get.find<NotificationController>();

    return Dialog(
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: Text(
                        textAlign: TextAlign.center,
                        AppLocalizations.of(context)!.wantTOAcceptInterest,
                        // "Want to Acccept Interest?",
                        style: TextStyle(
                          fontFamily: "WORKSANS",
                          color: AppTheme.primaryColor,
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 18.0, right: 18, bottom: 8, top: 8),
                    child: Text(
                      textAlign: TextAlign.center,
                      AppLocalizations.of(context)!.acceptInterestDesc,
                      // "Don't think..! Accept their interest & take steps toward a new match..",
                      style: CustomTextStyle.bodytext,
                    ),
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8),
                        topRight: Radius.circular(8),
                      ),
                    ),
                    height: 109,
                    width: 329,
                    child: Stack(
                      children: [
                        Center(
                          child: SizedBox(
                            height: 180,
                            width: 286,
                            child: Image.asset("assets/acceptInterest.png"),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(height: 10),
                        ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5))),
                            ),
                            onPressed: () {
                              dashboardController
                                  .acceptedrequest(memberid: matchid)
                                  .then(
                                (value) {
                                  notificationController.fetchNotifications();
                                },
                              );
                              Get.back();
                            },
                            icon: SizedBox(
                              height: 14,
                              width: 14,
                              child: Image.asset(
                                  "assets/Express-interest-button.png"),
                            ),
                            label: Obx(
                              () {
                                if (dashboardController.acceptloading.value) {
                                  return const CircularProgressIndicator(
                                    color: Colors.white,
                                  );
                                } else {
                                  return Text(
                                    AppLocalizations.of(context)!
                                        .acceptInterestButton,
                                    // "ACCEPT INTEREST",
                                    style: CustomTextStyle
                                        .elevatedButtonWhiteLarge,
                                  );
                                }
                              },
                            )),
                        const SizedBox(
                          height: 10,
                        ),
                        GestureDetector(
                          onTap: () {
                            Get.back();
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: SizedBox(
                                  height: 12,
                                  child: Image.asset("assets/no-thanks.png"),
                                ),
                              ),
                              Text(
                                // " Don't Accept",
                                AppLocalizations.of(context)!.dontAcceptButton,
                                style: CustomTextStyle.bodytextbold,
                              ),
                            ],
                          ),
                        ),
                        /*    TextButton.icon(
                          style: ElevatedButton.styleFrom(
                            shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                    Radius.circular(5))),
                            backgroundColor: Colors.white,
                          ),
                          onPressed: () {
                            Get.back();
                          },
                          icon: Padding(
                            padding: const EdgeInsets.all(0),
                            child: SizedBox(height: 12, child: Image.asset("assets/no-thanks.png"),),
                          ),
                          label: const Text(
                            " No, Thanks",
                            style: CustomTextStyle.bodytextbold,
                          ),
                        ),*/
                      ],
                    ),
                  )
                ],
              ),
            ),
            // Close icon at the top right corner, half outside the dialog
            Positioned(
              top: -7,
              right: -7,
              child: GestureDetector(
                onTap: () {
                  Get.back();
                },
                child: Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        child: Image.asset(
                            height: 24, width: 24, "assets/close-popup.png"),
                      ),
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/*
   Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(child: ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
        backgroundColor: Colors.white , side: const BorderSide(color: Colors.red )  ), 
      onPressed: (){
      Get.back();
    }, child:  const Text("Cancel" , style: CustomTextStyle.elevatedButtonSmallRed,))),
    const SizedBox(width: 10,),
                  Expanded(child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),

                    ),
                    onPressed: (){
                   _dashboardController.acceptedrequest(memberid: matchid).then((value) {
                     _notificationController.fetchNotifications();
                   },);
                Get.back();
                    

                    }, child: Obx(() {
                      if(_dashboardController.acceptloading.value){
                        return CircularProgressIndicator(color: Colors.white,);
                      }else{
                        return const Text("Accept" , style: CustomTextStyle.elevatedButtonSmall,);
                      }
                    },)
                    
                    )
                    
                    ), 

                ],)
            ),*/

class DeclineInterestDialogueForNotification extends StatelessWidget {
  const DeclineInterestDialogueForNotification(
      {super.key, required this.matchid});
  final int matchid;

  @override
  Widget build(BuildContext context) {
    final DashboardController dashboardcontroller =
        Get.find<DashboardController>();
    final NotificationController notificationController =
        Get.find<NotificationController>();

    return Dialog(
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: Text(
                        textAlign: TextAlign.center,
                        // "Want to Decline This Profile?",
                        AppLocalizations.of(context)!.wantToDeclineInterest,
                        style: TextStyle(
                          fontFamily: "WORKSANS",
                          color: AppTheme.primaryColor,
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 18.0, right: 18, bottom: 8, top: 8),
                    child: Text(
                      textAlign: TextAlign.center,
                      // "If you cancel your interest, you won’t be able to interact with this profile further. Are you sure you want to proceed?",
                      AppLocalizations.of(context)!.declineInterestDesc,
                      style: CustomTextStyle.bodytext,
                    ),
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8),
                        topRight: Radius.circular(8),
                      ),
                    ),
                    height: 109,
                    width: 329,
                    child: Stack(
                      children: [
                        Center(
                          child: SizedBox(
                            height: 180,
                            width: 286,
                            child: Image.asset("assets/declineInterest.png"),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(height: 10),
                        ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5))),
                            ),
                            onPressed: () {
                              print("this is Member ID \$memberID");
                              dashboardcontroller
                                  .declinerequest(memberid: matchid)
                                  .then(
                                (value) {
                                  Get.back();
                                  notificationController.fetchNotifications();
                                },
                              );
                            },
                            icon: SizedBox(
                              height: 14,
                              width: 14,
                              child: Image.asset(
                                  "assets/Express-interest-button.png"),
                            ),
                            label: Obx(
                              () {
                                if (dashboardcontroller.declineLoading.value) {
                                  return const CircularProgressIndicator(
                                    color: Colors.white,
                                  );
                                } else {
                                  return Text(
                                    // " DECLINE INTEREST",
                                    AppLocalizations.of(context)!
                                        .declineInterestButton,
                                    style: CustomTextStyle
                                        .elevatedButtonWhiteLarge,
                                  );
                                }
                              },
                            )),
                        const SizedBox(
                          height: 10,
                        ),
                        GestureDetector(
                          onTap: () {
                            Get.back();
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: SizedBox(
                                  height: 12,
                                  child: Image.asset("assets/no-thanks.png"),
                                ),
                              ),
                              Text(
                                // " Don't Decline",
                                AppLocalizations.of(context)!.dontDecline,
                                style: CustomTextStyle.bodytextbold,
                              ),
                            ],
                          ),
                        ),
                        /*    TextButton.icon(
                          style: ElevatedButton.styleFrom(
                            shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                    Radius.circular(5))),
                            backgroundColor: Colors.white,
                          ),
                          onPressed: () {
                            Get.back();
                          },
                          icon: Padding(
                            padding: const EdgeInsets.all(0),
                            child: SizedBox(height: 12, child: Image.asset("assets/no-thanks.png"),),
                          ),
                          label: const Text(
                            " No, Thanks",
                            style: CustomTextStyle.bodytextbold,
                          ),
                        ),*/
                      ],
                    ),
                  )
                ],
              ),
            ),
            // Close icon at the top right corner, half outside the dialog
            Positioned(
              top: -7,
              right: -7,
              child: GestureDetector(
                onTap: () {
                  Get.back();
                },
                child: Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        child: Image.asset(
                            height: 24, width: 24, "assets/close-popup.png"),
                      ),
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/*
Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(child: ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
        backgroundColor: Colors.white , side: const BorderSide(color: Colors.red )  ), 
      onPressed: (){
      Get.back();
    }, child:  const Text("Cancel" , style: CustomTextStyle.elevatedButtonSmallRed,))),
    const SizedBox(width: 10,),
                  Expanded(child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),

                    ),
                    onPressed: (){
                       dashboardcontroller.declinerequest(memberid: matchid).then((value) {
                            Get.back();
_notificationController.fetchNotifications();

                       },);
                    

                    }, child: Obx(() {
                      if(dashboardcontroller.declineLoading.value){
                        return CircularProgressIndicator(color: Colors.white,);
                      }else{
                        return const Text("Decline" , style: CustomTextStyle.elevatedButtonSmall,);
                      }
                    },)
                    
                    )
                    
                    ), 

                ],)
            )*/
