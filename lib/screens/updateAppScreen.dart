import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:_96kuliapp/commons/textdecoration.dart';
import 'package:_96kuliapp/main.dart';
import 'package:_96kuliapp/routes/routenames.dart';
import 'package:url_launcher/url_launcher.dart';

class UpdateAppScreen extends StatefulWidget {
  const UpdateAppScreen({super.key});

  @override
  _UpdateAppScreenState createState() => _UpdateAppScreenState();
}

class _UpdateAppScreenState extends State<UpdateAppScreen> {
  @override
  void initState() {
    super.initState();

    // Show the bottom sheet when the page is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showNonDismissableBottomSheet();
    });
  }

  void _showNonDismissableBottomSheet() {
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,
      barrierColor: Colors.black54,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          height: MediaQuery.of(context).size.height * 0.4,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Update Required',
                style: CustomTextStyle.bodytextLarge,
              ),
              const SizedBox(height: 16),
              const Text(
                textAlign: TextAlign.center,
                'A new version of the app is available. Please update to continue using the app',
                style: CustomTextStyle.bodytext,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  const url =
                      'https://play.google.com/store/apps/details?id=com.marriage.maratha';

                  // Attempt to launch the URL
                  if (await canLaunchUrl(Uri.parse(url))) {
                    await launchUrl(Uri.parse(url),
                        mode: LaunchMode.externalApplication);
                    SystemNavigator.pop();
                  } else {
                    // Handle the error if the URL can't be launched
                    Get.snackbar(
                      'Error',
                      'Could not open the link.',
                      snackPosition: SnackPosition.BOTTOM,
                    );
                  }
                },
                child: const Text(
                  'Update',
                  style: CustomTextStyle.elevatedButton,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    print("Devoce id");
    final List<String> images = [
      'assets/welcome1.png',
      'assets/welcome2.png',
      'assets/welcome3.png',
    ];

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // Background image
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/bg2.png"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // App logo at the top right
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: SizedBox(
                            height: 50,
                            width: 150,
                            child: Image.asset("assets/applogo.png"),
                          ),
                        ),
                      ],
                    ),
                    const Text(
                      "Find Your Partner!!",
                      style: CustomTextStyle.boldHeading,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Your resource to discover and connect with designers worldwide.",
                      style: CustomTextStyle.bodytextbold,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    // Image slider
                    Center(
                      child: SizedBox(
                        height: 400,
                        child: PageView.builder(
                          itemCount: images.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              child: Image.asset(
                                images[index],
                                fit: BoxFit.contain,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const SizedBox(height: 20),
                    // Continue with Sign In button
                    SizedBox(
                      width: 270,
                      child: FittedBox(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                            ),
                          ),
                          onPressed: () {
                            //    Get.toNamed(AppRouteNames.registerScreen);
                          },
                          child: const Text(
                            "New user ? Register Now!!",
                            style: CustomTextStyle.elevatedButton,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    // New User Register now option
                    GestureDetector(
                      onTap: () {
                        //  Get.toNamed(AppRouteNames.loginScreen2);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text("Already a member ? ",
                              style: CustomTextStyle.fieldName),
                          InkWell(
                            onTap: () {
                              //   Get.toNamed(AppRouteNames.loginScreen2);
                            },
                            child: const Text(
                              "Login",
                              style: CustomTextStyle.textbuttonRed,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
