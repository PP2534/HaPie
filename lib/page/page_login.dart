import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hapie/controller/auth_controller.dart';
import 'package:hapie/helper/layout_check_internet.dart';
import 'package:hapie/page/page_check_auth.dart';
import 'package:hapie/page/page_register.dart';
import 'package:hapie/page/page_quen_mat_khau.dart';
import 'package:hapie/widgets/widget_function.dart';
import 'page_xac_thuc_email.dart';

class PageLogin extends StatelessWidget {
  PageLogin({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController txtEmail = TextEditingController(text: box.read("email"));
    TextEditingController txtPassword = TextEditingController();
    return LayoutCheckInternet(
        child: GetBuilder(
          init: AuthController.get(),
          id: "auth",
          builder: (controller) {
            final _formKey = GlobalKey<FormState>();
            return Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.transparent,
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
                          children: [
                            SizedBox(height: 60,),
                            Text("HaPie", style: TextStyle(
                                fontSize: 60, fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor
                            ),),
                            SizedBox(height: 45,),
                            Text("Đăng nhập", style: TextStyle(
                                fontSize: 27, fontWeight: FontWeight.bold
                            ),),
                            SizedBox(height: 5,),
                            // if(controller.message.isNotEmpty)Text(controller.message, style: TextStyle(color: Colors.red),),
                            SizedBox(height: 20,),
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
                            SizedBox(height: 18,),
                            TextFormField(
                              controller: txtPassword,
                              decoration: InputDecoration(
                                labelText: "Mật khẩu",
                                hintText: "Nhập mật khẩu....",
                                suffixIcon: IconButton(
                                    onPressed: () {
                                      controller.changeHienThiPassword();
                                    },
                                    icon: Icon(controller.hienPassword?Icons.visibility:Icons.visibility_off)
                                ),
                              ),
                              validator: (value) {
                                if(value == null || value.trim().isEmpty){
                                  return "Vui lòng nhập mật khẩu";
                                }
                                if(value.length <6){
                                  return "Vui lòng nhập mật khẩu ít nhất 6 ký tự";
                                }
                                return null;
                              },
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              obscureText: !controller.hienPassword,
                              keyboardType: TextInputType.visiblePassword,
                            ),
                            SizedBox(height: 5,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                TextButton(
                                  onPressed: () {
                                    Get.to(PageQuenMatKhau(), binding: AuthBinding());
                                  },
                                  child: Text("Quên mật khẩu?", style: TextStyle(fontSize: 15),))
                                ],
                            ),
                            SizedBox(height: 15,),
                            controller.isLoading?CircularProgressIndicator():
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () async{
                                      if (_formKey.currentState!.validate()) {
                                        String? kq = await controller.login(email: txtEmail.text.trim(), password: txtPassword.text.trim());
                                        if(kq == "ok"){
                                          Get.offAll(PageCheckAuth(xacthuc: true,));

                                        }
                                        else if(kq == "invalid_credentials"){
                                          showConfirmDialogOneButtonFailed(context, "Địa chỉ email hoặc mật khẩu không đúng", buttonText: "Chấp nhận", title: "Đăng nhập thất bại");
                                        }
                                        else if(kq == "email_not_confirmed"){
                                          Get.to(PageXacThucEmail(email: txtEmail.text.trim()));
                                        }
                                        else if(kq!=null){
                                          showConfirmDialogOneButtonFailed(context, "Lỗi: ${kq}", buttonText: "Chấp nhận", title: "Đăng nhập thất bại");
                                        }
                                      }
                                    },
                                    child: Text("Đăng nhập", style: TextStyle( fontSize: 20
                                    ),)
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("Bạn chưa có tài khoản?", style: TextStyle(fontSize: 15),),
                                TextButton(
                                    onPressed: () {
                                      controller.refresh();
                                      Get.to(PageRegister(), binding: AuthBinding());
                                    }, 
                                    child: Text("Đăng ký", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),))
                              ],
                            )
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
