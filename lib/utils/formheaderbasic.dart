import 'package:flutter/material.dart';
import 'package:flutter_timer_countdown/flutter_timer_countdown.dart';
import 'package:_96kuliapp/commons/textdecoration.dart';

class StepsFormHeaderBasic extends StatefulWidget {
  const StepsFormHeaderBasic(
      {super.key,
      required this.title,
      required this.desc,
      required this.image,
      required this.statusdesc,
      required this.statusPercent,
      this.endhour,
      this.endminutes,
      this.endseconds});
  final String title;
  final String desc;
  final String image;
  final String statusdesc;
  final String statusPercent;
  final int? endhour;
  final int? endminutes;
  final int? endseconds;
  @override
  State<StepsFormHeaderBasic> createState() => _StepsFormHeaderBasicState();
}

//
class _StepsFormHeaderBasicState extends State<StepsFormHeaderBasic>
    with SingleTickerProviderStateMixin {
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
    print("Imag ${widget.image}");
    print("Dec ${widget.desc}");
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
                      fontSize: 20,
                      fontWeight: FontWeight.w600),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Divider(
                  endIndent: 10,
                  indent: 10,
                  thickness: 1,
                  color: Colors.white,
                ),
                const SizedBox(
                  height: 10,
                ),
                Center(
                    child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  child: Text(
                    widget.desc,
                    style: CustomTextStyle.bodytextbold
                        .copyWith(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                )),
                const SizedBox(
                  height: 15,
                ),
                widget.endhour == 0 &&
                        widget.endminutes == 0 &&
                        widget.endseconds == 0
                    ? const SizedBox()
                    : Stack(
                        children: [
                          LayoutBuilder(
                            builder: (context, constraints) {
                              return Container(
                                width: 250,
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
                                          descriptionTextStyle: CustomTextStyle
                                              .timerformattextDesc,
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
                      ),
                const SizedBox(
                  height: 10,
                ),
                RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(children: <TextSpan>[
                      TextSpan(
                          text: "${widget.statusdesc} ",
                          style: CustomTextStyle.bodytextbold
                              .copyWith(color: Colors.white)),
                      TextSpan(
                          text: widget.statusPercent,
                          style: CustomTextStyle.completPercent)
                    ])),
                widget.image == "height"
                    ? const SizedBox(
                        height: 0,
                      )
                    : const SizedBox(
                        height: 80,
                      )
              ],
            ),
          ),
        ),
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
