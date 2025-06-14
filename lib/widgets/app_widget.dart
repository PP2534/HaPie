import 'package:flutter/material.dart';

Widget ConfirmDialogOneButtonFailed(BuildContext context, String disMessage, {String buttonText = "Chấp nhận", String title = "Lỗi", Future<void> ?function }){
  AlertDialog dialog = AlertDialog(
    title: Text(title, style: TextStyle(fontWeight: FontWeight.bold),),
    content: Text(disMessage, style: TextStyle(color: Colors.red, fontSize: 16),textAlign: TextAlign.center,),
    icon: Icon(Icons.error_outline, color: Colors.red,size: 40,),
    actions: [
      Center(
        child: ElevatedButton(
            style: ButtonStyle(
                fixedSize: WidgetStatePropertyAll(Size(150, 50))
            ),
            onPressed: () async{
              if(function!=null)await function;
              Navigator.of(context, rootNavigator: true).pop("ok");
            },
            child: Text(buttonText)
        ),
      ),
    ],
  );
  return dialog;
}

Widget sendCodeEmailNote(String email, Color color){
  return RichText(
    textAlign: TextAlign.center,
    text: TextSpan(
      style: TextStyle(color: color, fontSize: 15),
      children: [
        TextSpan(text: "Mã OTP đã được gửi qua email "),
        TextSpan(text: "${email}", style: TextStyle(fontWeight: FontWeight.bold)),
        TextSpan(text: ", vui lòng kiểm tra email của bạn (bao gồm hộp thư chính, spam...)."),
      ]
    )
  );
}