import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hapie/controller/auth_controller.dart';
import 'package:hapie/controller/giao_dich_controller.dart';
import 'package:hapie/controller/layout_app_controller.dart';
import 'package:hapie/helper/layout_check_internet.dart';
import 'package:hapie/page/page_them_giao_dich.dart';

late BuildContext mycontext;
late List<String> ds_tuan = ["Thứ hai", "Thứ ba", "Thứ tư", "Thứ năm", "Thứ sáu", "Thứ bảy", "Chủ nhật"];
class LayoutApp extends StatefulWidget {
  const LayoutApp({super.key});

  @override
  State<LayoutApp> createState() => _LayoutAppState();
}

class _LayoutAppState extends State<LayoutApp> {
  @override
  Widget build(BuildContext context) {
    mycontext = context;
    return LayoutCheckInternet(
        child: GetBuilder(
          id: "layout_app",
          init: LayoutAppController.get(),
          builder: (controller) {
            return
              GetBuilder(
                id: "auth",
                init: AuthController.get(),
                builder: (auth_controller) {
                  return auth_controller.isLoading?Scaffold(
                    body: Center(child: CircularProgressIndicator()),
                  ): Scaffold(
                      appBar: AppBar(
                        title: Row(
                          children: [
                            controller.index==0?Image.asset("assets/images/logo_hapie.png",height: 30,):Text(""),
                            controller.index==0?SizedBox(width: 10,):Text(""),
                            Text(controller.textAppbar),
                          ],
                        ),
                        // backgroundColor: Theme.of(context).colorScheme.inversePrimary,
                      ),
                      body: controller.body,

                      floatingActionButton: controller.floatingButton?FloatingActionButton(
                        onPressed: () {
                          Get.to(PageThemGiaoDich(),);
                        },
                        child: Icon(Icons.add),
                      ):null,
                      bottomNavigationBar:BottomNavigationBar(
                        backgroundColor: Theme.of(context).bottomAppBarTheme.color,
                        currentIndex: controller.index,
                        selectedItemColor: Theme.of(context).primaryColor,
                        unselectedItemColor: Colors.grey,
                        type: BottomNavigationBarType.fixed,
                        items:[
                          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Tổng quan"),
                          BottomNavigationBarItem(icon: Icon(Icons.monetization_on_outlined), label: "Sổ giao dịch"),
                          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: "Thống kê"),
                          BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Cài đặt"),
                        ],
                        onTap: (value){
                          controller.Change_Page(value);
                        },
                      )
                  );
                },
              );
          },
        )
    );
  }
}
