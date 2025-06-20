import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:_96kuliapp/main.dart';
import 'package:_96kuliapp/routes/routenames.dart';
import 'dart:async';

import 'package:_96kuliapp/screens/userInfoForms/userinfoStepSix.dart';

class TimerController extends GetxController {
  Timer? _timer;
  var isTimerRunning = false.obs; // Observable to track timer status

  void startTimer() {
    if (isTimerRunning.value) {
      print("Timer is already running.");
      return;
    }

    print("Started timer");
    isTimerRunning.value = true;
    _timer = Timer(const Duration(minutes: 3), () {
      print("Timer completed. Navigating to the next page.");
      navigatorKey.currentState!.pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => const UserInfoStepSix(),
        ),
        (route) => false,
      );
      isTimerRunning.value = false; // Timer is no longer running
    });
  }

  void cancelTimer() {
    if (_timer != null && isTimerRunning.value) {
      _timer?.cancel();
      isTimerRunning.value = false;
      print("Timer cancelled.");
    } else {
      print("No timer to cancel.");
    }
  }

  @override
  void onClose() {
    _timer
        ?.cancel(); // Ensure the timer is cancelled when the controller is disposed
    super.onClose();
  }
}
