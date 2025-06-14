//Cho bảng giao_dich
import 'package:hapie/helper/supabase_helper.dart';
import 'package:hapie/model/profile_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'danh_muc_model.dart';

class GiaoDich{
  int? id;
  int so_tien;
  DanhMuc danh_muc; // table danhmuc
  DateTime ngay_giao_dich;
  String? ghi_chu;
  DateTime? ngay_tao;

  GiaoDich({this.id, required this.danh_muc, required this.so_tien, required this.ngay_giao_dich, required this.ghi_chu, this.ngay_tao});

  factory GiaoDich.fromJson(Map<String, dynamic> json) {
    // print("dt ${json}");
    return GiaoDich(
      id: json["id"],
      so_tien: json["so_tien"],
      danh_muc: DanhMuc.fromJson(json["DanhMuc"]), // table DanhMuc
      ngay_giao_dich: DateTime.parse(json["ngay_giao_dich"]),
      ghi_chu: json["ghi_chu"],
      ngay_tao: DateTime.parse(json["ngay_tao"]),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "so_tien": this.so_tien,
      "ma_danh_muc": this.danh_muc.id,
      "ma_nguoi_dung": supabase.auth.currentUser!.id,
      "ngay_giao_dich": this.ngay_giao_dich.toIso8601String(),
      "ghi_chu": this.ghi_chu,
    };
  }
}

class GiaoDichSnapshot {
  static Future<void> insert(GiaoDich newGiaoDich) async {
    final supabase = Supabase.instance.client;
    print(newGiaoDich.toJson());
    await supabase
        .from("GiaoDich")
        .insert(newGiaoDich.toJson());
    var user = await ProfileSnapshot.getUser();
    if(newGiaoDich.danh_muc.loai_danh_muc == false){
      user.so_du = user.so_du! - newGiaoDich.so_tien;
    }
    else{
      user.so_du = user.so_du! + newGiaoDich.so_tien;
    }
    ProfileSnapshot.update(user);
  }

  static Future<void> delete(int idGiaoDich) async {
    final supabase = Supabase.instance.client;

    var mapOldGiaoDich = await supabase.from("GiaoDich").select("*,DanhMuc(*)").eq("id", idGiaoDich).single();
    print(mapOldGiaoDich);
    var oldGiaoDich = GiaoDich.fromJson(mapOldGiaoDich);
    await supabase.from("GiaoDich").delete().eq("id", idGiaoDich);
    var user = await ProfileSnapshot.getUser();
    if(oldGiaoDich.danh_muc.loai_danh_muc == false){
      user.so_du = user.so_du! + oldGiaoDich.so_tien;
    }
    else{
      user.so_du = user.so_du! - oldGiaoDich.so_tien;
    }
    ProfileSnapshot.update(user);
  }

  static Future<void> update(GiaoDich newGiaoDich) async {
    final supabase = Supabase.instance.client;
    var mapOldGiaoDich = await supabase.from("GiaoDich").select("*,DanhMuc(*)").eq("id", newGiaoDich.id!).single();
    var oldGiaoDich = GiaoDich.fromJson(mapOldGiaoDich);
    // print("pgf ${newGiaoDich}");
    await supabase.from("GiaoDich").update(newGiaoDich.toJson()).eq("id", newGiaoDich.id!);
    var user = await ProfileSnapshot.getUser();
    if(oldGiaoDich.danh_muc.loai_danh_muc == false){
      user.so_du = user.so_du! + oldGiaoDich.so_tien;
    }
    else{
      user.so_du = user.so_du! - oldGiaoDich.so_tien;
    }

    if(newGiaoDich.danh_muc.loai_danh_muc == false){
      user.so_du = user.so_du! - newGiaoDich.so_tien;
    }
    else{
      user.so_du = user.so_du! + newGiaoDich.so_tien;
    }
    ProfileSnapshot.update(user);
  }

  // static Stream<List<GiaoDich>> getGiaoDichStream(DateTime month) {
  //   // return getDataStream(table: "GiaoDich", ids: ["id"], fromJson: GiaoDich.fromJson);
  //   final start = DateTime(month.year, month.month, 1);
  //   final end = DateTime(month.year, month.month + 1, 1);
  //   var stream = supabase
  //       .from("GiaoDich")
  //       .select(
  //       'id, ma_nguoi_dung, ma_danh_muc, so_tien, loai_giao_dich, ngay_giao_dich, ghi_chu, ngay_tao, DanhMuc(ten_danh_muc)')
  //       .eq("ma_nguoi_dung", supabase.auth.currentUser!.id)
  //       .gte("ngay_giao_dich", start.toIso8601String())
  //       .lt("ngay_giao_dich", end.toIso8601String())
  //       .order("ngay_tao", ascending: true)
  //       .asStream();
  //   var k = stream.map((mapList) =>
  //       mapList.map(
  //             (map) =>
  //             GiaoDich.fromJson(
  //                 map), // Fruit.fromJson(map) la ham khoi tao thuoc lop fruit, khoi tao 1 the hien cua fruit
  //       ).toList());
  //   print('stream: ${supabase.auth.currentUser!.id}');
  //   return k;
  // }

  static Future<List<GiaoDich>> getGiaoDichs(DateTime month) async{
    // return getDataStream(table: "GiaoDich", ids: ["id"], fromJson: GiaoDich.fromJson);
    final start = DateTime(month.year, month.month, 1);
    final end = DateTime(month.year, month.month + 1, 1);
    var data = await supabase
        .from("GiaoDich")
        .select(
        'id, so_tien, ngay_giao_dich, ghi_chu, ngay_tao, DanhMuc(*)')
        .eq("ma_nguoi_dung", supabase.auth.currentUser!.id)
        .gte("ngay_giao_dich", start.toIso8601String())
        .lt("ngay_giao_dich", end.toIso8601String())
        .order("ngay_tao", ascending: false);
    var k = data.map((e) => GiaoDich.fromJson(e),).toList();
    // print('data: ${supabase.auth.currentUser!.id}');
    return k;
  }

  static Stream<List<Map<String, dynamic>>> getThuChiTheoDanhMuc(bool loaiGiaoDich,
      DateTime thang) {
    var data = supabase.rpc("get_thu_chi_theo_danh_muc", params: {
      'ma_user': supabase.auth.currentUser!.id,
      'thang': thang.toIso8601String(),
      'loai_gd': loaiGiaoDich
    }).asStream();
    var res =  data.map((event) => List<Map<String,dynamic>>.from(event),);
    return res;
  }

  static dynamic getTongThuChiTheoThang(bool loadGiaoDich, DateTime thang){
    var data = supabase.rpc("get_tong_thu_chi_theo_thang", params: {
      'ma_user': supabase.auth.currentUser!.id,
      'thang': thang.toIso8601String(),
      'loai_gd': loadGiaoDich
    });
    return data;
  }

  //Thống kê xuống dưới:

  //Get danh sách tổng tiền thu và chi trong 12 tháng gần nhất
  static Stream<List<Map<String, dynamic>>> getThuChiTrong12Thang() {
    var data = supabase.rpc("get_bctc_12_thang", params: {
      'ma_user': supabase.auth.currentUser!.id,
    }).asStream();
    var res =  data.map((event) => List<Map<String,dynamic>>.from(event),);
    return res;
  }


}
