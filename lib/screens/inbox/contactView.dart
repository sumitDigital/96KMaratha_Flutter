import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:_96kuliapp/commons/textdecoration.dart';
import 'package:_96kuliapp/controllers/dashboardControllers/dashboardController.dart';
import 'package:_96kuliapp/controllers/viewProfileControllers/viewprofileController.dart';
import 'package:_96kuliapp/main.dart';
import 'package:_96kuliapp/routes/routenames.dart';
import 'package:_96kuliapp/routes/routenames.dart';
import 'package:_96kuliapp/screens/profile_screens/user_details.dart';
import 'package:_96kuliapp/utils/Apptheme.dart';
import 'package:_96kuliapp/utils/newmatches.dart';
import 'package:_96kuliapp/utils/userImageContainer.dart';
import 'package:_96kuliapp/utils/verificationTag.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ContactViewed extends StatefulWidget {
  const ContactViewed({super.key});

  @override
  State<ContactViewed> createState() => _ContactViewedState();
}

class _ContactViewedState extends State<ContactViewed> {
  final DashboardController _dashboardController =
      Get.find<DashboardController>();
  final controller = ScrollController();
  String? language = sharedPreferences?.getString("Language");

  @override
  void initState() {
    super.initState();

    // Fetch data initially when the page loads
    _dashboardController.fetchContactViewdList();

    // Add scroll listener for pagination
    controller.addListener(() {
      if (controller.position.maxScrollExtent == controller.offset) {
        // Fetch more data when the user scrolls to the bottom, but only if not already fetching
        _dashboardController.fetchContactViewdList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    //  _dashboardController.fetchIntrestReceivedList();
    // _dashboardController.fetchIntrestReceivedList();

    return Obx(
      () {
        if (_dashboardController.contactViewdList.isEmpty &&
            _dashboardController.contactViewdListfetching.value == false) {
          return RefreshIndicator(
            onRefresh: () {
              return Future(() async {
                _dashboardController.contactViewdpage.value = 1;
                _dashboardController.contactViewdhasMore.value = true;
                _dashboardController.contactViewdList.clear();
                _dashboardController.contactViewdListfetching.value = true;

                await _dashboardController.fetchContactViewdList();
              });
            },
            child: ListView(
              children: [
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.nodatafound,
                          style: CustomTextStyle.title,
                        ),
                        const SizedBox(height: 8),
                        const Icon(
                          Icons.arrow_downward,
                          size: 24,
                          color: Colors.grey,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          AppLocalizations.of(context)!.scrolldowntorefresh,
                          style: CustomTextStyle.title,
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          );
        } else {
          return RefreshIndicator(
            onRefresh: () {
              return Future(() async {
                _dashboardController.contactViewdpage.value = 1;
                _dashboardController.contactViewdhasMore.value = true;
                _dashboardController.contactViewdList.clear();
                _dashboardController.contactViewdListfetching.value = true;

                await _dashboardController.fetchContactViewdList();
              });
            },
            child: ListView.builder(
              controller: controller,
              shrinkWrap: true,
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: _dashboardController.contactViewdList.length + 1,
              itemBuilder: (context, index) {
                // Check if the index is less than the data length
                if (index < _dashboardController.contactViewdList.length) {
                  // Access the current match data
                  var matchData = _dashboardController.contactViewdList[index];

                  return Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 8),
                    child: GestureDetector(
                      onTap: () {
                        navigatorKey.currentState!.push(MaterialPageRoute(
                          builder: (context) => UserDetails(
                              notificationID: 0,
                              memberid: matchData["member_id"]),
                        ));
                      },
                      child: Padding(
                        padding:
                            const EdgeInsets.only(right: 4, bottom: 4, top: 4),
                        child: Stack(
                          children: [
                            Container(
                              height: 530,
                              width: double.infinity,
                              decoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.network(
                                  matchData["photoUrl"],
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            // Gradient overlay
                            Container(
                              height: 530,
                              width: double.infinity,
                              decoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                gradient: LinearGradient(
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                  colors: [
                                    Color(0xFF0C0B0B), // #0C0B0B at 100%
                                    Color(
                                        0x800C0B0B), // rgba(12, 11, 11, 0.5) at 45.36%
                                    Color(
                                        0x00FFFFFF), // rgba(255, 255, 255, 0) at 0%
                                  ],
                                  stops: [0.0, 0.45, 1.0],
                                ),
                              ),
                            ),
                            matchData["is_premium"] == "1"
                                ? const Positioned(
                                    top: 15,
                                    right: 0,
                                    child: PremiumTag(),
                                  )
                                : const SizedBox(),
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: SizedBox(
                                height: 530,
                                width: double.infinity,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Spacer(),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          matchData["member_name"] +
                                              " ", // Replace with dynamic name
                                          style: CustomTextStyle.imageText
                                              .copyWith(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w800,
                                            color: Colors.white,
                                          ),
                                        ),
                                        matchData["is_Document_Verification"] ==
                                                1
                                            ? const verificationTag()
                                            : const SizedBox()
                                      ],
                                    ),
                                    RichText(
                                        text: TextSpan(children: <TextSpan>[
                                      TextSpan(
                                          text: language == "en"
                                              ? "Member ID - "
                                              : "मेंबर आयडी - ",
                                          style: CustomTextStyle.imageText
                                              .copyWith(fontSize: 14)),
                                      TextSpan(
                                          text: matchData["member_profile_id"],
                                          style: CustomTextStyle.imageText
                                              .copyWith(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w800)),
                                    ])),
                                    const SizedBox(height: 10),
                                    RichText(
                                      text: TextSpan(
                                        children: <InlineSpan>[
                                          TextSpan(
                                            text:
                                                "${matchData["age"]} Yrs , ${matchData["height"]} ",
                                            style: CustomTextStyle.imageText,
                                          ),
                                          WidgetSpan(
                                            child: Padding(
                                              padding: const EdgeInsets
                                                  .symmetric(
                                                  horizontal: 4.0,
                                                  vertical:
                                                      4), // Adjust the padding as needed
                                              child: Container(
                                                width:
                                                    6.0, // Adjust size for the circle
                                                height: 6.0,
                                                decoration: BoxDecoration(
                                                  color: const Color.fromARGB(
                                                          255, 215, 215, 215)
                                                      .withOpacity(
                                                          0.5), // Set the color of the circle
                                                  shape: BoxShape.circle,
                                                ),
                                              ),
                                            ),
                                          ),
                                          TextSpan(
                                            text:
                                                "${matchData["marital_status"]} ",
                                            style: CustomTextStyle.imageText,
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 1,
                                    ),
                                    RichText(
                                      text: TextSpan(
                                        children: <InlineSpan>[
                                          TextSpan(
                                            text: "${matchData["subcaste"]}",
                                            style: CustomTextStyle.imageText,
                                          ),
                                          WidgetSpan(
                                            child: Padding(
                                              padding: const EdgeInsets
                                                  .symmetric(
                                                  horizontal: 4.0,
                                                  vertical:
                                                      4), // Adjust the padding as needed
                                              child: Container(
                                                width:
                                                    6.0, // Adjust size for the circle
                                                height: 6.0,
                                                decoration: BoxDecoration(
                                                  color: const Color.fromARGB(
                                                          255, 215, 215, 215)
                                                      .withOpacity(
                                                          0.4), // Set the color of the circle
                                                  shape: BoxShape.circle,
                                                ),
                                              ),
                                            ),
                                          ),
                                          TextSpan(
                                            text:
                                                " ${matchData["present_city_name"]}, ${matchData["present_state_name"]}",
                                            style: CustomTextStyle.imageText,
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 1,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 8.0, bottom: 8.0),
                                      child: Container(
                                        decoration: const BoxDecoration(
                                            color: Color.fromARGB(
                                                255, 91, 169, 131),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10))),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Center(
                                            child: Text(
                                                textAlign: TextAlign.center,
                                                language == "en"
                                                    ? "You View Contacts Number of this Profile."
                                                    : "तुम्ही या प्रोफाईलचा संपर्क बघितला आहे",
                                                style:
                                                    CustomTextStyle.imageText),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Divider(
                                      height: 2,
                                      color: const Color.fromARGB(
                                              255, 215, 226, 242)
                                          .withOpacity(.69),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        TextButton(
                                            onPressed: () {
                                              _dashboardController
                                                  .fetchContactDetails(
                                                      memberid: matchData[
                                                          "member_id"])
                                                  .then(
                                                (value) {
                                                  showDialog(
                                                    //   barrierDismissible: false,
                                                    context: context,
                                                    builder: (context) {
                                                      return const ContactViewDetailsPopupForContactList();
                                                    },
                                                  );
                                                },
                                              );
                                            },
                                            child: Row(
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: SizedBox(
                                                    height: 15,
                                                    width: 15,
                                                    child: Image.asset(
                                                        "assets/contactgreen.png"),
                                                  ),
                                                ),
                                                Text(
                                                  language == "en"
                                                      ? "View Contact"
                                                      : "संपर्क पहा",
                                                  style: CustomTextStyle
                                                      .imageText
                                                      .copyWith(
                                                          fontSize: 14,
                                                          fontFamily:
                                                              "WORKSANS",
                                                          fontWeight:
                                                              FontWeight.w700),
                                                )
                                              ],
                                            ))
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                } else {
                  // Show loader or 'End of List' when all items are loaded
                  if (_dashboardController.contactViewdList.isEmpty &&
                      _dashboardController.contactViewdListfetching.value) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: Container(
                          height: 530,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    );
                  } else {
                    return GetBuilder<DashboardController>(
                      id: 'no_more_data_for_contactviewd',
                      builder: (controller) {
                        return Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: Center(
                              child: _dashboardController
                                      .contactViewdhasMore.value
                                  ? Shimmer.fromColors(
                                      baseColor: Colors.grey[300]!,
                                      highlightColor: Colors.grey[100]!,
                                      child: Container(
                                        height: 530,
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      ),
                                    )
                                  : Text.rich(
                                      language == "en"
                                          ? TextSpan(
                                              children: [
                                                const TextSpan(
                                                    text: "  Seems Like ",
                                                    style:
                                                        CustomTextStyle.title),
                                                const TextSpan(
                                                    text:
                                                        "you reached the End! ",
                                                    style:
                                                        CustomTextStyle.title),
                                                WidgetSpan(
                                                  child: Icon(
                                                      Icons
                                                          .emoji_emotions_rounded,
                                                      color: AppTheme
                                                          .secondryColor,
                                                      size: 20),
                                                ),
                                              ],
                                            )
                                          : TextSpan(
                                              children: [
                                                const TextSpan(
                                                    text: "  तुम्ही पेजच्या ",
                                                    style:
                                                        CustomTextStyle.title),
                                                const TextSpan(
                                                    text: "शेवटी आला आहात! ",
                                                    style:
                                                        CustomTextStyle.title),
                                                WidgetSpan(
                                                  child: Icon(
                                                      Icons
                                                          .emoji_emotions_rounded,
                                                      color: AppTheme
                                                          .secondryColor,
                                                      size: 20),
                                                ),
                                              ],
                                            ),
                                    )),
                        );
                      },
                    );
                  }
                }
              },
            ),
          );
        }
      },
    );
  }
}

class ContactViewDetailsPopupForContactList extends StatelessWidget {
  const ContactViewDetailsPopupForContactList({super.key});

  @override
  Widget build(BuildContext context) {
    final DashboardController viewprofileController =
        Get.put(DashboardController());

    return Dialog(
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        child: Obx(() {
          if (viewprofileController.Contactdatafetching.value) {
            return const Center(child: CircularProgressIndicator());
          } else {
            final mybox = Hive.box('myBox');
            String gender = mybox.get("gender") == 2 ? "Bride" : "Groom";
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Stack(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(
                          height: 30,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: Text(
                                textAlign: TextAlign.center,
                                "All Contact Details",
                                style: CustomTextStyle.headlineMain2Primary),
                          ),
                        ),
                        Container(
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(8),
                              topRight: Radius.circular(8),
                            ),
                          ),
                          height: 150,
                          width: 329,
                          child: SizedBox(
                            height: 150,
                            width: 286,
                            child: Image.asset("assets/contactdetails.png"),
                          ),
                        ),
                      ],
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: IconButton(
                        icon: const Icon(Icons.close),
                        color: Colors.black,
                        onPressed: () {
                          Get.back(); // Close dialog

                          // viewprofileController.fetchUserInfo(memberid: memberID);
                        },
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                          child: Text(
                        textAlign: TextAlign.center,
                        "$gender Contact Number :-",
                        style: CustomTextStyle.bodytext,
                      )),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 2, vertical: 5),
                          decoration: BoxDecoration(
                            color: AppTheme.floatingActionBG,
                          ),
                          child: Center(
                            child: RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                style: CustomTextStyle
                                    .bodytext, // Base style for the text.
                                children: [
                                  TextSpan(
                                    text:
                                        "${viewprofileController.Contactdata["mobile_number"]} ",
                                  ),
                                  WidgetSpan(
                                    alignment: PlaceholderAlignment.middle,
                                    child: GestureDetector(
                                      onTap: () {
                                        Clipboard.setData(
                                          ClipboardData(
                                            text: viewprofileController
                                                .Contactdata["mobile_number"],
                                          ),
                                        ).then((value) {
                                          Get.snackbar(
                                            "Copied", // Title of the snackbar
                                            "Mobile number copied to clipboard", // Message
                                            snackPosition: SnackPosition
                                                .BOTTOM, // Position of the snackbar
                                            backgroundColor:
                                                Colors.black.withOpacity(0.7),
                                            colorText: Colors.white,
                                            margin: const EdgeInsets.all(10),
                                            duration:
                                                const Duration(seconds: 2),
                                          );
                                        });
                                        print("Copied");
                                      },
                                      child: Icon(
                                        Icons.copy,
                                        color: AppTheme.textColor,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Center(
                          child: Text(
                        textAlign: TextAlign.center,
                        "$gender Parent's Contact Number :-",
                        style: CustomTextStyle.bodytext,
                      )),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 2, vertical: 5),
                          decoration: BoxDecoration(
                            color: AppTheme.floatingActionBG,
                          ),
                          child: Center(
                            child: RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                style: CustomTextStyle
                                    .bodytext, // Base style for the text.
                                children: [
                                  TextSpan(
                                    text:
                                        "${viewprofileController.Contactdata["parents_contact_no"]} ",
                                  ),
                                  WidgetSpan(
                                    alignment: PlaceholderAlignment.middle,
                                    child: GestureDetector(
                                      onTap: () {
                                        Clipboard.setData(
                                          ClipboardData(
                                            text: viewprofileController
                                                    .Contactdata[
                                                "parents_contact_no"],
                                          ),
                                        ).then((value) {
                                          Get.snackbar(
                                            "Copied", // Title of the snackbar
                                            "Parent's Number copied to clipboard", // Message
                                            snackPosition: SnackPosition
                                                .BOTTOM, // Position of the snackbar
                                            backgroundColor:
                                                Colors.black.withOpacity(0.7),
                                            colorText: Colors.white,
                                            margin: const EdgeInsets.all(10),
                                            duration:
                                                const Duration(seconds: 2),
                                          );
                                        });
                                        print("Copied");
                                      },
                                      child: Icon(
                                        Icons.copy,
                                        color: AppTheme.textColor,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Center(
                          child: Text(
                        textAlign: TextAlign.center,
                        "$gender Email ID :-",
                        style: CustomTextStyle.bodytext,
                      )),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 2, vertical: 5),
                          decoration: BoxDecoration(
                            color: AppTheme.floatingActionBG,
                          ),
                          child: Center(
                            child: RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                style: CustomTextStyle
                                    .bodytext, // Base style for the text.
                                children: [
                                  TextSpan(
                                    text:
                                        "${viewprofileController.Contactdata["email_address"]} ",
                                  ),
                                  WidgetSpan(
                                    alignment: PlaceholderAlignment.middle,
                                    child: GestureDetector(
                                      onTap: () {
                                        Clipboard.setData(
                                          ClipboardData(
                                            text: viewprofileController
                                                .Contactdata["email_address"],
                                          ),
                                        ).then((value) {
                                          Get.snackbar(
                                            "Copied", // Title of the snackbar
                                            "Email ID copied to clipboard", // Message
                                            snackPosition: SnackPosition
                                                .BOTTOM, // Position of the snackbar
                                            backgroundColor:
                                                Colors.black.withOpacity(0.7),
                                            colorText: Colors.white,
                                            margin: const EdgeInsets.all(10),
                                            duration:
                                                const Duration(seconds: 2),
                                          );
                                        });
                                        print("Copied");
                                      },
                                      child: Icon(
                                        Icons.copy,
                                        color: AppTheme.textColor,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ],
            );
          }
        }),
      ),
    );
  }
}
