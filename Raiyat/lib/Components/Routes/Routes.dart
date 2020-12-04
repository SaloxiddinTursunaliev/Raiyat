import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:Raiyat/Home/Main/Home.dart';
import 'package:flutter/services.dart';

class Routes extends StatelessWidget {
  @override
  Widget build(context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: "/Home",
      //showPerformanceOverlay: true,
      routes: {
        "/Home": (context) => Home(),
      },
      builder: (context, widget) => ResponsiveWrapper.builder(
        BouncingScrollWrapper.builder(context, widget),
        //maxWidth: 1000,
        minWidth: 450,
        defaultScale: true,
        breakpoints: [
          ResponsiveBreakpoint.resize(450, name: MOBILE),
          ResponsiveBreakpoint.resize(800, name: TABLET),
          ResponsiveBreakpoint.resize(1000, name: TABLET),
          ResponsiveBreakpoint.resize(1200, name: DESKTOP),
          ResponsiveBreakpoint.resize(2460, name: "4K"),
        ],
        background: Container(
          color: Color(0xFFF5F5F5),
        ),
      ),
    );
  }
}
