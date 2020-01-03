import 'package:connectivity/connectivity.dart';

class CheckInternetState
{
   Future<bool> check()async
  {
    bool state = true;
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      print("Connected to Mobile Network");
    } else if (connectivityResult == ConnectivityResult.wifi) {
      print("Connected to WiFi");
    } else {
      state=false;
    }
    return state;
  }
}