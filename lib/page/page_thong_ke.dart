import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hapie/controller/thong_ke_controller.dart';
import 'package:hapie/main.dart';
import 'package:hapie/widgets/BarChartSample2.dart';
import 'package:intl/intl.dart';
class PageThongKe extends StatelessWidget {
  const PageThongKe({super.key});
  @override
  Widget build(BuildContext context) {
    DateTime today = DateTime.now();
    return GetBuilder<ThongKeController>(
      init: ThongKeController(),
      builder: (controller) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Biểu đồ Thu/Chi",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text("${get12MonthRange(today)}", style: TextStyle(fontSize: 12),),
              const SizedBox(height: 5),
              StreamBuilder<List<Map<String, dynamic>>>(
                stream: controller.thuChi12ThangStream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text("Không có dữ liệu"));
                  }

                  final data = snapshot.data!;
                  return Container(
                    // color: MyApp.fivety_color,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey,width: 2),
                          borderRadius:BorderRadius.circular(12)
                      ),
                      child: BarChartSample2(data: data));
                },

              ),
              SizedBox(height: 10,),
              Text(
                "Chi tiết theo tháng",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 5),
              StreamBuilder<List<Map<String, dynamic>>>(
                stream: controller.thuChi12ThangStream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text("Không có dữ liệu"));
                  }

                  final data = snapshot.data!.reversed.toList();
                  return Expanded(
                    child: ListView.separated(
                        itemBuilder: (context, index) {
                          var json= data[index];
                          final thu = json['tong_thu']?? 0;
                          final chi = json['tong_chi']?? 0;
                          final sodu = thu-chi;
                          final date = DateTime.parse(json["thang"]);
                          final fomat = DateFormat("'Tháng 'MM/yyyy").format(date);
                          final fmt = NumberFormat.decimalPattern('vi_VN');
                          return Card(
                            color: Theme.of(context).cardColor,
                            child: Column(
                              children: [
                                Container(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(fomat),
                                      Text(
                                        "${fmt.format(sodu)}₫",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: sodu > 0 ? Colors.greenAccent : Colors.redAccent,// đổi màu nếu số dư âm hoặc dương
                                        ),
                                      ),
                                    ],
                                  ),
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)),
                                      gradient: LinearGradient(colors: [Theme.of(context).cardColor, MyApp.fourty_color])
                                  ),
                                ),// hiển thị tháng và năm
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Text("Thu nhập:  "),
                                          Text("${fmt.format(thu)}₫", style: TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.bold)),
                                        ],
                                      ),
                                      SizedBox(height:10,),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Text("Chi tiêu:  "),
                                          Text("${fmt.format(chi)}₫", style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        }, separatorBuilder: (context, index) => SizedBox(height: 5,),
                        itemCount: data.length),
                  );
                },

              ),
            ],
          ),
        );
      },
    );
  }
}
String get12MonthRange(DateTime currentDate) {
  int startMonth = currentDate.month - 11;
  int startYear = currentDate.year;

  if (startMonth <= 0) {
    startMonth += 12;
    startYear -= 1;
  }

  String twoDigits(int n) => n.toString().padLeft(2, '0');

  String start = "${twoDigits(startMonth)}/$startYear";
  String end = "${twoDigits(currentDate.month)}/${currentDate.year}";

  return "$start - $end";
}