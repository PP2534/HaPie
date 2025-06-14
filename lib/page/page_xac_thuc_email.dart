import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hapie/controller/auth_controller.dart';
import 'package:hapie/helper/layout_check_internet.dart';

class PageXacThucEmail extends StatelessWidget{
  final String email ;
  PageXacThucEmail({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    return LayoutCheckInternet(
        child: GetBuilder(
          id: "auth",
          init: AuthController.get(),
          builder: (controller) {
            final _formKey = GlobalKey<FormState>();
            // print("check em: ${controller.email_xac_thuc}");
            return Scaffold(
              body: Center(
                child: Container(
                  child: Padding(
                    padding: EdgeInsets.only(left: 20, right: 20),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("HaPie", style: TextStyle(
                              fontSize: 60, fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor
                          ),),
                          SizedBox(height: 45,),
                          Text("Bạn cần xác thực email", style: TextStyle(
                              fontSize: 27, fontWeight: FontWeight.bold
                          ),),
                          SizedBox(height: 5,),
                          Text("${email}", style: TextStyle(fontSize: 16),),
                          SizedBox(height: 15,),
                          // if(controller.message.isNotEmpty)Text(controller.message, style: TextStyle(color: Colors.red),),

                          SizedBox(height: 25,),
                          controller.isLoading?CircularProgressIndicator():
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                    onPressed: () {
                                      if (_formKey.currentState!.validate()) {
                                        controller.xacThucEmail(email);
                                      }
                                    },
                                    child: Text("Xác thực ngay", style: TextStyle(
                                        fontSize: 20
                                    ),)
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        )
    );
  }
}
