import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hapie/controller/auth_controller.dart';
import 'package:hapie/controller/profile_controller.dart';
import 'package:hapie/helper/layout_check_internet.dart';
import 'package:hapie/helper/supabase_helper.dart';
import 'package:hapie/model/profile_model.dart';
import 'package:hapie/page/page_profile_update.dart';
import 'package:hapie/widgets/widget_function.dart';
import 'package:intl/intl.dart';

class PageProfileChiTiet extends StatelessWidget {
  const PageProfileChiTiet({super.key});

  @override
  Widget build(BuildContext context) {
    final fmt = NumberFormat.decimalPattern('vi_VN');

    return Scaffold(
      appBar: AppBar(
        title: Text("Thông tin cá nhân"),
        // backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: LayoutCheckInternet(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: GetBuilder(
              id: "profile",
              init: ProfileController.get(),
              builder: (controller) {
                Profile user = controller.user;
                DateTime ngay_tao = DateTime.parse(controller.user.ngay_tao!);
                return Column(
                  children: [
                    Center(
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 80,
                            backgroundColor: Theme.of(context).primaryColor,
                            backgroundImage:
                            user.url_avatar == null
                                ? AssetImage("assets/images/hapie_user.png")
                                : NetworkImage(user.url_avatar!),
                          ),
                          SizedBox(height: 10,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Chào, ", style: TextStyle(fontSize: 15),),
                              Text("${user.ho_ten}", style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Số dư: ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
                              Text("${controller.hienSoDu?"${fmt.format(user.so_du)}₫":"******"}", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold,color: (user.so_du!<0)?Colors.red:Theme.of(context).textTheme.bodyMedium?.color),),
                              IconButton(
                                  onPressed: () {
                                    controller.changeHienSoDu();
                                  },
                                  icon: Icon(controller.hienSoDu?Icons.visibility:Icons.visibility_off, size: 20,)
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    Container(
                      decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.all(Radius.circular(10))
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Icon(Icons.email, color: Theme.of(context).primaryColor,),
                                SizedBox(width: 15,),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Email", style: TextStyle(color: Theme.of(context).primaryColor)),
                                    Text("${supabase.auth.currentUser!.email}",style: TextStyle(fontSize: 16),)
                                  ],
                                )
                              ],
                            ),
                            SizedBox(height: 20,),
                            Row(
                              children: [
                                Icon(Icons.date_range, color: Theme.of(context).primaryColor,),
                                SizedBox(width: 15,),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Ngày sinh", style: TextStyle(color: Theme.of(context).primaryColor),),
                                    user.ngay_sinh!=null?Text("${DateFormat("dd/MM/yyyy").format(user.ngay_sinh!)}",style: TextStyle(fontSize: 16),):Text("Không xác định")
                                  ],
                                )
                              ],
                            ),
                            SizedBox(height: 20,),
                            Row(
                              children: [
                                Icon(Icons.people_alt_outlined, color: Theme.of(context).primaryColor,),
                                SizedBox(width: 15,),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Giới tính", style: TextStyle(color: Theme.of(context).primaryColor),),
                                    user.gioi_tinh!=null?Text("${user.gioi_tinh}",style: TextStyle(fontSize: 16),):Text("Không xác định")
                                  ],
                                )
                              ],
                            ),
                            SizedBox(height: 20,),
                            Row(
                              children: [
                                Icon(Icons.accessibility_new_outlined, color: Theme.of(context).primaryColor,),
                                SizedBox(width: 15,),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Tham gia", style: TextStyle(color: Theme.of(context).primaryColor)),
                                    Text("${DateFormat("dd/MM/yyyy - HH:mm:ss").format(ngay_tao)}",style: TextStyle(fontSize: 16),)
                                  ],
                                )
                              ],
                            ),
                            Divider(),
                            SizedBox(height: 20,),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ElevatedButton(
                                    style: ButtonStyle(
                                        fixedSize: WidgetStatePropertyAll(Size(MediaQuery.of(context).size.width*0.44, 50))
                                    ),
                                    onPressed: () {
                                      Get.to(PageProfileUpdate());
                                    },
                                    child: Row(
                                      children: [
                                        Icon(Icons.edit),
                                        SizedBox(width: 3,),
                                        Expanded(child: Text("Cập nhật thông tin", style: TextStyle(fontSize: 16), textAlign: TextAlign.center,)),
                                      ],
                                    )
                                ),
                                OutlinedButton(
                                    style: ButtonStyle(
                                      foregroundColor: WidgetStatePropertyAll(Colors.red),
                                      fixedSize: WidgetStatePropertyAll(Size(MediaQuery.of(context).size.width*0.44, 50)),
                                      side: WidgetStatePropertyAll(
                                          BorderSide(
                                              width: 1,
                                              color: Colors.red
                                          )
                                      ),
                                    ),
                                    onPressed: () async{
                                      var kq = await showConfirmDialogTwoButtonDanger(context, "Thao tác này sẽ xóa hết toàn bộ dữ liệu trong tài khoản của bạn (bao gồm cả các giao dịch và số dư)", title: "Xóa dữ liệu"
                                      );
                                      if(kq=="ok"){
                                        await controller.reset_data();
                                        await showConfirmDialogOneButtonSuccess(context, "Đã xóa toàn bộ dữ liệu trong tài khoản, vui lòng đăng nhập lại để tiếp tục sử dụng", title: "Thành công", buttonText: "Đồng ý");
                                        AuthController().logout();
                                      }
                                    },
                                    child: Row(
                                      children: [
                                        Icon(Icons.delete),
                                        SizedBox(width: 3,),
                                        Expanded(child: Text("Reset toàn bộ dữ liệu",style: TextStyle(fontSize: 16), textAlign: TextAlign.center,)),
                                      ],
                                    )
                                ),
                              ],
                            ),
                            SizedBox(height: 8,)
                          ],
                        ),
                      ),
                    )
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
