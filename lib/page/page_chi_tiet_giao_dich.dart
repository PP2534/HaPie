import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hapie/controller/giao_dich_controller.dart';
import 'package:hapie/controller/home_controller.dart';
import 'package:hapie/helper/layout_check_internet.dart';
import 'package:hapie/model/giao_dich_model.dart';
import 'package:hapie/page/page_them_giao_dich.dart';
import 'package:intl/intl.dart';

import 'page_layout_app.dart';
import '../widgets/widget_function.dart';

class PageChiTietGiaoDich extends StatefulWidget {
  GiaoDich gd;

  PageChiTietGiaoDich({super.key, required this.gd});

  @override
  State<PageChiTietGiaoDich> createState() => _PageChiTietGiaoDichState();
}

class _PageChiTietGiaoDichState extends State<PageChiTietGiaoDich> {
  final fmt = NumberFormat.decimalPattern('vi_VN');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chi tiết giao dịch"),
        // backgroundColor: Color(0xFF9AF6E8),
      ),
      // backgroundColor: Color(0xFF9AF6E8),
      backgroundColor: Theme.of(context).colorScheme.tertiaryContainer,
      body: LayoutCheckInternet(
        child: Stack(
          children:[
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15),
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(15),

                    ),
                    // height: 350,
                    // color: Colors.white,
                    margin: const EdgeInsets.only(top: 60),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 15, right: 15),
                      child: Column(
                        mainAxisSize: MainAxisSize.min ,
                        children: [
                          SizedBox(height: 55,),
                          Text("${widget.gd.danh_muc.loai_danh_muc? "Thu nhập" : "Chi tiêu"}", style: TextStyle(color: Colors.grey)),
                          SizedBox(height: 0.3,),
                          Text("${fmt.format(widget.gd.so_tien)}₫", style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),),
                          SizedBox(height: 30,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Thời gian", style: TextStyle(color: Colors.grey),),
                              Text("${ds_tuan[widget.gd.ngay_giao_dich.weekday-1]}, ${DateFormat("dd/MM/yyyy").format(widget.gd.ngay_giao_dich)}", style: TextStyle(fontWeight: FontWeight.bold),),
                            ],
                          ),
                          SizedBox(height: 7,),
                          Divider(),
                          SizedBox(height: 7,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Danh mục", style: TextStyle(color: Colors.grey),),
                              Text("${widget.gd.danh_muc.ten_danh_muc}", style: TextStyle(fontWeight: FontWeight.bold),)
                            ],
                          ),
                          SizedBox(height: 7,),
                          Divider(),
                          SizedBox(height: 7,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Ghi chú", style: TextStyle(color: Colors.grey),),
                              SizedBox(width: 7,),
                              Expanded(child: Text("${widget.gd.ghi_chu??"Không có ghi chú"}", style: TextStyle(fontWeight: FontWeight.bold),textAlign: TextAlign.end,))
                            ],
                          ),
                          SizedBox(height: 19,),
                          // duong net dut
                          DottedLine(
                            dashLength: 7,
                            dashColor: Colors.grey,
                          ),
                        ]
                      ),
                    ),
                  ),

                  // NÚT BẤM
                  Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 15, right: 15),
                      child: Row(
                        children: [
                          // XOA
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () async{
                                var xacNhan = await showConfirmDialogTwoButtonDanger(
                                  context,
                                  "Bạn có muốn xóa ${widget.gd.ghi_chu ?? "giao dịch này không?"}",
                                );
                                if (xacNhan == "ok") {
                                  await GiaoDichSnapshot.delete(widget.gd.id!);
                                  showSnackBar(
                                    context,
                                    message:
                                    "Đã xóa ${widget.gd.ghi_chu ?? "giao dịch"}",
                                  );
                                  GiaoDichController.get().loadGiaoDich();
                                  HomeController.get().refesh();
                                  Get.back();
                                }
                              },
                              style: ButtonStyle(
                                // fixedSize: WidgetStatePropertyAll(Size(MediaQuery.of(context).size.width*0.35,57)),
                                backgroundColor: WidgetStatePropertyAll(Colors.transparent), // màu nền
                                shadowColor: WidgetStatePropertyAll(Colors.transparent), // màu viền
                                foregroundColor: WidgetStatePropertyAll(Theme.of(context).textTheme.bodyMedium?.color), // màu các phần tử con
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.delete),
                                  SizedBox(width: 3),
                                  Text("Xóa", style: TextStyle(fontWeight: FontWeight.bold),), // neu trong nay co mau se ưu tien hien mau nay
                                ],
                              ),
                            ),
                          ),

                          // NUT PHAN CACH
                          // VerticalDivider(color: Colors.black,width: 22,),
                          SizedBox(width: 3,),
                          Container(
                            height: 35,
                            width: 1,
                            color: Colors.grey,
                          ),
                          SizedBox(width: 3,),

                          // CHINH SUA
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () async{
                                GiaoDich? newCTGD = await Get.to(PageThemGiaoDich(capNhat: true, capNhatGiaoDich: widget.gd,));
                                // print(" ctgd: ${newCTGD}");
                                if(newCTGD!=null){
                                  setState(() {
                                    widget.gd = newCTGD;
                                  });
                                }
                                GiaoDichController.get().loadGiaoDich();
                              },
                              style: ButtonStyle(
                                // fixedSize: WidgetStatePropertyAll(Size(MediaQuery.of(context).size.width*0.35,57)),
                                backgroundColor: WidgetStatePropertyAll(Colors.transparent),
                                shadowColor: WidgetStatePropertyAll(Colors.transparent),
                                foregroundColor: WidgetStatePropertyAll(Theme.of(context).textTheme.bodyMedium?.color),
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.edit),
                                  SizedBox(width: 3),
                                  Text("Chỉnh sửa"),
                                ],
                              )
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),


            //ICON
            Positioned(
                top: 20,
                left: 0,
                right: 0,
                child: Container(
                  padding: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      // border: Border.all(color: Colors.grey, width: 0.1),
                      color: Theme.of(context).cardColor
                  ),
                  child: Container(
                      padding: EdgeInsets.all(13),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.grey, width: 0.1),
                        color: widget.gd.danh_muc.loai_danh_muc? Color(0xFF92E47B) : Color(0xFFF18A8A),
                      ),
                      height: 75,
                      child: Image.asset(widget.gd.danh_muc.loai_danh_muc ? "assets/icons/thu.png" : "assets/icons/chi.png", ),
                  ),
                )
            ),
          ],
        ),
      ),
    );
  }
}
