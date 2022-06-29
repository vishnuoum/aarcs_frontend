import 'package:agri_app/pages/Crop.dart';
import 'package:agri_app/pages/addNewCrop.dart';
import 'package:agri_app/pages/addNewDoubt.dart';
import 'package:agri_app/pages/addNewEvent.dart';
import 'package:agri_app/pages/addNewLand.dart';
import 'package:agri_app/pages/addNewTool.dart';
import 'package:agri_app/pages/calendar.dart';
import 'package:agri_app/pages/changePassword.dart';
import 'package:agri_app/pages/chat.dart';
import 'package:agri_app/pages/chooseHome.dart';
import 'package:agri_app/pages/doubt.dart';
import 'package:agri_app/pages/editEvent.dart';
import 'package:agri_app/pages/home.dart';
import 'package:agri_app/pages/initial.dart';
import 'package:agri_app/pages/listPage.dart';
import 'package:agri_app/pages/logs.dart';
import 'package:agri_app/pages/mainHome.dart';
import 'package:agri_app/pages/myDoubt.dart';
import 'package:agri_app/pages/myQueries.dart';
import 'package:agri_app/pages/newHome.dart';
import 'package:agri_app/pages/land.dart';
import 'package:agri_app/pages/login.dart';
import 'package:agri_app/pages/market.dart';
import 'package:agri_app/pages/otp.dart';
import 'package:agri_app/pages/profile.dart';
import 'package:agri_app/pages/recommend.dart';
import 'package:agri_app/pages/recommended.dart';
import 'package:agri_app/pages/rent.dart';
import 'package:agri_app/pages/results.dart';
import 'package:agri_app/pages/setURLPage.dart';
import 'package:agri_app/pages/showCommunity.dart';
import 'package:agri_app/pages/signup.dart';
import 'package:agri_app/pages/userItems.dart';
import 'package:agri_app/pages/userLands.dart';
import 'package:agri_app/pages/userTools.dart';
import 'package:agri_app/pages/viewPic.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.green, // status bar color
  ));
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
        "/init" : (context) => Init(),
        "/home" : (context) => Home(),
        "/home1" : (context) => Home1(),
        "/home2" : (context) => Home2(),
        "/chooseHome" : (context) => ChooseHome(),
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
        "/showCommunity":(context) => ShowCommunity(),
        "/recommendationResult":(context) => RecommendationResult(argument: ModalRoute.of(context)!.settings.arguments as Map,),
        "/doubt":(context) => Doubt(arguments: ModalRoute.of(context)!.settings.arguments as Map,),
        "/addNewDoubt":(context) => AddNewDoubt(),
        "/myQueries":(context) => MyQueries(),
        "/myDoubt":(context) => MyDoubt(arguments: ModalRoute.of(context)!.settings.arguments as Map,),
        "/viewPic":(context) => ViewPic(arguments: ModalRoute.of(context)!.settings.arguments as Map,),
        "/logs":(context) => LOGS(),
        "/results":(context) => Result(arguments: ModalRoute.of(context)!.settings.arguments as Map,),
        "/listPage":(context) => ListPage(arguments: ModalRoute.of(context)!.settings.arguments as Map,),
        "/setURLPage":(context) => SetURLPage(),
      },
      initialRoute: "/init",
    );
  }
}

