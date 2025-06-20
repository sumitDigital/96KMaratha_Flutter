// ignore_for_file: unnecessary_import, deprecated_member_use

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:_96kuliapp/commons/appconstants.dart';
import 'package:_96kuliapp/commons/textdecoration.dart';
import 'package:_96kuliapp/controllers/planControllers/myplanController.dart';
import 'package:_96kuliapp/main.dart';
import 'package:_96kuliapp/routes/routenames.dart';
import 'package:_96kuliapp/screens/plans/inVoiceScreen.dart';
import 'package:_96kuliapp/utils/Apptheme.dart';
import 'package:_96kuliapp/utils/backHeader.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shimmer/shimmer.dart';

class MyPlan extends StatefulWidget {
  const MyPlan({super.key});

  @override
  State<MyPlan> createState() => _MyPlanState();
}

class _MyPlanState extends State<MyPlan> {
  final MyPlanController _myPlanController = Get.put(MyPlanController());
  String? language = sharedPreferences?.getString("Language");

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _myPlanController.fetchPlans();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.delete<MyPlanController>();
        Get.back();
        return false;
      },
      child: Scaffold(
        body: SingleChildScrollView(child: SafeArea(child: Obx(
          () {
            if (_myPlanController.isLoading.value) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Container(
                        width: MediaQuery.of(context).size.width *
                            0.7, // Set your desired width
                        height: 300, // Set your desired height
                        decoration: BoxDecoration(
                          color:
                              Colors.white, // Background color of the container
                          borderRadius:
                              BorderRadius.circular(10), // Rounded corners
                        ),
                      ),
                    ),
                  ),
                ],
              );
            } else {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BackHeader(
                    title: language == "en" ? "My Plan" : "माझा प्लॅन ",
                    onTap: () {
                      Get.delete<MyPlanController>();
                      Get.back();
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.currentActivePlan,
                          style: CustomTextStyle.bodytext.copyWith(
                              fontFamily: "WORKSANS",
                              fontWeight: FontWeight.w600,
                              fontSize: 22),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: Card(
                            shadowColor: Colors.grey,
                            color: Colors.white,
                            elevation: 4,
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ListView.builder(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount:
                                        _myPlanController.combinedList.length,
                                    itemBuilder: (context, index) {
                                      final plan =
                                          _myPlanController.combinedList[index];
                                      final name =
                                          plan['plan_name']?.isNotEmpty == true
                                              ? plan['plan_name']
                                              : plan['addon_name'] ??
                                                  "Unnamed Plan";

                                      return Text(
                                          index <
                                                  _myPlanController
                                                          .combinedList.length -
                                                      1
                                              ? "$name +"
                                              : name, // Append "+" only for non-last items
                                          style: CustomTextStyle.bodytextbold
                                              .copyWith(
                                                  height: 1.5, fontSize: 22));
                                    },
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    "( ${language == "en" ? "Duration" : "कालावधी"}  : ${_myPlanController.combinedList[0]["plan_duration"]} days )",
                                    style: CustomTextStyle.bodytext,
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  const Divider(
                                    indent: 10,
                                    endIndent: 10,
                                    color: Color.fromRGBO(17, 95, 15, 1),
                                  ),

                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    "${AppLocalizations.of(context)!.planStartDate} : ${DateFormat('dd-MM-yyyy').format(DateTime.parse(_myPlanController.combinedList[0]['plan_start_date']))}",
                                    style: CustomTextStyle.bodytext,
                                  ),
                                  Text(
                                    "${AppLocalizations.of(context)!.planEndDate} : ${DateFormat('dd-MM-yyyy').format(DateTime.parse(_myPlanController.combinedList[0]['plan_end_date']))}",
                                    style: CustomTextStyle.bodytext,
                                  ),
                                  Text(
                                    maxLines: 2,
                                    "${AppLocalizations.of(context)!.weekStartFrom}: ${DateFormat('EEEE').format(DateTime.parse(_myPlanController.combinedList[0]['plan_start_date']))} - ${DateFormat('EEEE').format(DateTime.parse(_myPlanController.combinedList[0]['plan_end_date']).subtract(const Duration(days: 1)))}",
                                    style: CustomTextStyle.bodytext,
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Container(
                                    // rgba(38, 193, 35, 0.14)
                                    decoration: const BoxDecoration(
                                        color:
                                            Color.fromRGBO(38, 193, 35, 0.14),
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(5),
                                        )),
                                    child: Padding(
                                      padding: const EdgeInsets.all(18.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                AppLocalizations.of(context)!
                                                    .totalContact,
                                                style: CustomTextStyle.bodytext,
                                              ),
                                              Text(
                                                "${_myPlanController.toTalRemainingContact["Total_contact"]}",
                                                style: CustomTextStyle
                                                    .bodytextbold,
                                              )
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 15,
                                          ),
                                          const Divider(
                                            color:
                                                Color.fromRGBO(17, 95, 15, 1),
                                          ),
                                          const SizedBox(
                                            height: 15,
                                          ),
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "${AppLocalizations.of(context)!.weeklyContactLimit} ",
                                                style: CustomTextStyle.bodytext,
                                              ),
                                              Text(
                                                "${_myPlanController.toTalRemainingContact["weekly_contact_limit"]}",
                                                style: CustomTextStyle
                                                    .bodytextbold,
                                              )
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 15,
                                          ),
                                          const Divider(
                                            color:
                                                Color.fromRGBO(17, 95, 15, 1),
                                          ),
                                          const SizedBox(
                                            height: 15,
                                          ),
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "${AppLocalizations.of(context)!.weeklyContactViewd} ",
                                                style: CustomTextStyle.bodytext,
                                              ),
                                              Text(
                                                "${_myPlanController.toTalRemainingContact["weekly_Contact_View"]}",
                                                style: CustomTextStyle
                                                    .bodytextbold,
                                              )
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 15,
                                          ),
                                          const Divider(
                                            color:
                                                Color.fromRGBO(17, 95, 15, 1),
                                          ),
                                          const SizedBox(
                                            height: 15,
                                          ),
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                AppLocalizations.of(context)!
                                                    .remainingWeeklyContact,
                                                style: CustomTextStyle.bodytext,
                                              ),
                                              Text(
                                                "${_myPlanController.toTalRemainingContact["weekly_remain_contact"]}",
                                                style: CustomTextStyle
                                                    .bodytextbold,
                                              )
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 15,
                                          ),
                                          /*  Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                           Text("Remaining Weekly Contact" , style: CustomTextStyle.bodytext,) , 
                           Text("50" , style: CustomTextStyle.bodytextbold,)
                 ],), */
                                        ],
                                      ),
                                    ),
                                  ),

                                  const SizedBox(
                                    height: 20,
                                  ),
                                  // rgba(80, 93, 126, 1)
                                  Text(
                                    language == "en"
                                        ? "Download Invoice"
                                        : "बिल डाऊनलोड करा",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                        color: Color.fromRGBO(80, 93, 126, 1)),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  const Divider(
                                    color: Color.fromRGBO(17, 95, 15, 1),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),

                                  ListView.builder(
                                    itemCount:
                                        _myPlanController.combinedList.length,
                                    shrinkWrap: true,
                                    itemBuilder: (context, index) {
                                      final plan =
                                          _myPlanController.combinedList[index];
                                      final name =
                                          plan['plan_name']?.isNotEmpty == true
                                              ? plan['plan_name']
                                              : plan['addon_name'] ??
                                                  "Unnamed Plan";

                                      return GestureDetector(
                                        onTap: () {
                                          if (plan["plan_name"] != null) {
                                            if (plan["plan_name"] ==
                                                "TrueMatch") {
                                            } else {
                                              openFile(
                                                url:
                                                    "${Appconstants.baseURL}/api/plan-invoice/${plan["purchase_id"]}",
                                                fileName: '$name.pdf',
                                              );
                                            }
                                          } else {
                                            print(
                                                "INSIDE Non NULL ${plan["purchase_id"]}");
                                            // For non-null case
                                            openFile(
                                              url:
                                                  "${Appconstants.baseURL}/api/addon-plan-invoice/${plan["purchase_id"]}",
                                              fileName: '$name.pdf',
                                            );
                                          }
                                        },
                                        child: Container(
                                          height: 35,
                                          width: double.infinity,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal:
                                                  10), // Optional, to give some space around
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                // This ensures the remaining space is clickable
                                                child: Text(
                                                  "$name",
                                                  style: const TextStyle(
                                                    fontFamily: "WORKSANS",
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 16,
                                                    height: 1,
                                                    color: Color.fromRGBO(
                                                        80, 93, 126, 1),
                                                  ),
                                                  overflow: TextOverflow
                                                      .ellipsis, // Handles long text gracefully
                                                ),
                                              ),
                                              if (name != "TrueMatch")
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    SizedBox(
                                                      height: 16,
                                                      width: 16,
                                                      child: Image.asset(
                                                          "assets/downloadInvoice.png"),
                                                    ),
                                                    const SizedBox(width: 5),
                                                    Text(
                                                      language == "en"
                                                          ? "INVOICE"
                                                          : "बिल",
                                                      style: const TextStyle(
                                                        fontSize: 11,
                                                        color: Color.fromRGBO(
                                                            234, 52, 74, 1),
                                                      ),
                                                    ),
                                                    const SizedBox(width: 10),
                                                  ],
                                                )
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  )
                                ],
                              ),
                            ),
                          ),
                        )

                        /*    const SizedBox(height: 20,), 
            Text("Previous Plan" , style: CustomTextStyle.bodytext.copyWith(fontSize: 22 , fontFamily: "WORKSANSBOLD"),), 
            const SizedBox(height: 20,), 
            Card(
              color: const Color.fromARGB(255, 245, 248, 252),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                  Text("Diamond Plus" ,style: CustomTextStyle.bodytextbold.copyWith(fontSize: 22),), 
                  const Text("( Duration : 6 months )" ,style: CustomTextStyle.bodytext,), 
                  const SizedBox(height: 10,), 
                  Divider(color: AppTheme.dividerDarkColor,), 
                     const SizedBox(height: 10,), 
                const Text("Plan Start Date : 25th June 2024" , style: CustomTextStyle.bodytext,), 
                const Text("Plan End Date : 25th June 2024" , style: CustomTextStyle.bodytext,), 
          
          
                const SizedBox(height: 10,), 
                Text("₹ 1,135" , style: CustomTextStyle.bodytext.copyWith(fontFamily: "WORKSANSBOLD" , fontSize: 40),), 
          const SizedBox(height: 10,), 
          SizedBox(
                  width: 208,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10)))),
                    onPressed: (){},
                   child: const Text("View Plan" , style: CustomTextStyle.elevatedButton,)),
                ),
                ],),
              ),
            ), 
            const SizedBox(height: 10,), 
             Card(
              color: const Color.fromARGB(255, 245, 248, 252),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                  Text("Diamond Plus" ,style: CustomTextStyle.bodytextbold.copyWith(fontSize: 22),), 
                  const Text("( Duration : 6 months )" ,style: CustomTextStyle.bodytext,), 
                  const SizedBox(height: 10,), 
                  Divider(color: AppTheme.dividerDarkColor,), 
                     const SizedBox(height: 10,), 
                const Text("Plan Start Date : 25th June 2024" , style: CustomTextStyle.bodytext,), 
                const Text("Plan End Date : 25th June 2024" , style: CustomTextStyle.bodytext,), 
          
          
                const SizedBox(height: 10,), 
                Text("₹ 1,135" , style: CustomTextStyle.bodytext.copyWith(fontFamily: "WORKSANSBOLD" , fontSize: 40),), 
          const SizedBox(height: 10,), 
          SizedBox(
                  width: 208,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10)))),
                    onPressed: (){},
                   child: const Text("View Plan" , style: CustomTextStyle.elevatedButton,)),
                ),
                ],),
              ),
            ), */
                        ,
                        const SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  )
                ],
              );
            }
          },
        ))),
      ),
    );
  }
}

void openFile({
  required String url,
  required String fileName,
}) async {
  final file = await downloadFile(url, fileName);
  if (file == null) {
    print("Failed to download file.");
    return;
  }
  print("File downloaded at: ${file.path}");
  OpenFile.open(file.path);
}

Future<File?> downloadFile(String url, String name) async {
  try {
    final appStorage = await getApplicationDocumentsDirectory();
    final file = File('${appStorage.path}/$name');

    // Ensure file does not already exist
    if (await file.exists()) {
      await file.delete();
    }

    String? token = sharedPreferences!.getString("token");

    // Show the loading dialog
    Get.dialog(
      WillPopScope(
        onWillPop: () async => false, // Prevent back button dismissal
        child: const Center(
          child: SizedBox(
            width:
                50, // Adjust the width (diameter) of the CircularProgressIndicator
            height:
                50, // Adjust the height (diameter) of the CircularProgressIndicator
            child: CircularProgressIndicator(
              color: Colors.white,
              strokeWidth:
                  12.0, // Adjust the thickness of the circular indicator
            ),
          ),
        ),
      ),
      barrierDismissible: false, // Prevent tapping outside to dismiss
    );

    final response = await Dio().get(
      url,
      options: Options(
        responseType: ResponseType.bytes,
        followRedirects: false,
        headers: {
          'Authorization': 'Bearer $token', // Include the token in the headers
          'Accept': 'application/pdf', // Explicitly accept PDF files
        },
        receiveTimeout: const Duration(seconds: 10),
      ),
    );

    // Dismiss the loading dialog
    Get.back();

    // Write binary data to the file
    final raf = file.openSync(mode: FileMode.write);
    raf.writeFromSync(response.data);
    await raf.close();
    print('Response Size: ${response.data.length} bytes');
    return file;
  } catch (e) {
    // Dismiss the loading dialog in case of an error
    Get.back();
    print("Error downloading file: $e");
    return null;
  }
}
