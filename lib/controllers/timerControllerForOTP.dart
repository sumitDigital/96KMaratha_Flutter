import 'dart:async';
import 'package:get/get.dart';

class TimerControllerForOTP extends GetxController {
  var remainingSeconds = 120.obs; // Observable variable for countdown
  var timerActive = true.obs; // Tracks whether timer is active
  Timer? _timer;

  void startTimer() {
    remainingSeconds.value = 120; // Reset to 120 seconds
    timerActive.value = true; // Set timer as active
    _timer?.cancel(); // Cancel any previous timer
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingSeconds.value <= 0) {
        timer.cancel(); // Stop the timer
        timerActive.value = false; // Show "Resend OTP" button
      } else {
        remainingSeconds.value--;
      }
    });
  }

  void resendOtp() {
    startTimer(); // Restart the timer when "Resend OTP" is clicked
    // Add any other resend OTP logic here, like sending an OTP request to your backend
  }

  @override
  void onClose() {
    _timer?.cancel(); // Clean up the timer when the controller is disposed
    super.onClose();
  }
}
