import 'dart:io';
import 'dart:math';

import 'package:agri_app/icons/icon_icons.dart';
import 'package:agri_app/services/analyticsService.dart';
import 'package:agri_app/services/dbservice.dart';
import 'package:agri_app/services/loginService.dart';
import 'package:agri_app/services/weatherService.dart';
import 'package:fab_circular_menu/fab_circular_menu.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tflite/tflite.dart';
import 'package:url_launcher/url_launcher.dart';

class Home1Mal extends StatefulWidget {
  Home1Mal({Key? key}) : super(key: key);

  @override
  _Home1MalState createState() => _Home1MalState();
}

class _Home1MalState extends State<Home1Mal> {

  final GlobalKey<FabCircularMenuState> fabKey = GlobalKey();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  late SharedPreferences sharedPreferences;
  final ImagePicker _picker = ImagePicker();
  String? res;
  late DBService dbObject;
  WeatherService weatherService=WeatherService();
  String weather="";
  List logs=[];
  DateFormat format = DateFormat("dd/MM/yyyy hh:mm:ss a");

  AnalyticsService analyticsService=AnalyticsService();
  late PaletteGenerator paletteGenerator;
  LoginService loginService = LoginService();
  bool authentication=false,authenticated=false;

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
    await checkLogin();
  }

  void weatherApi()async{
    logs.add("${format.format(DateTime.now())} Fetching Weather.....");
    if(sharedPreferences.containsKey("phone")) {
      var result = await weatherService.getWeather(
          phone: sharedPreferences.getString("phone"));
      if (result != "error") {
        logs.add("${format.format(DateTime.now())} Loading Weather.....");
        weather =
        "${(result["main"]["temp"] - 273).toStringAsFixed(2)}°C  ${capitalize(
            result["weather"][0]["description"])}";
      }
      setState(() {});
    }
  }

  Future<void> checkLogin()async{
    logs.add("${format.format(DateTime.now())} Connecting to server for authentication.....");
    try {
      if (sharedPreferences.containsKey("phone")) {
        if (!authentication) {
          setState(() {
            authentication = true;
          });
        }
        var result = await loginService.authenticate(
            phone: sharedPreferences.getString("phone").toString());
        if (result == "done") {
          logs.add("${format.format(DateTime.now())} Authenticating.....");
          weatherApi();
          setState(() {
            authentication = false;
            authenticated = true;
          });
        }
        else {
          Future.delayed(Duration(seconds: 5), () {
            checkLogin();
          });
        }
      }
    }
    catch(e){
      Future.delayed(Duration(seconds: 5), () {
        checkLogin();
      });
    }

  }


  void loadLeafModel()async{
    logs.add("${format.format(DateTime.now())} Loading Leaf Model.....");
    res = await Tflite.loadModel(
        model: "assets/model.tflite",
        labels: "assets/labels.txt",
        numThreads: 1, // defaults to 1
        isAsset: true, // defaults to true, set to false to load resources outside assets
        useGpuDelegate: false // defaults to false, set to true to use GPU delegate
    );
    print(res);
    logs.add("${format.format(DateTime.now())} Loaded Leaf Model!!!");
  }

  void loadSeedlingModel()async{
    logs.add("${format.format(DateTime.now())} Loading Seedling Model.....");
    res = await Tflite.loadModel(
        model: "assets/model_seedling.tflite",
        labels: "assets/labels_seedling.txt",
        numThreads: 1, // defaults to 1
        isAsset: true, // defaults to true, set to false to load resources outside assets
        useGpuDelegate: false // defaults to false, set to true to use GPU delegate
    );
    print(res);
    logs.add("${format.format(DateTime.now())} Loaded Seedling Model!!!");
  }


  Future<void> alertDialog(var text) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('റിസൾട്ട്'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(text),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('ഓക്കേ'),
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
    logs.add("${format.format(DateTime.now())} Initiating Leaf Scan.....");
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        loadLeafModel();
        return AlertDialog(
          title: Text('ഇല സ്കാൻ ചെയ്യുക'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text("ദയവായി ഒരു ഓപ്ഷൻ തിരഞ്ഞെടുക്കുക."),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('ക്യാമറ'),
              onPressed: () async{
                logs.add("${format.format(DateTime.now())} Opening Camera.....");
                Navigator.of(context).pop();
                print('Leaf Camera');
                final XFile? image = await _picker.pickImage(source: ImageSource.camera);
                try {
                  print(image!.path);
                  var recognitions = await Tflite.runModelOnImage(
                    path: image.path,   // required
                  );
                  print(recognitions);
                  logs.add("${format.format(DateTime.now())} ${recognitions.toString()}");
                  if(recognitions![0]["confidence"]<0.85){
                    alertDialog("ചിത്രത്തിലെ ഇല കണ്ടെത്താൻ കഴിഞ്ഞില്ല.");
                    return;
                  }
                  if(recognitions[0]["label"].contains("healthy")){
                    alertDialog("നിങ്ങളുടെ ചെടി ആരോഗ്യമുള്ളതായി തോന്നുന്നു!!");
                  }
                  else {
                    PaletteGenerator color=await getColorPalette(image.path.substring(1));
                    print(color.dominantColor!.color);
                    double cmp=compareColor(color.dominantColor!.color);
                    print(cmp);
                    if(cmp.toInt()>25){
                      alertDialog("ചിത്രത്തിലെ ഇല കണ്ടെത്താൻ കഴിഞ്ഞില്ല.");
                      return;
                    }
                    var result = await dbObject.getDiseaseMal(
                        recognitions[0]["index"] + 1);
                    await dbObject.addDiseaseAnalytics(recognitions[0]["index"] );
                    // Navigator.pushNamed(cont, "/crop", arguments: result[0]);
                    Navigator.pushNamed(cont, "/resultsMal", arguments: {"result":recognitions,"type":"disease","obj":dbObject});
                  }
                }
                catch(e){
                  print("Exception $e");
                  logs.add("${format.format(DateTime.now())} Exception $e");
                }
              },
            ),
            TextButton(
              child: Text('ഗാലറി'),
              onPressed: ()async {
                logs.add("${format.format(DateTime.now())} Opening Gallery.....");
                Navigator.of(context).pop();
                print('Leaf Gallery');
                final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
                try {
                  print(image!.path);
                  var recognitions = await Tflite.runModelOnImage(
                    path: image.path,   // required
                  );
                  print(recognitions);
                  logs.add("${format.format(DateTime.now())} ${recognitions.toString()}");
                  if(recognitions![0]["confidence"]<0.85){
                    alertDialog("ചിത്രത്തിലെ ഇല കണ്ടെത്താൻ കഴിഞ്ഞില്ല.");
                    return;
                  }
                  if(recognitions[0]["label"].contains("healthy")){
                    alertDialog("നിങ്ങളുടെ ചെടി ആരോഗ്യമുള്ളതായി തോന്നുന്നു!!");
                  }
                  else{
                    PaletteGenerator color=await getColorPalette(image.path.substring(1));
                    print(color.dominantColor!.color);
                    double cmp=compareColor(color.dominantColor!.color);
                    print(cmp);
                    if(cmp.toInt()>25){
                      alertDialog("ചിത്രത്തിലെ ഇല കണ്ടെത്താൻ കഴിഞ്ഞില്ല.");
                      return;
                    }
                    var result = await dbObject.getDiseaseMal(
                        recognitions[0]["index"] + 1);
                    // Navigator.pushNamed(cont, "/crop", arguments: result[0]);
                    Navigator.pushNamed(cont, "/resultsMal", arguments: {"result":recognitions,"type":"disease","obj":dbObject});
                  }
                }
                catch(e){
                  print("Exception $e");
                  logs.add("${format.format(DateTime.now())} Exception $e");
                }
              },
            ),
          ],
        );
      },
    );
  }


  Future<void> seedlingScan(BuildContext cont) async {
    logs.add("${format.format(DateTime.now())} Initiating Seedling Scan.....");
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        loadSeedlingModel();
        return AlertDialog(
          title: Text('തൈകൾ സ്കാൻ ചെയ്യുക'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text("ദയവായി ഒരു ഓപ്ഷൻ തിരഞ്ഞെടുക്കുക."),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('ക്യാമറ'),
              onPressed: () async{
                logs.add("${format.format(DateTime.now())} Opening Camera.....");
                Navigator.of(context).pop();
                print('Seedling Camera');
                final XFile? image = await _picker.pickImage(source: ImageSource.camera);
                try {
                  print(image!.path);
                  var recognitions = await Tflite.runModelOnImage(
                    path: image.path,   // required
                  );
                  logs.add("${format.format(DateTime.now())} ${recognitions.toString()}");
                  if(recognitions![0]["confidence"]<0.85){
                    alertDialog("ചിത്രത്തിൽ തൈ കണ്ടെത്താനായില്ല.");
                    return;
                  }
                  print(recognitions[0]);
                  // alertDialog("$recognitions");
                  Navigator.pushNamed(cont, "/resultsMal", arguments: {"result":recognitions,"type":"seedling","obj":dbObject});
                }
                catch(e){
                  print("Exception $e");
                  logs.add("${format.format(DateTime.now())} Exception $e");
                }
              },
            ),
            TextButton(
              child: Text('ഗാലറി'),
              onPressed: () async{
                logs.add("${format.format(DateTime.now())} Opening Gallery.....");
                Navigator.of(context).pop();
                print('Seedling Gallery');
                final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
                try {
                  print(image!.path);
                  var recognitions = await Tflite.runModelOnImage(
                    path: image.path,   // required
                  );
                  logs.add("${format.format(DateTime.now())} ${recognitions.toString()}");
                  if(recognitions![0]["confidence"]<0.85){
                    alertDialog("ചിത്രത്തിൽ തൈ കണ്ടെത്താനായില്ല.");
                    return;
                  }
                  print(recognitions);
                  // alertDialog("$recognitions");
                  Navigator.pushNamed(cont, "/resultsMal", arguments: {"result":recognitions,"type":"seedling","obj":dbObject});
                }
                catch(e){
                  print("Exception $e");
                  logs.add("${format.format(DateTime.now())} Exception $e");
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
            ListTile(
              leading: Icon(Icons.home),
              title: Text("ഹോം സ്റ്റൈൽ"),
              onTap: (){
                Navigator.pop(context);
                Navigator.pushNamed(context, "/chooseHomeMal");
              },
            ),
            ListTile(
              leading: Icon(Icons.language),
              title: Text("ഇംഗ്ലീഷിലേക്ക് മാറുക"),
              onTap: ()async{
                await sharedPreferences.remove("lang");
                Navigator.pop(context);
                Navigator.pushReplacementNamed(context, "/init");
              },
            ),
            ListTile(
              leading: Icon(Icons.description),
              title: Text("Logs"),
              onTap: ()async{
                Navigator.pop(context);
                Navigator.pushNamed(context, "/logsMal",arguments: {"logs":logs});
              },
            ),
            ListTile(
              leading: Icon(Icons.link),
              title: Text("Set URL"),
              onTap: ()async{
                Navigator.pop(context);
                Navigator.pushNamed(context, "/setURLPageMal");
              },
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text("ഞങ്ങളെ സമീപിക്കുക"),
              onTap: ()async{
                Navigator.pop(context);
                await canLaunch("mailto:agri-app@gmail.com?subject=Agri%20App&body=New%20plugin") ? await launch("mailto:agri-app@gmail.com?subject=Agri%20App&body=New%20plugin") : throw 'Could not launch gmail';
              },
            ),
            authenticated?ListTile(
              leading: Icon(Icons.logout),
              title: Text("ലോഗൗട്ട്"),
              onTap: ()async{
                Navigator.pop(context);
                await sharedPreferences.remove("phone");
                setState(() {
                  authenticated=false;
                  authentication=false;
                });
                OneSignal.shared.removeExternalUserId();
                checkLogin();
              },
            ):Container(),
          ],
        ),
      ),
      backgroundColor: Colors.green,
      body: GestureDetector(
        onTap: (){
          fabKey.currentState!.close();
        },
        child: ListView(
          padding: EdgeInsets.only(top: 20),
          children: [
            Padding(padding: EdgeInsets.only(right: 10,top: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  authenticated?Text(weather,style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 16),):SizedBox(),
                  SizedBox(width: 15,),
                  IconButton(icon: Icon(Icons.menu_open),onPressed: (){
                    _scaffoldKey.currentState!.openEndDrawer();
                  },color: Colors.white,iconSize: 25,),
                ],
              ),),
            SizedBox(height: 20,),
            Padding(
              padding: const EdgeInsets.only(left: 30.0),
              child: Text("A.A.R.C.S.",style: TextStyle(color: Colors.white,fontSize: 40,fontWeight: FontWeight.bold),),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30,vertical: 5),
              child: Text("കർഷകർക്കായി ഒരു ഉപയോക്തൃ സൗഹൃദ ആപ്പ്",style: TextStyle(fontSize: 17,color: Colors.white),),
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
                    Row(
                      children: [
                        SizedBox(width: 30,),
                        authentication?ElevatedButton(
                          onPressed: (){},
                          child: SizedBox(height: 18,width: 18,child: CircularProgressIndicator(color: Colors.white,)),
                          style: TextButton.styleFrom(elevation: 5,fixedSize: Size.fromWidth(double.infinity),padding: EdgeInsets.all(18),backgroundColor: Colors.green,primary: Colors.white,shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(50))),
                        ):authenticated?ElevatedButton(
                          onPressed: (){
                            Navigator.pushNamed(context, "/profileMal");
                          },
                          child: Row(children: [Text("നിങ്ങളുടെ പ്രൊഫൈൽ",style: TextStyle(fontSize: 16),),SizedBox(width: 5,),Icon(Icons.person,size: 18,)],),
                          style: TextButton.styleFrom(elevation: 5,fixedSize: Size.fromWidth(double.infinity),padding: EdgeInsets.all(18),backgroundColor: Colors.green,primary: Colors.white,shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(50))),
                        ):
                        ElevatedButton(
                          onPressed: ()async{
                            Navigator.pushNamed(context, "/loginMal").then((_) => setState(() {}));

                          },
                          child: Row(children: [Text("ലോഗിൻ",style: TextStyle(fontSize: 16),),SizedBox(width: 5,),Icon(Icons.arrow_forward_rounded,size: 18,)],),
                          style: TextButton.styleFrom(elevation: 5,fixedSize: Size.fromWidth(double.infinity),padding: EdgeInsets.all(18),backgroundColor: Colors.green,primary: Colors.white,shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(50))),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 30.0,right: 30,top:15,bottom: 5),
                      child: Text("ഓൺ-എഡ്ജ് സേവനങ്ങൾ",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.green,fontSize: 17),),
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
                              onTap: (){
                                leafScan(context);
                              },
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
                                    Text("രോഗങ്ങൾ",style: TextStyle(color: Colors.green,fontWeight: FontWeight.bold,fontSize: 12),)
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
                              onTap: (){
                                seedlingScan(context);
                              },
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
                                    Text("തൈകൾ",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 12),)
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
                              onTap: (){
                                Navigator.pushNamed(context, "/recommendMal",arguments: {"logs":logs});
                              },
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
                                    Text("വിളകൾ",style: TextStyle(color: Colors.green,fontWeight: FontWeight.bold,fontSize: 12),)
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
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)
                            ),
                            elevation: 10,
                            child: InkWell(
                              onTap: (){
                                Navigator.pushNamed(context, "/calendarMal",arguments: {"db":dbObject});
                              },
                              borderRadius: BorderRadius.circular(10),
                              child: Container(
                                height: 100,
                                width: 100,
                                padding: EdgeInsets.all(10),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.calendar_today,color: Colors.green,size: 30,),
                                    SizedBox(height: 10,),
                                    Text("ഷെഡ്യൂളർ",style: TextStyle(color: Colors.green,fontWeight: FontWeight.bold,fontSize: 12),)
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    authenticated?Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 20,),
                        Padding(
                          padding: const EdgeInsets.only(left: 30.0,right: 30,top:15,bottom: 5),
                          child: Text("ഓൺലൈൻ സേവനങ്ങൾ",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.green,fontSize: 17),),
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
                                  onTap: (){
                                    Navigator.pushNamed(context, "/marketMal");
                                  },
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
                                        Text("വിപണി",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 12),)
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
                                  onTap: (){
                                    Navigator.pushNamed(context, "/landMal");
                                  },
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
                                        Text("ഭൂമികൾ",style: TextStyle(color: Colors.green,fontWeight: FontWeight.bold,fontSize: 12),)
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
                                  onTap: (){
                                    Navigator.pushNamed(context, "/rentMal");
                                  },
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
                                        Text("ഉപകരണങ്ങൾ",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 9),)
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
                                  onTap: (){
                                    Navigator.pushNamed(context, "/chatMal");
                                  },
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
                                        Text("ചാറ്റ്",style: TextStyle(color: Colors.green,fontWeight: FontWeight.bold,fontSize: 12),)
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
                                  onTap: (){
                                    Navigator.pushNamed(context, "/showCommunityMal");
                                  },
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
                                        Text("പോസ്റ്റുകൾ",style: TextStyle(color: Colors.green,fontWeight: FontWeight.bold,fontSize: 12),)
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ):SizedBox(),
                    SizedBox(height: 20,),
                    Padding(
                      padding: const EdgeInsets.only(left: 30.0,right: 30,top:15,bottom: 5),
                      child: Text("പ്രാദേശിക ഇനങ്ങൾ",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.green,fontSize: 17),),
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
                              var result=await dbObject.getInfoMal(1);
                              Navigator.pushNamed(context, "/cropMal",arguments: result[0]);
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
                                    Positioned(left: 10,bottom: 15,child: Text("അരി",style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold),))
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
                              var result=await dbObject.getInfoMal(2);
                              Navigator.pushNamed(context, "/cropMal",arguments: result[0]);
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
                                    Positioned(left: 10,bottom: 15,child: Text("ഗോതമ്പ്",style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold),))
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
                              var result=await dbObject.getInfoMal(3);
                              Navigator.pushNamed(context, "/cropMal",arguments: result[0]);
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
                                    Positioned(left: 10,bottom: 15,child: Text("കരിമ്പ്",style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold),))
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
                              var result=await dbObject.getInfoMal(4);
                              Navigator.pushNamed(context, "/cropMal",arguments: result[0]);
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
                                    Positioned(left: 10,bottom: 15,child: Text("ചോളം",style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold),))
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
