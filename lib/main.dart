import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:movieapi/screens/home_screen.dart';
import 'package:movieapi/screens/movie_detail.dart';
import 'package:movieapi/screens/search.dart';

void main(){
  runApp(DevicePreview(enabled: !kReleaseMode, builder: (context) =>  MyApp(),));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      home: MovieHomePage()
    );
  }
}