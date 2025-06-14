import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:get/get.dart';
import 'package:hapie/controller/auth_controller.dart';
import 'package:hapie/controller/layout_app_controller.dart';
import 'package:hapie/controller/otp_controller.dart';
import 'package:hapie/page/page_layout_app.dart';
import 'package:hapie/helper/layout_check_internet.dart';
import 'package:hapie/page/page_change_password.dart';
import 'package:hapie/page/page_check_auth.dart';
import 'package:hapie/widgets/widget_function.dart';
import 'package:hapie/widgets/app_widget.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PageCodeXacThuc extends StatelessWidget {
  late String email;
  OtpType type;
  bool resetPassword;

  PageCodeXacThuc({
    super.key,
    required this.type,
    required this.email,
    this.resetPassword = false,
  });

  // TextEditingController txtCode = TextEditingController();
  String txtCode = "";
  List<TextEditingController?> code = List.empty();

  bool checkCode(){
    int c = 0;
    String x = "";
    for(var t in code){
      // print("t - ${c}: ${t!.text}");
      if(t==null || t.text.toString().trim().isEmpty){
        return false;
      }
      if(t.text.trim().isNotEmpty){
        x+=t.text.trim();
      }
      c++;
    }
    // print("c = ${c}");
    if(c!=6)return false;
    txtCode = x;
    // print("0k ${x}");
    return true;
  }


  @override
  Widget build(BuildContext context) {
    // OTPController.chayDemNguoc();
    return LayoutCheckInternet(
      child: GetBuilder(
        id: "auth_fix",
        init: AuthController.get(),
        builder: (controller) {
          final _formKey = GlobalKey<FormState>();
          return Scaffold(
            appBar: AppBar(),
            body: SingleChildScrollView(
              child: Center(
                child: Container(
                  child: Padding(
                    padding: EdgeInsets.only(left: 25, right: 25),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(height: 40),
                          Text(
                            "HaPie",
                            style: TextStyle(
                              fontSize: 60,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          SizedBox(height: 40),
                          Text(
                            (resetPassword
                                ? "Xác thực danh tính"
                                : "Xác nhận đăng ký tài khoản"),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 27,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 5),
                          sendCodeEmailNote(email,Theme.of(context).textTheme.bodyMedium?.color??Colors.black),
                          SizedBox(height: 5,),
                          Text("Vui lòng nhập mã xác thực bên dưới:"),

                          SizedBox(height: 40),

                          OtpTextField(
                            numberOfFields: 6,
                            handleControllers: (controllers) {
                              code = controllers;
                            },
                            borderColor: Theme.of(context).primaryColor,
                            focusedBorderColor: Theme.of(context).primaryColor,
                            showFieldAsBox: true,
                            onCodeChanged: (String code) {
                            },
                            onSubmit: (String verificationCode) {
                            }, // end onSubmit
                          ),

                          // TextFormField(
                          //   controller: txtCode,
                          //   decoration: InputDecoration(
                          //     labelText: "Mã xác thực",
                          //     hintText: "Nhập mã xác thực....",
                          //   ),
                          //   validator: (value) {
                          //     if(value == null || value.trim().isEmpty){
                          //       return "Vui lòng nhập mã xác thực";
                          //     }
                          //     if(value.length!=6){
                          //       return "Mã xác thực gồm 6 ký tự";
                          //     }
                          //     return null;
                          //   },
                          //   autovalidateMode: AutovalidateMode.onUserInteraction,
                          //   keyboardType: TextInputType.numberWithOptions(decimal: false, signed: false)
                          //
                          // ),
                          SizedBox(height: 50),
                          GetBuilder(
                            id: "otp",
                            init: OTPController.get(),
                            builder: (otp_controller) {
                              return GetBuilder(
                                id: "auth",
                                  init: controller,
                                  builder: (controller) {
                                    return Column(
                                      children: [
                                        controller.isLoading
                                            ? CircularProgressIndicator()
                                            : Row(
                                          children: [
                                            Expanded(
                                              child:
                                              otp_controller.demNguoc > 0
                                                  ? ElevatedButton(
                                                onPressed: () async {
                                                  if (checkCode()) {
                                                    String? kq =
                                                    await controller
                                                        .check_code(
                                                      type,
                                                      txtCode.trim(),
                                                      email,
                                                    );
                                                    if (otp_controller
                                                        .demNguoc ==
                                                        0) {
                                                      String?
                                                      xn = await showConfirmDialogOneButtonFailed(
                                                        context,
                                                        "Mã xác thực đã hết hạn",
                                                        title:
                                                        "Xác thực thất bại",
                                                        buttonText:
                                                        "Gửi lại mã",
                                                      );
                                                      if (xn == "ok") {
                                                        txtCode = "";
                                                        controller.update(["auth_fix"]);
                                                        await controller
                                                            .resendOTP(
                                                          email,
                                                          resetPassword:
                                                          resetPassword,
                                                        );
                                                        otp_controller
                                                            .chayDemNguoc();
                                                      }
                                                    } else if (kq ==
                                                        "ok") {
                                                      otp_controller
                                                          .onClose();
                                                      await showConfirmDialogOneButtonSuccess(
                                                        context,
                                                        (resetPassword
                                                            ? "Xác mình danh tính thành công, vui lòng đặt mật khẩu mới!"
                                                            : "Xác thực email thành công!"),
                                                        title:
                                                        "Hoàn thành",
                                                        buttonText:
                                                        "Chấp nhận",
                                                      );
                                                      if (resetPassword) {
                                                        Get.offAll(
                                                          PageChangePassword(
                                                            reset: true,
                                                          ),
                                                        );
                                                      } else {
                                                        Get.offAll(
                                                          PageCheckAuth(
                                                            xacthuc: true,
                                                          ),
                                                        );
                                                      }
                                                    } else if (kq ==
                                                        "otp_expired") {
                                                      await showConfirmDialogOneButtonFailed(
                                                        context,
                                                        "Mã xác thực không đúng",
                                                        title:
                                                        "Xác thực thất bại",
                                                        buttonText:
                                                        "Thử lại",
                                                      );
                                                    } else if (kq != "") {
                                                      await showConfirmDialogOneButtonFailed(
                                                        context,
                                                        "${kq}",
                                                        title:
                                                        "Xác thực thất bại",
                                                        buttonText:
                                                        "Thử lại",
                                                      );
                                                    } else {
                                                      String?
                                                      xn = await showConfirmDialogOneButtonFailed(
                                                        context,
                                                        "Đã có lỗi",
                                                        title:
                                                        "Xác thực thất bại",
                                                        buttonText:
                                                        "Gửi lại mã",
                                                      );
                                                      if (xn == "ok") {
                                                        controller.update(["auth_fix"]);
                                                        txtCode = "";
                                                        await controller
                                                            .resendOTP(
                                                          email,
                                                          resetPassword:
                                                          resetPassword,
                                                        );
                                                        otp_controller
                                                            .chayDemNguoc();

                                                      }
                                                    }
                                                  }
                                                  else {
                                                    await showConfirmDialogOneButtonWarning(context, "Vui lòng kiểm tra và nhập đủ 6 chữ số mã xác thực mà bạn đã nhận, đảm bảo chính xác trước khi tiếp tục", title: "Ẩu rồi đó ba!");
                                                  }
                                                },
                                                child: Text(
                                                  "Xác nhận",
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight:
                                                    FontWeight.bold,
                                                  ),
                                                ),
                                              )
                                                  : OutlinedButton(
                                                onPressed: () async {
                                                  controller.update(["auth_fix"]);
                                                  txtCode = "";
                                                  await controller
                                                      .resendOTP(
                                                    email,
                                                    resetPassword:
                                                    resetPassword,
                                                  );
                                                  otp_controller
                                                      .chayDemNguoc();
                                                },
                                                child: Text(
                                                  "Gửi lại mã OTP",
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight:
                                                    FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 20),
                                        otp_controller.demNguoc > 0
                                            ? Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.center,
                                          children: [
                                            Text("Mã OTP hết hạn sau: "),
                                            Text(
                                              "${otp_controller.min}:${otp_controller.second}",
                                              style: TextStyle(
                                                color: Colors.red,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        )
                                            : Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "Mã xác thực đã hết hạn!",
                                              style: TextStyle(
                                                color: Colors.red,
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                        if(otp_controller.demNguoc <360)
                                          Row(
                                          children: [
                                            Text("Bạn không nhận được mã OTP?"),
                                            SizedBox(width: 1,),
                                            TextButton(
                                                onPressed:
                                                () async{
                                                  controller.update(["auth_fix"]);
                                                  txtCode = "";
                                                  await controller
                                                      .resendOTP(
                                                    email,
                                                    resetPassword:
                                                    resetPassword,
                                                  );
                                                  otp_controller
                                                      .chayDemNguoc();
                                                }, child: Text("Gửi lại mã")
                                            ),
                                          ],
                                        )
                                      ],
                                    );
                                  },
                              );
                            },
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
      ),
    );
  }
}
