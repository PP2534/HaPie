import 'dart:async';

import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class OTPController extends GetxController{
  final supabase = Supabase.instance.client;
  static OTPController get() => Get.find();
  late String min = "07", second = "00";
  late int demNguoc = 420;
  Timer? _timer;

  void chayDemNguoc(){
    _timer?.cancel();
    demNguoc = 420;
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if(demNguoc> 0){
        demNguoc--;
        int phut = demNguoc~/60;
        min = phut<10?"0${phut}":"${phut}";
        second = demNguoc%60<10?"0${demNguoc%60}":"${demNguoc%60}";
      }
      else{
        timer.cancel();
      }
      update(["otp", "auth"]);
      print("${demNguoc}");
    },);
  }


  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    chayDemNguoc();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
    _timer?.cancel();
  }
}

// class OTPBinding extends Bindings{
//   @override
//   void dependencies() {
//     // TODO: implement dependencies
//     Get.lazyPut(()=> OTPController(),fenix: true);
//   }
// }