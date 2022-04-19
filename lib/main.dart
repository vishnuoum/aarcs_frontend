import 'package:agri_app/pages/Crop.dart';
import 'package:agri_app/pages/addNewCrop.dart';
import 'package:agri_app/pages/addNewEvent.dart';
import 'package:agri_app/pages/addNewLand.dart';
import 'package:agri_app/pages/addNewTool.dart';
import 'package:agri_app/pages/calendar.dart';
import 'package:agri_app/pages/changePassword.dart';
import 'package:agri_app/pages/chat.dart';
import 'package:agri_app/pages/editEvent.dart';
import 'package:agri_app/pages/home.dart';
import 'package:agri_app/pages/land.dart';
import 'package:agri_app/pages/login.dart';
import 'package:agri_app/pages/market.dart';
import 'package:agri_app/pages/otp.dart';
import 'package:agri_app/pages/profile.dart';
import 'package:agri_app/pages/recommend.dart';
import 'package:agri_app/pages/recommended.dart';
import 'package:agri_app/pages/rent.dart';
import 'package:agri_app/pages/signup.dart';
import 'package:agri_app/pages/userItems.dart';
import 'package:agri_app/pages/userLands.dart';
import 'package:agri_app/pages/userTools.dart';
import 'package:flutter/material.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    initOneSignal();
    super.initState();
  }

  Future<void> initOneSignal()async {

    OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);

    await OneSignal.shared.setAppId("9a34fce0-8e58-42af-b1bf-217caa61de6f");

    // The promptForPushNotificationsWithUserResponse function will show the iOS push notification prompt. We recommend removing the following code and instead using an In-App Message to prompt for notification permission
    OneSignal.shared.promptUserForPushNotificationPermission().then((accepted) {
      print("Accepted permission: $accepted");
    });
  }

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
        "/land" : (context) => Land(),
        "/addNewCrop":(context) => AddNewCrop(),
        "/addNewTool":(context) => AddNewTool(),
        "/addNewLand":(context) => AddNewLand(),
        "/otp":(context) => OTP(arguments: ModalRoute.of(context)!.settings.arguments as Map,),
        "/profile":(context) => Profile(),
        "/changePassword":(context) => ChangePassword(arguments: ModalRoute.of(context)!.settings.arguments as Map,),
        "/userItems":(context) => UserItems(),
        "/userTools":(context) => UserTools(),
        "/userLands":(context) => UserLands(),
        "/recommend":(context) => Recommend(),
        "/calendar":(context) => Calendar(),
        "/addNewEvent":(context) => AddNewEvent(),
        "/editEvent":(context) => EditEvent(),
        "/recommendationResult":(context) => RecommendationResult(argument: ModalRoute.of(context)!.settings.arguments as Map,),
      },
      initialRoute: "/",
    );
  }
}

