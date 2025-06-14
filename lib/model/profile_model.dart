//Sử dụng cho bảng Profile. thông tin của người dùng như Tên, ngày sinh, gioi tính, hình ảnh
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hapie/controller/home_controller.dart';
import 'package:hapie/helper/supabase_helper.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Profile{
  String id, ho_ten;
  String? gioi_tinh, url_avatar, ngay_tao;
  DateTime? ngay_sinh;
  String theme_mode;
  int? so_du;

  Profile({
    required this.id,
    required this.ho_ten,
    this.gioi_tinh,
    this.url_avatar,
    this.ngay_sinh,
    this.ngay_tao,
    required this.theme_mode,
    this.so_du,
  });


  Map<String, dynamic> toJson() {
    return {
      "id": this.id,
      "ho_ten": this.ho_ten,
      "gioi_tinh": this.gioi_tinh,
      "url_avatar": this.url_avatar,
      "ngay_sinh": this.ngay_sinh?.toIso8601String(),
      "ngay_tao": this.ngay_tao,
      "theme_mode": this.theme_mode,
      "so_du": this.so_du,
    };
  }

  factory Profile.fromJson(Map<String, dynamic> json) {
    // print("id ${json["id"]}");
    // print("hoten ${json["ho_ten"]}");
    // print("id ${json["id"]}");
    // print("id ${json["id"]}");
    return Profile(
      id: json["id"],
      ho_ten: json["ho_ten"],
      gioi_tinh: json["gioi_tinh"],
      url_avatar: json["url_avatar"],
      // ngay_sinh: json["ngay_sinh"],
      ngay_sinh: json["ngay_sinh"]!=null?DateTime.parse(json["ngay_sinh"]):DateTime.now(),
      ngay_tao: json["ngay_tao"],
      theme_mode: json["theme_mode"],
      so_du: json["so_du"]
    );
  }
}

class ProfileSnapshot{
  static Profile? user;
  // static String idUser = Supabase.instance.client.auth.currentUser!.id;

  // static void load_data_Profile(){
  //   idUser = Supabase.instance.client.auth.currentUser!.id;
  // }

  static Future<dynamic> insert (Profile user) async{
    final supabase = Supabase.instance.client;
    user.id = supabase.auth.currentUser!.id;
    user.ngay_tao = DateTime.now().toLocal().toIso8601String();
    user.theme_mode = "system";
    final Uint8List imageBytes = await rootBundle.load('assets/images/hapie_user.png')
        .then((byteData) => byteData.buffer.asUint8List());
    user.url_avatar = await uploadImageBin(image: imageBytes, bucket: "images", path: "user_avartar/profile_${supabase.auth.currentUser!.id}.png");
    var data = await supabase
        .from("Profile")
        .insert(user.toJson());
    return data;
  }

  static Future<Profile> getUser() async{
    final supabase = Supabase.instance.client;
    var data = await supabase.from("Profile").select().eq("id", supabase.auth.currentUser!.id).single();
    print("Người dùng: ${data}");
    user = Profile.fromJson(data);
    return Profile.fromJson(data);
  }

  static Future<void> resetdata() async{
    final supabase = Supabase.instance.client;
    await supabase.from("Profile").delete().eq("id", supabase.auth.currentUser!.id);
    return;
  }

  static Future<bool> checkProfile() async {
    final supabase = Supabase.instance.client;
    var checkProfile = await supabase.from("Profile").select("id, theme_mode").eq("id", supabase.auth.currentUser!.id);
    if(checkProfile.isEmpty)return false;
    // Get.changeThemeMode(checkProfile[0]["theme_mode"]? ThemeMode.dark : ThemeMode.light);
    return true;
  }

  static Future<dynamic> update(Profile user) async {
    final supabase = Supabase.instance.client;
    final data = await supabase.from("Profile").update(user.toJson()).eq("id", user.id);
    HomeController.get().loadSoDu();
    return data;
  }


}
