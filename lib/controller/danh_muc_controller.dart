import 'dart:async';

import 'package:get/get.dart';
import 'package:hapie/model/danh_muc_model.dart';


class ControllerDanhMuc extends GetxController{
  var danhmucs = <DanhMuc>[];
  bool? currentFilter; // null: tất cả, true: thu, false: chi
  late StreamSubscription ss;

  List<DanhMuc> get filteredDanhmucs {
    if (currentFilter == null) return danhmucs;
    return danhmucs.where((e) => e.loai_danh_muc == currentFilter).toList();
  }

  void setFilter(bool? filter) {
    currentFilter = filter;
    update(['danhmucs']);
  }
  static ControllerDanhMuc get() => Get.find();
  // @override
  // void onReady() {
  //   // TODO: implement onReady
  //   super.onReady();
  //   load_danh_muc();
  // }
  load_danh_muc()
  {
    ss = DanhMucSnapShot.getDanhMucStream().listen((data) {
      danhmucs = data;
      // print("Nhận được ${danhmucs.length} mục từ Supabase");
      for (var dm in danhmucs) {
        // print("Danh mục: ${dm.toJson()}");
      }
      update(["danhmucs"]);
    });
  }
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    load_danh_muc();
  }
  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
    ss.cancel();
  }

}
class BindingAppDanhMuc extends Bindings {

  @override
  void dependencies() {
    Get.lazyPut(() => ControllerDanhMuc(),);
  }
}
