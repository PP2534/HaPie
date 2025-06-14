import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:get/get.dart';
import 'package:hapie/controller/auth_controller.dart';
import 'package:hapie/controller/profile_controller.dart';
import 'package:hapie/helper/layout_check_internet.dart';
import 'package:hapie/helper/supabase_helper.dart';
import 'package:hapie/model/profile_model.dart';
import 'package:hapie/widgets/widget_function.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class PageProfileUpdate extends StatefulWidget {
   PageProfileUpdate({super.key});
  @override
  State<PageProfileUpdate> createState() => _PageProfileUpdateState();
}

class _PageProfileUpdateState extends State<PageProfileUpdate> {
  late ProfileController controller;
  late Profile user;
  XFile? _xFile;
  String ? imageUrl;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController txtSoDu = TextEditingController();
  DateTime? _selectedDate;
  String? _selectedGender;

  int getSoDuRaw() {
    final f = txtSoDu.text;
    final numOnly = f.replaceAll(RegExp(r'[^0-9]'), '');
    return int.tryParse(numOnly) ?? 0;
  }
  final fmt = NumberFormat.decimalPattern('vi_VN');

  @override
  void initState() {
    super.initState();
    controller = ProfileController.get();
    user = controller.user;
    _nameController.text = user.ho_ten;
    _selectedDate = user.ngay_sinh;
    _selectedGender = user.gioi_tinh;
    txtSoDu.text = fmt.format(user.so_du)+"₫";
  }

  Future<void> _pickDate() async {
    DateTime initialDate = _selectedDate ?? DateTime(1990, 1, 1);
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      fieldLabelText: "Chọn ngày sinh",
      cancelText: "Hủy",
      helpText: "Chọn ngày sinh"
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Thông tin cá nhân"),
        // backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: LayoutCheckInternet(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(8),
          child: GetBuilder<ProfileController>(
            id: "profile",
            init: controller,
            builder: (_) {
              final _formKey = GlobalKey<FormState>();
              return Column(
                children: [
                  Center(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          SizedBox(height: 10,),
                          Stack(
                            children: [
                              CircleAvatar(
                                radius: 90,
                                backgroundColor: Theme.of(context).primaryColor,
                                backgroundImage:
                                _xFile == null ? user.url_avatar!=null?NetworkImage(user.url_avatar!):AssetImage("assets/images/hapie_user.png"):FileImage(File(_xFile!.path))
                              ),
                              // Container(
                              //   padding: EdgeInsets.all(15),
                              //   height: 300,
                              //   child: _xFile == null ? user.url_avatar!=null?Image.network(user.url_avatar!):Image.asset("assets/images/hapie_user.png"):Image.file(File(_xFile!.path)),
                              // ),
                              Positioned(
                                right: 0,

                                bottom: 0,
                                  child: IconButton(onPressed: () async{
                                    var imagePicker = await ImagePicker()
                                              .pickImage(source: ImageSource.gallery);
                                          if (imagePicker != null) {
                                            setState(() {
                                              _xFile = imagePicker;
                                            });
                                          }
                                  }, icon: Container(
                                    padding: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: Color(0xFFC6C6C6),
                                      borderRadius: BorderRadius.circular(40)
                                    ),
                                      child: Icon(Icons.camera_alt,size: 20,color: Colors.white,))
                                  )
                              )
                            ],
                          ),

                          // ElevatedButton(
                          //     onPressed: () async {
                          //       var imagePicker = await ImagePicker()
                          //           .pickImage(source: ImageSource.gallery);
                          //
                          //       if (imagePicker != null) {
                          //         setState(() {
                          //           _xFile = imagePicker;
                          //         });
                          //       }
                          //     },
                          //     child: Text("Chọn ảnh")),
                          SizedBox(height: 50),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Icon(Icons.account_box, color: Theme.of(context).primaryColor),
                                SizedBox(width: 15),
                                Expanded(
                                  child: TextFormField(
                                    controller: _nameController,
                                    decoration: InputDecoration(
                                        labelText: "Họ tên",
                                      hintText: "Nhập họ và tên..."
                                    ),
                                    validator: (value) {
                                      if(value==null || value.trim().isEmpty){
                                        return "Họ tên không được để trống";
                                      }
                                      return null;
                                    },
                                    autovalidateMode: AutovalidateMode.onUserInteraction,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 5),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Icon(Icons.account_balance_wallet,
                                color: Theme.of(context).primaryColor),
                            SizedBox(width: 15),
                            Expanded(
                              child: TextFormField(
                                inputFormatters: [MoneyInputFormatter(
                                    thousandSeparator: ThousandSeparator.Period,
                                    mantissaLength: 0,
                                    trailingSymbol: '₫'
                                )],
                                autovalidateMode: AutovalidateMode.onUserInteraction,
                                keyboardType: TextInputType.numberWithOptions(signed: false, decimal: false),
                                decoration: InputDecoration(
                                    labelText: "Số dư",

                                ),
                                controller: txtSoDu
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        Row(
                          children: [
                            Icon(Icons.date_range,
                                color: Theme.of(context).primaryColor),
                            SizedBox(width: 15),
                            Expanded(
                              child: InkWell(
                                onTap: _pickDate,
                                child: InputDecorator(
                                  decoration:
                                  InputDecoration(labelText: "Ngày sinh"),
                                  child: Text(
                                    _selectedDate == null
                                        ? "Chọn ngày sinh"
                                        : "${DateFormat("dd/MM/yyyy").format(_selectedDate!)}",
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        Row(
                          children: [
                            Icon(Icons.people_alt_outlined,
                                color: Theme.of(context).primaryColor),
                            SizedBox(width: 15),
                            Expanded(
                              child: DropdownButtonFormField<String>(
                                dropdownColor: Theme.of(context).cardColor,
                                value: _selectedGender,
                                decoration:
                                InputDecoration(labelText: "Giới tính"),
                                items: [
                                  DropdownMenuItem(
                                      child: Text("Nam"), value: "Nam"),
                                  DropdownMenuItem(
                                      child: Text("Nữ"), value: "Nữ"),

                                ],
                                onChanged: (val) {
                                  setState(() {
                                    _selectedGender = val;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 30),
                        ElevatedButton(
                            onPressed: () async {
                              showSnackBar(context, message: "Đang cập nhật ${_nameController.text}...",second: 10);
                              if (_xFile != null) {


                                imageUrl = await updateImage(
                                    image: File(_xFile!.path),
                                    bucket: "images",
                                    path: "user_avartar/profile_${supabase.auth.currentUser!.id}.jpg");
                                user.url_avatar = imageUrl;

                              }


                              user.ho_ten = _nameController.text;
                              user.ngay_sinh= _selectedDate;
                              user.gioi_tinh = _selectedGender;
                              user.so_du = getSoDuRaw();
                              ProfileSnapshot.update(user);
                              ScaffoldMessenger.of(context).clearSnackBars();
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text("Đã cập nhật ${_nameController.text}!"),
                                duration: Duration(seconds: 5),
                              ));
                              controller.update(["profile"]);
                              Get.back();
                            },
                            child: Text("Cập nhật ",style: TextStyle(fontSize: 18),)),
                      ],
                    ),
                  )
                ],
              );
            },
          ),
        ),
      ),
    );

  }
}
