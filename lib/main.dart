import 'package:firstproject/pages/home_page.dart';
import 'package:firstproject/pages/login_page.dart';
import 'package:firstproject/utilis/routes.dart';
//import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'widgets/themes.dart';
//import 'package:firstproject/models/catalog.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: ThemeMode.light,
      theme: MyTheme.lightTheme(context),
      darkTheme: MyTheme.darkTheme(context),
      debugShowCheckedModeBanner: false,
      home: LoginPage(), //default route but now we add "/" for home

      initialRoute: "/",
      routes: {
        MyRoutes.loginRoute: (context) => LoginPage(),
        MyRoutes.homeRoute: (context) => HomePage(),
      },
    );
  }
}
