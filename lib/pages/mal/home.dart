import 'dart:io';
import 'dart:math';

import 'package:agri_app/icons/icon_icons.dart';
import 'package:agri_app/services/analyticsService.dart';
import 'package:agri_app/services/dbservice.dart';
import 'package:agri_app/services/loginService.dart';
import 'package:agri_app/services/weatherService.dart';
import 'package:fab_circular_menu/fab_circular_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tflite/tflite.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeMal extends StatefulWidget {
  HomeMal({Key? key}) : super(key: key);

  @override
  _HomeMalState createState() => _HomeMalState();
}

class _HomeMalState extends State<HomeMal> {

  final GlobalKey<FabCircularMenuState> fabKey = GlobalKey();
  DateTime start = DateTime.now();
  LoginService loginService = LoginService();

  late SharedPreferences sharedPreferences;
  final ImagePicker _picker = ImagePicker();
  String? res;
  late DBService dbObject;
  WeatherService weatherService=WeatherService();
  String weather="";
  bool authentication=false,authenticated=false;

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
    await checkLogin();
  }

  void weatherApi()async{
    if(sharedPreferences.containsKey("phone")) {
      var result = await weatherService.getWeather(
          phone: sharedPreferences.getString("phone"));
      if (result != "error") {
        weather =
        "${(result["main"]["temp"] - 273).toStringAsFixed(2)}°C  ${capitalize(
            result["weather"][0]["description"])}";
      }
      setState(() {});
    }
  }

  Future<void> checkLogin()async{
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
                    Navigator.pushNamed(cont, "/resultsMal", arguments: {"result":recognitions,"type":"disease","obj":dbObject});
                  }
                }
                catch(e){
                  print("Exception $e");
                }
              },
            ),
            TextButton(
              child: Text('ഗാലറി'),
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
                    Navigator.pushNamed(cont, "/resultsMal", arguments: {"result":recognitions,"type":"disease","obj":dbObject});
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
                Navigator.of(context).pop();
                print('Seedling Camera');
                final XFile? image = await _picker.pickImage(source: ImageSource.camera);
                try {
                  print(image!.path);
                  var recognitions = await Tflite.runModelOnImage(
                    path: image.path,   // required
                  );
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
                }
              },
            ),
            TextButton(
              child: Text('ഗാലറി'),
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
                    alertDialog("ചിത്രത്തിൽ തൈ കണ്ടെത്താനായില്ല.");
                    return;
                  }
                  print(recognitions);
                  // alertDialog("$recognitions");
                  Navigator.pushNamed(cont, "/resultsMal", arguments: {"result":recognitions,"type":"seedling","obj":dbObject});
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
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backwardsCompatibility: false,
        systemOverlayStyle: SystemUiOverlayStyle(statusBarColor: Colors.green),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          authenticated?Row(children: [
            Text(weather,style: TextStyle(color: Colors.green,fontWeight: FontWeight.bold),)
          ],):SizedBox(),
          SizedBox(width: 10,)
        ],
        iconTheme: IconThemeData(
          color: Colors.green,
        ),
      ),
      drawer: Drawer(
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
              leading: Icon(Icons.calendar_today_rounded),
              title: Text("ഇവന്റ് ഷെഡ്യൂളർ"),
              onTap: (){
                Navigator.pop(context);
                Navigator.pushNamed(context, "/calendarMal",arguments: {"db":dbObject});
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
            authenticated?ListTile(
              leading: Icon(Icons.shopping_cart_rounded),
              title: Text("മാർക്കറ്റ് പ്ലേസ്"),
              onTap: (){
                Navigator.pop(context);
                Navigator.pushNamed(context, "/marketMal");
              },
            ):Container(),
            authenticated?ListTile(
              leading: Icon(Icons.settings),
              title: Text("വാടകയ്‌ക്കെടുക്കുക"),
              onTap: (){
                Navigator.pop(context);
                Navigator.pushNamed(context, "/rentMal");
              },
            ):Container(),
            authenticated?ListTile(
              leading: Icon(Icons.place),
              title: Text("ഭൂമി കടം കൊടുക്കുക"),
              onTap: (){
                Navigator.pop(context);
                Navigator.pushNamed(context, "/landMal");
              },
            ):Container(),
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
      backgroundColor: Colors.white,
      floatingActionButton: FabCircularMenu(
        key: fabKey,
        fabColor: Colors.green,
        ringColor: Colors.green,
        fabOpenIcon: Icon(Icons.lightbulb,color: Colors.white,),
        fabCloseIcon: Icon(Icons.close,color: Colors.white,),
        children: <Widget>[
          IconButton(tooltip: "കമ്മ്യൂണിറ്റിയിൽ ചോദിക്കുക",color: Colors.white,splashColor: Colors.transparent,focusColor: Colors.transparent,highlightColor: Colors.transparent,icon: Icon(Icons.question_answer), onPressed: authenticated?() {
            print('Ask in Community');
            fabKey.currentState!.close();
            Navigator.pushNamed(context, "/showCommunityMal");
          }:null,),
          IconButton(tooltip: "കമ്മ്യൂണിറ്റി ചാറ്റ്",color: Colors.white,splashColor: Colors.transparent,focusColor: Colors.transparent,highlightColor: Colors.transparent,icon: Icon(Icons.message), onPressed: authenticated?() {
            print('Community Chat');
            fabKey.currentState!.close();
            Navigator.pushNamed(context, "/chatMal");
          }:null,),
          IconButton(tooltip: "വിള ശുപാർശ",icon: Icon(FlutterIcon.soil),color: Colors.white,splashColor: Colors.transparent,focusColor: Colors.transparent,highlightColor: Colors.transparent,onPressed: ()async{
            fabKey.currentState!.close();
            await Navigator.pushNamed(context, "/recommendMal");
          },),
          IconButton(tooltip: "തൈകൾ സ്കാൻ ചെയ്യുക",color: Colors.white,splashColor: Colors.transparent,focusColor: Colors.transparent,highlightColor: Colors.transparent,icon: Icon(FlutterIcon.plant), onPressed: ()async {
            fabKey.currentState!.close();
            seedlingScan(context);
          }),
          IconButton(tooltip: "ഇല സ്കാൻ ചെയ്യുക",color: Colors.white,splashColor: Colors.transparent,focusColor: Colors.transparent,highlightColor: Colors.transparent,icon: Icon(FlutterIcon.leaf), onPressed: ()async {
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
              child: Text("A.A.R.C.S.",style: TextStyle(color: Colors.green,fontSize: 40,fontWeight: FontWeight.bold),),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30,vertical: 5),
              child: Text("കർഷകർക്കായി ഒരു ഉപയോക്തൃ സൗഹൃദ ആപ്പ്",style: TextStyle(fontSize: 17,color: Colors.green),),
            ),
            SizedBox(height: 25,),
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
            )
          ],
        ),
      ),
    );
  }
}
