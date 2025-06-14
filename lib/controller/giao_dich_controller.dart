import 'package:get/get.dart';
import 'package:hapie/model/danh_muc_model.dart';
import 'package:hapie/model/giao_dich_model.dart';

class GiaoDichController extends GetxController{
  DateTime selectMonth = DateTime.now();
  bool selectLoaiGiaoDich = false;
  bool isLoading = false;
  bool isLoadingDM = false;
  List<GiaoDich> dsgd = [];
  List<DanhMuc> dsdm = [];
  int number_loc = 0;
  int maDM_loc = 0;
  String loai_giao_dich_loc = "all";
  static GiaoDichController get() => Get.find();

  void changeMonth(DateTime month){
    selectMonth = month;
    locGiaoDich(selectMonth, loai_giao_dich_loc,maDM_loc);
  }

  void doiLoaiGiaoDich(bool loaiGiaoDich){
    selectLoaiGiaoDich = loaiGiaoDich;
    loadDanhMuc();
    // update(["them_giao_dich"]);
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    selectMonth = DateTime.now();
    selectLoaiGiaoDich = false;
    loadGiaoDich();
    loadDanhMuc();
  }

  void loadGiaoDich()async{
    isLoading = true;
    update(["giao_dich"]);
    dsgd = await GiaoDichSnapshot.getGiaoDichs(selectMonth);
    isLoading = false;
    update(["giao_dich"]);
  }

  void loadDanhMuc(){
    DanhMucSnapShot.getDanhMucStream().listen((event) {
      isLoadingDM = true;
      update(["them_giao_dich"]);
      dsdm = event.where((element) => element.loai_danh_muc == selectLoaiGiaoDich).toList();
      // print(" dsDM: ${dsdm}");
      isLoadingDM = false;
      update(["them_giao_dich"]);
    },);
  }
  void loadDanhMuc_loc(String loai_giao_dich){
    loai_giao_dich_loc = loai_giao_dich;
    DanhMucSnapShot.getDanhMucStream().listen((event) {
      isLoadingDM = true;
      update(["loc_giao_dich"]);
      if(loai_giao_dich_loc=="all"){
        dsdm = event;
      }
      else if(loai_giao_dich_loc == "thu"){
        dsdm = event.where((element) => element.loai_danh_muc == true).toList();
      }
      else{
        dsdm = event.where((element) => element.loai_danh_muc == false).toList();
      }
      isLoadingDM = false;
      update(["loc_giao_dich"]);
    },);
  }

  void locGiaoDich(DateTime month, String loai_giao_dich, int maDM) async{
    isLoading = true;
    update(["giao_dich"]);
    selectMonth = month;
    loai_giao_dich_loc = loai_giao_dich;
    maDM_loc = maDM;
    dsgd = await GiaoDichSnapshot.getGiaoDichs(selectMonth);
    number_loc = 0;
    if(loai_giao_dich!="all"){
      if(loai_giao_dich=="chi"){
        dsgd = dsgd.where((m)=>m.danh_muc.loai_danh_muc==false).toList();
      }
      else{
        dsgd = dsgd.where((m)=>m.danh_muc.loai_danh_muc==true).toList();
      }
      number_loc += 1;
    }
    if(maDM!=0){
      dsgd = dsgd.where((m)=>m.danh_muc.id == maDM).toList();
      number_loc += 1;
    }
    // print("l = ${dsgd.length}");
    // for(var i in dsgd){
    //   print("DT ${i.danh_muc.loai_danh_muc} : ${i.danh_muc.ten_danh_muc}");
    // }
    isLoading = false;
    update(["giao_dich"]);
    Get.back();
  }
  void huyLocGiaoDich()  {
    loai_giao_dich_loc = "all";
    maDM_loc = 0;
    selectMonth = DateTime.now();
    number_loc = 0;
    loadGiaoDich();
    Get.back();
  }
}

class GiaoDichBinding extends Bindings{
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut(() => GiaoDichController());
  }

}