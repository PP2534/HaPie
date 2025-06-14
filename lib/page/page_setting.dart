import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:hapie/controller/auth_controller.dart';
import 'package:hapie/controller/profile_controller.dart';
import 'package:hapie/page/page_layout_app.dart';
import 'package:hapie/helper/supabase_helper.dart';
import 'package:hapie/model/profile_model.dart';
import 'package:hapie/page/page_change_password.dart';
import 'package:hapie/page/page_change_theme.dart';
import 'package:hapie/page/page_check_auth.dart';
import 'package:hapie/page/page_danh_muc.dart';
import 'package:hapie/page/page_login.dart';
import 'package:hapie/page/page_profile_chi_tiet.dart';

Widget PageSetting() {
  if (box.read("login")) {
    return GetBuilder(
      id: "profile",
      init: ProfileController.get(),
      builder: (controller) {
        Profile user = controller.user;
        return Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              Center(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 70,
                      backgroundColor: Theme.of(mycontext).primaryColor,
                      child: ClipOval(
                        child: user.url_avatar == null
                            ? Image.asset("assets/images/hapie_user.png",width: 140,
                          height: 140,
                          fit: BoxFit.cover,)
                            : Image.network(user.url_avatar!,loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Center(child: CircularProgressIndicator(),);
                            },
                          width: 140,
                          height: 140,
                          fit: BoxFit.cover,
                        ),
                      ),

                    ),
                    TextButton(onPressed: () {
                      Get.to(PageProfileChiTiet(), binding: ProfileBinding());
                    }, child: Text("Chào, ${user.ho_ten}", style: TextStyle(fontSize: 15),)),
                  ],
                ),
              ),
              SizedBox(height: 20),
              FilledButton(
                style: ButtonStyle(
                  shadowColor: WidgetStatePropertyAll(Colors.transparent),
                  backgroundColor: WidgetStatePropertyAll(Colors.transparent),
                ),
                onPressed: () {
                  Get.to(PageProfileChiTiet(), binding: ProfileBinding());
                },
                child: Row(
                  children: [
                    Icon(Icons.person),
                    SizedBox(width: 10,),
                    Text("Thông tin cá nhân", style: TextStyle(fontSize: 18)),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 25, right: 25),
                child: Divider(),
              ),
              FilledButton(
                style: ButtonStyle(
                  shadowColor: WidgetStatePropertyAll(Colors.transparent),
                  backgroundColor: WidgetStatePropertyAll(Colors.transparent),

                ),
                onPressed: () {
                  Get.to(PageChangePassword());
                },
                child: Row(
                  children: [
                    Icon(Icons.password),
                    SizedBox(width: 10,),
                    Text("Đổi mật khẩu", style: TextStyle(fontSize: 18)),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 25, right: 25),
                child: Divider(),
              ),
              FilledButton(
                style: ButtonStyle(
                  shadowColor: WidgetStatePropertyAll(Colors.transparent),
                  backgroundColor: WidgetStatePropertyAll(Colors.transparent),
                ),
                onPressed: () {
                  Get.to(PageHomeDanhMuc());
                },
                child: Row(
                  children: [
                    Icon(Icons.category),
                    SizedBox(width: 10,),
                    Text("Quản lý danh mục", style: TextStyle(fontSize: 18)),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 25,right: 25),
                child: Divider(),
              ),
            FilledButton(
              style: ButtonStyle(
                shadowColor: MaterialStateProperty.all(Colors.transparent),
                backgroundColor: MaterialStateProperty.all(Colors.transparent),
              ),
              onPressed: () {
                Get.to(PageChangeTheme());
                // controller.toggleDarkMode();
              },
              child: Row(
                children: [
                  Icon(user.theme_mode=="dark" ? Icons.light_mode : Icons.dark_mode),
                  SizedBox(width: 10),
                  Text(
                    "Giao diện",
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
            ),
              Spacer(),
              ElevatedButton(
                onPressed: () {
                  AuthController.get().logout();
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Đăng xuất", style: TextStyle(fontSize: 18)),
                    SizedBox(width: 10,),
                    Icon(Icons.logout),
                  ],
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }
  return Padding(
    padding: const EdgeInsets.only(left: 25, right: 25, top: 8),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Bạn chưa đăng nhập, vui lòng đăng nhập để tiếp tục sử dụng!",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        Spacer(),
        ElevatedButton(
          onPressed: () {
            Get.offAll(PageLogin(), binding: AuthBinding());
          },
          child: Text(
            "Đăng nhập",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(height: 20),
      ],
    ),
  );
}
