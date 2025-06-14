import 'package:flutter/material.dart';

Future <String?> showConfirmDialogTwoButton(BuildContext context, String disMessage) async{
  AlertDialog dialog = AlertDialog(
    title: const Text("Xác nhận",style: TextStyle(fontSize: 20),),
    content: Text(disMessage),
    actions: [
      ElevatedButton(
          onPressed: () => Navigator.of(context, rootNavigator: true).pop("cancel"),
          child: Text("Hủy")
      ),
      Spacer(),
      ElevatedButton(
          onPressed: () => Navigator.of(context, rootNavigator: true).pop("ok"),
          child: Text("Đồng ý")
      ),
    ],
  );
  String? res = await showDialog <String?>(
    barrierDismissible: false,
    context: context,
    builder: (context) => dialog,
  );
  return res;
}

Future <String?> showConfirmDialogTwoButtonDanger(BuildContext context, String disMessage, {String title = "Cảnh báo"}) async{
  AlertDialog dialog = AlertDialog(
    title: Text(title, style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
    content: Text(disMessage, style: TextStyle(color: Colors.red, fontSize: 16),textAlign: TextAlign.center,),
    icon: Icon(Icons.error_outline, color: Colors.red,size: 40,),
    actions: [
      OutlinedButton(
          onPressed: () => Navigator.of(context, rootNavigator: true).pop("cancel"),
          child: Text("Hủy"),
        style: ButtonStyle(
            fixedSize: WidgetStatePropertyAll(Size(100, 47))
        ),
      ),
      // Spacer(),
      SizedBox(width: 10,),
      ElevatedButton(
          onPressed: () => Navigator.of(context, rootNavigator: true).pop("ok"),
          child: Text("Đồng ý"),
        style: ButtonStyle(
            fixedSize: WidgetStatePropertyAll(Size(100, 47))
        ),
      ),
    ],
  );
  String? res = await showDialog <String?>(
    barrierDismissible: false,
    context: context,
    builder: (context) => dialog,
  );
  return res;
}

Future <String?> showConfirmDialogOneButtonWarning(BuildContext context, String disMessage, {String buttonText = "Chấp nhận", String title = "Xác nhận"}) async{
  AlertDialog dialog = AlertDialog(
    title: Text(title, style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
    content: Text(disMessage, style: TextStyle(color: Colors.orange, fontSize: 16),textAlign: TextAlign.center,),
    icon: Icon(Icons.warning_amber, color: Colors.orange, size: 40,),
    actions: [
      Center(
        child: ElevatedButton(
          style: ButtonStyle(
            fixedSize: WidgetStatePropertyAll(Size(150, 50))
          ),
            onPressed: () => Navigator.of(context, rootNavigator: true).pop("ok"),
            child: Text(buttonText, style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),)
        ),
      ),
    ],
  );
  String? res = await showDialog <String?>(
    barrierDismissible: false,
    context: context,
    builder: (context) => dialog,
  );
  return res;
}

Future <String?> showConfirmDialogOneButtonSuccess(BuildContext context, String disMessage, {String buttonText = "Chấp nhận", String title = "Xác nhận"}) async{
  AlertDialog dialog = AlertDialog(
    title: Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
    content: Text(disMessage, style: TextStyle(color: Colors.green, fontSize: 16),textAlign: TextAlign.center,),
    icon: Icon(Icons.verified_user_outlined, color: Colors.green, size: 40,),
    actions: [
      Center(
        child: ElevatedButton(
          style: ButtonStyle(
            fixedSize: WidgetStatePropertyAll(Size(150, 50))
          ),
            onPressed: () => Navigator.of(context, rootNavigator: true).pop("ok"),
            child: Text(buttonText, style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),)
        ),
      ),
    ],
  );
  String? res = await showDialog <String?>(
    barrierDismissible: false,
    context: context,
    builder: (context) => dialog,
  );
  return res;
}

Future <String?> showConfirmDialogOneButtonFailed(BuildContext context, String disMessage, {String buttonText = "Chấp nhận", String title = "Lỗi"}) async{
  AlertDialog dialog = AlertDialog(
    title: Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
    content: Text(disMessage, style: TextStyle(color: Colors.red, fontSize: 16),textAlign: TextAlign.center,),
    icon: Icon(Icons.error_outline, color: Colors.red,size: 40,),
    actions: [
      Center(
        child: ElevatedButton(
            style: ButtonStyle(
                fixedSize: WidgetStatePropertyAll(Size(150, 50))
            ),
            onPressed: () => Navigator.of(context, rootNavigator: true).pop("ok"),
            child: Text(buttonText, style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),)
        ),
      ),
    ],
  );
  String? res = await showDialog <String?>(
    barrierDismissible: false,
    context: context,
    builder: (context) => dialog,
  );
  return res;
}
void showSnackBar(BuildContext context, {required String message,  int second = 3}){
  ScaffoldMessenger.of(context).removeCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: Duration(seconds: second),)
  );
}