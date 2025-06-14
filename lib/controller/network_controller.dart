import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class NetworkController extends GetxController{
  var coInternet = true;
  var changeInternet = false;
  var internetChecking = false;
  Timer? _timer;

  static NetworkController get() => Get.find();
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    Connectivity().onConnectivityChanged.listen((result) async{
      // changeInternet = true;
      await checkInternet(); //Khi có thay đổi internet thì thử kiểm tra
      // chayCheckInternet();
      // print("day");
    });
    //sau 5s thì nó sẽ kiểm tra co Online hay ko
    _timer = Timer.periodic(Duration(seconds: 5), (timer) {
      if(!coInternet){
      checkInternet();
      }
    },);
    // _timer = Timer.periodic(Duration(seconds: 5), (timer) => checkInternet(),);
  }

  void chayCheckInternet(){
    _timer?.cancel();
    _timer = Timer.periodic(Duration(seconds: coInternet?30:5), (timer) => checkInternet(),);
    // print("o day ${coInternet}");
  }

  Future<void> checkInternet() async{
    try{
      if(!coInternet){
        internetChecking = true;
        update(["internet"]);
      }
      final response = await http.get(Uri.parse('https://www.google.com/generate_204')).timeout(Duration(seconds: 5));
      coInternet= response.statusCode==204;
    }
    catch(e){
      coInternet = false;
      changeInternet = true;
    }
    finally{
      await Future.delayed(Duration(seconds: 2), () async{
        internetChecking = false;
        update(["internet"]);
        if(changeInternet && coInternet){
          await Future.delayed(Duration(seconds: 2), () {
            changeInternet = false;
            print("check internet - new: ${coInternet}");
            update(["internet"]);
          },);
        }
        else{
          // changeInternet = false;
          print("check internet: ${coInternet}");
          update(["internet"]);
        }
      },);
    }
  }
}