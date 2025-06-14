import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hapie/controller/auth_controller.dart';
import 'package:hapie/controller/layout_app_controller.dart';
import 'package:hapie/page/page_layout_app.dart';
import 'package:hapie/helper/layout_check_internet.dart';
import 'package:hapie/page/page_code_xac_thuc.dart';
import 'package:hapie/widgets/widget_function.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PageRegister extends StatelessWidget {
  String? email;
  PageRegister({super.key, this.email = ""});

  @override
  Widget build(BuildContext context) {
    TextEditingController txtEmail = TextEditingController(text: email);
    TextEditingController txtPassword = TextEditingController();
    TextEditingController txtRNewPassword = TextEditingController();
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
                            Text("HaPie", style: TextStyle(
                                fontSize: 60, fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor
                            ),),
                            SizedBox(height: 45,),
                            Text("Tạo tài khoản", style: TextStyle(
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
                            SizedBox(height: 25,),
                            TextFormField(
                              controller: txtRNewPassword,
                              decoration: InputDecoration(
                                labelText: "Xác nhận mật khẩu",
                                hintText: "Nhập lại mật khẩu....",
                                suffixIcon: IconButton(
                                    onPressed: () {
                                      controller.changeHienThiPassword();
                                    },
                                    icon: Icon(controller.hienPassword?Icons.visibility:Icons.visibility_off)
                                ),
                              ),
                              validator: (value) {
                                if(value == null || value.trim().isEmpty){
                                  return "Vui lòng nhập lại mật khẩu";
                                }
                                if(value != txtPassword.text){
                                  return "Mật khẩu không trùng khớp!";
                                }
                                return null;
                              },
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              obscureText: !controller.hienPassword,
                              keyboardType: TextInputType.visiblePassword,
                            ),
                            SizedBox(height: 25,),
                            controller.isLoading?CircularProgressIndicator():
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                      onPressed: () async{
                                        if (_formKey.currentState!.validate()) {
                                         String? kq = await controller.register(email: txtEmail.text.trim(), password: txtPassword.text.trim());
                                         if(kq == "email_had"){
                                           await showConfirmDialogOneButtonFailed(context, "Email đã có trong hệ thống. Vui lòng đăng nhập hoặc sử dụng chức năng Quên mật khẩu", title: "Đăng ký thất bại", buttonText: "Đồng ý", );
                                         }
                                         else if(kq=="has_account"){
                                           Get.offAll(LayoutApp(), binding: LayoutAppBinding());
                                         }
                                         else if(kq=="ok"){
                                           Get.offAll(PageCodeXacThuc(type: OtpType.signup,email: txtEmail.text.trim()));
                                         }
                                         else if(kq == "late_has_account"){
                                           await showConfirmDialogOneButtonWarning(context, "Tài khoản của bạn đã có trong hệ thống từ trước.", title: "Thông báo", buttonText: "Đồng ý", );
                                           Get.offAll(LayoutApp(), binding: LayoutAppBinding());
                                         }
                                         else if(kq!=null){
                                           await showConfirmDialogOneButtonFailed(context, "Đã có lỗi: ${kq}", title: "Đăng ký thất bại", buttonText: "Chấp nhận", );
                                         }
                                         else{
                                           await showConfirmDialogOneButtonFailed(context, "Đã có lỗi hệ thống", title: "Đăng ký thất bại", buttonText: "Chấp nhận", );
                                         }

                                        }
                                      },
                                      child: Text("Đăng ký", style: TextStyle(
                                          height: 2.8, fontSize: 20
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
