import 'package:_96kuliapp/main.dart';
import 'package:flutter/material.dart';
import 'package:_96kuliapp/commons/textdecoration.dart';

class InboxScreenWidget extends StatelessWidget {
  const InboxScreenWidget(
      {super.key, required this.message, required this.widget, this.msgcolor});
  final String message;
  final Widget widget;
  final Color? msgcolor;
  @override
  Widget build(BuildContext context) {
    String? language = sharedPreferences?.getString("Language");

    return ListView.builder(
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      itemCount: 8,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            // Get.toNamed(AppRouteNames.userDetails);
          },
          child: Padding(
            padding: const EdgeInsets.only(right: 4, bottom: 4, top: 4),
            child: Stack(
              children: [
                Container(
                  height: 530,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      "assets/profilepic2.png",
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                // Gradient overlay
                Container(
                  height: 530,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Color(0xFF0C0B0B), // #0C0B0B at 100%
                        Color(0x800C0B0B), // rgba(12, 11, 11, 0.5) at 45.36%
                        Color(0x00FFFFFF), // rgba(255, 255, 255, 0) at 0%
                      ],
                      stops: [0.0, 0.45, 1.0],
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: SizedBox(
                    height: 530,
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Spacer(),
                        Text(
                          "S. Gupta",
                          style: CustomTextStyle.imageText.copyWith(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: Colors.white),
                        ),
                        RichText(
                            text: TextSpan(children: <TextSpan>[
                          TextSpan(
                              text: language == "en"
                                  ? "Member ID - "
                                  : "मेंबर आयडी - ",
                              style: CustomTextStyle.imageText
                                  .copyWith(fontSize: 14)),
                          TextSpan(
                              text: "JM2258 ",
                              style: CustomTextStyle.imageText.copyWith(
                                  fontSize: 14, fontWeight: FontWeight.w800)),
                        ])),
                        const SizedBox(height: 10),
                        RichText(
                          text: TextSpan(
                            children: <InlineSpan>[
                              const TextSpan(
                                text: "28 Years, 5'5 ",
                                style: CustomTextStyle.imageText,
                              ),
                              WidgetSpan(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 4.0,
                                      vertical:
                                          4), // Adjust the padding as needed
                                  child: Container(
                                    width: 6.0, // Adjust size for the circle
                                    height: 6.0,
                                    decoration: BoxDecoration(
                                      color: const Color.fromARGB(
                                              255, 215, 215, 215)
                                          .withOpacity(
                                              0.5), // Set the color of the circle
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ),
                              ),
                              const TextSpan(
                                text: "Never Married ",
                                style: CustomTextStyle.imageText,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 1,
                        ),
                        RichText(
                          text: TextSpan(
                            children: <InlineSpan>[
                              const TextSpan(
                                text: "Shwetambar-Khandwal",
                                style: CustomTextStyle.imageText,
                              ),
                              WidgetSpan(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 4.0,
                                      vertical:
                                          4), // Adjust the padding as needed
                                  child: Container(
                                    width: 6.0, // Adjust size for the circle
                                    height: 6.0,
                                    decoration: BoxDecoration(
                                      color: const Color.fromARGB(
                                              255, 215, 215, 215)
                                          .withOpacity(
                                              0.4), // Set the color of the circle
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ),
                              ),
                              const TextSpan(
                                text: " Pune, Ahemadnagar",
                                style: CustomTextStyle.imageText,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 1,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                          child: Container(
                            decoration: BoxDecoration(
                                color: msgcolor ??
                                    const Color.fromARGB(255, 235, 237, 239)
                                        .withOpacity(0.37),
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(10))),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
                                child: Text(
                                    textAlign: TextAlign.center,
                                    message,
                                    style: CustomTextStyle.imageText),
                              ),
                            ),
                          ),
                        ),

                        /*   Text("28 Years, 5'5    Shwetambar-Khandwal",
                              style: CustomTextStyle.imageText),
                          Text(
                            "Never Married     Pune, Ahemadnagar",
                            style: CustomTextStyle.imageText,
                          ),
                          Text(
                            "Marketing Professional    30-35 Lakhs",
                            style: CustomTextStyle.imageText,
                          ),*/
                        Divider(
                          height: 2,
                          color: const Color.fromARGB(255, 215, 226, 242)
                              .withOpacity(.69),
                        ),
                        /*  Row(
                        mainAxisAlignment: MainAxisAlignment.start ,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                        TextButton(onPressed: (){}, child: Row(children: [
                          const SizedBox(width: 7,),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(height: 22, width: 22, child: Image.asset("assets/decline.png"),),
                          ) , 
                          Text("Decline" , style: CustomTextStyle.imageText.copyWith(fontWeight: FontWeight.w600 , fontSize: 16),) , 
                      
                        
                        
                        ],) ) , 
                              const SizedBox(width: 25,), 
                          Container(height: 16, color:  const Color.fromARGB(255, 215, 226, 242).withOpacity(.69),width: 1,), 
                            TextButton(onPressed: (){}, child: Row(children: [
                          const SizedBox(width: 7,),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(height: 22, width: 22, child: Image.asset("assets/accept.png"),),
                          ) , 
                          Text("Accept" , style: CustomTextStyle.imageText.copyWith(fontWeight: FontWeight.w600 , fontSize: 16),) , 
                      
                        
                        
                        ],) ) , 
                        ],), */
                        widget,
                        const SizedBox(
                          height: 10,
                        )
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 15,
                  right: 0,
                  child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 255, 199, 56),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15), // Sharp corner
                          topRight: Radius.circular(0), // Sharp corner
                          bottomLeft: Radius.circular(0), // Sharp corner
                          bottomRight: Radius.circular(0), // Sharp corner
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            height: 10,
                            width: 10,
                            child: Image.asset("assets/premiumblack.png"),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          const Text(
                            "Premium",
                            style: TextStyle(
                              fontSize: 10,
                              fontFamily: "WORKSANS",
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 5, 28, 60),
                            ),
                          ),
                        ],
                      )),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
