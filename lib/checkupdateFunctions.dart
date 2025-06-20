  import 'package:in_app_update/in_app_update.dart';

Future<void> checkForUpdate() async {
    try {
      print('Checking for Update');
      AppUpdateInfo info = await InAppUpdate.checkForUpdate();

      if (info.updateAvailability == UpdateAvailability.updateAvailable) {
        print('Update available');
        await update();
      } else {
        print('No update available');
      }
    } catch (e) {
      print('Error checking for update: ${e.toString()}');
    }
  }

    Future<void> update() async {
    try {
      print('Starting update');
      await InAppUpdate.performImmediateUpdate();
    } catch (e) {
      print('Error performing update: ${e.toString()}');
      // You might want to handle this case, such as notifying the user.
    }
  }