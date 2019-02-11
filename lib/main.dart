import 'package:flutter/material.dart';
import './pages/home.dart';
import './pages/splash.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      //         theme: ThemeData(
      //   brightness: Brightness.dark,
      //   primaryColor: Colors.grey[600],
      //   accentColor: Colors.cyan[600],
      // ),
      home: new SplashScreen(),

    );
  }
}

