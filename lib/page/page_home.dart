import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hapie/controller/giao_dich_controller.dart';
import 'package:hapie/controller/home_controller.dart';
import 'package:hapie/page/page_layout_app.dart';
import 'package:hapie/model/giao_dich_model.dart';
import 'package:hapie/widgets/async_widget.dart';
import 'package:intl/intl.dart';

Widget PageHome(){
  final fmt = NumberFormat.decimalPattern('vi_VN');
  TextEditingController txtSoDu = TextEditingController(text: "${fmt.format(10000)}₫");
  final today = DateTime.now();

  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: GetBuilder(
      id: "home",
      init: HomeController.get(),
      builder: (controller) {
        var selectThang = controller.selectThang;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text("Số dư hiện tại: ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
                Text("${controller.hienSoDu?"${fmt.format(controller.soDu)}₫":"******"}", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: (controller.soDu<0)?Colors.red:Theme.of(mycontext).textTheme.bodyMedium?.color),),
                IconButton(
                  onPressed: () {
                    controller.changeHienSoDu();
                  },
                  icon: Icon(controller.hienSoDu?Icons.visibility:Icons.visibility_off, size: 20,)
                )
              ],
            ),
            Row(
              children: [
                Text("Tình hình thu chi", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
                IconButton(
                    onPressed: () {
                      controller.changeHienTongThuChi();
                    },
                    icon: Icon(controller.hienTongThuChi?Icons.visibility:Icons.visibility_off, size: 20,)
                )
              ],
            ),
            SizedBox(height: 10,),
            Container(
              decoration: BoxDecoration(
                color: Theme.of(mycontext).cardColor,
                borderRadius: BorderRadius.all(Radius.circular(10))
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 8,right: 8,top: 2),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                            onPressed: () {
                              controller.changeThang(DateTime(selectThang.year, selectThang.month-1, 1));
                            },
                            icon: Icon(Icons.keyboard_arrow_left)
                        ),

                        Text((selectThang.year == today.year && selectThang.month == today.month? "Tháng này" : "Tháng ${selectThang.month}/${selectThang.year}"), style: TextStyle(fontWeight: FontWeight.bold),),

                        IconButton(
                          style: ButtonStyle(
                              foregroundColor: (selectThang.year == today.year && selectThang.month == today.month ? WidgetStatePropertyAll(Colors.grey) : Theme.of(mycontext).iconButtonTheme.style?.foregroundColor
                              )
                          ),
                            onPressed: () {
                              if(selectThang.year == today.year && selectThang.month == today.month )
                                return;
                              controller.changeThang(DateTime(selectThang.year, selectThang.month+1, 1));

                            },
                            icon: Icon(Icons.keyboard_arrow_right)
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: SegmentedButton(
                            style: ButtonStyle(
                              // foregroundColor: WidgetStatePropertyAll(Colors.blue),
                              shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                            ),
                            segments:[
                              ButtonSegment(value: false, label: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text("Chi tiêu", style: TextStyle(height: 1.5),),
                                      SizedBox(width: 8,),
                                      (controller.tongChiTieu==controller.tongChiTieuThangTruoc?Icon(Icons.currency_exchange, color: Theme.of(mycontext).primaryColor,size: 16,): controller.tongChiTieu>controller.tongChiTieuThangTruoc? Icon(Icons.arrow_circle_up, color: Colors.red,size: 19):Icon(Icons.arrow_circle_down, color: Colors.green,size: 19,))

                                    ],
                                  ),
                                  !controller.hienTongThuChi?Text("******", style: TextStyle(fontSize: 16),):controller.loading?Text("Đang cập nhật...",style: TextStyle(height: 1.65),):Text("${fmt.format(controller.tongChiTieu)}₫", style: TextStyle(fontSize: 16),)
                                ],
                              ),
                              ),
                              ButtonSegment(value: true, label: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text("Thu nhập", style: TextStyle(height: 1.5),),
                                      SizedBox(width: 8,),
                                      (controller.tongThuNhap==controller.tongThuNhapThangTruoc?Icon(Icons.currency_exchange, color: Theme.of(mycontext).primaryColor,size: 16,):controller.tongThuNhap>controller.tongThuNhapThangTruoc? Icon(Icons.arrow_circle_up, color: Colors.green,size: 19,):Icon(Icons.arrow_circle_down, color: Colors.red,size: 19,))
                                    ],
                                  ),
                                  !controller.hienTongThuChi?Text("******", style: TextStyle(fontSize: 16),):controller.loading?Text("Đang cập nhật...",style: TextStyle(height: 1.65),): Text("${fmt.format(controller.tongThuNhap)}₫",style: TextStyle(fontSize: 16),)
                                ],
                              )),
                            ] ,
                            selected: {controller.selectLoaiGiaoDich},
                            onSelectionChanged: (p0) {
                              controller.doiLoaiGiaoDich(p0.toList()[0]);
                            },
                            showSelectedIcon: false,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10,),
                    Row(
                      children: [
                        Icon(Icons.insert_chart_outlined, color: Theme.of(mycontext).primaryColor,size: 25,),
                        SizedBox(width: 10,),
                        controller.selectLoaiGiaoDich?
                        Row(
                          children: [
                            Text("${controller.tongThuNhap==controller.tongThuNhapThangTruoc?"Không thay đổi" : controller.tongThuNhap>controller.tongThuNhapThangTruoc?"Tăng":"Giảm"} "),
                            controller.tongThuNhap==controller.tongThuNhapThangTruoc?Text("") : Text("${fmt.format(controller.tongThuNhap-controller.tongThuNhapThangTruoc)}₫ ", style: TextStyle(color: controller.tongThuNhap>controller.tongThuNhapThangTruoc?Colors.green:Colors.red),),
                            Text("so với tháng trước"),
                          ],
                        ):
                        Row(
                          children: [
                            Text("${controller.tongChiTieu==controller.tongChiTieuThangTruoc?"Không thay đổi" : controller.tongChiTieu>controller.tongChiTieuThangTruoc?"Tăng":"Giảm"} "),
                            controller.tongChiTieu==controller.tongChiTieuThangTruoc?Text(""):Text("${fmt.format(controller.tongChiTieu-controller.tongChiTieuThangTruoc)}₫ ", style: TextStyle(color: controller.tongChiTieu>controller.tongChiTieuThangTruoc?Colors.red:Colors.green),),
                            Text("so với tháng trước"),
                          ],
                        )
                      ],
                    ),
                    // SizedBox(height: 10,),
                    Divider(),
                    Text("Chi tiết từng danh mục:"),
                    SizedBox(height: 10,),
                    StreamBuilder(
                      stream: GiaoDichSnapshot.getThuChiTheoDanhMuc(controller.selectLoaiGiaoDich, controller.selectThang),
                      builder: (context, snapshot) {
                        return AsyncWidget(
                          snapshot: snapshot,
                          builder: (context, snapshot) {
                            var list = snapshot.data! as List;
                            // print("list ${list}");
                            return list.isEmpty?
                            Center(
                                child: Column(
                                  children: [
                                    SizedBox(height: 10,),
                                    Text("Không tìm thấy mục nào!",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontStyle: FontStyle.italic
                                      ),
                                    ),
                                  ],
                                )
                            ) :
                            ListView.separated(
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                var json = list[index];
                                return Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(json["danh_muc"], style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15),),
                                    Text("${fmt.format(json["tong_tien"])}₫", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15),),
                                  ],
                                );
                              },
                              separatorBuilder: (context, index) => Divider(),
                              itemCount: list.length,
                            );
                          },
                        );
                      },
                    ),
                    SizedBox(height: 30,)
                  ],
                ),
              ),
            ),
            //fix lỗi
            GetBuilder(
              init: GiaoDichController.get(),
                builder: (controller) => Container(),
            )
          ],
        );
      },
    ),
  );
}