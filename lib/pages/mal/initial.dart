import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InitMal extends StatefulWidget {
  const InitMal({Key? key}) : super(key: key);

  @override
  State<InitMal> createState() => _InitMalState();
}

class _InitMalState extends State<InitMal> {

  late SharedPreferences sharedPreferences;

  @override
  void initState() {
    loadSP();
    super.initState();
  }

  void loadSP()async{
    sharedPreferences = await SharedPreferences.getInstance();
    if(!sharedPreferences.containsKey("url")){
      sharedPreferences.setString("url", "http://10.0.2.2:3000");
    }
    if(sharedPreferences.containsKey("home")){
      var value=sharedPreferences.getString("home");
      if(value=="home")
        Navigator.pushReplacementNamed(context, "/homeMal");
      if(value=="home1")
        Navigator.pushReplacementNamed(context, "/home1Mal");
      if(value=="home2")
        Navigator.pushReplacementNamed(context, "/home2Mal");
    }
    else {
      Navigator.pushReplacementNamed(context, "/homeMal");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: CircularProgressIndicator(color: Colors.green,)),
    );
  }
}
