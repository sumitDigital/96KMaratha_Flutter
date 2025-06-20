/*
class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin{
  NotificationServices _notificationServices = NotificationServices();
  double _rotation = 0.0;
  Timer? _timer;
  late AnimationController _controller;
  late AnimationController _controller1;

  late Animation<Offset> _slideAnimation;
  late Animation<double> _heartbeatAnimation;
  @override
  void initState() {
    super.initState();
    _startRotation();
       _controller = AnimationController(
      duration: Duration(seconds: 1), // Heartbeat duration
      vsync: this,
    )..repeat(reverse: true); // Repeats the heartbeat animation

    _heartbeatAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    // Animation for sliding the static image from the right
    _controller1 = AnimationController(
      duration: Duration(seconds: 1), // Duration of the slide
      vsync: this,
    )..forward(); // Play the animation only once

    _slideAnimation = Tween<Offset>(begin: Offset(1.0, 0.0), end: Offset.zero).animate(
      CurvedAnimation(parent: _controller1, curve: Curves.easeInOut),
    );
    // Start the splash screen image display timer
    Future.delayed(Duration(seconds: 3), () {
      handleSplashScreenEnd();
    });
  }

  void handleSplashScreenEnd() {
    _notificationServices.firebaseInit(context);
    _notificationServices.setupInteractMessage(context);
    _initDeepLinkListener();

  /*  _notificationServices.getDeviceToken().then((value) {
      print("Device token: $value");
    });*/

    // Ensure navigation happens after the current frame is done
    Future.delayed(Duration.zero, () {
      checkUserTokenAndNavigate();
    });
  }
  void _startRotation() {
    _timer = Timer.periodic(Duration(milliseconds: 20), (timer) {
      setState(() {
        _rotation += 0.05;
        if (_rotation >= 360) {
          _rotation = 0;
        }
      });
    });
  }
  Future<void> checkUserTokenAndNavigate() async {
    String? pageIndex = sharedPreferences?.getString("PageIndex");
    String? token = sharedPreferences?.getString("token");

    if (token == null) {
      // If no token, navigate to the welcome screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => WelcomeScreen()),
      );
    } else {
      // Navigate based on page index
      switch (pageIndex) {
        case "1":
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const RegisterOTPScreen()),
          );
          break;
        case "2":
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const UserInfoStepOne()),
          );
          break;
        case "3":
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const UserInfoStepTwo()),
          );
          break;
        case "4":
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const UserInfoStepThree()),
          );
          break;
        case "5":
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const UserInfoStepFour()),
          );
          break;
        case "6":
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const UserInfoStepFive()),
          );
          break;
        case "7":
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const UserInfoStepSix()),
          );
          break;
        case "8":
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const BottomNavBar()),
          );
          break;
        case "9":
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const UpgradePlan()),
          );
          break;
        default:
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => WelcomeScreen()),
          );
          break;
      }
    }
  }
    String? pageIndex = sharedPreferences?.getString("PageIndex");

void _initDeepLinkListener() async {
  try {
    // Listen for incoming links
    Uri? initialLink = await AppLinks().getInitialLink();
    if (initialLink != null) {
      print('Initial link: ${initialLink.toString()}');
    
    String? token = sharedPreferences?.getString('token'); // replace 'token' with your key
    

      // Check if the path matches the format and extract the last segment
   if(token == null){
   navigatorKey.currentState!.pushReplacement(
            MaterialPageRoute(
              builder: (context) => WelcomeScreen()
            ),
          );
   }{
   if(pageIndex == "8"){
    if (initialLink.pathSegments.length > 0 && initialLink.path.startsWith("/home/member-detail")) {
        String lastSegment = initialLink.pathSegments.last;
print("THIS IS LAST ${lastSegment}");
        // Convert the last segment to an integer if it's a valid number
        int? memberId = int.tryParse(lastSegment);
        print("THIS IS LAST me ${memberId}");
        if (memberId != null) {
          navigatorKey.currentState!.pushReplacement(
            MaterialPageRoute(
              builder: (context) => UserDetails(memberid: memberId, notificationID: 0),
            ),
          );
        } else {
          print('Error: Last segment is not a valid number');
        }
      }else
      if(initialLink.path == "/home/profile"){
            navigatorKey.currentState!.pushReplacement(
            MaterialPageRoute(
              builder: (context) => const EditProfile()
            ),
          );
      }
     
         else    if(initialLink.path == "/home/edit/family"){
            navigatorKey.currentState!.pushReplacement(
            MaterialPageRoute(
              builder: (context) => const EditFamilyDetailsScreen()
            ),
          );
      }
      else    if(initialLink.path == "/home/edit/spiritual"){
            navigatorKey.currentState!.pushReplacement(
            MaterialPageRoute(
              builder: (context) => const EditSpiritualDetailsScreen()
            ),
          );
      }
        else    if(initialLink.path == "/home/edit/lifestyle"){
            navigatorKey.currentState!.pushReplacement(
            MaterialPageRoute(
              builder: (context) => const EditLifestyleDetails()
            ),
          );
      }
           else    if(initialLink.path == "/home/edit/introduction"){
            navigatorKey.currentState!.pushReplacement(
            MaterialPageRoute(
              builder: (context) => const EditAboutMeScreen()
            ),
          );
      }
      // jain_demo/home/edit/personalinfo
     else    if(initialLink.path == "/home/edit/personalinfo"){
            navigatorKey.currentState!.pushReplacement(
            MaterialPageRoute(
              builder: (context) => const EditPersonalInfoScreen()
            ),
          );
      }
       else    if(initialLink.path == "/home/addon-plan"){
            navigatorKey.currentState!.pushReplacement(
            MaterialPageRoute(
              builder: (context) => const Addonplan()
            ),
          );
      }
       
        else    if(initialLink.path == "/home/plan"){
            navigatorKey.currentState!.pushReplacement(
            MaterialPageRoute(
              builder: (context) => const UpgradePlan()
            ),
          );
      }
       else    if(initialLink.path == "/home/edit/basic-info"){
            navigatorKey.currentState!.pushReplacement(
            MaterialPageRoute(
              builder: (context) => const EditBasicInfoScreen()
            ),
          );
      }
   }else{
     
   }
   }
    }
  } catch (e) {
    print('Error handling deep link: $e');
  }
}

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    _controller1.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryColor,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Rotating logo with heartbeat animation
            CircleAvatar(
  backgroundColor: Colors.white,
  radius: 40,
  child: ScaleTransition(
    scale: _heartbeatAnimation, // Scale transition applied to the CircleAvatar
    child: Container(
      alignment: Alignment.center, // Ensures proper alignment
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform(
            transform: Matrix4.rotationY(_rotation), // Rotating transition for the image
            alignment: Alignment.center,
            child: child,
          );
        },
        child: Image.asset(
          "assets/logodesign.png",
          height: 200,
          width: 150,
        ),
      ),
    ),
  ),
),
            // Static image sliding from the right side of the screen
            SlideTransition(
              position: _slideAnimation,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                child: Image.asset(
                  'assets/logoname.png',
                  fit: BoxFit.cover,
                  height: 110,
                  width: double.infinity,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
*/
