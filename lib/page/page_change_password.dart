import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hapie/controller/auth_controller.dart';
import 'package:hapie/controller/layout_app_controller.dart';
import 'package:hapie/page/page_layout_app.dart';
import 'package:hapie/helper/layout_check_internet.dart';
import 'package:hapie/page/page_check_auth.dart';
import 'package:hapie/widgets/widget_function.dart';

class PageChangePassword extends StatelessWidget {
  bool reset;
  PageChangePassword({super.key, this.reset = false});

  @override
  Widget build(BuildContext context) {
    TextEditingController txtNewPassword = TextEditingController();
    TextEditingController txtRNewPassword = TextEditingController();
    TextEditingController txtOldPassword = TextEditingController();
    return LayoutCheckInternet(
        child: GetBuilder(
          init: AuthController.get(),
          id: "auth",
          builder: (controller) {
            final _formKey = GlobalKey<FormState>();
            return Scaffold(
              appBar: AppBar(
                title: Text((reset?"Đặt mật khẩu mới":"Thay đổi mật khẩu"), style: TextStyle(
                    fontSize: 20, fontWeight: FontWeight.bold
                ),),
                // backgroundColor: Theme.of(context).colorScheme.inversePrimary,
              ),
              body: Center(
                child: Container(
                  child: Padding(
                    padding: EdgeInsets.only(left: 20, right: 20),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        // mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if(!reset)SizedBox(height: 20,),
                          if(!reset)TextFormField(
                            controller: txtOldPassword,
                            decoration: InputDecoration(
                              labelText: "Mật khẩu hiện tại",
                              hintText: "Nhập mật khẩu hiện tại...",
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
                          SizedBox(height: 20,),
                          TextFormField(
                            controller: txtNewPassword,
                            decoration: InputDecoration(
                              labelText: "Mật khẩu mới",
                              hintText: "Nhập mật khẩu mới....",
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
                          SizedBox(height: 20,),
                          TextFormField(
                            controller: txtRNewPassword,
                            decoration: InputDecoration(
                              labelText: "Xác nhận mật khẩu",
                              hintText: "Nhập lại mật khẩu mới....",
                              suffixIcon: IconButton(
                                  onPressed: () {
                                    controller.changeHienThiPassword();
                                  },
                                  icon: Icon(controller.hienPassword?Icons.visibility:Icons.visibility_off)
                              ),
                            ),
                            validator: (value) {
                              if(value == null || value.trim().isEmpty){
                                return "Vui lòng nhập lại mật khẩu mới";
                              }
                              if(value != txtNewPassword.text){
                                return "Mật khẩu không trùng khớp!";
                              }
                              return null;
                            },
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            obscureText: !controller.hienPassword,
                            keyboardType: TextInputType.visiblePassword,
                          ),
                          // SizedBox(height: 50,),
                          Spacer(),
                          controller.isLoading?CircularProgressIndicator():
                          ElevatedButton(
                              onPressed: () async{
                                if (_formKey.currentState!.validate()) {
                                  String? kq = await controller.updatePassword(txtNewPassword.text.trim(),reset: reset, oldPassword: txtOldPassword.text.trim());
                                  if(kq=="ok"){
                                    await showConfirmDialogOneButtonSuccess(context, "Cập nhật mật khẩu mới thành công!", title: "Hoàn thành", buttonText: "Chấp nhận", );
                                    Get.offAll(PageCheckAuth(xacthuc: true,));
                                  }
                                  else if(kq=="no_log_in"){
                                    Get.offAll(PageCheckAuth(xacthuc: true,));
                                  }
                                  else if(kq=="current_password_wrong"){
                                    await showConfirmDialogOneButtonFailed(context, "Mật khẩu hiện tại không đúng", title: "Thất bại", buttonText: "Thử lại", );
                                  }
                                  else if(kq=="same_password"){
                                    if(reset){
                                      await showConfirmDialogOneButtonWarning(context, "Mật khẩu mới bạn vừa nhập là mật khẩu cũ, chúc mừng bạn đã nhớ lại mật khẩu 🤡.", title: "Thông báo", buttonText: "Đồng ý", );
                                      Get.offAll(LayoutApp(), binding: LayoutAppBinding());
                                    }else{
                                      await showConfirmDialogOneButtonFailed(context, "Mật khẩu mới không đuợc giống mật khẩu cũ.", title: "Thông báo", buttonText: "Thử lại", );
                                    }

                                  }
                                  else{
                                    await showConfirmDialogOneButtonFailed(context, "Đã có lỗi ${kq}", title: "Thất bại", buttonText: "Thử lại", );
                                  }
                                }
                              },
                              child: Text("Xác nhận", style: TextStyle(
                                  fontSize: 20
                              ),)
                          ),
                          SizedBox(height: 20,),
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
