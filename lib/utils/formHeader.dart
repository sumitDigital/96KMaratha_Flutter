import 'package:_96kuliapp/controllers/userform/formstep1Controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_timer_countdown/flutter_timer_countdown.dart';
import 'package:_96kuliapp/commons/appconstants.dart';
import 'package:_96kuliapp/commons/textdecoration.dart';
import 'package:_96kuliapp/main.dart';
import 'package:_96kuliapp/utils/Apptheme.dart';
import 'package:get/get.dart';

class StepsFormHeader extends StatefulWidget {
  const StepsFormHeader(
      {super.key,
      required this.title,
      required this.desc,
      required this.image,
      required this.statusdesc,
      required this.statusPercent,
      required this.endhour,
      this.endminutes,
      this.endseconds,
      required this.statusPercentMarathi,
      required this.statusDescMarathiPrefix,
      required this.statusDescMarathiSuffix});
  final String title;
  final String desc;
  final String image;
  final String statusdesc;
  final String statusPercent;
  final String statusDescMarathiPrefix;
  final String statusDescMarathiSuffix;
  final String statusPercentMarathi;

  final int? endhour;
  final int? endminutes;
  final int? endseconds;
  @override
  State<StepsFormHeader> createState() => _StepsFormHeaderState();
}

//
class _StepsFormHeaderState extends State<StepsFormHeader>
    with SingleTickerProviderStateMixin {
  String? language = sharedPreferences?.getString("Language");
  final StepOneController _stepOneController = Get.put(StepOneController());

  late AnimationController _controller;
  late Animation<double> _animation;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 3), // Animation duration
      vsync: this,
    )..repeat(); // Repeat the animation

    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          color: const Color.fromRGBO(204, 40, 77, 1),
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 10,
                ),
                Text(
                  textAlign: TextAlign.center,
                  widget.title,
                  style: CustomTextStyle.bodytextLarge.copyWith(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w600),
                ), // 20
                const SizedBox(
                  height: 10,
                ),
                Divider(
                  endIndent: 10,
                  indent: 10,
                  thickness: 1,
                  color: Colors.white.withOpacity(0.5),
                ),
                const SizedBox(
                  height: 10,
                ),
                Center(
                    child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  child: Text(
                    widget.desc,
                    // "खालील वेळेत तुमची माहिती पूर्ण करून १ दिवसाची धमाका ऑफर मिळवा",
                    style: CustomTextStyle.bodytextbold.copyWith(
                        fontSize: 16, // 13
                        color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                )),
                const SizedBox(
                  height: 10,
                ),
                //  widget.endhour == 0 && widget.endminutes == 0 && widget.endseconds == 0 ? SizedBox() :
                Center(
                    child: SizedBox(
                  // height: 157,
                  width: 200,
                  child: Image.network(
                    widget.image,
                    fit: BoxFit.fitWidth,
                  ),
                  // Image.asset("assets/dhamakedar-offer-96k-02.png"),
                )),
                const SizedBox(
                  height: 20,
                ),
                Obx(() {
                  final endTime =
                      _stepOneController.basicInfoData["End_Date_time"];
                  if (endTime != null && endTime != "0000-00-00 00:00:00") {
                    return Stack(
                      children: [
                        LayoutBuilder(
                          builder: (context, constraints) {
                            print(
                                "Timer Condition Check ${_stepOneController.basicInfoData["End_Date_time"]}");
                            return Container(
                              width: 230,
                              height: 70,
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: 10,
                                    spreadRadius: 2,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                                color: const Color.fromRGBO(9, 39, 73, 1),
                                //rgba(234, 52, 74, 1) rgba(9, 39, 73, 1)
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(14.0),
                                child: FittedBox(
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      SizedBox(
                                        height: 30,
                                        width: 30,
                                        child: Image.asset(
                                          'assets/HourGlass.gif',
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      TimerCountdown(
                                        onEnd: () {
                                          print("THIS TIME END");
                                        },
                                        colonsTextStyle:
                                            CustomTextStyle.timerformattext,
                                        timeTextStyle:
                                            CustomTextStyle.timerformattext,
                                        descriptionTextStyle:
                                            CustomTextStyle.timerformattextDesc,
                                        format: CountDownTimerFormat
                                            .hoursMinutesSeconds,
                                        endTime: DateTime.now().add(Duration(
                                          hours: widget.endhour ?? 0,
                                          minutes: widget.endminutes ?? 0,
                                          seconds: widget.endseconds ?? 0,
                                        )),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        Positioned.fill(
                          // Ensure the border overlays the entire child
                          child: AnimatedBuilder(
                            animation: _animation,
                            builder: (context, child) {
                              return CustomPaint(
                                painter: AnimatedBorderPainter(
                                  progress: _animation.value,
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    );
                  } else {
                    return const SizedBox();
                  }
                }),
                // _stepOneController.basicInfoData["End_Date_time"] != null ||
                //         _stepOneController.basicInfoData["End_Date_time"] ==
                //             "0000-00-00 00:00:00"
                //     ? Stack(
                //         children: [
                //           LayoutBuilder(
                //             builder: (context, constraints) {
                //               print(
                //                   "Timer Condition Check ${_stepOneController.basicInfoData["End_Date_time"]}");
                //               return Container(
                //                 width: 230,
                //                 height: 70,
                //                 decoration: BoxDecoration(
                //                   boxShadow: [
                //                     BoxShadow(
                //                       color: Colors.black.withOpacity(0.2),
                //                       blurRadius: 10,
                //                       spreadRadius: 2,
                //                       offset: Offset(0, 4),
                //                     ),
                //                   ],
                //                   color: const Color.fromRGBO(9, 39, 73, 1),
                //                   //rgba(234, 52, 74, 1) rgba(9, 39, 73, 1)
                //                   borderRadius: BorderRadius.circular(5),
                //                 ),
                //                 child: Padding(
                //                   padding: const EdgeInsets.all(14.0),
                //                   child: FittedBox(
                //                     child: Row(
                //                       mainAxisSize: MainAxisSize.min,
                //                       children: [
                //                         SizedBox(
                //                           height: 30,
                //                           width: 30,
                //                           child: Image.asset(
                //                             'assets/HourGlass.gif',
                //                             fit: BoxFit.cover,
                //                           ),
                //                         ),
                //                         SizedBox(
                //                           width: 5,
                //                         ),
                //                         TimerCountdown(
                //                           onEnd: () {
                //                             print("THIS TIME END");
                //                           },
                //                           colonsTextStyle:
                //                               CustomTextStyle.timerformattext,
                //                           timeTextStyle:
                //                               CustomTextStyle.timerformattext,
                //                           descriptionTextStyle: CustomTextStyle
                //                               .timerformattextDesc,
                //                           format: CountDownTimerFormat
                //                               .hoursMinutesSeconds,
                //                           endTime: DateTime.now().add(Duration(
                //                             hours: widget.endhour ?? 0,
                //                             minutes: widget.endminutes ?? 0,
                //                             seconds: widget.endseconds ?? 0,
                //                           )),
                //                         ),
                //                       ],
                //                     ),
                //                   ),
                //                 ),
                //               );
                //             },
                //           ),
                //           Positioned.fill(
                //             // Ensure the border overlays the entire child
                //             child: AnimatedBuilder(
                //               animation: _animation,
                //               builder: (context, child) {
                //                 return CustomPaint(
                //                   painter: AnimatedBorderPainter(
                //                     progress: _animation.value,
                //                   ),
                //                 );
                //               },
                //             ),
                //           ),
                //         ],
                //       )
                //     : SizedBox(),
                const SizedBox(
                  height: 10,
                ),
                language == "en"
                    ? RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(children: <TextSpan>[
                          TextSpan(
                              text: "${widget.statusdesc} ",
                              style: CustomTextStyle.bodytextbold
                                  .copyWith(fontSize: 16, color: Colors.white)),
                          TextSpan(
                              text: widget.statusPercent,
                              style: CustomTextStyle.completPercent)
                        ]))
                    : RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(children: <TextSpan>[
                          TextSpan(
                              text: "${widget.statusDescMarathiPrefix} ",
                              style: CustomTextStyle.bodytextbold
                                  .copyWith(fontSize: 16, color: Colors.white)),
                          TextSpan(
                              text: widget.statusPercentMarathi,
                              style: CustomTextStyle.completPercent),
                          TextSpan(
                              text: "${widget.statusDescMarathiSuffix} ",
                              style: CustomTextStyle.bodytextbold
                                  .copyWith(fontSize: 16, color: Colors.white)),
                        ])),
              ],
            ),
          ),
        ),
        /*  Positioned(
      bottom: -50, // Half of the button size to make it overlap the container
      left: 0,
      right: 0,
      child: Center(
        child: SizedBox(
          height: 147, 
          width: 270,
          child: Image.asset("assets/Group 757.png"),)
      ),
    ),*/
      ],
    );
  }
}

class HeartbeatPainter extends CustomPainter {
  final double progress; // Progress of the heartbeat animation
  final double maxScale; // Maximum scale for the heartbeat effect

  HeartbeatPainter({required this.progress, this.maxScale = 0.4});

  @override
  void paint(Canvas canvas, Size size) {
    // Calculate the current scale of the effect based on the progress
    final scale = 1 + (maxScale - 1) * progress;

    // Define a paint object for the pulsating effect
    final paint = Paint()
      ..color = Colors.red.withOpacity(0.5) // Semi-transparent red
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;

    // Center and size
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width / 2) * scale;

    // Draw the pulsating circle
    canvas.drawCircle(center, radius, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class AnimatedBorderPainter extends CustomPainter {
  final double progress;

  AnimatedBorderPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color.fromARGB(255, 251, 214, 60) // Border color
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke;

    final path = Path();
    final totalLength = 2 * (size.width + size.height);
    final currentLength = progress * totalLength;

    // Define border path
    path.moveTo(0, 0);
    if (currentLength <= size.width) {
      path.lineTo(currentLength, 0);
    } else if (currentLength <= size.width + size.height) {
      path.lineTo(size.width, 0);
      path.lineTo(size.width, currentLength - size.width);
    } else if (currentLength <= 2 * size.width + size.height) {
      path.lineTo(size.width, 0);
      path.lineTo(size.width, size.height);
      path.lineTo(
          size.width - (currentLength - size.width - size.height), size.height);
    } else {
      path.lineTo(size.width, 0);
      path.lineTo(size.width, size.height);
      path.lineTo(0, size.height);
      path.lineTo(
          0, size.height - (currentLength - 2 * size.width - size.height));
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
