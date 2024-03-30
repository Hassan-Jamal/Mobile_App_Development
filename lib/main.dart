import 'package:firstproject/pages/home_page.dart';
import 'package:firebase_core/firebase_core.dart'; // Import Firebase core
import 'package:firstproject/firebase_options.dart';
import 'package:firstproject/pages/login_page.dart';
import 'package:firstproject/pages/signup.dart';
import 'package:firstproject/utilis/routes.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'widgets/themes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
      initialRoute: "/",
      routes: {
        "/": (context) => SignUpPage(),
        MyRoutes.loginRoute: (context) => LoginPage(),
        MyRoutes.homeRoute: (context) => HomePage(),
        MyRoutes.signUpRoute: (context) => SignUpPage(),
      },
    );
  }
}
