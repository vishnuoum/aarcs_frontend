import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

class LOGS extends StatefulWidget {
  const LOGS({Key? key}) : super(key: key);


  @override
  _LOGSState createState() => _LOGSState();
}

class _LOGSState extends State<LOGS> {

  late Timer _everySecond;

  Map logs={};

  @override
  void initState() {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.black
    ));
    load();
    super.initState();
  }

  void load()async{
    _everySecond = Timer.periodic(Duration(seconds: 1), (Timer t) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.green
    ));
    _everySecond.cancel();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    if(logs.length==0)
      logs = ModalRoute.of(context)!.settings.arguments as Map;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle(
          // Status bar color
          statusBarColor: Colors.black,// For iOS (dark icons)
        ),
        backgroundColor: Colors.black,
        title: Text("Log"),
        actions: [
          IconButton(onPressed: ()async{
            await canLaunch("mailto:agri-app@gmail.com?subject=Agri%20App&body=New%20plugin") ? await launch("mailto:agri-app@gmail.com?subject=Agri%20App&body=${logs["logs"]}") : throw 'Could not launch gmail';
          }, icon: Icon(Icons.share),tooltip: "Share Log",)
        ],
      ),
      body: logs.length==0?SizedBox():ListView.builder(
        reverse: true,
        physics: BouncingScrollPhysics(),
        itemCount: logs["logs"].length,
        itemBuilder: (context, index) {
          return Text(logs["logs"][logs["logs"].length-1-index],style: TextStyle(color: Colors.white),);
        },
      ),
    );
  }
}
