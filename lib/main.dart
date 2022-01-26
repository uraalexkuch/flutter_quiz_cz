import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:testcz/helper/functions.dart';
import 'package:testcz/views/home.dart';
import 'package:testcz/views/signin.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FirebaseApp app = await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isLoggedIn = false;

  @override
  void initState() {
    checkUserLoggedInStatus();
    // TODO: implement initState
    super.initState();
  }

  checkUserLoggedInStatus() async {
    await HelperFunctions.getUserLoggedInDetails().then((value) => {
          setState(() {
            _isLoggedIn = value!;
          })
        });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: (context, widget) => ResponsiveWrapper.builder(
          BouncingScrollWrapper.builder(context, widget!),
          maxWidth: 1200,
          minWidth: 450,
          defaultScale: true,
          breakpoints: [
            ResponsiveBreakpoint.resize(450, name: MOBILE),
            ResponsiveBreakpoint.autoScale(800, name: TABLET),
            ResponsiveBreakpoint.autoScale(1000, name: TABLET),
            ResponsiveBreakpoint.resize(1200, name: DESKTOP),
            ResponsiveBreakpoint.autoScale(2460, name: "4K"),
          ]),
      title: 'Тестування працівників служби зайнятості',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: (_isLoggedIn == false) ? Home() : SignIn(),
    );
  }
}
