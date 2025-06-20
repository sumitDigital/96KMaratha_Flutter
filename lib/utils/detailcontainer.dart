import 'package:flutter/material.dart';
import 'package:_96kuliapp/commons/textdecoration.dart';

class detailContainer extends StatelessWidget {
  const detailContainer({
    super.key,
    required this.title,
    required this.assetimg,
  });
  final String title;
  final String assetimg;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: const Color.fromARGB(255, 230, 232, 235)),
        borderRadius: const BorderRadius.all(Radius.circular(5)),
      ),
      child: Padding(
        padding:
            const EdgeInsets.only(bottom: 8.0, top: 8.0, left: 12, right: 12),
        child: Row(
          mainAxisAlignment:
              MainAxisAlignment.start, // Align content to the start
          mainAxisSize: MainAxisSize.min,
          children: [
            networkImageWithFallback(assetimg, "assets/drink.png"),
            const SizedBox(width: 4),
            Flexible(
              // Allow text to wrap when necessary
              child: Text(
                title,
                style: CustomTextStyle.bodytext,
                softWrap: true, // Enable text wrapping
                overflow: TextOverflow
                    .visible, // Ensure text is visible if it overflows
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget networkImageWithFallback(String? networkUrl, String assetImgPath,
      {double height = 25, double width = 25}) {
    return SizedBox(
      height: height,
      width: width,
      child: (networkUrl != null && networkUrl.isNotEmpty)
          ? Image.network(
              networkUrl,
              errorBuilder: (context, error, stackTrace) {
                return Image.asset(
                    assetImgPath); // If network image fails, show asset image
              },
            )
          : Image.asset(
              assetImgPath), // If URL is null or empty, show asset image directly
    );
  }
}
