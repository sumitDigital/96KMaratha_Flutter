// import 'package:connectivity_plus/connectivity_plus.dart';
/*
class NetworkController extends GetxController{
  final Connectivity _connectivity = Connectivity();
  List<ConnectivityResult> _connectionStatus = [ConnectivityResult.none];
  RxBool hasInternet = false.obs;
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  void _updateConnectionStatus(List<ConnectivityResult> connectivityresult) async{
_connectionStatus = connectivityresult;
  print("Connectivity is ${_connectionStatus}");
await checkInternetConnection();


  }

  void initiConnectivity() async{
    late List<ConnectivityResult> result;

    try {
      result = await _connectivity.checkConnectivity();
    } catch (e) {
      print("Error in network ${e}");
    }

  return _updateConnectionStatus(result);

  }

   Future<void> checkInternetConnection() async {
    bool internetAvailable = await _isInternetAvailable();
    hasInternet.value = internetAvailable;
    print("Internet available: ${hasInternet.value}");
  }

    Future<bool> _isInternetAvailable() async {
    try {
      // Ping Google's primary DNS to check for internet access
      final response = await http.get(Uri.parse('https://google.com')).timeout(Duration(seconds: 5));
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print("No internet connection: $e");
      return false;
    }
  }
  
  }*/
