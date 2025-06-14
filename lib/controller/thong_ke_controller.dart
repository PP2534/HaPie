import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:hapie/model/giao_dich_model.dart';


class ThongKeController extends GetxController {
  static ThongKeController get() => Get.find();
  Stream<List<Map<String, dynamic>>> get thuChi12ThangStream =>
      GiaoDichSnapshot.getThuChiTrong12Thang();


  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();

  }
}

class ThongKeBinding extends Bindings{
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut(()=>ThongKeController());
  }

}