import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hapie/controller/profile_controller.dart';
import 'package:hapie/helper/layout_check_internet.dart';
import 'package:hapie/page/page_check_auth.dart';

class PageChangeTheme extends StatelessWidget {
  PageChangeTheme({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Giao diện"),
      ),
      body: LayoutCheckInternet(
        child: GetBuilder(
          id: "profile",
            init: ProfileController.get(),
            builder: (controller) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Theme.of(context).textTheme.bodyMedium?.color??Colors.black),
                        borderRadius: BorderRadius.circular(12)
                      ),
                      child: RadioListTile(
                        visualDensity: VisualDensity(horizontal: -4),
                        title: Row(
                          children: [
                            Text("Chế độ sáng"),
                            Spacer(),
                            Icon(Icons.light_mode),
                          ],
                        ),
                        value: "light",
                        groupValue: controller.user.theme_mode,
                        onChanged: (value) {
                          controller.toggleDarkMode(value!);
                        },
                      ),
                    ),
                    SizedBox(height: 15,),
                    Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: Theme.of(context).textTheme.bodyMedium?.color??Colors.black),
                          borderRadius: BorderRadius.circular(12)
                      ),
                      child: RadioListTile(
                        visualDensity: VisualDensity(horizontal: -4),
                        title: Row(
                          children: [
                            Text("Chế độ tối"),
                            Spacer(),
                            Icon(Icons.dark_mode),
                          ],
                        ),
                        value: "dark",
                        groupValue: controller.user.theme_mode,
                        onChanged: (value) {
                          controller.toggleDarkMode(value!);
                          fill_input=true;
                        },
                      ),
                    ),
                    SizedBox(height: 15,),
                    Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: Theme.of(context).textTheme.bodyMedium?.color??Colors.black),
                          borderRadius: BorderRadius.circular(12)
                      ),
                      child: RadioListTile(
                        visualDensity: VisualDensity(horizontal: -4),
                        title: Row(
                          children: [
                            Text("Chế độ hệ thống"),
                            Spacer(),
                            Icon(Icons.phone_android),
                          ],
                        ),
                        value: "system",
                        groupValue: controller.user.theme_mode,
                        onChanged: (value) {
                          controller.toggleDarkMode(value!);
                          fill_input=MediaQuery.of(context).platformBrightness == Brightness.dark;
                        },
                      ),
                    )
                  ],
                ),
              );
            },
        )
      ),
    );
  }
}
