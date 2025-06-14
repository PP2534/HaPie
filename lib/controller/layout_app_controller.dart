import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:hapie/controller/auth_controller.dart';
import 'package:hapie/controller/home_controller.dart';
import 'package:hapie/controller/profile_controller.dart';
import 'package:hapie/controller/thong_ke_controller.dart';
import 'package:hapie/page/page_layout_app.dart';
import 'package:hapie/model/profile_model.dart';
import 'package:hapie/page/page_check_auth.dart';
import 'package:hapie/page/page_home.dart';
import 'package:hapie/page/page_login.dart';
import 'package:hapie/page/page_setting.dart';
import 'package:hapie/page/page_so_giao_dich.dart';
import 'package:hapie/page/page_thong_ke.dart';
import 'package:hapie/page/page_welcome.dart';
import 'package:hapie/widgets/widget_function.dart';

import 'giao_dich_controller.dart';

class LayoutAppController extends GetxController{
  late int index;
  late Widget body;
  late bool floatingButton;
  late String textAppbar;
  // RxBool isDarkMode = false.obs;
  // final ThemeController themeController = Get.find<ThemeController>();
  static LayoutAppController get() => Get.find();

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    index = 0;
    body = PageHome();
    floatingButton = true;
    textAppbar = "HaPie";

  }

  void Change_Page(int value) async{
    index = value;
    if(value == 0){
      body = PageHome();
      floatingButton = true;
      textAppbar = "HaPie";
    }
    else if(value == 1){
      if(box.read("login")){
        body = PageSoGiaoDich();
        floatingButton = true;
        textAppbar = "Sổ giao dịch";
      }
      else{
        await showConfirmDialogOneButtonFailed(mycontext, "Bạn vui lòng đăng nhập để tiếp tục sử dụng tính năng này!", title: "Bạn cần đăng nhập", buttonText: "Chấp nhận", );
        Get.offAll(PageWelcome());
        Get.to(PageLogin());
      }
    }
    else if(value == 2){
      if(box.read("login")){
        body = PageThongKe();
        floatingButton = false;
        textAppbar = "Thống kê";
      }
      else{
        await showConfirmDialogOneButtonFailed(mycontext, "Bạn vui lòng đăng nhập để tiếp tục sử dụng tính năng này!", title: "Bạn cần đăng nhập", buttonText: "Chấp nhận", );
        Get.offAll(PageWelcome());
        Get.to(PageLogin());
      }
    }
    else if(value == 3){
      body = PageSetting();
      floatingButton = false;
      textAppbar = "Cài đặt";
    }
    else{
      body = Center(child: Text("???"),);
    }
    update(["layout_app"]);
  }
  // Future<void> loadUserProfile() async {
  //   try {
  //     final profile = await ProfileSnapshot.getUser();
  //     // isDarkMode.value = profile.dark_them ?? false;
  //     ThemeController.get().setTheme(profile.dark_them??false);
  //   } catch (e) {
  //     print("Lỗi loadUserProfile: $e");
  //     // // Xử lý dự phòng, ví dụ dùng giá trị mặc định
  //     // isDarkMode.value = false;
  //     ThemeController.get().setTheme(false);
  //   }
  // }



}

class LayoutAppBinding extends Bindings{
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut(()=> LayoutAppController());
    if(box.read("login")){
      Get.lazyPut(()=>ProfileController());
    }
    Get.lazyPut(()=> AuthController());
    Get.lazyPut(() => GiaoDichController(),fenix: true);
    Get.lazyPut(() => HomeController());
    Get.lazyPut(() => ThongKeController());
  }
}