import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hapie/page/page_check_auth.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'controller/auth_controller.dart';


void main() async {
  await Supabase.initialize(
    url: "https://glwnyvucxmxewkdweyhc.supabase.co",
    anonKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imdsd255dnVjeG14ZXdrZHdleWhjIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDUxMjA4MzIsImV4cCI6MjA2MDY5NjgzMn0.PibTDmwr_kcjeJYcsAAOvnyhVq-Zeq63kyNRrpJjbsU",
  );
  await GetStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  static const primary_color = Color(0xFF40E0D0);
  static const secondary_color = Color(0xFFFFFFFF);
  static const thirsty_color = Colors.black;
  static var fourty_color = Color(0xFFDDE4E2);
  static var fivety_color = Color(0xFF303030);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    var mode = box.read("dark_them")??"system";
    if(mode=="dark"){
      Get.changeThemeMode(ThemeMode.dark);
      fill_input = true;
    }
    else if(mode=="light"){
      Get.changeThemeMode(ThemeMode.light);
      fill_input = false;
    }
    else{
      Get.changeThemeMode(ThemeMode.system);
      fill_input = MediaQuery.of(context).platformBrightness == Brightness.dark;
    }
    return GetMaterialApp(
      title: 'HaPie',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: primary_color, surfaceVariant: Color(0xFFD5DFDF),
          tertiaryContainer: Color(0xFF9AF6E8)

        ),
        cardColor: Colors.white,
        appBarTheme: AppBarTheme(
          color: primary_color,
        ),
        primaryColor: primary_color,
        elevatedButtonTheme: ElevatedButtonThemeData(style: ElevatedButton.styleFrom(backgroundColor: primary_color, foregroundColor: secondary_color, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12),),
          fixedSize: Size(MediaQuery.of(context).size.width, 57)
        )),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: ButtonStyle(
            side: WidgetStatePropertyAll(
                BorderSide(
                    width: 3,
                    color: primary_color
                )
            ),
            foregroundColor: WidgetStatePropertyAll(primary_color),
            shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
            fixedSize: WidgetStatePropertyAll(Size(MediaQuery.of(context).size.width, 57))
          )
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: ButtonStyle(
            foregroundColor: WidgetStatePropertyAll(Colors.black)
          )
        ),
        focusColor: primary_color,
        // useMaterial3: true,
        textButtonTheme: TextButtonThemeData(style: ButtonStyle(foregroundColor: WidgetStatePropertyAll(primary_color))),
        fontFamily: 'Roboto',
        inputDecorationTheme: InputDecorationTheme(
          filled: true,border: OutlineInputBorder(borderRadius: BorderRadius.circular(12),borderSide: BorderSide.none,
        ),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12),borderSide: BorderSide.none),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12),borderSide: BorderSide.none),
        ),
        iconButtonTheme: IconButtonThemeData(
          style: ButtonStyle(
            foregroundColor: WidgetStatePropertyAll(Colors.black)
          )
        ),
        
      ),
      themeMode:ThemeMode.system,
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: primary_color,surfaceVariant: fivety_color, onSurfaceVariant: Colors.white,
          onSurface: Colors.white,//get
          tertiaryContainer: Colors.black
        ),

        cardColor:fivety_color,
        primaryColor: primary_color,
        elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(backgroundColor: primary_color, foregroundColor: secondary_color, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12),),
            fixedSize: Size(MediaQuery.of(context).size.width, 57)
        )),
        outlinedButtonTheme: OutlinedButtonThemeData(
            style: ButtonStyle(
                side: WidgetStatePropertyAll(
                    BorderSide(
                        width: 3,
                        color: primary_color
                    )
                ),
                foregroundColor: WidgetStatePropertyAll(primary_color),
                shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                fixedSize: WidgetStatePropertyAll(Size(MediaQuery.of(context).size.width, 57))
            )
        ),
        dialogTheme: DialogThemeData(
            backgroundColor: fivety_color
        ),
        focusColor: primary_color,
        useMaterial3: true,
        textButtonTheme: TextButtonThemeData(style: ButtonStyle(foregroundColor: WidgetStatePropertyAll(primary_color))),
        fontFamily: 'Roboto',
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12),),
          fillColor: fivety_color,
          // border: InputBorder.none,
        ),
        textTheme: TextTheme(
          bodyMedium: TextStyle(
            color: secondary_color
          )
        ),
        filledButtonTheme: FilledButtonThemeData(
            style: ButtonStyle(
                foregroundColor: WidgetStatePropertyAll(primary_color)
            )
        ),
        iconButtonTheme: IconButtonThemeData(
            style: ButtonStyle(
                foregroundColor: WidgetStatePropertyAll(primary_color)
            )
        ),
        bottomAppBarTheme: BottomAppBarTheme(color: Colors.black),
        appBarTheme: AppBarTheme(
          foregroundColor: Colors.white,
          backgroundColor: fivety_color
        ),
        scaffoldBackgroundColor: thirsty_color,
        segmentedButtonTheme: SegmentedButtonThemeData(
            style: ButtonStyle(
              backgroundColor:WidgetStateColor.resolveWith((states) {
                if(states.contains(WidgetState.selected)){
                  return primary_color;
                }
                return Colors.transparent;
              },),
              foregroundColor: WidgetStatePropertyAll(Colors.white)
            )
        ),
        datePickerTheme: DatePickerThemeData(
          backgroundColor: fivety_color
        ),

        bottomSheetTheme: BottomSheetThemeData(
          backgroundColor: thirsty_color
        )
      ),
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        Locale("en", "US"),
        Locale("vi","VN")
      ],
      locale: Locale("vi","VN"),
      debugShowCheckedModeBanner: false,
      initialBinding: AuthBinding(),

      home: PageCheckAuth()
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('You have pushed the button this many times:'),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
