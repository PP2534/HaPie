import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hapie/controller/auth_controller.dart';
import 'package:hapie/helper/layout_check_internet.dart';
import 'package:hapie/main.dart';
import 'package:hapie/page/page_login.dart';
import 'package:hapie/page/page_register.dart';

class PageWelcome extends StatelessWidget {
  const PageWelcome({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutCheckInternet(
        child: Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height*1/6,),
                  Image.asset("assets/images/logo_hapie.png", height: 200,),
                  Text("HaPie", style: TextStyle(
                    fontSize: 60,
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold
                  ),),
                  SizedBox(height: 120,),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                            onPressed: () {
                              Get.to(PageLogin(), binding: AuthBinding());
                            },
                            child: Text("Đăng nhập", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),)
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 15,),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            Get.to(PageRegister(), binding: AuthBinding());
                          },
                          child: Text("Đăng ký", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),)
                        ),
                      )
                    ],
                  ),

                ],
              ),
            ),
          ),
        )
    );
  }
}
