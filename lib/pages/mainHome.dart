import 'dart:io';
import 'dart:math';

import 'package:agri_app/icons/icon_icons.dart';
import 'package:agri_app/services/analyticsService.dart';
import 'package:agri_app/services/dbservice.dart';
import 'package:agri_app/services/weatherService.dart';
import 'package:fab_circular_menu/fab_circular_menu.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tflite/tflite.dart';
import 'package:url_launcher/url_launcher.dart';

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  final GlobalKey<FabCircularMenuState> fabKey = GlobalKey();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  DateTime start = DateTime.now();

  late SharedPreferences sharedPreferences;
  final ImagePicker _picker = ImagePicker();
  String? res;
  late DBService dbObject;
  WeatherService weatherService=WeatherService();
  String weather="";

  AnalyticsService analyticsService=AnalyticsService();
  late PaletteGenerator paletteGenerator;

  @override
  void initState() {
    super.initState();
    dbObject=DBService();
    loadSharedPreferences();
    analyticsService.sendAnalytics();
  }

  double compareColor(Color color){
    return (sqrt(pow(color.red-45,2)+ pow(color.green-90,2)+ pow(color.blue-39,2))/441.672)*100;
  }

  String capitalize(String string) {
    if (string.isEmpty) {
      return string;
    }

    return string[0].toUpperCase() + string.substring(1);
  }

  Future<dynamic> getColorPalette(String path)async
  {
    try {
      paletteGenerator = await PaletteGenerator.fromImageProvider(
        Image(image: FileImage(File(path))).image,
      );
      return paletteGenerator;
    }
    catch(e){
      return "";
    }
  }



  void loadSharedPreferences()async{
    sharedPreferences=await SharedPreferences.getInstance();
    var result=await weatherService.getWeather(phone: sharedPreferences.getString("phone"));
    if(result!="error"){
      weather="${(result["main"]["temp"]-273).toStringAsFixed(2)}°C  ${capitalize(result["weather"][0]["description"])}";
    }
    setState(() {});
  }

  bool checkLogin(){
    try{
      return sharedPreferences.containsKey("phone");
    }
    catch(e){
      return false;
    }
  }


  void loadLeafModel()async{
    res = await Tflite.loadModel(
        model: "assets/model.tflite",
        labels: "assets/labels.txt",
        numThreads: 1, // defaults to 1
        isAsset: true, // defaults to true, set to false to load resources outside assets
        useGpuDelegate: false // defaults to false, set to true to use GPU delegate
    );
    print(res);
  }

  void loadSeedlingModel()async{
    res = await Tflite.loadModel(
        model: "assets/model_seedling.tflite",
        labels: "assets/labels_seedling.txt",
        numThreads: 1, // defaults to 1
        isAsset: true, // defaults to true, set to false to load resources outside assets
        useGpuDelegate: false // defaults to false, set to true to use GPU delegate
    );
    print(res);
  }


  Future<void> alertDialog(var text) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Result'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(text),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }


  Future<void> leafScan(BuildContext cont) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        loadLeafModel();
        return AlertDialog(
          title: Text('Scan Leaf'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text("Please select an option."),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Open Camera'),
              onPressed: () async{
                Navigator.of(context).pop();
                print('Leaf Camera');
                final XFile? image = await _picker.pickImage(source: ImageSource.camera);
                try {
                  print(image!.path);
                  var recognitions = await Tflite.runModelOnImage(
                    path: image.path,   // required
                  );
                  print(recognitions);
                  if(recognitions![0]["confidence"]<0.85){
                    alertDialog("Could not find the leaf in the image.");
                    return;
                  }
                  if(recognitions[0]["label"].contains("healthy")){
                    alertDialog("Your plant seems healthy!!");
                  }
                  else {
                    PaletteGenerator color=await getColorPalette(image.path.substring(1));
                    print(color.dominantColor!.color);
                    double cmp=compareColor(color.dominantColor!.color);
                    print(cmp);
                    if(cmp.toInt()>25){
                      alertDialog("Could not find the leaf in the image.");
                      return;
                    }
                    var result = await dbObject.getDisease(
                        recognitions[0]["index"] + 1);
                    await dbObject.addDiseaseAnalytics(recognitions[0]["index"] );
                    Navigator.pushNamed(cont, "/crop", arguments: result[0]);
                  }
                }
                catch(e){
                  print("Exception $e");
                }
              },
            ),
            TextButton(
              child: Text('Open Gallery'),
              onPressed: ()async {
                Navigator.of(context).pop();
                print('Leaf Gallery');
                final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
                try {
                  print(image!.path);
                  var recognitions = await Tflite.runModelOnImage(
                    path: image.path,   // required
                  );
                  print(recognitions);
                  if(recognitions![0]["confidence"]<0.85){
                    alertDialog("Could not find the leaf in the image.");
                    return;
                  }
                  if(recognitions[0]["label"].contains("healthy")){
                    alertDialog("Your plant seems healthy!!");
                  }
                  else{
                    PaletteGenerator color=await getColorPalette(image.path.substring(1));
                    print(color.dominantColor!.color);
                    double cmp=compareColor(color.dominantColor!.color);
                    print(cmp);
                    if(cmp.toInt()>25){
                      alertDialog("Could not find the leaf in the image.");
                      return;
                    }
                    var result = await dbObject.getDisease(
                        recognitions[0]["index"] + 1);
                    Navigator.pushNamed(cont, "/crop", arguments: result[0]);
                  }
                }
                catch(e){
                  print("Exception $e");
                }
              },
            ),
          ],
        );
      },
    );
  }


  Future<void> seedlingScan(BuildContext cont) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        loadSeedlingModel();
        return AlertDialog(
          title: Text('Scan Seedling'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text("Please select an option."),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Open Camera'),
              onPressed: () async{
                Navigator.of(context).pop();
                print('Seedling Camera');
                final XFile? image = await _picker.pickImage(source: ImageSource.camera);
                try {
                  print(image!.path);
                  var recognitions = await Tflite.runModelOnImage(
                    path: image.path,   // required
                  );
                  if(recognitions![0]["confidence"]<0.85){
                    alertDialog("Could not find seedling in the image.");
                    return;
                  }
                  print(recognitions[0]);
                  alertDialog("$recognitions");
                }
                catch(e){
                  print("Exception $e");
                }
              },
            ),
            TextButton(
              child: Text('Open Gallery'),
              onPressed: () async{
                Navigator.of(context).pop();
                print('Seedling Gallery');
                final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
                try {
                  print(image!.path);
                  var recognitions = await Tflite.runModelOnImage(
                    path: image.path,   // required
                  );
                  if(recognitions![0]["confidence"]<0.85){
                    alertDialog("Could not find seedling in the image.");
                    return;
                  }
                  print(recognitions);
                  alertDialog("$recognitions");
                }
                catch(e){
                  print("Exception $e");
                }
              },
            ),
          ],
        );
      },
    );
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backwardsCompatibility: false,
        systemOverlayStyle: SystemUiOverlayStyle(statusBarColor: Colors.green),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          Row(children: [
            Text(weather,style: TextStyle(color: Colors.green,fontWeight: FontWeight.bold),)
          ],),
          SizedBox(width: 10,),
          IconButton(icon: Icon(Icons.menu_open),onPressed: (){
            _scaffoldKey.currentState!.openEndDrawer();
          },)
        ],
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
      ),
      endDrawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                  color:Colors.green
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    child: Text("A",style: TextStyle(fontSize: 30),),
                    radius: 32,
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.green,
                  ),
                  SizedBox(height: 10,),
                  Text("A.A.R.C.S.",style: TextStyle(color: Colors.white,fontSize: 20,),),
                  SizedBox(height: 5,),
                  Text("Advanced Agricultural Recommendation and Classification System",style: TextStyle(color: Colors.white,fontSize: 12),)
                ],
              ),
            ),
            checkLogin()?ListTile(
              leading: Icon(Icons.calendar_today_rounded),
              title: Text("Event Scheduler"),
              onTap: (){
                Navigator.pop(context);
                Navigator.pushNamed(context, "/calendar",arguments: {"db":dbObject});
              },
            ):Container(),
            checkLogin()?ListTile(
              leading: Icon(Icons.shopping_cart_rounded),
              title: Text("Market Place"),
              onTap: (){
                Navigator.pop(context);
                Navigator.pushNamed(context, "/market");
              },
            ):Container(),
            checkLogin()?ListTile(
              leading: Icon(Icons.settings),
              title: Text("Rent a Tool"),
              onTap: (){
                Navigator.pop(context);
                Navigator.pushNamed(context, "/rent");
              },
            ):Container(),
            checkLogin()?ListTile(
              leading: Icon(Icons.place),
              title: Text("Lend a Land"),
              onTap: (){
                Navigator.pop(context);
                Navigator.pushNamed(context, "/land");
              },
            ):Container(),
            ListTile(
              leading: Icon(Icons.description),
              title: Text("Logs"),
              onTap: ()async{
                Navigator.pop(context);
                await canLaunch("mailto:agri-app@gmail.com?subject=Agri%20App&body=New%20plugin") ? await launch("mailto:agri-app@gmail.com?subject=Agri%20App&body=New%20plugin") : throw 'Could not launch gmail';
              },
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text("Contact Us"),
              onTap: ()async{
                Navigator.pop(context);
                await canLaunch("mailto:agri-app@gmail.com?subject=Agri%20App&body=New%20plugin") ? await launch("mailto:agri-app@gmail.com?subject=Agri%20App&body=New%20plugin") : throw 'Could not launch gmail';
              },
            ),
            checkLogin()?ListTile(
              leading: Icon(Icons.logout),
              title: Text("Logout"),
              onTap: ()async{
                Navigator.pop(context);
                await sharedPreferences.remove("phone");
                setState(() {});
              },
            ):Container(),
          ],
        ),
      ),
      backgroundColor: Colors.green,
      floatingActionButton: FabCircularMenu(
          key: fabKey,
          fabColor: Colors.green,
          ringColor: Colors.green,
          fabOpenIcon: Icon(Icons.lightbulb,color: Colors.white,),
          fabCloseIcon: Icon(Icons.close,color: Colors.white,),
          children: <Widget>[
            IconButton(tooltip: "Community Chat",color: Colors.white,splashColor: Colors.transparent,focusColor: Colors.transparent,highlightColor: Colors.transparent,icon: Icon(Icons.message), onPressed: checkLogin()?() {
              print('Community Chat');
              fabKey.currentState!.close();
              Navigator.pushNamed(context, "/chat");
            }:null,),
            IconButton(tooltip: "Crop Recommendation",icon: Icon(FlutterIcon.soil),color: Colors.white,splashColor: Colors.transparent,focusColor: Colors.transparent,highlightColor: Colors.transparent,onPressed: ()async{
              fabKey.currentState!.close();
              await Navigator.pushNamed(context, "/recommend");
            },),
            IconButton(tooltip: "Scan Seedling",color: Colors.white,splashColor: Colors.transparent,focusColor: Colors.transparent,highlightColor: Colors.transparent,icon: Icon(FlutterIcon.plant), onPressed: ()async {
              fabKey.currentState!.close();
              seedlingScan(context);
            }),
            IconButton(tooltip: "Scan Leaf",color: Colors.white,splashColor: Colors.transparent,focusColor: Colors.transparent,highlightColor: Colors.transparent,icon: Icon(FlutterIcon.leaf), onPressed: ()async {
              fabKey.currentState!.close();
              leafScan(context);
            }),
          ]
      ),
      body: GestureDetector(
        onTap: (){
          fabKey.currentState!.close();
        },
        child: ListView(
          padding: EdgeInsets.only(top: 20),
          children: [
            SizedBox(height: 70,),
            Padding(
              padding: const EdgeInsets.only(left: 30.0),
              child: Text("A.A.R.C.S.",style: TextStyle(color: Colors.white,fontSize: 40,fontWeight: FontWeight.bold),),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30,vertical: 5),
              child: Text("A User-Friendly App for farmers",style: TextStyle(fontSize: 17,color: Colors.white),),
            ),
            SizedBox(height: 20,),
            Container(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height-(70+30+40+10+17+20),
              ),
              child: Card(
                margin: EdgeInsets.zero,
                elevation: 10,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(30))
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        margin: EdgeInsets.all(10),
                        height: 5,
                        width: 80,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(500),
                          color: Colors.green,
                        ),
                      ),
                    ),
                    SizedBox(height: 20,),
                    Padding(
                      padding: const EdgeInsets.only(left: 30.0,right: 30,top:15,bottom: 5),
                      child: Text("On-Edge Services",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.green,fontSize: 17),),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 30.0,right: 30,top:15,bottom: 5),
                      child:Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)
                            ),
                            elevation: 10,
                            child: InkWell(
                              onTap: (){},
                              borderRadius: BorderRadius.circular(10),
                              child: Container(
                                height: 100,
                                width: 100,
                                padding: EdgeInsets.all(10),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(FlutterIcon.leaf,color: Colors.green,size: 30,),
                                    SizedBox(height: 10,),
                                    Text("Disease",style: TextStyle(color: Colors.green,fontWeight: FontWeight.bold,fontSize: 17),)
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Card(
                            color: Colors.green,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)
                            ),
                            elevation: 10,
                            child: InkWell(
                              onTap: (){},
                              borderRadius: BorderRadius.circular(10),
                              child: Container(
                                height: 100,
                                width: 100,
                                padding: EdgeInsets.all(10),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(FlutterIcon.plant,color: Colors.white,size: 30,),
                                    SizedBox(height: 10,),
                                    Text("Seedling",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 17),)
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)
                            ),
                            elevation: 10,
                            child: InkWell(
                              onTap: (){},
                              borderRadius: BorderRadius.circular(10),
                              child: Container(
                                height: 100,
                                width: 100,
                                padding: EdgeInsets.all(10),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(FlutterIcon.soil,color: Colors.green,size: 30,),
                                    SizedBox(height: 10,),
                                    Text("Crop",style: TextStyle(color: Colors.green,fontWeight: FontWeight.bold,fontSize: 17),)
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20,),
                    Padding(
                      padding: const EdgeInsets.only(left: 30.0,right: 30,top:15,bottom: 5),
                      child: Text("Online Services",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.green,fontSize: 17),),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 30.0,right: 30,top:15,bottom: 5),
                      child:Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Card(
                            color: Colors.green,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)
                            ),
                            elevation: 10,
                            child: InkWell(
                              onTap: (){},
                              borderRadius: BorderRadius.circular(10),
                              child: Container(
                                height: 100,
                                width: 100,
                                padding: EdgeInsets.all(10),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.shopping_basket,color: Colors.white,size: 30,),
                                    SizedBox(height: 10,),
                                    Text("Market",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 17),)
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)
                            ),
                            elevation: 10,
                            child: InkWell(
                              onTap: (){},
                              borderRadius: BorderRadius.circular(10),
                              child: Container(
                                height: 100,
                                width: 100,
                                padding: EdgeInsets.all(10),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.location_on,color: Colors.green,size: 30,),
                                    SizedBox(height: 10,),
                                    Text("Land",style: TextStyle(color: Colors.green,fontWeight: FontWeight.bold,fontSize: 17),)
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Card(
                            color: Colors.green,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)
                            ),
                            elevation: 10,
                            child: InkWell(
                              onTap: (){},
                              borderRadius: BorderRadius.circular(10),
                              child: Container(
                                height: 100,
                                width: 100,
                                padding: EdgeInsets.all(10),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.settings,color: Colors.white,size: 30,),
                                    SizedBox(height: 10,),
                                    Text("Tools",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 17),)
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 30.0,right: 30,top:15,bottom: 5),
                      child:Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)
                            ),
                            elevation: 10,
                            child: InkWell(
                              onTap: (){},
                              borderRadius: BorderRadius.circular(10),
                              child: Container(
                                height: 100,
                                width: 100,
                                padding: EdgeInsets.all(10),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.chat_bubble,color: Colors.green,size: 30,),
                                    SizedBox(height: 10,),
                                    Text("Chat",style: TextStyle(color: Colors.green,fontWeight: FontWeight.bold,fontSize: 17),)
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Card(
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)
                            ),
                            elevation: 10,
                            child: InkWell(
                              onTap: (){},
                              borderRadius: BorderRadius.circular(10),
                              child: Container(
                                height: 100,
                                width: 100,
                                padding: EdgeInsets.all(10),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.question_answer,color: Colors.green,size: 30,),
                                    SizedBox(height: 10,),
                                    Text("Post",style: TextStyle(color: Colors.green,fontWeight: FontWeight.bold,fontSize: 17),)
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20,),
                    Padding(
                      padding: const EdgeInsets.only(left: 30.0,right: 30,top:15,bottom: 5),
                      child: Text("Common Regional Varieties",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.green,fontSize: 17),),
                    ),
                    SizedBox(
                      width: double.infinity,
                      height: 250,
                      child: ListView(
                        padding: const EdgeInsets.all(10.0),
                        physics: BouncingScrollPhysics(),
                        scrollDirection:Axis.horizontal,
                        children: [
                          SizedBox(width: 20,),
                          InkWell(
                            onTap: ()async{
                              print("rice");
                              var result=await dbObject.getInfo(1);
                              Navigator.pushNamed(context, "/crop",arguments: result[0]);
                            },
                            child: Container(
                              width: 150,
                              child: Card(
                                semanticContainer: true,
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                elevation:6,
                                child: Stack(
                                  children: [
                                    SizedBox.expand(
                                      child: Image.asset(
                                        "assets/images/Rice.jpg",fit: BoxFit.cover,
                                      ),
                                    ),
                                    Positioned(left: 10,bottom: 15,child: Text("Rice",style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold),))
                                  ],
                                ),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              ),
                            ),
                          ),
                          SizedBox(width: 5,),
                          InkWell(
                            onTap: ()async{
                              print("wheat");
                              var result=await dbObject.getInfo(2);
                              Navigator.pushNamed(context, "/crop",arguments: result[0]);
                            },
                            child: Container(
                              width: 150,
                              child: Card(
                                semanticContainer: true,
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                elevation:6,
                                child: Stack(
                                  children: [
                                    SizedBox.expand(
                                      child: Image.asset(
                                        "assets/images/Wheat.jpg",fit: BoxFit.cover,
                                      ),
                                    ),
                                    Positioned(left: 10,bottom: 15,child: Text("Wheat",style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold),))
                                  ],
                                ),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              ),
                            ),
                          ),
                          SizedBox(width: 5,),
                          InkWell(
                            onTap: ()async{
                              print("Sugarcane");
                              var result=await dbObject.getInfo(3);
                              Navigator.pushNamed(context, "/crop",arguments: result[0]);
                            },
                            child: Container(
                              width: 150,
                              child: Card(
                                semanticContainer: true,
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                elevation:6,
                                child: Stack(
                                  children: [
                                    SizedBox.expand(
                                      child: Image.asset(
                                        "assets/images/Sugarcane.jpg",fit: BoxFit.cover,
                                      ),
                                    ),
                                    Positioned(left: 10,bottom: 15,child: Text("Sugarcane",style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold),))
                                  ],
                                ),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              ),
                            ),
                          ),
                          SizedBox(width: 5,),
                          InkWell(
                            onTap: ()async{
                              print("corn");
                              var result=await dbObject.getInfo(4);
                              Navigator.pushNamed(context, "/crop",arguments: result[0]);
                            },
                            child: Container(
                              width: 150,
                              child: Card(
                                semanticContainer: true,
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                elevation:6,
                                child: Stack(
                                  children: [
                                    SizedBox.expand(
                                      child: Image.asset(
                                        "assets/images/Corn.jpg",fit: BoxFit.cover,
                                      ),
                                    ),
                                    Positioned(left: 10,bottom: 15,child: Text("Corn",style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold),))
                                  ],
                                ),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              ),
                            ),
                          ),
                          SizedBox(width: 5,),
                        ],
                      ),
                    ),
                    SizedBox(height: 80,)
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
