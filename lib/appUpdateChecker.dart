import 'package:firebase_database/firebase_database.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:flutter/material.dart';

class ForceUpdateChecker {
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();

  Future<void> checkForUpdate(BuildContext context) async {
    try {
      final snapshot = await _dbRef.child('AppVersion/App_Version').get();
      if (snapshot.exists) {
        double latestVersion = snapshot.value as double;

        PackageInfo packageInfo = await PackageInfo.fromPlatform();
        String currentVersionString = packageInfo.version;
        double currentVersion = double.parse(currentVersionString);
        print("Current version $currentVersion");
        print("latest version $latestVersion");
        if (currentVersion < latestVersion) {
          //     _showForceUpdateDialog(context);
        }
      } else {
        debugPrint('App version not found in Firebase.');
      }
    } catch (e) {
      debugPrint('Error checking app version: $e');
    }
  }

  void _showForceUpdateDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Update Required'),
        content: const Text(
          'A new version of the app is available. Please update to continue using the app.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              // Redirect to app store/play store
              Navigator.of(context).pop();
              _redirectToStore();
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  void _redirectToStore() {
    // Add logic to redirect to the app store/play store
    // Example: open the app's page using the url_launcher package
  }
}
