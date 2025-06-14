import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:hapie/controller/danh_muc_controller.dart';
import 'package:hapie/controller/giao_dich_controller.dart';
import 'package:hapie/helper/layout_check_internet.dart';
import 'package:hapie/model/danh_muc_model.dart';
import 'package:hapie/page/page_them_danh_muc.dart';
import 'package:hapie/page/page_update_danh_muc.dart';
import 'package:hapie/widgets/widget_function.dart';



class Danhmucpage extends StatelessWidget {
  const Danhmucpage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: "Danh muc Page ",
      debugShowCheckedModeBanner: false,
      initialBinding: BindingAppDanhMuc(),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey),
        useMaterial3: true,
      ),
      home: PageHomeDanhMuc(),
    );
  }
}

class PageHomeDanhMuc extends StatelessWidget {
   PageHomeDanhMuc({super.key});
  late BuildContext myContext;
  @override
  Widget build(BuildContext context) {
    myContext = context;
    return Scaffold(
      appBar: AppBar(
        title: const Text(" Danh Mục"),
        // backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: LayoutCheckInternet(
        child: GetBuilder(
          id: "danhmucs",
            init: ControllerDanhMuc(),
          builder: (controller) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: SegmentedButton<bool?>(
                          style: ButtonStyle(
                            shape: WidgetStatePropertyAll(
                              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                          ),
                          segments: const [
                            ButtonSegment(value: null, label: Text("Tất cả")),
                            ButtonSegment(value: true, label: Text("Thu nhập")),
                            ButtonSegment(value: false, label: Text("Chi tiêu")),
                          ],
                          selected: {controller.currentFilter},
                          onSelectionChanged: (selected) {
                            controller.setFilter(selected.first);
                          },
                          showSelectedIcon: false,
                        ),
                      ),
                    ],
                  ),
                ),
                if(controller.filteredDanhmucs.length ==0)
                  Expanded(child: Center(child: Text("Không có danh mục nào!", style: TextStyle(fontStyle: FontStyle.italic),))),

                Expanded(
                  child: ListView.separated(
                    padding: EdgeInsets.only(left: 12, right: 12),
                    itemCount: controller.filteredDanhmucs.length,
                    separatorBuilder: (context, index) => Divider(),
                    itemBuilder: (context, index) {
                      final e = controller.filteredDanhmucs[index];
                      return Slidable(
                        key: ValueKey(e.id),
                        endActionPane: ActionPane(
                          extentRatio: 0.6,
                          motion: const ScrollMotion(),
                          children: [
                            SlidableAction(
                              flex: 3,
                              onPressed: (context) {
                                // Navigator.of(context).push(
                                //     MaterialPageRoute(builder: (context) => PageUpdateDanhMuc(danhmuc: e),)
                                // );
                                Get.to(PageUpdateDanhMuc(danhmuc: e));
                              },
                              backgroundColor: Color(0xFF7BC043),
                              foregroundColor: Colors.white,
                              icon: Icons.edit,
                              label: 'Cập nhật',
                            ),
                            SlidableAction(
                              flex: 2,
                              onPressed: (context) async {
                                var xacNhan = await showConfirmDialogTwoButtonDanger(
                                  myContext,
                                  "Bạn có muốn xóa ${e.ten_danh_muc}?",
                                );
                                if (xacNhan == "ok") {
                                  await DanhMucSnapShot.deleteById(e.id!);
                                  showSnackBar(myContext, message: "Đã xóa ${e.ten_danh_muc}");
                                  controller.load_danh_muc();
                                  GiaoDichController.get().loadDanhMuc();
                                }

                              },
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                              icon: Icons.delete_forever,
                              label: 'Xóa',
                            ),
                          ],
                        ),
                        child: Card(
                          margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 6),
                          color: Theme.of(context).cardColor,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          elevation: 3,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      e.loai_danh_muc ? Icons.arrow_upward : Icons.arrow_downward,
                                      color: e.loai_danh_muc ? Colors.green : Colors.red,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      e.ten_danh_muc,
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8),
                                if(controller.currentFilter==null)Text(
                                  "Loại: ${e.loai_danh_muc ? 'Thu nhập' : 'Chi tiêu'}",
                                ),
                                // const Divider(height: 16, thickness: 1),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(PageAddDanhMuc());
        },
        backgroundColor: Theme.of(context).primaryColor,
        child: Icon(Icons.add),
        tooltip: "Thêm danh mục",
      ),
    );
  }
}