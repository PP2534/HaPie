import 'package:get/get.dart';
import 'package:hapie/controller/profile_controller.dart';
import 'package:hapie/page/page_layout_app.dart';
import 'package:hapie/model/giao_dich_model.dart';
import 'package:hapie/model/profile_model.dart';
import 'package:hapie/page/page_check_auth.dart';
import 'package:hapie/page/page_login.dart';
import 'package:hapie/page/page_welcome.dart';
import 'package:hapie/widgets/widget_function.dart';

class HomeController extends GetxController{
  late bool selectLoaiGiaoDich;
  late bool hienSoDu;
  late bool hienTongThuChi;
  late DateTime selectThang;
  late int soDu;
  late int tongChiTieu, tongThuNhap;
  late int tongChiTieuThangTruoc, tongThuNhapThangTruoc;
  late bool loading;

  static HomeController get() => Get.find();

  void doiLoaiGiaoDich(bool loaiGiaoDich){
    selectLoaiGiaoDich = loaiGiaoDich;
    update(["home"]);
  }

  void changeHienSoDu() async{
    if(box.read("login")){
      hienSoDu = !hienSoDu;
      update(["home"]);
    }
    else{
      await showConfirmDialogOneButtonFailed(mycontext, "Bạn vui lòng đăng nhập để tiếp tục sử dụng tính năng này!", title: "Bạn cần đăng nhập", buttonText: "Chấp nhận", );
      Get.offAll(PageWelcome());
      Get.to(PageLogin());
    }
  }
  void changeHienTongThuChi() async{
    if(box.read("login")){
      hienTongThuChi = !hienTongThuChi;
      update(["home"]);
    }
    else{
      await showConfirmDialogOneButtonFailed(mycontext, "Bạn vui lòng đăng nhập để tiếp tục sử dụng tính năng này!", title: "Bạn cần đăng nhập", buttonText: "Chấp nhận", );
      Get.offAll(PageWelcome());
      Get.to(PageLogin());
    }
  }
  void changeThang(DateTime thang) async{
    if(box.read("login")){
      selectThang = thang;
      loadTongThuChi();
      update(["home"]);
    }
    else{
      await showConfirmDialogOneButtonFailed(mycontext, "Bạn vui lòng đăng nhập để tiếp tục sử dụng tính năng này!", title: "Bạn cần đăng nhập", buttonText: "Chấp nhận", );
      Get.offAll(PageWelcome());
      Get.to(PageLogin());
    }
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    selectLoaiGiaoDich = false;
    hienSoDu = false;
    if(box.read("login")){
      hienTongThuChi = true;
    }
    else {
      hienTongThuChi = false;
    }
    soDu = 0;
    tongChiTieuThangTruoc= 0;
    tongChiTieu = 0;
    tongThuNhapThangTruoc = 0;
    tongThuNhap = 0;
    selectThang = DateTime.now();
    loading = true;
    loadSoDu();
    loadTongThuChi();
  }

  void refesh(){
    loadSoDu();
    loadTongThuChi();
    update(["home"]);
  }

  void loadSoDu() async{
    if(box.read("login")){
      var user = await ProfileSnapshot.getUser();
      // ProfileController.get().setTheme();
      soDu = user.so_du!;
      update(["home"]);
    }
  }

  void loadTongThuChi() async{
    if(box.read("login")){
      loading = true;
      update(["home"]);
      tongChiTieu = await GiaoDichSnapshot.getTongThuChiTheoThang(false, selectThang)??0;
      tongThuNhap = await GiaoDichSnapshot.getTongThuChiTheoThang(true, selectThang)??0;
      tongChiTieuThangTruoc = await GiaoDichSnapshot.getTongThuChiTheoThang(false, DateTime(selectThang.year, selectThang.month-1, 1))??0;
      tongThuNhapThangTruoc = await GiaoDichSnapshot.getTongThuChiTheoThang(true, DateTime(selectThang.year, selectThang.month-1, 1))??0;
      loading = false;
      update(["home"]);
    }
    // print("TCT ${tongChiTieu}");
    // print("TTN ${tongThuNhap}");
    // print("TCT_old ${tongChiTieuThangTruoc}");
    // print("TTN_old ${tongThuNhapThangTruoc}");
  }
}

class HomeBinding extends Bindings{
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut(()=> HomeController());
  }
}