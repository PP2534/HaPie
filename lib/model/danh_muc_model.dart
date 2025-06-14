
import 'package:hapie/helper/supabase_helper.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DanhMuc{
  int? id;
  String ten_danh_muc;
  bool loai_danh_muc;
  String ma_nguoi_dung;
  String? ghi_chu;
  DanhMuc({this.id, required this.ten_danh_muc, required this.loai_danh_muc, required this.ma_nguoi_dung, required this.ghi_chu});

  factory DanhMuc.fromJson(Map<String, dynamic> json) {
    try {
      // print("Đang parse: $json");
      return DanhMuc(
        id: json["id"],
        ten_danh_muc: json["ten_danh_muc"],
        loai_danh_muc: json["loai_danh_muc"],
        ma_nguoi_dung: json["ma_nguoi_dung"],
        ghi_chu: json["ghi_chu"],
      );
    } catch (e) {
      print("ỗi khi parse DanhMuc: $e với dữ liệu $json");
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      // "id": this.id,
      "ten_danh_muc": this.ten_danh_muc,
      "loai_danh_muc": this.loai_danh_muc,
      "ma_nguoi_dung": this.ma_nguoi_dung,
      "ghi_chu": this.ghi_chu,
    };
  }

}
class DanhMucSnapShot{
  static Future<void> Update(DanhMuc newDanhMuc) async {
    final supabase = Supabase.instance.client;
    var data = await supabase.from('DanhMuc')
        .update(newDanhMuc.toJson())
        .eq("id", newDanhMuc.id!);
    return data;
  }
  static Future<void> deleteById(int id) async {
    final supabase = Supabase.instance.client;
    await supabase.from("DanhMuc").delete().eq("id", id).eq("ma_nguoi_dung", supabase.auth.currentUser!.id);
  }
  static Future<void> insert(DanhMuc newDanhMuc) async {
    final supabase = Supabase.instance.client;

    try {
      final response = await supabase
          .from('DanhMuc')
          .insert(newDanhMuc.toJson()).eq("ma_nguoi_dung", supabase.auth.currentUser!.id);

      // print("Phản hồi từ Supabase: $response");
    } catch (e) {
      print("Lỗi insert Supabase: $e");
      rethrow; // Để lỗi ném về UI xử lý
    }
  }


  static Stream<List<DanhMuc>> getDanhMucStream() {
    final supabase = Supabase.instance.client;
    return supabase
        .from('DanhMuc')
        .stream(primaryKey: ['id']).eq("ma_nguoi_dung", supabase.auth.currentUser!.id)
        .map((data) => data.map((e) => DanhMuc.fromJson(e)).toList());
  }

  static Future<DanhMuc> getDanhMuc(int id)async{
    var dm = await supabase.from("DanhMuc").select().eq("id", id).eq("ma_nguoi_dung", supabase.auth.currentUser!.id).single();
    return DanhMuc.fromJson(dm);
  }

}