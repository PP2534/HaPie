import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hapie/helper/layout_check_internet.dart';
import 'package:hapie/helper/supabase_helper.dart';
import 'package:hapie/model/danh_muc_model.dart';


class PageUpdateDanhMuc extends StatefulWidget {
  PageUpdateDanhMuc({super.key, required this.danhmuc});
  DanhMuc danhmuc;

  @override
  State<PageUpdateDanhMuc> createState() => _PageUpdateDanhMucState();
}

class _PageUpdateDanhMucState extends State<PageUpdateDanhMuc> {
  final TextEditingController txtTenDanhMuc = TextEditingController();
  final TextEditingController txtGhiChu = TextEditingController();
  bool _isThu = true;

  @override
  void initState() {
    super.initState();
    txtTenDanhMuc.text = widget.danhmuc.ten_danh_muc;
    txtGhiChu.text = widget.danhmuc.ghi_chu??"";
    _isThu = widget.danhmuc.loai_danh_muc;
  }

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    return Scaffold(
      appBar: AppBar(
        title: Text("Cập nhật danh mục"),
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
                SizedBox(height: 35),
                Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      if(_formKey.currentState!.validate()){
                        try {
                          widget.danhmuc.ten_danh_muc = txtTenDanhMuc.text.trim();
                          widget.danhmuc.loai_danh_muc=_isThu;
                          widget.danhmuc.ghi_chu = txtGhiChu.text.trim();

                          print("Gửi dữ liệu: ${widget.danhmuc.toJson()}");

                          await DanhMucSnapShot.Update(widget.danhmuc);

                          // Nếu không có lỗi -> hiện thành công
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Đã cập nhật danh mục thành công")),
                          );

                          Get.back();
                        } catch (e) {
                          print("Lỗi khi thêm: $e");

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Không thể cập nhât danh mục")),
                          );
                        }
                      }
                    },

                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Cập nhật", style: TextStyle(fontSize: 18),),
                      ],
                    ),
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
