import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:get/get.dart';
import 'package:hapie/controller/giao_dich_controller.dart';
import 'package:hapie/controller/home_controller.dart';
import 'package:hapie/helper/layout_check_internet.dart';
import 'package:hapie/helper/supabase_helper.dart';
import 'package:hapie/model/danh_muc_model.dart';
import 'package:hapie/model/giao_dich_model.dart';
import 'package:hapie/page/page_check_auth.dart';
import 'package:hapie/page/page_them_danh_muc.dart';
import 'package:hapie/widgets/widget_function.dart';
import 'package:intl/intl.dart';

class PageThemGiaoDich extends StatelessWidget {
  bool capNhat;
  GiaoDich? capNhatGiaoDich;
  PageThemGiaoDich({super.key, this.capNhat = false, this.capNhatGiaoDich});

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final fmt = NumberFormat.decimalPattern('vi_VN');
    TextEditingController txtSoTien = TextEditingController(text: (capNhat ? fmt.format(capNhatGiaoDich!.so_tien) + "₫" : ""));
    TextEditingController txtNgayGiaoDich = TextEditingController(text: capNhat?  "${DateFormat("dd/MM/yyyy").format(capNhatGiaoDich!.ngay_giao_dich)}" : "${DateFormat("dd/MM/yyyy").format(today)}");
    TextEditingController txtGhiChu = TextEditingController(text: (capNhat? capNhatGiaoDich!.ghi_chu : ""));
    DateTime selectNgayGiaoDich = capNhat ? capNhatGiaoDich!.ngay_giao_dich : DateTime.now();
    int maDM = 1;
    bool? loai_giao_dich = capNhat? capNhatGiaoDich!.danh_muc.loai_danh_muc : null;

    final _formKey = GlobalKey<FormState>();
    int getSoTienRaw() {
      final f = txtSoTien.text;
      final numOnly = f.replaceAll(RegExp(r'[^0-9]'), '');
      return int.tryParse(numOnly) ?? 0;
    }

    Future<void> pickDate() async{

      final picked = await showDatePicker(
          context: context,
          firstDate: DateTime(today.year - 5),
          lastDate: DateTime(today.year + 5),
          fieldLabelText: "Chọn ngày giao dịch",
          cancelText: "Hủy",
          helpText: "Chọn ngày giao dịch"
      );
      if(picked != null)
        selectNgayGiaoDich = picked;
        txtNgayGiaoDich.text = DateFormat("dd/MM/yyyy").format(selectNgayGiaoDich);
        // txtNgayGiaoDich.text = "${selectNgayGiaoDich.day}/${selectNgayGiaoDich.month}/${selectNgayGiaoDich.year}";
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(capNhat? "Cập nhật giao dịch":"Thêm Giao Dịch"),
        // backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: LayoutCheckInternet(
          child: SingleChildScrollView(
            child: GetBuilder(
              id: "them_giao_dich",
              init: GiaoDichController.get(),
              builder: (controller) {
                if(controller.isLoadingDM){
                  return Container(
                    height: MediaQuery.of(context).size.height*0.8,
                    child: Center(child: CircularProgressIndicator())
                  );
                }
                if(controller.dsdm.length == 0){
                  return Padding(
                    padding: const EdgeInsets.only(left: 25, right: 25),
                    child: Container(
                      height: MediaQuery.of(context).size.height*0.86,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Container(
                                child: Center(child: Text("Hiện chưa có danh mục thuộc loại ${controller.selectLoaiGiaoDich?"THU NHẬP":"CHI TIÊU"}\nBạn vui lòng thêm ít nhất 1 danh mục loại này để tiếp tục.", textAlign: TextAlign.center,))
                            ),
                          ),
                          ElevatedButton(
                            onPressed: (){
                              Get.to(PageAddDanhMuc());
                            }, child: Text("Thêm danh mục")
                          )
                        ],
                      ),
                    ),
                  );
                }
                if(capNhat){
                  if(controller.selectLoaiGiaoDich==capNhatGiaoDich!.danh_muc.loai_danh_muc){
                    maDM = capNhatGiaoDich!.danh_muc.id!;
                  }
                  else{
                    maDM = controller.dsdm.last.id!;
                  }
                }
                else{
                  maDM = controller.dsdm.last.id!;
                }
                if(loai_giao_dich!=null&&controller.selectLoaiGiaoDich!=loai_giao_dich){
                  // controller.selectLoaiGiaoDich = loai_giao_dich!;

                  controller.doiLoaiGiaoDich(loai_giao_dich!);
                }

                // for(var x in controller.dsdm){
                //   print(x.id!);
                // }
                var menu = controller.dsdm.map(
                  (dm) => DropdownMenuItem(
                    child: Text(dm.ten_danh_muc),
                    value: dm.id,
                  ),
                ).toList();
                menu.add(
                  DropdownMenuItem(
                    value: 0,
                  child: Text("Thêm danh mục", style: TextStyle(color: Colors.red),)
                  )
                );
                // print("Menu ${menu}");
                final _formKey1 = GlobalKey<FormState>();
                return Padding(
                  padding: const EdgeInsets.only(top: 10, left: 15, right: 15),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: SegmentedButton(
                              style: ButtonStyle(
                                // foregroundColor: WidgetStatePropertyAll(Colors.blue),
                                shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                              ),
                              segments:[
                                ButtonSegment(value: false, label: Text("Chi Tiêu", style: TextStyle(height: 3),), ),
                                ButtonSegment(value: true, label: Text("Thu Nhập")),
                              ] ,
                              selected: {controller.selectLoaiGiaoDich},
                              onSelectionChanged: (p0) {
                                if(capNhat){
                                  loai_giao_dich = p0.toList()[0];


                                }
                                controller.doiLoaiGiaoDich(p0.toList()[0]);
                              },
                              showSelectedIcon: false,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 15,),
                      // CÁC TRƯỜNG
                      Form(
                        key: _formKey,
                          child: Column(
                            children: [

                              // NHẬP TIỀN
                              TextFormField(
                                inputFormatters: [MoneyInputFormatter(
                                  thousandSeparator: ThousandSeparator.Period,
                                  mantissaLength: 0,
                                  trailingSymbol: '₫'
                                )],
                                autovalidateMode: AutovalidateMode.onUserInteraction,
                                keyboardType: TextInputType.numberWithOptions(signed: false, decimal: false),
                                controller: txtSoTien,
                                decoration: InputDecoration(
                                  filled: fill_input,
                                  border: OutlineInputBorder(),
                                  enabledBorder: OutlineInputBorder(),
                                  focusedBorder: OutlineInputBorder(),
                                  labelText: "Số tiền",
                                  hintText: "Nhập số tền",
                                ),
                                validator: (value) {
                                  if(value == null || value.isEmpty){
                                    return "Vui lòng nhập số tiền";
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(height: 25,),

                              // DANH MỤC
                              DropdownButtonFormField(
                                key: _formKey1,
                                dropdownColor: Theme.of(context).cardColor,
                                decoration: InputDecoration(
                                  filled: fill_input,
                                  border: OutlineInputBorder(),
                                  enabledBorder: OutlineInputBorder(),
                                  focusedBorder: OutlineInputBorder(),
                                  labelText: "Danh mục",
                                  hintText: "Chọn danh mục"
                                ),
                                value: maDM,
                                items: menu,
                                onChanged: (value) async{
                                  if(value == 0){
                                    var maDMOld = maDM;
                                    DanhMuc? dm = await Get.to(PageAddDanhMuc());
                                    if(dm != null){
                                      controller.selectLoaiGiaoDich = dm.loai_danh_muc;
                                    }
                                    else{
                                      maDM = maDMOld;
                                    }
                                    controller.update(["them_giao_dich"]);
                                  }
                                  else{
                                    maDM = value!;
                                  }
                                },
                                validator: (value) {
                                  if(value == null){
                                    return "Vui lòng chọn danh mục";
                                  }
                                },
                              ),
                              SizedBox(height: 25,),

                              // NGÀY GIAO DỊCH
                              TextFormField(
                                decoration: InputDecoration(
                                  filled: fill_input,
                                  border: OutlineInputBorder(),
                                  enabledBorder: OutlineInputBorder(),
                                  focusedBorder: OutlineInputBorder(),
                                  labelText: "Ngày giao dịch",
                                  hintText: "Chọn ngày giao dịch",
                                ),
                                controller: txtNgayGiaoDich,
                                readOnly: true,
                                onTap: pickDate,
                              ),
                              SizedBox(height: 20,),

                              // GHI CHÚ
                              TextFormField(
                                controller: txtGhiChu,
                                decoration: InputDecoration(
                                  filled: fill_input,
                                  border: OutlineInputBorder(),
                                  enabledBorder: OutlineInputBorder(),
                                  focusedBorder: OutlineInputBorder(),
                                  labelText: "Ghi chú",
                                  hintText: "Nhập ghi chú (không bắt buộc)",
                                ),
                                autovalidateMode: AutovalidateMode.onUserInteraction,
                                validator: (value) {
                                  if(value!=null && value.length > 90){
                                    return "Đã đạt giới hạn nhập ${value.length}/90";
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(height: 250,),

                              // NÚT THÊM GIAO DỊCH
                              ElevatedButton(
                                  onPressed: () async{
                                    if(_formKey.currentState!.validate()) {
                                      if (capNhat) {
                                        showSnackBar(context,
                                            message: "Đang cập nhật giao dịch");
                                        DanhMuc dm = await DanhMucSnapShot
                                            .getDanhMuc(maDM);
                                        capNhatGiaoDich!.danh_muc = dm;
                                        // capNhatGiaoDich!.danh_muc.loai_danh_muc = controller.selectLoaiGiaoDich;
                                        capNhatGiaoDich!.so_tien =
                                            getSoTienRaw();
                                        // capNhatGiaoDich!.danh_muc.id = maDM;
                                        capNhatGiaoDich!.ngay_giao_dich =
                                            selectNgayGiaoDich;
                                        capNhatGiaoDich!.ghi_chu =
                                            txtGhiChu.text;
                                        await GiaoDichSnapshot.update(
                                            capNhatGiaoDich!);
                                        showSnackBar(context,
                                            message: "Cập nhật thành công!");
                                      }
                                      else {
                                        showSnackBar(context,
                                            message: "Đang thêm giao dịch");
                                        DanhMuc danhMuc = DanhMuc(id: maDM,
                                            ten_danh_muc: "",
                                            loai_danh_muc: controller
                                                .selectLoaiGiaoDich,
                                            ma_nguoi_dung: "",
                                            ghi_chu: "");
                                        GiaoDich gdmoi = new GiaoDich(
                                            danh_muc: danhMuc,
                                            so_tien: getSoTienRaw(),
                                            ngay_giao_dich: selectNgayGiaoDich,
                                            ghi_chu: txtGhiChu.text
                                        );
                                        await GiaoDichSnapshot.insert(gdmoi);
                                        showSnackBar(context,
                                            message: "Thêm giao dịch thành công!");
                                      }
                                      controller.loadGiaoDich();
                                      HomeController.get().refesh();
                                      Get.back(result: capNhatGiaoDich);
                                    }
                                  },
                                  child: Text(capNhat? "Cập nhật giao dịch":"Thêm giao dịch")
                              )
                            ],
                          ),
                      )
                    ],
                  ),
                );
              },
            ),
          )
      ),
    );
  }
}
