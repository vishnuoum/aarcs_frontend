import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Init extends StatefulWidget {
  const Init({Key? key}) : super(key: key);

  @override
  State<Init> createState() => _InitState();
}

class _InitState extends State<Init> {

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
        Navigator.pushReplacementNamed(context, "/home");
      if(value=="home1")
        Navigator.pushReplacementNamed(context, "/home1");
      if(value=="home2")
        Navigator.pushReplacementNamed(context, "/home2");
    }
    else {
      Navigator.pushReplacementNamed(context, "/home");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: CircularProgressIndicator(color: Colors.green,)),
    );
  }
}
