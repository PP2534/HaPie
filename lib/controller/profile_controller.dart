//cho việc hiển thị và sửa profile
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hapie/model/profile_model.dart';
import 'package:hapie/page/page_check_auth.dart';
import 'package:hapie/page/page_layout_app.dart';
class ProfileController extends GetxController{
  late Profile user;
  late bool hienSoDu;
  late bool loading;
  static ProfileController get() => Get.find();

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    hienSoDu = false;
    user = ProfileSnapshot.user!;
    setTheme();
  }
  void changeHienSoDu() async{
    hienSoDu = !hienSoDu;
    update(["profile"]);
  }

  Future<void> reset_data() async{
    await ProfileSnapshot.resetdata();
  }

  void loadUser() async{
    user = await ProfileSnapshot.getUser();
  }

  void setTheme() {
    if(user.theme_mode=="dark"){
      Get.changeThemeMode(ThemeMode.dark);
      fill_input = true;
    }
    else if(user.theme_mode=="light"){
      Get.changeThemeMode(ThemeMode.light);
      fill_input = false;
    }
    else{
      Get.changeThemeMode(ThemeMode.system);
      fill_input = MediaQuery.of(mycontext).platformBrightness == Brightness.dark;
    }
    box.write("dark_them", user.theme_mode);
  }

  Future<void> toggleDarkMode(String mode) async {
    user.theme_mode = mode;
    await ProfileSnapshot.update(user);
    setTheme();
    update(["profile"]);
    // print("sd ${user.dark_them}");
  }
}

class ProfileBinding extends Bindings{
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut(()=> ProfileController());
  }
}