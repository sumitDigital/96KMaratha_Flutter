/*
class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
   final DashboardController _dashboardcontroller = Get.find<DashboardController>();

  @override 
  void initState() {
    // TODO: implement initState
    super.initState();
    if(

    _dashboardcontroller.dashboardData["redirect"]["pagename"] == "FORCEPOPUP"
    ){
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showCustomDialog(context);
    });

    }
   
  } 

  // Method to show the dialog
  void _showCustomDialog(BuildContext context) {
    showDialog(
      barrierColor: Colors.black.withOpacity(0.8),
   // barrierDismissible: false,
      context: context,
      builder: (context) {
        return Dialog(
          child: Container(
            decoration: BoxDecoration(
            color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(5)) , 
        
        
            ),
            width: MediaQuery.of(context).size.width * 0.9, // Adjust the width to fit better
            padding: EdgeInsets.only(left:  12.0 , right: 12 , top: 25 , bottom: 25),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // Display asset image
                     Text(
                  'Profile Under Review!', // Replace with your desired text
                  style: CustomTextStyle.bodytextboldPrimary,
                  textAlign: TextAlign.center,
                ),
                Image.asset(
                  'assets/your_image.png', // Replace with your image asset path
                  height: 150, // Adjust the image size as needed
                  width: MediaQuery.of(context).size.width*0.7,
                  fit: BoxFit.contain, // Adjust the fit as necessary
                ),
             //   Container(height: 150,    width: MediaQuery.of(context).size.width*0.7, color: Colors.red,),
                // Display text content
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    textAlign: TextAlign.center,
                    "Thank you for \n submitting your profile.", style: CustomTextStyle.bodytextboldLarge.copyWith(fontSize: 15 )),
                ), 
                  Padding(
                    
                  padding: const EdgeInsets.only(left:  8.0 , right: 8.0 , top: 4 ,bottom: 4 ),
                  child: Text(
                    textAlign: TextAlign.center,
                    " We are reviewing it and will update you as soon as it’s activated..!", style: CustomTextStyle.bodytext),
                ), 
        
               
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    _dashboardcontroller.fetchCountDetails();
    return WillPopScope( 
       onWillPop: () async {
    // Show the confirmation dialog
    bool? shouldExit = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return 

AlertDialog(
  backgroundColor: Colors.white,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(12.0), // Rounded corners
  ),
  title: Text(
    'Exit App',
    style: CustomTextStyle.bodytextLarge.copyWith(
      color: Colors.black, // Title color
      fontWeight: FontWeight.bold, // Bold title
    ),
  ),
  content: Text(
    'Do you really want to exit the app?',
    style: TextStyle(
      fontSize: 16, // Adjusted font size for content
      color: Colors.black54, // Lighter color for content text
    ),
  ),
  actions: [
    Padding(
      padding: const EdgeInsets.only(bottom: 10.0), // Padding at the bottom of the buttons
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true); // User wants to exit
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.white, backgroundColor: AppTheme.primaryColor, // White text color
              padding: EdgeInsets.symmetric(horizontal: 25, vertical: 12), // Button padding
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8), // Rounded corners for the button
              ),
            ),
            child: Text('Yes', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false); // User doesn't want to exit
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.white, backgroundColor: AppTheme.secondryColor, // White text color
              padding: EdgeInsets.symmetric(horizontal: 25, vertical: 12), // Button padding
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8), // Rounded corners for the button
              ),
            ),
            child: Text('No', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    ),
  ],
);

      },
    );
    return shouldExit ?? false;
  },
      child: Scaffold(
        drawer: const AppDrawer(),
         
        body: _dashboardcontroller.dashboardData.isEmpty ? SafeArea(child: Center(child:
        
         Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Center(child: Text("Server Issue ")) , 
            Center(child: ElevatedButton(onPressed: (){
              _dashboardcontroller.fetchUserInfo();
            }, child: const Text("Retry" , style: CustomTextStyle.elevatedButton,)),)
          ],)
         
         
         )) : RefreshIndicator( 
          onRefresh: () {
            return Future(() {
              _dashboardcontroller.fetchOnlineMembers(); 
              _dashboardcontroller.fetchRecomendedMatches();
              _dashboardcontroller.fetchProfileVisitors();
              _dashboardcontroller.fetchRecentlyJoinedMatches();
              _dashboardcontroller.resetAllListsforHome();
      _dashboardcontroller.fetchCountDetails();
      
      
            },);
          },
          child: SingleChildScrollView(
            child: RefreshIndicator( 
              onRefresh: () {
                return _dashboardcontroller.fetchOnlineMembers();
              },
              child: SafeArea(child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only( bottomLeft: Radius.circular(15) , bottomRight: Radius.circular(15)),
                    color: Color.fromARGB(255, 80, 93, 126)),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                         Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                          Builder(
                            builder: (context) {
                              return GestureDetector( 
                                onTap: () {
                                  Scaffold.of(context).openDrawer();
                                },
                                child:  Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                 const CircleAvatar(
                                                      radius: 15, // Adjust the radius as per your requirement
                                                      backgroundColor: Colors.transparent, // Optional: Set a background color
                                                      child: Icon(Icons.menu , color: Colors.white,)
                                                    ),
                                                   const SizedBox(width: 5,) , 
                                                   Text("Hello ${_dashboardcontroller.dashboardData["memberData"]["first_name"]}!" , style: CustomTextStyle.dashboardtitle,), 
                                  ],),
                              );
                            }
                          ), 
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                GestureDetector(
        onTap: () {
      Get.toNamed(AppRouteNames.notificationScreen);
        },
        child: Stack(
      clipBehavior: Clip.none, // Allow the circle to overflow the bounds
      children: [
        CircleAvatar(
          radius: 15, // Adjust the radius as per your requirement
          backgroundColor: Colors.transparent, // Optional: Set a background color
          child: Image.asset(
            "assets/notification.png",
            fit: BoxFit.cover,
            width: 20, // Icon size
            height: 20, // Icon size
          ),
        ),
        // Check if the count for notifications is non-null and greater than 0
        if (_dashboardcontroller .countData["notification"] != null &&
            _dashboardcontroller.countData["notification"] > 0)
          Positioned(
            right: 0,
            top: 0,
            child: Container(
              width: 12, // Reduced size of the red circle
              height: 12, // Reduced size of the red circle
              decoration: BoxDecoration(
                color: Colors.red, // Red color for the circle
                shape: BoxShape.circle, // Circle shape
              ),
              child: Center(
                child: Text(
                  '${_dashboardcontroller.countData["notification"]}', // Display the count (e.g., number of new notifications)
                  style: TextStyle(
                    color: Colors.white, // Text color inside the circle
                    fontSize: 8, // Smaller font size for the count
                    fontWeight: FontWeight.bold, // Make the text bold
                  ),
                ),
              ),
            ),
          ),
      ],
        ),
      ),
      
                     
                              ],)
                         , 
                                       
                         
                         
                          ],), 
                          const SizedBox(height: 5,),
              
                             Divider(  height: 8, color:AppTheme.dividerColor), 
                          const SizedBox(height: 5,),
                           Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                height: 120,
                width: 120,
                child: CircleAvatar(
                  
                  backgroundImage: NetworkImage(
                    "https://jainmatrimonybureau.com/public/storage/images/${_dashboardcontroller.dashboardData["photo"][0]["photo_name"]}"
                  ),
                  // Optionally add a background color
                  backgroundColor: Colors.grey[200], // Default background color if image fails to load
                ),
              )
              
                      , 
                      const SizedBox(width: 8,),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 7,),
                   Row(children: [
                 Text("${_dashboardcontroller.dashboardData["memberData"]["first_name"]} ${_dashboardcontroller.dashboardData["memberData"]["last_name"]}" , style: CustomTextStyle.dashboardtitle.copyWith(fontSize: 16),),  
                 const SizedBox(width: 5,),
                 SizedBox(height: 15, width: 15, child: Image.asset("assets/verified.png"),)       
                   ],),
              Row(children: [
                 Text("Profile ID - ${_dashboardcontroller.dashboardData["memberData"]["member_profile_id"] }" , style: CustomTextStyle.dashboardsubtitle, ) , 
                const SizedBox(width: 5,),
                Container(height: 10, color: Colors.white, width: 1,), 
                const SizedBox(width: 5,) , 
                GestureDetector( 
                  onTap: () {
                    Get.toNamed(AppRouteNames.editProfile);
                  },
                  child: Text("Edit Profile" , style: CustomTextStyle.dashboardsubtitle.copyWith(color: const Color.fromARGB(255, 255, 199, 56)),))
              ],), 
              const SizedBox(height: 8,),
                               Divider(  height: 10, color: AppTheme.dividerColor,), 
                              const SizedBox(height: 8,) , 
                              Text("Your Account - Free Membership" , style: CustomTextStyle.dashboardtitle.copyWith(fontSize: 12),)
                , 
                const SizedBox(height: 10,) , 
                Container( 
                  decoration:  BoxDecoration(
                  color: AppTheme.primaryColor,
              borderRadius: const BorderRadius.all(Radius.circular(20))
                  ),
                  height: 22, 
                  width: 122,
                  child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                   CircleAvatar(
                         
                           radius: 12, // Adjust the radius as per your requirement
                           backgroundColor: Colors.transparent, // Optional: Set a background color
                           child: Image.asset(
                             "assets/premium.png",
                             fit: BoxFit.cover,
                             width: 12, 
                             height: 12, 
                           ),
                         ), 
              
                Text("Upgrade Now" ,style: CustomTextStyle.elevatedButton.copyWith(fontSize: 12),)
              ],),
                )
                , 
              
                
              
                  ],),
              ),
              
                            ],)
                        ],),
                    ),
                  ), 
                     Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10,),
                    
               
                const OnlineMembers(),
              
                const SizedBox(height: 10,) , 
             
                 ProfileScoreCard(memberdata: _dashboardcontroller.dashboardData  ,), 
              const SizedBox(height: 18,),
              
                const RecentVisitors(),
                const SizedBox(height: 18,) , 
                         
               const NewMatches(), 
                  const SizedBox(height: 18,),
              
                    
                 const JustJoinMatches(),
              
                          const SizedBox(height: 20,), 
                        /*  Center(child: Container(
                            height: 355, 
                            width: 321, 
                            
                            child: Card(
                            elevation: 5, 
              
                              
                              color: const Color.fromARGB(255, 245, 245, 245),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: RichText(
                                      textAlign: TextAlign.center,
                                      text: TextSpan(children: <TextSpan>[ 
                                      TextSpan(text: "Upgrade Now  \n & Get Upto " , style: CustomTextStyle.bodytextbold.copyWith(fontSize: 18 , )), 
                                      TextSpan(text: "60% Discount " , style: CustomTextStyle.bodytextbold.copyWith(
                                      
                                        fontSize: 22 , color: const Color.fromARGB(255, 234, 52, 74))), 
                                    
                                    ])),
                                  ), 
                                  SizedBox(height: 10,),
                                  Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Container(
                                      height: 85, 
                                      width: 120,
                                      decoration: BoxDecoration(border: Border(
                                        bottom: BorderSide(width: 1 , color: const Color.fromARGB(255, 80, 93, 126).withOpacity(0.5)),
                                        right: BorderSide(width: 1 , color: const Color.fromARGB(255, 80, 93, 126).withOpacity(0.5))
                                        
                                        )
                                        
                                        ),),
                                  )
                                ],),
                              ),
                          ),)*/
              
              
              
              
              
              
              ],),
                ), 
                
              
                ],)),
            ),
          ),
        )
      ),
    );
  }


}


class OnlineMembers extends StatelessWidget {
  const OnlineMembers({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final DashboardController _dashboardController = Get.find<DashboardController>();
    _dashboardController.fetchOnlineMembers();

    return Obx(() {
      if (_dashboardController.onlineMembersFetching.value) {
        // Display Shimmer effect while fetching data
        return SizedBox(
          height: 130,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 8, // Show 8 shimmer items as placeholders
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(4.0),
                child: Column(
                  children: [
                    Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: CircleAvatar(
                        backgroundColor: Colors.grey[300],
                        radius: 40,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Container(
                        width: 60,
                        height: 15,
                        color: Colors.grey[300],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Container(
                        width: 40,
                        height: 10,
                        color: Colors.grey[300],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      } else {
        // Display actual content after fetching is done
        if(_dashboardController.onlinemembers.length == 0){
return const SizedBox();
        }else{
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
                    const Text("Online Members" , style: CustomTextStyle.title,), 
const SizedBox(height: 10,),
              SizedBox(
          height: 160, // Specify a fixed height for the ListView
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _dashboardController.onlinemembers. length, // Fetch actual number of items
            itemBuilder: (context, index) {
              final member = _dashboardController.onlinemembers[index];
              print("Print this ${member}");
              return GestureDetector(
                onTap: () {
                      Get.toNamed(AppRouteNames.userDetails   , arguments: member["member_id"] );
                },
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Column(
                    children: [
                      Center(
                        child: Stack(
                          children: [
                            CircleAvatar(
                              backgroundImage: NetworkImage(member['photoUrl'] ?? "https://jainmatrimonybureau.com/public/storage/images/download.png"),
                              radius: 40, // Main circle
                            ),
                            Positioned(
                              bottom: 7, // Position it at the bottom-right of the CircleAvatar
                              right: 7,
                              child: Container(
                                width: 10, // Size of the green symbol
                                height: 10,
                                decoration: const BoxDecoration(
                                  color: Color.fromARGB(255, 38, 193, 35), // Green color
                                  shape: BoxShape.circle, // Circular shape
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        member["member_name"], // Replace with actual member name
                        overflow: TextOverflow.ellipsis,
                        style: CustomTextStyle.bodytextbold,
                      ),
                      Text(
                       member["member_profile_id"], // Replace with actual profile ID
                        overflow: TextOverflow.ellipsis,
                        style: CustomTextStyle.bodytext.copyWith(fontSize: 10),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
            ],);
        }
      }
    });
  }
}












class ProfileScoreCard extends StatelessWidget {
  const ProfileScoreCard({
    super.key, this.memberdata,
  });
final dynamic memberdata;
  @override
  Widget build(BuildContext context) {
   
    return Container(
    width: double.infinity, 
    decoration: BoxDecoration(
      
            
      
      borderRadius: const BorderRadius.all(Radius.circular(10) , ) , border: Border.all(color: const Color.fromARGB(255, 234, 52, 74).withOpacity(0.48)) ),
    
    child: Padding(
      padding: const EdgeInsets.all(18.0),
      child: Column(
            children: [
    Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Flexible(
          flex: 6,
          child: Container(
          
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Update Your Profile To Boost Your Profile Visibility" , style: TextStyle(
                  fontSize: 16,
                  fontFamily: "WORKSANS" , fontWeight: FontWeight.w700 , color: Color.fromARGB(255, 5, 28, 60)),)
            , 
            const SizedBox(height: 10,),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
            SizedBox(height: 18, width: 18, child: Image.asset("assets/textbutton.png" , fit: BoxFit.fitHeight,),), 
            const SizedBox(width: 5,) ,
            Text("Basic Information", style: CustomTextStyle.bodytext.copyWith(fontSize: 14 ),)
              ],), 
              const SizedBox(height: 5,),

                   Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
            SizedBox(height: 18, width: 18, child: Image.asset("assets/textbutton.png" , fit: BoxFit.fitHeight,),), 
            const SizedBox(width: 5,) ,
            GestureDetector( 
              
              onTap: () {
               showDialog(context: context,
                builder: (context) {
                  return const CustomDialogue();
                },);
              },
              child: Text("Partner Expectation", style: CustomTextStyle.bodytext.copyWith(fontSize: 13 , color: const Color.fromARGB(255, 234, 52, 74) , fontWeight: FontWeight.w600 ),))
              ],), 
              const SizedBox(height: 5,),
                   Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
            SizedBox(height: 18, width: 18, child: Image.asset("assets/textbutton.png" , fit: BoxFit.fitHeight,),), 
            const SizedBox(width: 5,) ,
            Text("Education Details", style: CustomTextStyle.bodytext.copyWith(fontSize: 13 ),)
              ],), 
              ],),
          )) , 
           Flexible(
          flex: 4,
          child: SizedBox(
            height: 130 ,
    child: Image.asset("assets/expression.png"),
          ))
      ],),
      const SizedBox(height: 10,), 
    Padding(
  padding: const EdgeInsets.all(8.0),
  child: SizedBox(
    height: 10,
    child: LinearProgressIndicator(
      value: (memberdata["IncompleteProfile"]["percentages"]?.toDouble() ?? 50) / 100, // Ensures it's a double
      backgroundColor: Colors.grey.shade300,
      color: Colors.green,
    ),
  ),
),


             Center(
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(children: <TextSpan>[ 
            TextSpan(text: "Your Profile is " , style: CustomTextStyle.bodytext.copyWith(fontSize: 12)), 
             TextSpan(text: "${memberdata["IncompleteProfile"]["percentages"]}%" , style:  CustomTextStyle.bodytextbold.copyWith(fontSize: 12)
             
             ), 
      TextSpan(
      
        text: " Complete.  Finish Your Profile to Enhance Your Visibility!" , style: CustomTextStyle.bodytext.copyWith(fontSize: 12))
      ])),
    )
            ],
      )
    ),
    );
  }
}
class ShortListDialogue extends StatelessWidget {
  const ShortListDialogue({super.key });
  @override
  Widget build(BuildContext context) {
final DashboardController dashboardcontroller =  Get.find<DashboardController>();
    return Dialog(child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(8)),), 
      
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
        Container(
          decoration: BoxDecoration(borderRadius: const BorderRadius.only( topLeft:  Radius.circular(8) , topRight: Radius.circular(8)), 
          
          
          color: const Color.fromARGB(255, 240, 115, 151).withOpacity(0.3),
          ),
          height: 209, width: 329, 
        child: Stack(children: [
    
          SizedBox(height: 180, width: 286, child: Image.asset("assets/popup.png"),), 

          
        ],)
        ), 
     Padding(
       padding: const EdgeInsets.all(18.0),
       child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
             const Padding(
            padding: EdgeInsets.all(8.0),
            child: Center(child: Text(
              textAlign: TextAlign.center,
              "Add to Your Shortlist?" , style: TextStyle(
              fontFamily: "WORKSANS",
              color: Colors.black , fontWeight: FontWeight.w700 , fontSize: 16),),),
          ), 
            const SizedBox(height: 10,), 
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                textAlign: TextAlign.center,
                "Want to save this profile for future reference? Click \"Shortlist\" to add it now, or \"Cancel\" if you want to keep browsing." , style: CustomTextStyle.bodytext,),
            ), 
            const SizedBox(height: 10,),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(child: ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
        backgroundColor: Colors.white , side: const BorderSide(color: Colors.red )  ), 
      onPressed: (){
      Get.back();
    }, child:  const Text("Cancel" , style: CustomTextStyle.elevatedButtonSmallRed,))),
    const SizedBox(width: 10,),
                  Expanded(child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),

                    ),
                    onPressed: (){
                      

                    }, child: const Text("Shortlist" , style: CustomTextStyle.elevatedButtonSmall,))), 

                ],)
            )
        ],),
     )
      ],),
    ),);
  }
}


class CustomDialogue extends StatelessWidget {
  const CustomDialogue({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(8)),), 
      
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
        Container(
          decoration: BoxDecoration(borderRadius: const BorderRadius.only( topLeft:  Radius.circular(8) , topRight: Radius.circular(8)), 
          
          
          color: const Color.fromARGB(255, 240, 115, 151).withOpacity(0.3),
          ),
          height: 209, width: 329, 
        child: Stack(children: [
    
          SizedBox(height: 180, width: 286, child: Image.asset("assets/popup.png"),), 

          
        ],)
        ), 
     Padding(
       padding: const EdgeInsets.all(8.0),
       child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
             const Padding(
            padding: EdgeInsets.all(8.0),
            child: Center(child: Text("Your Profile is Incomplete!!!" , style: TextStyle(
              fontFamily: "WORKSANS",
              color: Colors.black , fontWeight: FontWeight.w700 , fontSize: 16),),),
          ), 
            const SizedBox(height: 10,), 
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                textAlign: TextAlign.center,
                "Verify your profile using ID Proof Document. to assure others you are genuine and get a badge" , style: CustomTextStyle.bodytext,),
            ), 
            const SizedBox(height: 10,),
            Center(
              child: ElevatedButton(onPressed: (){}, child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                Text("Add Partner Expectation" , style: CustomTextStyle.elevatedButton.copyWith(fontSize: 14),), 
                
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: SizedBox(height: 16, width: 16, child: Image.asset(
                    fit: BoxFit.cover,
                    "assets/partnerexpectation.png"),),
                )
              ],)),
            )
        ],),
     )
      ],),
    ),);
  }
}

class RecentVisitors extends StatelessWidget {
  const RecentVisitors({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final DashboardController _dashboardController = Get.find<DashboardController>();
    _dashboardController.fetchProfileVisitors();

    return Obx(() {
      if (_dashboardController.profileVisitorsFetching.value) {
        return SizedBox(
          height: 221,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 8,
            itemBuilder: (context, index) {
              return Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Container(
                    width: 150,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      border: Border.all(
                        color: const Color.fromARGB(255, 80, 93, 127).withOpacity(0.2),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Center(
                            child: CircleAvatar(
                              backgroundColor: Colors.grey,
                              radius: 45,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Center(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 80,
                                  height: 16,
                                  color: Colors.grey,
                                ),
                                const SizedBox(width: 5),
                                SizedBox(
                                  height: 15,
                                  width: 15,
                                  child: Container(color: Colors.grey),
                                )
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                          Center(
                            child: Container(
                              width: 100,
                              height: 12,
                              color: Colors.grey,
                            ),
                          ),
                          Center(
                            child: Container(
                              width: 100,
                              height: 12,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "View Profile",
                                style: TextStyle(color: Colors.red),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      } else {
        if(_dashboardController.profilevisitors.isEmpty){
return const SizedBox();
        }else{

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              
  const Text(
    
    "Profile Visitors" ,style: CustomTextStyle.title,), 
        
          const SizedBox(height: 10,), 
              SizedBox(
          height: 241,
          child:   ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _dashboardController.profilevisitors.length + 1,
            itemBuilder: (context, index) {
            //  print("THis is visitor ${visitor}");
              // Your actual visitor card widget goes here
              if(index < _dashboardController.profilevisitors.length){
              final visitor = _dashboardController.profilevisitors[index];
                return Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () {
             Get.toNamed(AppRouteNames.userDetails   , arguments: {
              "memberID" : visitor["member_id"] 
             } );
                    
                  },
                  child: Container(
                    width: 150,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      border: Border.all(
                        color: const Color.fromARGB(255, 80, 93, 127).withOpacity(0.2),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                           Center(
                            child: CircleAvatar(
                              backgroundImage: NetworkImage(visitor["photoUrl"] ?? "https://jainmatrimonybureau.com/public/storage/images/download.png"),
                              radius: 45,
                            ),
                          ),
                          const SizedBox(height: 10),
                 Center(
  child: RichText(
    maxLines: 2, 
    overflow: TextOverflow.ellipsis,
    textAlign: TextAlign.center,
    text: TextSpan(
      children: [
        TextSpan(
          text: visitor["member_profile_id"],
          style: CustomTextStyle.bodytextbold,
        ),
        WidgetSpan(
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: SizedBox(
              height: 15,
              width: 15,
              child: Image.asset("assets/verified.png"),
            ),
          ),
        ),
      ],
    ),
  ),
),


                          Spacer(),
                          Center(
                            child: Text(
                              "${visitor["age"]} , ${visitor["height"]},",
                              overflow: TextOverflow.ellipsis,
                              style: CustomTextStyle.bodytext.copyWith(fontSize: 12),
                            ),
                          ),
                          Center(
                            child: Text(
                              "${visitor["present_city_name"]}, ${visitor["education"]}",
                              overflow: TextOverflow.ellipsis,
                              style: CustomTextStyle.bodytext.copyWith(fontSize: 12),
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "View Profile",
                                style: CustomTextStyle.textbuttonRed,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
              }else{
 //   final BottomNavController bottomNavController = Get.put(BottomNavController());

                return Padding(
  padding: const EdgeInsets.all(4.0),
  child: GestureDetector(
    onTap: () {
      // Navigate to user details page with member ID
      // Get.toNamed(AppRouteNames.userDetails, arguments: visitor["member_id"]);
      _dashboardController.onItemTapped(2);
_dashboardController.onInboxItemTapped(2);
    },
    child: Stack(
      children: [
        Container(
          width: 150,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            border: Border.all(
              color: const Color.fromARGB(255, 80, 93, 127).withOpacity(0.2),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Add any other content here if needed.
              Center(
                            child: CircleAvatar(
                              backgroundImage: NetworkImage("https://jainmatrimonybureau.com/public/storage/images/download.png"),
                              radius: 45,
                            ),
                          ),
              ],
            ),
          ),
        ),
        // Full overlay
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.7), // Dark overlay with opacity
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                "See More",
                style: CustomTextStyle.bodytextbold.copyWith(
                  color: AppTheme.primaryColor,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ),
      ],
    ),
  ),
);

              }
            },
          ),
        )
            ],);
        }
      }
    });
  }
}*/
