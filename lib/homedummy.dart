/*
class HomeDummy extends StatefulWidget {
  const HomeDummy({super.key});

  @override
  State<HomeDummy> createState() => _HomeDummyState();
}

class _HomeDummyState extends State<HomeDummy> {
  NotificationServices _notificationServices = NotificationServices();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _notificationServices.requestNotificationPermission();
        
   _notificationServices.firebaseInit(context);
   _notificationServices.setupInteractMessage(context);
    _notificationServices.getDeviceToken().then((value) {
      print("Device token ${value}");
    },);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: Column(children: [
        Text("Text 1 23")
      ],)),
    );
  }
}*/
