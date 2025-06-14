import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hapie/controller/layout_app_controller.dart';
import 'package:hapie/controller/network_controller.dart';
import 'package:hapie/controller/profile_controller.dart';
import 'package:hapie/page/page_layout_app.dart';
import 'package:hapie/helper/layout_check_internet.dart';
import 'package:hapie/helper/supabase_helper.dart';
import 'package:hapie/model/giao_dich_model.dart';
import 'package:hapie/model/profile_model.dart';
import 'package:hapie/page/page_add_profile.dart';
import 'package:hapie/page/page_login.dart';
import 'package:hapie/page/page_welcome.dart';
import 'package:hapie/widgets/app_widget.dart';
import 'package:hapie/widgets/widget_function.dart';
Timer? _timer;
final box = GetStorage();
Profile? user = ProfileSnapshot.user;
bool fill_input = false;

class PageCheckAuth extends StatefulWidget {
  bool xacthuc ;
  PageCheckAuth({super.key, this.xacthuc=false});
  @override
  State<PageCheckAuth> createState() => _PageCheckAuthState();

}

class _PageCheckAuthState extends State<PageCheckAuth> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    xuLyChuyenHuong(widget.xacthuc);
    _timer = Timer.periodic(Duration(seconds: 10), (timer) {
      print("Đang xử lý chuyển hướng lại!");
      xuLyChuyenHuong(widget.xacthuc);
    },);
;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutCheckInternet(
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // SizedBox(height: 200,),
              Image.asset("assets/images/logo_hapie.png", height: 200,),
              SizedBox(height: 20,),
              Text("HaPie", style: TextStyle(
                  fontSize: 50,
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold
              ),),
              SizedBox(height: 30,),
              Text("Theo dõi chi tiêu, làm chủ tài chính", style: TextStyle(color: Color(0xFF444444)),),
              SizedBox(height: 15,),
              Padding(
                padding: const EdgeInsets.only(left: 50, right: 50),
                child: LinearProgressIndicator(),
              ),
              // Spacer(),
              GetBuilder(
                id: "internet",
                init: NetworkController.get(),
                builder: (controller) {

                  return Column(
                    children: [
                      if(!controller.coInternet)
                        SizedBox(height: 30,),
                      Text("${!controller.coInternet?"Vui lòng kết nối internet để tiếp tục.":""}",style: TextStyle(color: Colors.red),),
                    ],
                  );
                },
              ),

              // Text("Đang tải...",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
              SizedBox(height: 90,)
            ],
          ),
        ),
      ),
    );
  }
}


Future<void> xuLyChuyenHuong(bool xacthuc) async{
  await Future.delayed(Duration(seconds: 1));
  bool lan_dau_vao_app = box.read("lan_dau_tien")??true;
  box.write("lan_dau_tien", false);
  print("Page check auth");
  if(lan_dau_vao_app){
    Get.offAll(PageWelcome());
  }
  else {

    final session = supabase.auth.currentSession;
    if (session != null) {
      var checkProfile = await ProfileSnapshot.checkProfile();
      _timer?.cancel();
      // print("CP: ${checkProfile.length}");
      if(!checkProfile){
        Get.offAll(PageAddProfile());
      }
      else{

        box.write("email", supabase.auth.currentUser!.email);
        //Mở command để kích hoạt bảo mật
        if(!xacthuc) {
          box.write("login", false);
        }
        else box.write("login", true);
        // box.write("login", true);

        // ProfileSnapshot.load_data_Profile();

        Get.offAll(LayoutApp(), binding: LayoutAppBinding());
      }
    } else {

      _timer?.cancel();
      Get.offAll(PageWelcome());
      Get.to(PageLogin());
      // box.write("lan_dau_tien", true);
    }
  }
}