import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:_96kuliapp/commons/appconstants.dart';
import 'package:_96kuliapp/commons/textdecoration.dart';
import 'package:_96kuliapp/main.dart';
import 'package:_96kuliapp/utils/Apptheme.dart';
import 'package:http/http.dart' as http;

class NotificationController extends GetxController {
  var notifications = {}.obs;
  var isLoading = true.obs;
  @override
  void onInit() {
    super.onInit();
    fetchNotifications();
  }

  Future<void> fetchNotifications() async {
    print("Notifications");
    String? token = sharedPreferences!.getString("token");
    String? language = sharedPreferences!.getString("Language");

    isLoading(true);
    try {
      final response = await http.post(
        Uri.parse(
            '${Appconstants.baseURL}/api/member/app/notification?lang=$language'),
        headers: {
          'Content-Type': 'application/json',
          "Authorization": "Bearer $token",
        },
        // Add any necessary body data or authorization headers if required
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status']) {
          notifications.value = data['data']['data'];
        }
      } else {
        // Handle error response
        print('Failed to load notifications');
      }
    } catch (e) {
      print("Error fetching notifications: $e");
    } finally {
      isLoading(false);
    }
  }
}
