import 'package:flutter/material.dart';
import 'package:_96kuliapp/utils/Apptheme.dart';

class CustomSnackBar extends StatelessWidget {
  final String title;
  final String message;
  final String iconPath;

  const CustomSnackBar({
    super.key,
    required this.title,
    required this.message,
    required this.iconPath,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color.fromRGBO(215, 226, 242, 0.69),
          borderRadius: BorderRadius.circular(8),
          boxShadow: const [
            // Shadow only at the bottom
            BoxShadow(
              color: Color.fromRGBO(187, 184, 184, 0.1), // Shadow color
              blurRadius: 3, // Blur effect
              blurStyle: BlurStyle.outer,
              spreadRadius: 4,
              offset: Offset(0, 2), // Offset only in the vertical direction
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 25,
                    width: 25,
                    child: Image.asset(iconPath),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            fontFamily: "WORKSANS",
                            color: AppTheme.primaryColor,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          message,
                          style: TextStyle(
                            fontSize: 12,
                            fontFamily: "WORKSANS",
                            color: AppTheme.primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void showCustomSnackBar(
    BuildContext context, String title, String message, String iconPath) {
  final overlay = Overlay.of(context); // Ensure overlay is available

  final overlayEntry = OverlayEntry(
    builder: (context) => Positioned(
      top: 50,
      left: 16,
      right: 16,
      child: CustomSnackBar(
        title: title,
        message: message,
        iconPath: iconPath,
      ),
    ),
  );

  overlay.insert(overlayEntry);

  // Automatically remove the snackbar after 2 seconds
  Future.delayed(const Duration(seconds: 1), () {
    if (overlayEntry.mounted) {
      overlayEntry.remove();
    }
  });
}
