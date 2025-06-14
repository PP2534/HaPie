//Cho đăng ký, đăng nhập
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hapie/controller/otp_controller.dart';
import 'package:hapie/page/page_check_auth.dart';
import 'package:hapie/page/page_code_xac_thuc.dart';
import 'package:hapie/page/page_login.dart';
import 'package:hapie/page/page_welcome.dart';
import 'package:hapie/page/page_xac_thuc_email.dart';
import 'package:hapie/widgets/widget_function.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'network_controller.dart';

class AuthController extends GetxController{
  final supabase = Supabase.instance.client;
  static AuthController get() => Get.find();
  bool hienPassword = false;
  var isLoading = false;
  var message = "";
  var errorCode = "";


  //đăng ký tài khoản
  Future<String?> register({required String email,required String password}) async{
    try{
      isLoading = true;
      update(["auth"]);
      final kq = await supabase.auth.signUp(
        email: email,
        password: password,
      );
      print("kq - u ${kq.user}");
      print("kq - s ${kq.session}");
      print("kq -cr ${supabase.auth.currentUser}");
      print("kq -cr ${supabase.auth.currentSession}");

      if(kq.session!=null){
        return "has_account";
      }
      else {
        String? try_login = await login(email: email, password: password, try_login: true);
        if(try_login == "email_not_confirmed"){
          return "ok";
        }
        else if(try_login == "invalid_credentials") {
          message = "Email đã có trong hệ thống, vui lòng đăng nhập";
          return "email_had";
        }
        else if(try_login == "ok"){
          return "late_has_account";
        }
        else{
          return try_login;
        }
      }

    }
    catch(e){
      message = "Tạo tài khoản bị lỗi: ${e}";
      return e.toString();
    }
    finally{
      isLoading = false;
      update(["auth"]);
    }
  }
  Future<void> xacThucEmail(String email) async{
    try{
      isLoading = true;
      update(["auth"]);
      final ResendResponse res = await supabase.auth.resend(
        type: OtpType.signup,
        email: email,
      );
      print("xac thuc ${res.messageId}");

      Get.off(PageCodeXacThuc(type: OtpType.signup, email: email,));
    }
    catch(e){
      message = "Đã có lỗi: ${e}";
    }
    finally{
      isLoading = false;
      update(["auth"]);
    }
  }
  Future<String?> check_code(OtpType type, String code, String email) async{
    try{
      isLoading = true;
      update(["auth"]);
      final res = await supabase.auth.verifyOTP(
          type: type,
          token: code,
          email: email
      );
      return "ok";
      // Get.offAll(LayoutApp(), binding: LayoutAppBinding());
    }
    on AuthException catch (e) {
      print("Lỗi 1: ${e}");
      return errorCode = e.code??"";
    }
    catch(e){
      print("Lỗi 2: ${e}");
      return e.toString();
    }
    finally{
      isLoading = false;
      update(["auth"]);
    }
  }

  Future<void> resendOTP(String email, {bool resetPassword = false}) async{
    try{
      isLoading = true;
      update(["auth"]);
      if(resetPassword){
        await supabase.auth.resetPasswordForEmail(email);
        print("da gui lai OTP resetPassword!");
      }
      else{
        final ResendResponse res = await supabase.auth.resend(
          type: OtpType.signup,
          email: email,
        );
        print("xac thuc ${res.messageId}");
      }
    }
    catch(e){
      print("Có lỗi resend: ${e}");
      message = "Đã có lỗi: ${e}";
    }
    finally{
      isLoading = false;
      update(["auth", "otp"]);
    }
  }

  //đăng nhập
  Future<String?> login({required String email, required String password, bool try_login = false}) async{
    try{
      isLoading = true;
      update(["auth"]);
      final kq = await supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
      if(kq.user !=null){
        return "ok";
      }
      print("u: ${kq.user}");
      return null;
    }
    on AuthException catch (e) {
      return e.code;
    }
    catch(e){
      print("lỗi: ${e}");
      return e.toString();
    }
    finally{
      update(["auth"]);
      isLoading = false;

    }

  }

  //quên mật khẩu
  Future<void> resetPassword(String email) async{
    try{
      isLoading = true;
      update(["auth"]);
      await supabase.auth.resetPasswordForEmail(email);
      Get.off(PageCodeXacThuc(type: OtpType.email, email: email,resetPassword: true,));
    }
    catch(e){
      print("lỗi: ${e}");
    }
    finally{
      update(["auth"]);
      isLoading = false;
    }
  }

  Future<String?> updatePassword(String newPassword, {bool reset = true, String oldPassword = ""}) async{
    try{
      isLoading = true;
      update(["auth"]);
      if(!reset){
        final user = supabase.auth.currentUser;
        if(user==null){
          return "no_log_in";
        }
        Session? sessionCurrent = supabase.auth.currentSession;
        final email = user.email;
        String? kq = await login(email: email!, password: oldPassword, try_login: true);
        if(kq!="ok"){
          return "current_password_wrong";
        }
      }
      UserResponse res = await supabase.auth.updateUser(
        UserAttributes(
          password: newPassword,
        ),
      );
      print("Up: ${res}");
      print("Up -u: ${res.user}");
      return "ok";
    }
    on AuthException catch (e) {
      return e.code;
    }
    catch(e){
      print("Lỗi ${e}");
      return "error: ${e}";
    }
    finally{
      update(["auth"]);
      isLoading = false;
    }
  }

  //đăng xuất
  Future<void> logout() async{
    try{
      isLoading = true;
      update(["auth"]);
      await supabase.auth.signOut();
      box.write("login", false);
      Get.offAll(PageWelcome());
      Get.to(PageLogin());
    }
    catch(e){
      print("Lỗi đăng xuất: ${e}");
    }
    finally{
      isLoading = false;
      update(["auth"]);
    }
  }

  //kiểm tra người dùng đăng nhập hay chưa
  Future<bool> isLoggedIn() async {
    return supabase.auth.currentUser !=null;
  }

  Future<void> refresh()async {
    message = "";
    isLoading = false;
    errorCode = "";
    update(["auth"]);
  }

  void changeHienThiPassword(){
    hienPassword = !hienPassword;
    update(["auth"]);
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    // user = supabase.auth.currentUser;
    // _listenEvenAuth();
    message = "";
    isLoading = false;
    errorCode = "";
  }

  // void _listenEvenAuth(){
  //   final authSubscription = supabase.auth.onAuthStateChange.listen((data) {
  //     final AuthChangeEvent event = data.event;
  //     final Session? session = data.session;
  //     print('event: $event, session: $session');
  //     switch (event) {
  //       case AuthChangeEvent.signedIn:
  //         user = session?.user;
  //         Get.offAll(PageCheckAuth());
  //         break;
  //       // handle signed in
  //       case AuthChangeEvent.signedOut:
  //         user = null;
  //         Get.offAll(PageLogin());
  //         break;
  //       case AuthChangeEvent.initialSession:
  //       // handle signed out
  //       case AuthChangeEvent.passwordRecovery:
  //       // handle password recovery
  //       case AuthChangeEvent.tokenRefreshed:
  //       // handle token refreshed
  //       case AuthChangeEvent.userUpdated:
  //       // handle user updated
  //       case AuthChangeEvent.userDeleted:
  //       // handle user deleted
  //       case AuthChangeEvent.mfaChallengeVerified:
  //       // handle mfa challenge verified
  //     }
  //     update();
  //   });
  // }

}

class AuthBinding extends Bindings{
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut(()=>AuthController(),fenix: true);
    Get.lazyPut(()=> NetworkController(), fenix: true);
    Get.lazyPut(()=> OTPController(),fenix: true);
  }
}