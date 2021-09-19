import 'package:agri_app/pages/Crop.dart';
import 'package:agri_app/pages/addNewCrop.dart';
import 'package:agri_app/pages/addNewTool.dart';
import 'package:agri_app/pages/changePassword.dart';
import 'package:agri_app/pages/chat.dart';
import 'package:agri_app/pages/home.dart';
import 'package:agri_app/pages/login.dart';
import 'package:agri_app/pages/market.dart';
import 'package:agri_app/pages/otp.dart';
import 'package:agri_app/pages/profile.dart';
import 'package:agri_app/pages/rent.dart';
import 'package:agri_app/pages/signup.dart';
import 'package:agri_app/pages/userItems.dart';
import 'package:agri_app/pages/userTools.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      supportedLocales: [
        const Locale('en', 'IN'), // India
      ],
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      routes: {
        "/" : (context) => Home(),
        "/login" : (context) => Login(),
        "/signup" : (context) => Signup(),
        "/crop" : (context) => Crop( arguments:ModalRoute.of(context)!.settings.arguments as Map,),
        "/chat": (context) => Chat(),
        "/market":(context) => MarketPlace(),
        "/rent" : (context) => Rent(),
        "/addNewCrop":(context) => AddNewCrop(),
        "/addNewTool":(context) => AddNewTool(),
        "/otp":(context) => OTP(arguments: ModalRoute.of(context)!.settings.arguments as Map,),
        "/profile":(context) => Profile(),
        "/changePassword":(context) => ChangePassword(arguments: ModalRoute.of(context)!.settings.arguments as Map,),
        "/userItems":(context) => UserItems(),
        "/userTools":(context) => UserTools(),
      },
      initialRoute: "/",
    );
  }
}

