import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:get/get.dart';
import 'package:hapie/helper/layout_check_internet.dart';
import 'package:hapie/model/profile_model.dart';
import 'package:hapie/page/page_check_auth.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PageAddProfile extends StatelessWidget {
  PageAddProfile({super.key});
  TextEditingController txtHoTen = TextEditingController();
  TextEditingController txtSoDu = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  int getSoDuRaw() {
    final f = txtSoDu.text;
    final numOnly = f.replaceAll(RegExp(r'[^0-9]'), '');
    return int.tryParse(numOnly) ?? 0;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Thêm thông tin tài khoản"),
        // backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: LayoutCheckInternet(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                SizedBox(height: 20,),
                Text("Bạn vui lòng thêm một số thông tin vào tài khoản để bắt đầu với việc quản lý chi tiêu nhé!",style: TextStyle(fontSize: 16), textAlign: TextAlign.center,),
                SizedBox(height: 20,),
                Form(
                  key: _formKey,
                    child:Column(
                      children: [
                        TextFormField(
                          controller: txtHoTen,
                          decoration: InputDecoration(
                            filled: false,
                            border: OutlineInputBorder(),
                            enabledBorder: OutlineInputBorder(),
                            focusedBorder: OutlineInputBorder(),
                            labelText: "Họ và tên",
                            hintText: "Nhập họ và tên...",
                          ),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            if(value == null || value.trim().isEmpty){
                              return "Vui lòng nhập họ và tên";
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 25,),
                        TextFormField(
                          inputFormatters: [MoneyInputFormatter(
                              thousandSeparator: ThousandSeparator.Period,
                              mantissaLength: 0,
                              trailingSymbol: '₫'
                          )],
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          keyboardType: TextInputType.numberWithOptions(signed: false, decimal: false),
                          controller: txtSoDu,
                          decoration: InputDecoration(
                            filled: false,
                            border: OutlineInputBorder(),
                            enabledBorder: OutlineInputBorder(),
                            focusedBorder: OutlineInputBorder(),
                            labelText: "Số dư",
                            hintText: "Nhập số dư của bạn...",
                          ),
                          validator: (value) {
                            if(value == null || value.isEmpty){
                              return "Vui lòng nhập số dư";
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 45,),
                        ElevatedButton(
                            onPressed: () async{
                              if(_formKey.currentState!.validate()){
                                Get.snackbar("Đang thêm", "Vui lòng chờ..");
                                await ProfileSnapshot.insert(
                                    Profile(id: Supabase.instance.client.auth.currentUser!.id, ho_ten: txtHoTen.text.trim(), so_du: getSoDuRaw(), theme_mode: "system")
                                );
                                Get.snackbar("Đã cập nhật thành công", "Thông tin của bạn đã được ghi lại");
                                Get.offAll(PageCheckAuth());
                              }
                            },
                            child: Text("Xác nhận", style: TextStyle(fontSize: 17),)
                        )
                      ],
                    )
                )
              ],
            ),
          )
      ),
    );
  }
}
