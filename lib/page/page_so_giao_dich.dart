import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:hapie/controller/giao_dich_controller.dart';
import 'package:hapie/main.dart';
import 'package:hapie/model/giao_dich_model.dart';
import 'package:hapie/page/page_check_auth.dart';
import 'package:hapie/page/page_chi_tiet_giao_dich.dart';
import 'package:hapie/page/page_layout_app.dart';
import 'package:hapie/page/page_them_giao_dich.dart';
import 'package:hapie/widgets/async_widget.dart';
import 'package:hapie/widgets/widget_function.dart';
import 'package:intl/intl.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';


Widget PageSoGiaoDich() {
  final fmt = NumberFormat.decimalPattern('vi_VN');
  final today = DateTime.now();

  return GetBuilder(
    id: "giao_dich",
    init: GiaoDichController.get(),
    builder: (controller) {
      var selectMonth = controller.selectMonth;
      controller.loadDanhMuc_loc("all");
      return Column(
        children: [
          // NGAY GIAO DICH
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(width: 43,),
              //
              IconButton(
                  onPressed: () {
                    controller.changeMonth(
                        DateTime(selectMonth.year, selectMonth.month - 1, 1));
                  },
                  icon: Icon(Icons.keyboard_arrow_left)
              ),
              SizedBox(width: 9,),
              Container(
                  width: 120,
                  child: Text((selectMonth.year == today.year &&
                      selectMonth.month == today.month
                      ? "Tháng này"
                      : "Tháng ${selectMonth.month}/${selectMonth.year}"),
                    style: TextStyle(fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,)
              ),
              SizedBox(width: 9,),
              IconButton(
                  style: ButtonStyle(
                      foregroundColor: (selectMonth.year == today.year &&
                          selectMonth.month == today.month
                          ? WidgetStatePropertyAll(Colors.grey)
                          : Theme
                          .of(mycontext)
                          .iconButtonTheme
                          .style
                          ?.foregroundColor
                      )
                  ),
                  onPressed: () {
                    if (selectMonth.year == today.year &&
                        selectMonth.month == today.month)
                      return;
                    controller.changeMonth(
                        DateTime(selectMonth.year, selectMonth.month + 1, 1));
                  },
                  icon: Icon(Icons.keyboard_arrow_right)
              ),
              // SizedBox(width: 10,),

              // LOC
              IconButton(
                onPressed: () {
                  showModalBottomSheet(
                    context: mycontext,
                    isScrollControlled: true,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(12))),
                    builder: (context) {
                      TextEditingController txtThangGiaoDich = TextEditingController(text: "Tháng ${DateFormat("MM/yyyy").format(selectMonth)}");
                      DateTime selectThangGiaoDich = selectMonth;
                      int maDM = controller.maDM_loc;
                      String loai_giao_dich = controller.loai_giao_dich_loc;
                      final _formKey = GlobalKey<FormState>();
                      Future<void> pickMonth() async{
                        final picked = await showMonthPicker(
                          context: mycontext,
                          firstDate: DateTime(today.year - 5),
                          lastDate: DateTime(today.year, today.month),
                          initialDate: selectThangGiaoDich,
                          monthPickerDialogSettings: MonthPickerDialogSettings(
                            dialogSettings: PickerDialogSettings(
                              textScaleFactor: 0.8,
                              dialogBackgroundColor: Theme.of(context).cardColor
                            )
                          )
                        );
                        if(picked != null)
                          selectThangGiaoDich = picked;
                        txtThangGiaoDich.text = "Tháng ${DateFormat("MM/yyyy").format(selectThangGiaoDich)}";
                      }
                      return GetBuilder(
                        id: "loc_giao_dich",
                          init: GiaoDichController.get(),
                          builder: (loc_controller) {
                            final _formKey1 = GlobalKey<FormState>();
                            var menu = loc_controller.dsdm.map(
                                  (dm) => DropdownMenuItem(
                                child: Text(dm.ten_danh_muc),
                                value: dm.id,
                              ),
                            ).toList();
                            menu.insert(
                                    0, DropdownMenuItem(
                                    value: 0,
                                    child: Text("Tất cả")
                                )
                            );

                            return Container(
                              height: MediaQuery.of(context).size.height*0.9,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    SizedBox(height: 13,),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text("Bộ lọc", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18), ),
                                      ],
                                    ),
                                    SizedBox(height: 12,),
                                    DropdownButtonFormField(
                                      key: _formKey,
                                      dropdownColor: Theme.of(context).cardColor,
                                      decoration: InputDecoration(
                                          filled: user?.theme_mode=="dark" || (user?.theme_mode=="system" && MediaQuery.of(context).platformBrightness == Brightness.dark),
                                          border: OutlineInputBorder(),
                                          enabledBorder: OutlineInputBorder(),
                                          focusedBorder: OutlineInputBorder(),
                                          labelText: "Loại giao dịch",
                                          hintText: "Chọn loại giao dịch"
                                      ),
                                      value: loai_giao_dich,
                                      items: [
                                        DropdownMenuItem(
                                          child: Text("Tất cả"),
                                          value: "all",
                                        ),
                                        DropdownMenuItem(
                                          child: Text("Chi tiêu"),
                                          value: "chi",
                                        ),
                                        DropdownMenuItem(
                                          child: Text("Thu nhập"),
                                          value: "thu",
                                        ),
                                      ],
                                      onChanged: (value) async{
                                        loai_giao_dich = value!;
                                        maDM=0;
                                        loc_controller.loadDanhMuc_loc(loai_giao_dich);
                                      }
                                    ),
                                    SizedBox(height: 12,),
                                    // AnimatedToggleSwitch<bool>.size(
                                    //   current: controller.selectLoaiGiaoDich,
                                    //   values: const [false, true],
                                    //   iconOpacity: 0.2,
                                    //   indicatorSize: const Size.fromWidth(150),
                                    //   customIconBuilder: (context, local, global) => Text(local.value ? "Chi tiêu" : "Thu nhập", style: TextStyle(color: Color.lerp(Colors.red, Colors.blue, local.animationValue)),),
                                    //   borderWidth: 5.0,
                                    //   iconAnimationType: AnimationType.onHover,
                                    //   style: ToggleStyle(
                                    //     indicatorColor: Colors.teal,
                                    //     borderColor: Colors.transparent,
                                    //     borderRadius: BorderRadius.circular(10),
                                    //     boxShadow: [
                                    //       BoxShadow(
                                    //         color: Colors.black26,
                                    //         spreadRadius: 1,
                                    //         blurRadius: 2,
                                    //         offset: Offset(0, 10)
                                    //       )
                                    //     ]
                                    //   ),
                                    //   selectedIconScale: 1.0,
                                    //   onChanged: (value) => controller,
                                    // )
                                    DropdownButtonFormField(
                                      key: _formKey1,
                                      dropdownColor: Theme.of(context).cardColor,
                                      decoration: InputDecoration(
                                          filled: user?.theme_mode=="dark" || (user?.theme_mode=="system" && MediaQuery.of(context).platformBrightness == Brightness.dark),
                                          border: OutlineInputBorder(),
                                          enabledBorder: OutlineInputBorder(),
                                          focusedBorder: OutlineInputBorder(),
                                          labelText: "Danh mục",
                                          hintText: "Chọn danh mục"
                                      ),
                                      value: maDM,
                                      items: menu,
                                      onChanged: (value) async{
                                          maDM = value!;
                                      }
                                    ),
                                    SizedBox(height: 25,),

                                    // NGÀY GIAO DỊCH
                                    TextFormField(
                                      decoration: InputDecoration(
                                        filled: user?.theme_mode=="dark" || (user?.theme_mode=="system" && MediaQuery.of(context).platformBrightness == Brightness.dark),
                                        border: OutlineInputBorder(),
                                        enabledBorder: OutlineInputBorder(),
                                        focusedBorder: OutlineInputBorder(),
                                        labelText: "Tháng giao dịch",
                                        hintText: "Chọn tháng giao dịch",
                                      ),
                                      controller: txtThangGiaoDich,
                                      readOnly: true,
                                      onTap: pickMonth,
                                    ),
                                    Spacer(),
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        OutlinedButton(
                                            style: ButtonStyle(
                                              fixedSize: WidgetStatePropertyAll(Size(MediaQuery.of(context).size.width*0.44, 50)),
                                              side: WidgetStatePropertyAll(
                                                  BorderSide(
                                                      width: 1,
                                                  )
                                              ),
                                            ),
                                            onPressed: () async{
                                              controller.huyLocGiaoDich();
                                            },
                                            child: Text("Xóa bộ lọc",style: TextStyle(fontSize: 16), textAlign: TextAlign.center,)
                                        ),
                                        ElevatedButton(
                                            style: ButtonStyle(
                                                fixedSize: WidgetStatePropertyAll(Size(MediaQuery.of(context).size.width*0.44, 50))
                                            ),
                                            onPressed: () {
                                              controller.locGiaoDich(selectThangGiaoDich, loai_giao_dich, maDM);
                                            },
                                            child: Text("Áp dụng", style: TextStyle(fontSize: 16), textAlign: TextAlign.center,)
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 20,)
                                  ],
                                ),
                              ),
                            );
                          },
                      );
                    },
                  );
                },
                icon: Badge(
                  label: Text("${controller.number_loc}"),
                  isLabelVisible: controller.number_loc>0,
                  child: Icon(Icons.filter_alt_outlined),
                )
              ),

            ],
          ),
          Expanded(
            child: GetBuilder(
              init: controller,
              id: "giao_dich",
              builder: (controller) {
                if(controller.isLoading){
                  return Center(child: CircularProgressIndicator());
                }

                if(controller.dsgd.length ==0){
                  return Center(child: Text("Không có giao dịch nào trong tháng này!", style: TextStyle(fontStyle: FontStyle.italic)));
                }

              return Padding(
                  padding: const EdgeInsets.only(left: 5, right: 5),
                  child: GroupedListView(
                    elements: controller.dsgd,
                    groupBy: (element) {
                      // "${element.ngay_giao_dich.day}/${element.ngay_giao_dich.month}/${element.ngay_giao_dich.year}";
                      return DateTime(element.ngay_giao_dich.year,
                          element.ngay_giao_dich.month,
                          element.ngay_giao_dich.day);
                    },
                    itemComparator: (element1, element2) {
                      return element1.ngay_tao!.compareTo(element2.ngay_tao!);
                    },
                    useStickyGroupSeparators: true,
                    // THANG/NAM
                    groupSeparatorBuilder: (value) {
                      return Container(
                        padding: const EdgeInsets.only(top: 17),
                        child: Container(
                          width: MediaQuery
                              .of(mycontext)
                              .size
                              .width,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                                "${DateFormat("dd/MM/yyyy").format(value)}"),
                          ),
                          color: Theme
                              .of(mycontext)
                              .colorScheme
                              .surfaceVariant,
                        ),
                        color: Theme
                            .of(mycontext)
                            .bottomAppBarTheme
                            .color,
                      );
                    },
                    order: GroupedListOrder.DESC,
                    separator: Divider(height: 1,),
                    itemBuilder: (context, element) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 8, bottom: 8),
                        child: GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 9, right: 9),
                            child: Row(
                              children: [
                                // ICON
                                Container(
                                    padding: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                          color: Colors.grey, width: 0.1),
                                      color: Colors.transparent,
                                    ),
                                    child: (element.danh_muc.loai_danh_muc ? Icon(
                                      Icons.attach_money, color: Colors.green,
                                      size: 30,) : Icon(
                                      Icons.payment_outlined,
                                      color: Colors.red, size: 30,))
                                ),
                                SizedBox(width: 4,),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment
                                        .start,
                                    children: [
                                      Text("${element.ghi_chu != null && element.ghi_chu!.isNotEmpty && element.ghi_chu != "" ?
                                          element.ghi_chu : "${element.danh_muc.loai_danh_muc ?
                                          "Nhận tiền ${element.danh_muc.ten_danh_muc}" : "Chi tiêu cho ${element.danh_muc.ten_danh_muc}"}"}",
                                        style: TextStyle(fontSize: 18),),
                                      SizedBox(height: 6,),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment
                                            .spaceBetween,
                                        children: [
                                          Text("${element.danh_muc.ten_danh_muc}",
                                            style: TextStyle(
                                                color: Colors.grey),),
                                          Text("${element.danh_muc.loai_danh_muc
                                              ? "+"
                                              : "-" }${fmt.format(
                                              element.so_tien)}₫",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                                color: element.danh_muc.loai_danh_muc
                                                    ? Colors.green
                                                    : Colors.redAccent),)
                                        ],
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          onTap: () {
                            Get.to(PageChiTietGiaoDich(gd: element));
                          },
                        ),
                      );
                    },
                    footer: SizedBox(height: 100,),
                  )
              );
            },),
          ),
        ],
      );
    },
  );
}
