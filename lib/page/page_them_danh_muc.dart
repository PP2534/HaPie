import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hapie/helper/layout_check_internet.dart';
import 'package:hapie/helper/supabase_helper.dart';
import 'package:hapie/model/danh_muc_model.dart';


class PageAddDanhMuc extends StatefulWidget {
  const PageAddDanhMuc({super.key});

  @override
  State<PageAddDanhMuc> createState() => _PageAddDanhMucState();

}

class _PageAddDanhMucState extends State<PageAddDanhMuc> {
  final TextEditingController txtTenDanhMuc = TextEditingController();
  final TextEditingController txtGhiChu = TextEditingController();

  bool _isThu = true;

  final String _maNguoiDung = supabase.auth.currentUser!.id;

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    return Scaffold(
      appBar: AppBar(
        title: Text("Thêm Danh Mục"),
        // backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: LayoutCheckInternet(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(12),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20,),
                TextFormField(
                  validator: (value) {
                    if(value==null || value.trim().isEmpty){
                      return "Vui lòng nhập tên danh mục";
                    }
                    return null;
                  },
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: txtTenDanhMuc,
                  decoration: InputDecoration(
                      labelText: "Tên danh mục",
                    hintText: "Nhập tên danh mục"
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: txtGhiChu,
                  decoration: InputDecoration(
                      labelText: "Ghi chú",
                    hintText: "Nhập ghi chú (không bắt buộc)"
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<bool>(
                        dropdownColor: Theme.of(context).cardColor,
                        decoration: InputDecoration(
                          labelText: "Loại danh mục"
                        ),
                        value: _isThu,
                        items: const [
                          DropdownMenuItem(value: true, child: Text("Thu nhập")),
                          DropdownMenuItem(value: false, child: Text("Chi tiêu")),
                        ],
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              _isThu = value;
                            });
                          }
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 390),
                Center(
                  child: ElevatedButton(
                      onPressed: () async {
                        if(_formKey.currentState!.validate()){
                          try {
                            DanhMuc danhMuc = DanhMuc(
                              ten_danh_muc: txtTenDanhMuc.text,
                              loai_danh_muc: _isThu,
                              ma_nguoi_dung: _maNguoiDung,
                              ghi_chu: txtGhiChu.text,
                            );

                            print("Gửi dữ liệu: ${danhMuc.toJson()}");

                            await DanhMucSnapShot.insert(danhMuc);

                            // Nếu không có lỗi -> hiện thành công
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Đã thêm danh mục thành công")),
                            );
                            Get.back(result: danhMuc);
                          } catch (e) {
                            print("Lỗi khi thêm: $e");

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Không thể thêm danh mục")),
                            );
                          }
                        }
                      },
                    child: Text("Thêm Danh Mục", style: TextStyle(fontSize: 18),),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
