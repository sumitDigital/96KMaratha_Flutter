// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_picker/image_picker.dart';
import 'package:_96kuliapp/commons/editformcontainer.dart';
import 'package:_96kuliapp/commons/textdecoration.dart';
import 'package:_96kuliapp/controllers/editforms_controllers/editPartnerExpectationController.dart';
import 'package:_96kuliapp/controllers/editforms_controllers/editProfilePhotoController.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:_96kuliapp/controllers/viewProfileControllers/myprofileController.dart';
import 'package:_96kuliapp/main.dart';
import 'package:_96kuliapp/routes/routenames.dart';
import 'package:_96kuliapp/screens/editProfile_screens/editAstroDetails.dart';
import 'package:_96kuliapp/screens/editProfile_screens/editBasicInfo.dart';
import 'package:_96kuliapp/screens/editProfile_screens/editEducationForm.dart';
import 'package:_96kuliapp/screens/editProfile_screens/editFamilyDetails.dart';
import 'package:_96kuliapp/screens/editProfile_screens/editGalleryPhotos.dart';
import 'package:_96kuliapp/screens/editProfile_screens/editLifestyleDetails.dart';
import 'package:_96kuliapp/screens/editProfile_screens/editLocationForm.dart';
import 'package:_96kuliapp/screens/editProfile_screens/editPartnerPrefrance.dart';
import 'package:_96kuliapp/screens/editProfile_screens/editPersonalInfo.dart';
import 'package:_96kuliapp/screens/editProfile_screens/editSpiritualDetails.dart';
import 'package:_96kuliapp/screens/editProfile_screens/edit_about_me.dart';
import 'package:_96kuliapp/utils/Apptheme.dart';
import 'package:_96kuliapp/utils/bottomnavBar.dart';
import 'package:_96kuliapp/utils/buttonContainer.dart';
import 'package:_96kuliapp/utils/detailcontainer.dart';
import 'package:shimmer/shimmer.dart';
import 'package:readmore/readmore.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final MyProfileController _profileController = Get.put(MyProfileController());
  final Editprofilephotocontroller _editprofilephotocontroller =
      Get.put(Editprofilephotocontroller());

  String? language = sharedPreferences?.getString("Language");

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _profileController.fetchUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    final List astrodetails = [
      "Born in Noida On **/**/**** At Exactly 3:05 Am",
      "Non-Manglik",
      "Dev gan",
      "Meen rashi",
      "Kashyapi Gotra",
    ];
    return Obx(
      () {
        if (_editprofilephotocontroller.isLoading.value) {
          return Scaffold(
            body: SafeArea(
                child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      language == "en"
                          ? "Uploading Profile Photo"
                          : "प्रोफाईल फोटो बदला ",
                      style: CustomTextStyle.bodyboldHeading,
                    ),
                  ),
                  const CircularProgressIndicator()
                ],
              ),
            )),
          );
        } else {
          if (_profileController.loadingPage.value) {
            return WillPopScope(
              onWillPop: () async {
                if (navigatorKey.currentState!.canPop()) {
                  Get.back();
                } else {
                  navigatorKey.currentState!.pushReplacement(MaterialPageRoute(
                    builder: (context) => const BottomNavBar(),
                  ));
                }

                return false; // Prevent default back navigation
              },
              child: Scaffold(
                body: SafeArea(
                  child: Center(
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
                ),
              ),
            );
          } else {
            return WillPopScope(
              onWillPop: () async {
                if (navigatorKey.currentState!.canPop()) {
                  Get.delete<
                      Editprofilephotocontroller>(); // Deletes the controller to free up resources

                  Get.delete<
                      MyProfileController>(); // Deletes the controller to free up resources
                  Get.back(); // Navigates back to the previous screen
                } else {
                  Get.delete<
                      Editprofilephotocontroller>(); // Deletes the controller to free up resources

                  Get.delete<
                      MyProfileController>(); // Deletes the controller to free up resources

                  navigatorKey.currentState!.pushReplacement(MaterialPageRoute(
                    builder: (context) => const BottomNavBar(),
                  ));
                }
                // Execute actions before the back button is pressed

                return false; // Allows the navigation to happen
              },
              child: Scaffold(
                body: SingleChildScrollView(
                  child: SafeArea(
                      child: Column(
                    children: [
                      Container(
                        height: 60,
                        color: const Color.fromARGB(255, 222, 222, 226)
                            .withOpacity(0.25),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      if (navigatorKey.currentState!.canPop()) {
                                        Get.back();
                                      } else {
                                        navigatorKey.currentState!
                                            .pushReplacement(MaterialPageRoute(
                                          builder: (context) =>
                                              const BottomNavBar(),
                                        ));
                                      }
                                    },
                                    child: SizedBox(
                                      width: 25,
                                      height: 40,
                                      child: SvgPicture.asset(
                                        "assets/arrowback.svg",
                                        fit: BoxFit.fitWidth,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text(AppLocalizations.of(context)!.myProfile,
                                      style: CustomTextStyle.bodytextLarge),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(18.0),
                            child: Column(
                              children: [
                                const SizedBox(
                                  height: 70,
                                ),
                                Container(
                                  decoration: const BoxDecoration(
                                      // rgba(247, 247, 248, 1)
                                      color: Color.fromRGBO(247, 247, 248, 1),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20))),
                                  height: 320,
                                  width: double.infinity,
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(18.0),
                            child: Column(
                              children: [
                                const SizedBox(
                                  height: 10,
                                ),
                                Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Container(
                                      height: 230,
                                      width: 230,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        image: DecorationImage(
                                          image: NetworkImage(
                                            // Correctly use the fallback inside the NetworkImage
                                            _profileController
                                                .userdetail["profilePhotoUrl"],
                                          ),
                                          fit: BoxFit
                                              .cover, // Ensures the image covers the circle
                                          alignment: Alignment
                                              .topCenter, // Aligns the image to the top
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      right: 0,
                                      left: 0,
                                      bottom: 0,
                                      child: GestureDetector(
                                        onTap: () {
                                          // Add your edit action here
                                          navigatorKey.currentState!
                                              .push(MaterialPageRoute(
                                            builder: (context) =>
                                                EditGalleryPhotosScreen(
                                              key: UniqueKey(),
                                            ),
                                          ));
                                        },
                                        /*               Get.offNamed(AppRouteNames.userDetails , arguments: {
              "memberID": notification["notification_by"],
              "notificationID": notification["notification_id"],
                }, );*/
                                        child: CircleAvatar(
                                            backgroundColor: Colors.white,
                                            radius: 20,
                                            child: Image.asset(
                                                "assets/changeProfile.png")),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                RichText(
                                    text: TextSpan(children: <TextSpan>[
                                  TextSpan(
                                      text:
                                          "${AppLocalizations.of(context)!.memberid}- ",
                                      style: CustomTextStyle.editProfileHeader
                                          .copyWith(fontSize: 18)),
                                  TextSpan(
                                      text:
                                          "${_profileController.userdetail["profile"]["member_profile_id"]}",
                                      style: CustomTextStyle.editProfileHeader
                                          .copyWith(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w800,
                                      )),
                                ])),
                                Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: SizedBox(
                                    height: 10,
                                    child: LinearProgressIndicator(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(10)),
                                      value: (_profileController
                                                  .userdetail["ProfileState"]
                                                      ["percentages"]
                                                  ?.toDouble() ??
                                              50) /
                                          100, // Ensures it's a double
                                      backgroundColor: Colors.grey.shade300,
                                      color: Colors.green,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  "${AppLocalizations.of(context)!.yourProfileScore} ${_profileController.userdetail["ProfileState"]["percentages"]}% ${language == "en" ? "Update Info" : "उर्वरित माहिती भरा"} !!",
                                  style: CustomTextStyle.dashboardsubtitle,
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Divider(
                                  endIndent: 15,
                                  indent: 15,
                                  height: 2,
                                  color:
                                      const Color.fromARGB(255, 215, 226, 242)
                                          .withOpacity(.69),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  "${AppLocalizations.of(context)!.accountType} -  ${AppLocalizations.of(context)!.premiumMeber}",
                                  style: CustomTextStyle.dashboardsubtitle,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: double.infinity,
                              child: Card(
                                color: Colors.white,
                                elevation: 3,
                                shape: const RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20))),
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            AppLocalizations.of(context)!
                                                .aboutMe,
                                            style: CustomTextStyle.bodytextbold
                                                .copyWith(
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.w800),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              navigatorKey.currentState!
                                                  .push(MaterialPageRoute(
                                                builder: (context) =>
                                                    const EditAboutMeScreen(),
                                              ));
                                            },
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  Text(
                                                    AppLocalizations.of(
                                                            context)!
                                                        .edit,
                                                    style: CustomTextStyle
                                                        .textbuttonRed
                                                        .copyWith(
                                                            fontWeight:
                                                                FontWeight
                                                                    .w300),
                                                  ),
                                                  const SizedBox(
                                                    width: 4,
                                                  ),
                                                  SizedBox(
                                                      height: 10,
                                                      width: 13,
                                                      child: Image.asset(
                                                        "assets/editprofilered.png",
                                                      ))
                                                ],
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                      Divider(
                                        color: const Color.fromARGB(
                                                255, 80, 93, 128)
                                            .withOpacity(0.5),
                                      ),
                                      //   Text("Hello, I’m glad you're interested in knowing more about me. I have completed my [Education] and am currently [Occupation or focusing on personal growth]. I believe in living a life rooted in respect, values, and personal development. I am looking for a well-educated, professionally settled partner who shares similar values and is looking for a meaningful connection." , style: CustomTextStyle.bodytext.copyWith(fontSize: 13),)
                                      Text(
                                        "${_profileController.userdetail["profile"]["about_me"]}",
                                        style: CustomTextStyle.bodytext,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            editformcontainer(
                                ontap: () {
                                  navigatorKey.currentState!
                                      .push(MaterialPageRoute(
                                    builder: (context) =>
                                        EditPersonalInfoScreen(
                                      key: UniqueKey(),
                                    ),
                                  ));
                                },
                                assetimage: "assets/icons/About_user.png",
                                title:
                                    AppLocalizations.of(context)!.personalInfo,
                                widget: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Flexible(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              displayFormat(
                                                  title: AppLocalizations.of(
                                                          context)!
                                                      .height,
                                                  subtitle: _profileController
                                                          .userdetail["profile"]
                                                      ["height"]),
                                              displayFormat(
                                                  title: AppLocalizations.of(
                                                          context)!
                                                      .maritalstatus,
                                                  subtitle: _profileController
                                                          .userdetail["profile"]
                                                      [
                                                      "personal_marital_status"]),
                                              displayFormat(
                                                  title: AppLocalizations.of(
                                                          context)!
                                                      .weight,
                                                  subtitle: _profileController
                                                          .userdetail["profile"]
                                                      ["weight"]),
                                              displayFormat(
                                                  title: AppLocalizations.of(
                                                          context)!
                                                      .complexion,
                                                  subtitle: _profileController
                                                          .userdetail["profile"]
                                                      ["complexion"]),
                                            ],
                                          ),
                                        ),
                                        Flexible(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              displayFormat(
                                                  title: AppLocalizations.of(
                                                          context)!
                                                      .bloodgroup,
                                                  subtitle: _profileController
                                                          .userdetail["profile"]
                                                      ["blood_group"]),
                                              displayFormat(
                                                  title: AppLocalizations.of(
                                                          context)!
                                                      .disability,
                                                  subtitle: _profileController
                                                          .userdetail["profile"]
                                                      ["disability"]),
                                              displayFormat(
                                                  title: AppLocalizations.of(
                                                          context)!
                                                      .lens,
                                                  subtitle: _profileController
                                                          .userdetail["profile"]
                                                      ["lens"]),
                                              displayFormat(
                                                  title: AppLocalizations.of(
                                                          context)!
                                                      .spectacles,
                                                  subtitle: _profileController
                                                          .userdetail["profile"]
                                                      ["spectacles"]),

                                              // displayFormat(title: "Number of Married Sisters" , subtitle: _profileController.userdetail["profile"]["no_of_married_sisters"]),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Obx(() {
                                      // Access the ProfileState data stored in the observable
                                      final profileState = _profileController
                                          .userdetail["ProfileState"];

                                      // Check if incompletetable contains a table with the name "Family"
                                      final hasFamilyTable =
                                          profileState["incompletetable"].any(
                                              (table) =>
                                                  table["table"] ==
                                                  "PersonalInfo");

                                      return hasFamilyTable
                                          ? EditReminderContainer(
                                              name:
                                                  AppLocalizations.of(context)!
                                                      .personalInfo,
                                              ontap: () {
                                                navigatorKey.currentState!
                                                    .push(MaterialPageRoute(
                                                  builder: (context) =>
                                                      EditPersonalInfoScreen(
                                                    key: UniqueKey(),
                                                  ),
                                                ));
                                              },
                                            )
                                          : const SizedBox
                                              .shrink(); // SizedBox to take up no space if "Family" table is not present
                                    }),
                                  ],
                                )),
                            const SizedBox(
                              height: 10,
                            ),
                            editformcontainer(
                                ontap: () {
                                  navigatorKey.currentState!
                                      .push(MaterialPageRoute(
                                    builder: (context) => EditEducationForm(
                                      key: UniqueKey(),
                                    ),
                                  ));
                                },
                                assetimage: "assets/icons/Education.png",
                                title: AppLocalizations.of(context)!
                                    .educationAndCarrer,
                                widget: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Flexible(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              displayFormat(
                                                  title: AppLocalizations.of(
                                                          context)!
                                                      .highestEducation,
                                                  subtitle: _profileController
                                                          .userdetail["profile"]
                                                      ["highest_education_id"]),
                                              displayFormat(
                                                  title: AppLocalizations.of(
                                                          context)!
                                                      .employedIn,
                                                  subtitle: _profileController
                                                          .userdetail["profile"]
                                                      ["employeed"]),
                                              displayFormat(
                                                  title: AppLocalizations.of(
                                                          context)!
                                                      .occupation,
                                                  subtitle: _profileController
                                                          .userdetail["profile"]
                                                      ["edu_occupation"]),
                                              displayFormat(
                                                  title: AppLocalizations.of(
                                                          context)!
                                                      .companyName,
                                                  subtitle: _profileController
                                                          .userdetail["profile"]
                                                      ["company_name"]),
                                            ],
                                          ),
                                        ),
                                        Flexible(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              displayFormat(
                                                  title: AppLocalizations.of(
                                                          context)!
                                                      .designation,
                                                  subtitle: _profileController
                                                          .userdetail["profile"]
                                                      ["designation"]),
                                              displayFormat(
                                                  title: AppLocalizations.of(
                                                          context)!
                                                      .annualIncome,
                                                  subtitle: _profileController
                                                          .userdetail["profile"]
                                                      ["edu_annual_income"]),
                                              displayFormat(
                                                  title: AppLocalizations.of(
                                                          context)!
                                                      .currentJobLocation,
                                                  subtitle: _profileController
                                                          .userdetail["profile"]
                                                      ["job_location"]),
                                              displayFormat(
                                                  title: AppLocalizations.of(
                                                          context)!
                                                      .workMode,
                                                  subtitle: _profileController
                                                          .userdetail["profile"]
                                                      ["work_mode"]),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ],
                                )),
                            const SizedBox(
                              height: 10,
                            ),
                            editformcontainer(
                                ontap: () {
                                  navigatorKey.currentState!
                                      .push(MaterialPageRoute(
                                    builder: (context) => EditBasicInfoScreen(
                                      key: UniqueKey(),
                                    ),
                                  ));
                                },
                                assetimage: "assets/icons/About_user.png",
                                title: AppLocalizations.of(context)!
                                    .basicInformation,
                                widget: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    displayFormat(
                                        title: AppLocalizations.of(context)!
                                            .fullName,
                                        subtitle:
                                            "${_profileController.userdetail["profile"]["first_name"]} ${_profileController.userdetail["profile"]["middle_name"]} ${_profileController.userdetail["profile"]["last_name"]}"),
                                    displayFormat(
                                        title: AppLocalizations.of(context)!
                                            .mobileNumber,
                                        subtitle: _profileController
                                                .userdetail["profile"]
                                            ["mobile_number"]),
                                    displayFormat(
                                        title: AppLocalizations.of(context)!
                                            .emailID,
                                        subtitle: _profileController
                                                .userdetail["profile"]
                                            ["email_address"]),
                                    displayFormat(
                                        title: AppLocalizations.of(context)!
                                            .dateOfBirth,
                                        subtitle: _profileController
                                                .userdetail["profile"]
                                            ["date_of_birth"]),
                                    displayFormat(
                                        title: AppLocalizations.of(context)!
                                            .gender,
                                        subtitle: _profileController
                                            .userdetail["profile"]["gender"]),
                                  ],
                                )),
                            const SizedBox(
                              height: 10,
                            ),
                            editformcontainer(
                                ontap: () {
                                  navigatorKey.currentState!
                                      .push(MaterialPageRoute(
                                    builder: (context) => EditLocationForm(
                                      key: UniqueKey(),
                                    ),
                                  ));
                                },
                                assetimage: "assets/icons/Location.png",
                                title: AppLocalizations.of(context)!
                                    .locationDetails,
                                widget: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Flexible(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              displayFormat(
                                                  title: AppLocalizations.of(
                                                          context)!
                                                      .presentCity,
                                                  subtitle: _profileController
                                                          .userdetail["profile"]
                                                      ["present_city"]),
                                              displayFormat(
                                                  title: AppLocalizations.of(
                                                          context)!
                                                      .presentState,
                                                  subtitle: _profileController
                                                          .userdetail["profile"]
                                                      ["present_state"]),
                                              displayFormat(
                                                  title: AppLocalizations.of(
                                                          context)!
                                                      .presentCountry,
                                                  subtitle: _profileController
                                                          .userdetail["profile"]
                                                      ["present_country"]),
                                              displayFormat(
                                                  title: AppLocalizations.of(
                                                          context)!
                                                      .nativePlace,
                                                  subtitle: _profileController
                                                          .userdetail["profile"]
                                                      ["native_place"]),
                                            ],
                                          ),
                                        ),
                                        Flexible(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              displayFormat(
                                                  title: AppLocalizations.of(
                                                          context)!
                                                      .permanentCity,
                                                  subtitle: _profileController
                                                          .userdetail["profile"]
                                                      ["permanent_city"]),
                                              displayFormat(
                                                  title: AppLocalizations.of(
                                                          context)!
                                                      .permanentState,
                                                  subtitle: _profileController
                                                          .userdetail["profile"]
                                                      ["permanent_state"]),
                                              displayFormat(
                                                  title: AppLocalizations.of(
                                                          context)!
                                                      .permanentCountry,
                                                  subtitle: _profileController
                                                          .userdetail["profile"]
                                                      ["permanent_country"]),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ],
                                )),
                            const SizedBox(
                              height: 10,
                            ),
                            editformcontainer(
                                ontap: () {
                                  navigatorKey.currentState!
                                      .push(MaterialPageRoute(
                                    builder: (context) =>
                                        EditFamilyDetailsScreen(
                                      key: UniqueKey(),
                                    ),
                                  ));
                                },
                                assetimage: "assets/icons/Family_details.png",
                                title:
                                    AppLocalizations.of(context)!.familyDetails,
                                widget: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Flexible(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              displayFormat(
                                                  title: AppLocalizations.of(
                                                          context)!
                                                      .fatherName,
                                                  subtitle: _profileController
                                                          .userdetail["profile"]
                                                      ["middle_name"]),
                                              displayFormat(
                                                  title: AppLocalizations.of(
                                                          context)!
                                                      .motherName,
                                                  subtitle: _profileController
                                                          .userdetail["profile"]
                                                      ["mother_name"]),
                                              displayFormat(
                                                  title: AppLocalizations.of(
                                                          context)!
                                                      .noOfbrothers,
                                                  subtitle: _profileController
                                                          .userdetail["profile"]
                                                      ["no_of_brothers"]),
                                              displayFormat(
                                                  title: AppLocalizations.of(
                                                          context)!
                                                      .noOfSisters,
                                                  subtitle: _profileController
                                                          .userdetail["profile"]
                                                      ["no_of_sisters"]),
                                              displayFormat(
                                                  title: AppLocalizations.of(
                                                          context)!
                                                      .familyType,
                                                  subtitle: _profileController
                                                          .userdetail["profile"]
                                                      ["family_type"]),
                                              displayFormat(
                                                  title: AppLocalizations.of(
                                                          context)!
                                                      .livingWithParents,
                                                  subtitle: _profileController
                                                          .userdetail["profile"]
                                                      ["living_with_parents"]),
                                            ],
                                          ),
                                        ),
                                        Flexible(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              displayFormat(
                                                  title: AppLocalizations.of(
                                                          context)!
                                                      .fatherOccupation,
                                                  subtitle: _profileController
                                                          .userdetail["profile"]
                                                      ["father_occupation"]),
                                              displayFormat(
                                                  title: AppLocalizations.of(
                                                          context)!
                                                      .motherOccupation,
                                                  subtitle: _profileController
                                                          .userdetail["profile"]
                                                      ["mother_occupation"]),
                                              displayFormat(
                                                  title: AppLocalizations.of(
                                                          context)!
                                                      .noOfMarriedBrothers,
                                                  subtitle: _profileController
                                                          .userdetail["profile"]
                                                      [
                                                      "no_of_married_brothers"]),
                                              displayFormat(
                                                  title: AppLocalizations.of(
                                                          context)!
                                                      .noOfMarriedSisters,
                                                  subtitle: _profileController
                                                          .userdetail["profile"]
                                                      [
                                                      "no_of_married_sisters"]),
                                              displayFormat(
                                                  title: AppLocalizations.of(
                                                          context)!
                                                      .familyAssets,
                                                  subtitle: _profileController
                                                          .userdetail["profile"]
                                                      ["family_assets"]),
                                              displayFormat(
                                                  title: AppLocalizations.of(
                                                          context)!
                                                      .familyStatus,
                                                  subtitle: _profileController
                                                          .userdetail["profile"]
                                                      ["family_status"]),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Obx(() {
                                      // Access the ProfileState data stored in the observable
                                      final profileState = _profileController
                                          .userdetail["ProfileState"];

                                      // Check if incompletetable contains a table with the name "Family"
                                      final hasFamilyTable =
                                          profileState["incompletetable"].any(
                                              (table) =>
                                                  table["table"] == "Family");

                                      return hasFamilyTable
                                          ? EditReminderContainer(
                                              name:
                                                  AppLocalizations.of(context)!
                                                      .familyDetails,
                                              ontap: () {
                                                navigatorKey.currentState!
                                                    .push(MaterialPageRoute(
                                                  builder: (context) =>
                                                      EditFamilyDetailsScreen(
                                                    key: UniqueKey(),
                                                  ),
                                                ));
                                              },
                                            )
                                          : const SizedBox
                                              .shrink(); // SizedBox to take up no space if "Family" table is not present
                                    }),
                                  ],
                                )),
                            const SizedBox(
                              height: 10,
                            ),
                            SizedBox(
                              width: double.infinity,
                              child: Card(
                                elevation: 2,
                                color: Color.alphaBlend(
                                    const Color.fromARGB(255, 37, 177, 144)
                                        .withOpacity(0.1),
                                    Colors.white),
                                shape: const RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                height: 14,
                                                width: 14,
                                                child: Image.asset(
                                                    "assets/icons/ContactDetails.png"),
                                              ),
                                              const SizedBox(
                                                width: 5,
                                              ),
                                              Text(
                                                AppLocalizations.of(context)!
                                                    .contactInfo,
                                                style: CustomTextStyle
                                                    .bodytextbold
                                                    .copyWith(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w700),
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                      Divider(
                                        color: const Color.fromARGB(
                                                255, 80, 93, 128)
                                            .withOpacity(0.5),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      /* RichText(
              text: TextSpan(
                children: <InlineSpan>[
             
          WidgetSpan(
            child: Container(
              width: 13.0, // Adjust size for the circle
              height: 13.0,
              child: Image.asset("assets/contacts.png"),
                        
            ),
          ),
          const TextSpan(
            text: " Self Mobile Number",
            style: CustomTextStyle.bodytext,
          ),
                ],
              ),
            ),*/
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(4.0),
                                            child: SizedBox(
                                              width:
                                                  13.0, // Adjust size for the circle
                                              height: 13.0,
                                              child: Image.asset(
                                                  "assets/contacts.png"),
                                            ),
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                AppLocalizations.of(context)!
                                                    .selfContactNumber,
                                                style: CustomTextStyle.bodytext,
                                              ),
                                              Text(
                                                "${_profileController.userdetail["profile"]["mobile_number"]}",
                                                style: CustomTextStyle
                                                    .bodytextbold,
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(4.0),
                                            child: SizedBox(
                                              width:
                                                  13.0, // Adjust size for the circle
                                              height: 13.0,
                                              child: Image.asset(
                                                  "assets/contacts.png"),
                                            ),
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                AppLocalizations.of(context)!
                                                    .parentsContactNumber,
                                                style: CustomTextStyle.bodytext,
                                              ),
                                              Text(
                                                "${_profileController.userdetail["profile"]["parents_contact_no"]}",
                                                style: CustomTextStyle
                                                    .bodytextbold,
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(4.0),
                                            child: SizedBox(
                                              width:
                                                  13.0, // Adjust size for the circle
                                              height: 13.0,
                                              child: Image.asset(
                                                  "assets/contacts.png"),
                                            ),
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                AppLocalizations.of(context)!
                                                    .selfEmailAddress,
                                                style: CustomTextStyle.bodytext,
                                              ),
                                              Text(
                                                "${_profileController.userdetail["profile"]["email_address"]}",
                                                style: CustomTextStyle
                                                    .bodytextbold,
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            editformcontainer(
                                ontap: () {
                                  navigatorKey.currentState!
                                      .push(MaterialPageRoute(
                                    builder: (context) =>
                                        const EditSpiritualDetailsScreen(),
                                  ));
                                },
                                assetimage: "assets/icons/Astro_details.png",
                                title: AppLocalizations.of(context)!
                                    .spiritualDetails,
                                widget: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Flexible(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              displayFormat(
                                                  title: AppLocalizations.of(
                                                          context)!
                                                      .ras,
                                                  subtitle: _profileController
                                                          .userdetail["profile"]
                                                      ["ras"]),
                                              displayFormat(
                                                  title: AppLocalizations.of(
                                                          context)!
                                                      .gotra,
                                                  subtitle: _profileController
                                                          .userdetail["profile"]
                                                      ["gotra"]),
                                              displayFormat(
                                                  title: AppLocalizations.of(
                                                          context)!
                                                      .nakshatra,
                                                  subtitle: _profileController
                                                          .userdetail["profile"]
                                                      ["nakshtra"]),
                                              displayFormat(
                                                  title: AppLocalizations.of(
                                                          context)!
                                                      .nadi,
                                                  subtitle: _profileController
                                                          .userdetail["profile"]
                                                      ["nadi"]),
                                            ],
                                          ),
                                        ),
                                        Flexible(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              displayFormat(
                                                  title: AppLocalizations.of(
                                                          context)!
                                                      .manglik,
                                                  subtitle: _profileController
                                                          .userdetail["profile"]
                                                      ["manglik"]),
                                              displayFormat(
                                                  title: AppLocalizations.of(
                                                          context)!
                                                      .gan,
                                                  subtitle: _profileController
                                                          .userdetail["profile"]
                                                      ["gan"]),
                                              displayFormat(
                                                  title: AppLocalizations.of(
                                                          context)!
                                                      .charan,
                                                  subtitle: _profileController
                                                          .userdetail["profile"]
                                                      ["charan"]),
                                              // displayFormat(title: "Number of Married Sisters" , subtitle: _profileController.userdetail["profile"]["no_of_married_sisters"]),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Obx(() {
                                      // Access the ProfileState data stored in the observable
                                      final profileState = _profileController
                                          .userdetail["ProfileState"];

                                      // Check if incompletetable contains a table with the name "Family"
                                      final hasFamilyTable =
                                          profileState["incompletetable"].any(
                                              (table) =>
                                                  table["table"] ==
                                                  "Spiritual");

                                      return hasFamilyTable
                                          ? EditReminderContainer(
                                              name:
                                                  AppLocalizations.of(context)!
                                                      .spiritualDetails,
                                              ontap: () {
                                                navigatorKey.currentState!
                                                    .push(MaterialPageRoute(
                                                  builder: (context) =>
                                                      EditSpiritualDetailsScreen(
                                                    key: UniqueKey(),
                                                  ),
                                                ));
                                              },
                                            )
                                          : const SizedBox
                                              .shrink(); // SizedBox to take up no space if "Family" table is not present
                                    }),
                                  ],
                                )),
                            const SizedBox(
                              height: 10,
                            ),
                            editformcontainer(
                                ontap: () {
                                  navigatorKey.currentState!
                                      .push(MaterialPageRoute(
                                    builder: (context) => AstroDetailsScreen(
                                      key: UniqueKey(),
                                    ),
                                  ));
                                },
                                assetimage: "assets/icons/Astro_details.png",
                                title:
                                    AppLocalizations.of(context)!.astroDetails,
                                widget: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Flexible(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              displayFormat(
                                                  title: AppLocalizations.of(
                                                          context)!
                                                      .bornOn,
                                                  subtitle: _profileController
                                                          .userdetail["profile"]
                                                      ["date_of_birth"]),
                                              displayFormat(
                                                  title: AppLocalizations.of(
                                                          context)!
                                                      .placeofBirth,
                                                  subtitle: _profileController
                                                          .userdetail["profile"]
                                                      ["birth_place"]),
                                            ],
                                          ),
                                        ),
                                        Flexible(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              displayFormat(
                                                  title: AppLocalizations.of(
                                                          context)!
                                                      .timeofBirth,
                                                  subtitle: _profileController
                                                          .userdetail["profile"]
                                                      ["time_of_birth"]),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ],
                                )),
                            const SizedBox(
                              height: 10,
                            ),
                            /*    editformcontainer(
                                ontap: () {
                                  navigatorKey.currentState!
                                      .push(MaterialPageRoute(
                                    builder: (context) => EditLifestyleDetails(
                                      key: UniqueKey(),
                                    ),
                                  ));
                                },
                                assetimage: "assets/icons/Lifestyle.png",
                                title: "LifeStyle Details",
                                widget: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "Dietry habits",
                                                    style: CustomTextStyle
                                                        .bodytextbold
                                                        .copyWith(
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w700),
                                                  )
                                                ],
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Wrap(
                                            spacing: 10,
                                            runSpacing: 10,
                                            children: [
                                              Container(
                                                height: 40,
                                                decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color: const Color
                                                            .fromARGB(255, 230,
                                                            232, 235)),
                                                    borderRadius:
                                                        const BorderRadius.all(
                                                            Radius.circular(
                                                                5))),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          bottom: 8.0,
                                                          top: 8.0,
                                                          left: 12,
                                                          right: 12),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      SizedBox(
                                                        child: Image.asset(
                                                            "assets/salad.png"),
                                                      )
                                                      //  networkImageWithFallback(assetimg , "assets/drink.png" ),
                                                      ,
                                                      const SizedBox(
                                                        width: 4,
                                                      ),
                                                      Text(
                                                        " ${_profileController.userdetail["profile"]["diet_habit"]}",
                                                        style: CustomTextStyle
                                                            .bodytext,
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                height: 40,
                                                decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color: const Color
                                                            .fromARGB(255, 230,
                                                            232, 235)),
                                                    borderRadius:
                                                        const BorderRadius.all(
                                                            Radius.circular(
                                                                5))),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          bottom: 8.0,
                                                          top: 8.0,
                                                          left: 12,
                                                          right: 12),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      SizedBox(
                                                        child: Image.asset(
                                                            "assets/cheers.png"),
                                                      )
                                                      //  networkImageWithFallback(assetimg , "assets/drink.png" ),
                                                      ,
                                                      const SizedBox(
                                                        width: 4,
                                                      ),
                                                      Text(
                                                        " Drink - ${_profileController.userdetail["profile"]["drinking_habit"]}",
                                                        style: CustomTextStyle
                                                            .bodytext,
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                height: 40,
                                                decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color: const Color
                                                            .fromARGB(255, 230,
                                                            232, 235)),
                                                    borderRadius:
                                                        const BorderRadius.all(
                                                            Radius.circular(
                                                                5))),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          bottom: 8.0,
                                                          top: 8.0,
                                                          left: 12,
                                                          right: 12),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      SizedBox(
                                                        child: Image.asset(
                                                            "assets/no-smoking.png"),
                                                      )
                                                      //  networkImageWithFallback(assetimg , "assets/drink.png" ),
                                                      ,
                                                      const SizedBox(
                                                        width: 4,
                                                      ),
                                                      Text(
                                                        " Smoking - ${_profileController.userdetail["profile"]["smoking_habit"]}",
                                                        style: CustomTextStyle
                                                            .bodytext,
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Obx(
                                      () {
                                        if (_profileController
                                            .foodDetails.isEmpty) {
                                          return const SizedBox();
                                        } else {
                                          return Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          "Dietary habits",
                                                          style: CustomTextStyle
                                                              .bodytextbold
                                                              .copyWith(
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700),
                                                        )
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                Wrap(
                                                  spacing: 10,
                                                  runSpacing: 10,
                                                  children: _profileController
                                                      .foodDetails
                                                      .map((detail) {
                                                    return detailContainer(
                                                      assetimg:
                                                          detail["icon_url"],
                                                      title: detail["name"],
                                                    );
                                                  }).toList(), // Convert the iterable to a list
                                                )
                                              ],
                                            ),
                                          );
                                        }
                                      },
                                    ),
                                    Obx(
                                      () {
                                        if (_profileController
                                            .hobbiesDetails.isEmpty) {
                                          return const SizedBox();
                                        } else {
                                          return Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const Divider(),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          "Hobbies",
                                                          style: CustomTextStyle
                                                              .bodytextbold
                                                              .copyWith(
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700),
                                                        )
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                Wrap(
                                                  spacing: 10,
                                                  runSpacing: 10,
                                                  children: _profileController
                                                      .hobbiesDetails
                                                      .map((detail) {
                                                    return detailContainer(
                                                      assetimg:
                                                          detail["icon_url"],
                                                      title: detail["name"],
                                                    );
                                                  }).toList(), // Convert the iterable to a list
                                                )
                                              ],
                                            ),
                                          );
                                        }
                                      },
                                    ),
                                    Obx(
                                      () {
                                        if (_profileController
                                            .interestDetails.isEmpty) {
                                          return const SizedBox();
                                        } else {
                                          return Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const Divider(),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          "Interest",
                                                          style: CustomTextStyle
                                                              .bodytextbold
                                                              .copyWith(
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700),
                                                        )
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                Wrap(
                                                  spacing: 10,
                                                  runSpacing: 10,
                                                  children: _profileController
                                                      .interestDetails
                                                      .map((detail) {
                                                    return detailContainer(
                                                      assetimg:
                                                          detail["icon_url"],
                                                      title: detail["name"],
                                                    );
                                                  }).toList(), // Convert the iterable to a list
                                                )
                                              ],
                                            ),
                                          );
                                        }
                                      },
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Obx(() {
                                      // Access the ProfileState data stored in the observable
                                      final profileState = _profileController
                                          .userdetail["ProfileState"];

                                      // Check if incompletetable contains a table with the name "Family"
                                      final hasFamilyTable =
                                          profileState["incompletetable"].any(
                                              (table) =>
                                                  table["table"] ==
                                                  "Lifestyle");

                                      return hasFamilyTable
                                          ? EditReminderContainer(
                                              name: "Lifestyle Details",
                                              ontap: () {
                                                navigatorKey.currentState!
                                                    .push(MaterialPageRoute(
                                                  builder: (context) =>
                                                      EditLifestyleDetails(
                                                    key: UniqueKey(),
                                                  ),
                                                ));
                                              },
                                            )
                                          : const SizedBox
                                              .shrink(); // SizedBox to take up no space if "Family" table is not present
                                    }),
                                  ],
                                )),
                            const SizedBox(
                              height: 10,
                            ),*/
                            editformcontainer(
                                ontap: () {
                                  navigatorKey.currentState!
                                      .push(MaterialPageRoute(
                                    builder: (context) => EditLifestyleDetails(
                                      key: UniqueKey(),
                                    ),
                                  ));
                                },
                                assetimage: "assets/icons/General_info.png",
                                title:
                                    AppLocalizations.of(context)!.generalInfo,
                                widget: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        displayFormat(
                                            title: AppLocalizations.of(context)!
                                                .languagesKnown,
                                            subtitle:
                                                "${_profileController.userdetail["profile"]["languages_known"]}"),
                                        displayFormat(
                                            title: AppLocalizations.of(context)!
                                                .motherTongue,
                                            subtitle:
                                                "${_profileController.userdetail["profile"]["mother_tongue"]}"),
                                      ],
                                    ),
                                    /*            Obx(
                                      () {
                                        if (_profileController
                                            .dressStyle.isEmpty) {
                                          return const SizedBox();
                                        } else {
                                          return Padding(
                                            padding:
                                                const EdgeInsets.only(top: 8.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const Divider(),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          "Dress Style",
                                                          style: CustomTextStyle
                                                              .bodytextbold
                                                              .copyWith(
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700),
                                                        )
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                Wrap(
                                                  spacing: 10,
                                                  runSpacing: 10,
                                                  children: _profileController
                                                      .dressStyle
                                                      .map((detail) {
                                                    return detailContainer(
                                                      assetimg:
                                                          detail["icon_url"],
                                                      title: detail["name"],
                                                    );
                                                  }).toList(), // Convert the iterable to a list
                                                )
                                              ],
                                            ),
                                          );
                                        }
                                      },
                                    ),
                                    Obx(
                                      () {
                                        if (_profileController
                                            .favouriteMusic.isEmpty) {
                                          return const SizedBox();
                                        } else {
                                          return Padding(
                                            padding:
                                                const EdgeInsets.only(top: 8.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const Divider(),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          "Favourite Music",
                                                          style: CustomTextStyle
                                                              .bodytextbold
                                                              .copyWith(
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700),
                                                        )
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                Wrap(
                                                  spacing: 10,
                                                  runSpacing: 10,
                                                  children: _profileController
                                                      .favouriteMusic
                                                      .map((detail) {
                                                    return detailContainer(
                                                      assetimg:
                                                          detail["icon_url"],
                                                      title: detail["name"],
                                                    );
                                                  }).toList(), // Convert the iterable to a list
                                                )
                                              ],
                                            ),
                                          );
                                        }
                                      },
                                    ),
                                    Obx(
                                      () {
                                        if (_profileController
                                            .foodDetails.isEmpty) {
                                          return const SizedBox();
                                        } else {
                                          return Padding(
                                            padding:
                                                const EdgeInsets.only(top: 8.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const Divider(),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          "Favourite Food",
                                                          style: CustomTextStyle
                                                              .bodytextbold
                                                              .copyWith(
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700),
                                                        )
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                Wrap(
                                                  spacing: 10,
                                                  runSpacing: 10,
                                                  children: _profileController
                                                      .foodDetails
                                                      .map((detail) {
                                                    return detailContainer(
                                                      assetimg:
                                                          detail["icon_url"],
                                                      title: detail["name"],
                                                    );
                                                  }).toList(), // Convert the iterable to a list
                                                )
                                              ],
                                            ),
                                          );
                                        }
                                      },
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    )*/
                                  ],
                                )),
                            const SizedBox(
                              height: 10,
                            ),
                            editformcontainer(
                                ontap: () {
                                  navigatorKey.currentState!
                                      .push(MaterialPageRoute(
                                    builder: (context) => EditPartnerPrefrances(
                                      key: UniqueKey(),
                                    ),
                                  ));
                                },
                                assetimage:
                                    "assets/icons/MatchesByPartnerPreference.png",
                                title: AppLocalizations.of(context)!.lookingFor,
                                widget: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Text(
                                    //   language == "en"
                                    //       ? "These are Your desired partner qualities"
                                    //       : "तुम्ही जोडीदारासाठी निवडलेले अपेक्षित गुण खालीलप्रमाणे",
                                    //   style: CustomTextStyle.bodytext,
                                    // ),
                                    // const SizedBox(
                                    //   height: 10,
                                    // ),
                                    prefrance(
                                      Subtitle:
                                          "${_profileController.userdetail["profile"]["partner_min_age"]} to ${_profileController.userdetail["profile"]["partner_max_age"]} ",
                                      /* years */
                                      title: AppLocalizations.of(context)!.age,
                                      assetimg: "assets/icons/Age.png",
                                    ),
                                    prefrance(
                                      Subtitle:
                                          "${_profileController.userdetail["profile"]["partner_min_height"]} to ${_profileController.userdetail["profile"]["partner_max_height"]}",
                                      title:
                                          AppLocalizations.of(context)!.height,
                                      assetimg: "assets/icons/Height.png",
                                    ),
                                    prefrance(
                                      Subtitle:
                                          "${_profileController.userdetail["profile"]["partner_marital_status"]}",
                                      title: AppLocalizations.of(context)!
                                          .maritalstatus,
                                      assetimg:
                                          "assets/icons/Marital_status.png",
                                    ),
                                    prefrance(
                                      Subtitle:
                                          "${_profileController.userdetail["profile"]["religions"]}",
                                      title: language == "en"
                                          ? "Religion"
                                          : "धर्म",
                                      // AppLocalizations.of(context)!.section,
                                      assetimg: "assets/icons/Religion.png",
                                    ),
                                    prefrance(
                                      Subtitle:
                                          "${_profileController.userdetail["profile"]["subcaste"]}",
                                      title:
                                          AppLocalizations.of(context)!.caste,
                                      assetimg: "assets/icons/Religion.png",
                                    ),
                                    prefrance(
                                      Subtitle:
                                          "${_profileController.userdetail["profile"]["subcaste"]}",
                                      title: AppLocalizations.of(context)!
                                          .subcaste,
                                      assetimg: "assets/icons/Religion.png",
                                    ),
                                    prefrance(
                                      Subtitle:
                                          "${_profileController.userdetail["profile"]["partner_manglik"]}",
                                      title:
                                          AppLocalizations.of(context)!.manglik,
                                      assetimg: "assets/icons/Manglik.png",
                                    ),
                                    prefrance(
                                      Subtitle:
                                          "${_profileController.userdetail["profile"]["partner_city"]}, ${_profileController.userdetail["profile"]["partner_state"]}",
                                      title: AppLocalizations.of(context)!
                                          .livingIn,
                                      assetimg: "assets/icons/Location.png",
                                    ),
                                    prefrance(
                                      Subtitle:
                                          "${_profileController.userdetail["profile"]["partner_education"]}",
                                      title: AppLocalizations.of(context)!
                                          .education,
                                      assetimg: "assets/icons/Education.png",
                                    ),
                                    prefrance(
                                      Subtitle:
                                          "${_profileController.userdetail["profile"]["partner_occupation"]}",
                                      title: AppLocalizations.of(context)!
                                          .occupation,
                                      assetimg: "assets/icons/Occupation.png",
                                    ),
                                    prefrance(
                                      Subtitle:
                                          "INR ${_profileController.userdetail["profile"]["partner_min_annual_income"]}- ${_profileController.userdetail["profile"]["partner_max_annual_income"]} ${language == "en" ? 'Per Annum' : "वार्षिक उत्पन्न"}",
                                      title: AppLocalizations.of(context)!
                                          .annualIncome,
                                      assetimg:
                                          "assets/icons/Annual_income.png",
                                    ),
                                    /*  prefrance(
                                      Subtitle:
                                          "${_profileController.userdetail["profile"]["partner_dietary_habits"]}",
                                      title: AppLocalizations.of(context)!.maritalstatus,
                                      assetimg: "assets/icons/Diet.png",
                                    ),*/
                                    /*  prefrance(
                                      Subtitle:
                                          "${_profileController.userdetail["profile"]["partner_smoking_habits"]}",
                                      title: "Smoke",
                                      assetimg:
                                          "assets/icons/Smoking_habit.png",
                                    ),
                                    prefrance(
                                      Subtitle:
                                          "${_profileController.userdetail["profile"]["partner_drinking_habits"]}",
                                      title: "Drink",
                                      assetimg:
                                          "assets/icons/Drinking_habit.png",
                                    ),*/
                                  ],
                                )),
                            const SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      )
                    ],
                  )),
                ),
              ),
            );
          }
        }
      },
    );
  }

  Column displayFormat({required String title, required String subtitle}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8, right: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                overflow: TextOverflow.ellipsis,
                title,
                style: CustomTextStyle.bodytext,
              ),
              Text(
                  softWrap: true,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  subtitle.toString(),
                  style: CustomTextStyle.bodytextbold.copyWith(
                    fontWeight: subtitle.toString() == 'Not Filled' ||
                            subtitle.toString() == 'माहिती नाही '
                        ? FontWeight.w400
                        : null,
                    fontSize: subtitle.toString() == 'Not Filled' ||
                            subtitle.toString() == 'माहिती नाही '
                        ? 11
                        : null,
                    fontStyle: subtitle.toString() == 'Not Filled' ||
                            subtitle.toString() == 'माहिती नाही '
                        ? FontStyle.italic
                        : null,
                  )),
              const SizedBox(
                height: 10,
              )
            ],
          ),
        ),
      ],
    );
  }
}

class EditReminderContainer extends StatelessWidget {
  const EditReminderContainer({
    super.key,
    required this.name,
    this.ontap,
  });
  final String name;
  final void Function()? ontap;
  @override
  Widget build(BuildContext context) {
    String? language = sharedPreferences?.getString("Language");

    return Container(
      decoration: BoxDecoration(
          color: const Color.fromARGB(255, 37, 177, 144).withOpacity(0.1),
          borderRadius: const BorderRadius.all(Radius.circular(10))),
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              textAlign: TextAlign.center,
              language == "en"
                  ? "Describe Your $name to Understand You More!"
                  : "तुमची $nameभरा, जेणेकरून तुमच्या प्रोफाईलला अधिक पसंदी मिळेल",
              style: CustomTextStyle.bodytextbold,
            ),
            TextButton.icon(
                onPressed: () {
                  if (ontap != null) {
                    print("NOt null");
                    ontap!(); // Call the function
                  }
                },
                icon: Icon(
                  Icons.edit,
                  color: AppTheme.primaryColor,
                ),
                label: Text(
                  language == "en" ? "Complete $name " : "आपली $nameकरा",
                  style: CustomTextStyle.textbuttonRed,
                ))
          ],
        ),
      ),
    );
  }
}

class prefrance extends StatelessWidget {
  const prefrance({
    super.key,
    required this.assetimg,
    required this.title,
    required this.Subtitle,
  });

  final String assetimg;
  final String title;
  final String Subtitle;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 13,
                  width: 13,
                  child: Image.asset(assetimg),
                ),
                const SizedBox(width: 5),
                Expanded(
                  child: Text(
                    title,
                    style: CustomTextStyle.bodytext,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
              ],
            ),
            ReadMoreText(
              Subtitle,
              trimLines: 2,
              trimMode: TrimMode.Line,
              trimCollapsedText: ' Read more',
              trimExpandedText: ' Read less',
              style: CustomTextStyle.bodytextSmall
                  .copyWith(fontWeight: FontWeight.w700),
              moreStyle: TextStyle(
                  color: AppTheme.selectedOptionColor,
                  fontWeight: FontWeight.w500),
              lessStyle: TextStyle(
                  color: AppTheme.primaryColor, fontWeight: FontWeight.w500),
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}
