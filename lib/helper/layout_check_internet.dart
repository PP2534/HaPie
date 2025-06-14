import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hapie/controller/network_controller.dart';

class LayoutCheckInternet extends StatelessWidget {
  final Widget child;

  const LayoutCheckInternet({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      id: "internet",
      init: NetworkController.get(),
      builder: (controller) {
        return Column(
          children: [
            Expanded(child: child),
            if (!controller.coInternet ||
                (controller.changeInternet && controller.coInternet) ||
                controller.internetChecking)
              Material(
                  color:
                      ((controller.changeInternet && controller.coInternet)
                          ? Colors.green
                          : (controller.internetChecking
                              ? Colors.orange
                              : Colors.red)),
                  elevation: 5,
                  child: Center(
                    child: Text(
                      (controller.changeInternet && controller.coInternet
                          ? "Kết nối internet thành công!"
                          : (controller.internetChecking
                              ? "Đang kiểm tra kết nối internet..."
                              : "Không có kết nối internet!")),
                      style: TextStyle(color: Colors.white, height: 1.5,fontSize: 13),
                    ),
                  ),
                ),
        //             Stack(
        //             children: [
        // Positioned.fill(child: child),
        // if (!controller.coInternet ||
        // (controller.changeInternet && controller.coInternet) ||
        // controller.internetChecking)
        // AnimatedPositioned(
        // height: 25,
        // curve: Curves.easeInOut,
        // left: 0,
        // right: 0,
        // bottom: 0,
        // duration: Duration(microseconds: 300),
        // child: Material(
        // color:
        // ((controller.changeInternet && controller.coInternet)
        // ? Colors.green
        //     : (controller.internetChecking
        // ? Colors.orange
        //     : Colors.red)),
        // elevation: 5,
        // child: Center(
        // child: Text(
        // (controller.changeInternet && controller.coInternet
        // ? "Kết nối internet thành công!"
        //     : (controller.internetChecking
        // ? "Đang kiểm tra kết nối internet..."
        //     : "Không có kết nối internet!")),
        // style: TextStyle(color: Colors.white, height: 1.8),
        // ),
        // ),
        // ),
        // ),
        // // Positioned(
        // //   top: 90,
        // //   right: 0,
        // //   left: 0,
        // //   child: Padding(
        // //     padding: const EdgeInsets.all(0),
        // //     child: Material(
        // //       color:
        // //           ((controller.changeInternet && controller.coInternet)
        // //               ? Colors.green
        // //               : (controller.internetChecking
        // //                   ? Colors.orange
        // //                   : Colors.red)),
        // //       elevation: 5,
        // //       child: Center(
        // //         child: Text(
        // //           (controller.changeInternet && controller.coInternet
        // //               ? "Kết nối internet thành công!"
        // //               : (controller.internetChecking
        // //                   ? "Đang kiểm tra kết nối internet..."
        // //                   : "Không có kết nối internet!")),
        // //           style: TextStyle(color: Colors.white, height: 1.8),
        // //         ),
        // //       ),
        // //     ),
        // //   ),
        // // ),
        //
        // ],
        // );

            
          ],
        );
      },
    );
  }
}
