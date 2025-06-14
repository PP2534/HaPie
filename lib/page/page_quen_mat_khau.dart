import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hapie/controller/auth_controller.dart';
import 'package:hapie/helper/layout_check_internet.dart';
import 'package:hapie/page/page_register.dart';

class PageQuenMatKhau extends StatelessWidget {
  const PageQuenMatKhau({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController txtEmail = TextEditingController();
    return LayoutCheckInternet(
        child: GetBuilder(
          init: AuthController.get(),
          id: "auth",
          builder: (controller) {
            final _formKey = GlobalKey<FormState>();
            return Scaffold(
              appBar: AppBar(
                title: Text("Khôi phục mật khẩu"),
              ),
              body: SingleChildScrollView(
                child: Center(
                  child: Container(
                    child: Padding(
                      padding: EdgeInsets.only(left: 20, right: 20),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          // crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(height: 60,),
                            Text("HaPie", style: TextStyle(
                                fontSize: 60, fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor
                            ),),
                            SizedBox(height: 60,),
                            Text("Quên mật khẩu", style: TextStyle(
                                fontSize: 33, fontWeight: FontWeight.bold
                            ),),
                            SizedBox(height: 10,),
                            Text("Vui lòng cung cấp địa chỉ email đã đăng ký tài khoản để xác thực danh tính", textAlign: TextAlign.center, style: TextStyle(fontSize: 15),),
                            // SizedBox(height: 5,),
                            // if(controller.message.isNotEmpty)Text(controller.message, style: TextStyle(color: Colors.red),),
                            SizedBox(height: 35,),
                            TextFormField(
                              controller: txtEmail,
                              decoration: InputDecoration(
                                labelText: "Email",
                                hintText: "Nhập email....",
                              ),
                              validator: (value) {
                                if(value == null || value.trim().isEmpty){
                                  return "Vui lòng nhập email";
                                }
                                if(!GetUtils.isEmail(value.trim())){
                                  return "Email không hợp lệ";
                                }
                                return null;
                              },
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              keyboardType: TextInputType.emailAddress,
                
                            ),
                            SizedBox(height: 25,),
                            controller.isLoading?CircularProgressIndicator():
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                      onPressed: () {
                                        if (_formKey.currentState!.validate()) {
                                          controller.resetPassword(txtEmail.text.trim());
                                        }
                                      },
                                      child: Text("Xác nhận", style: TextStyle(
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
              ),
            );
          },

        )
    );
  }
}
