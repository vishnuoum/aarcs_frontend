import 'package:agri_app/services/analyticsService.dart';
import 'package:agri_app/services/dbservice.dart';
import 'package:fab_circular_menu/fab_circular_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
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
  DateTime start = DateTime.now();

  late SharedPreferences sharedPreferences;
  final ImagePicker _picker = ImagePicker();
  String? res;
  late DBService dbObject;

  AnalyticsService analyticsService=AnalyticsService();

  @override
  void initState() {
    super.initState();
    loadModel();
    dbObject=DBService();
    loadSharedPreferences();
    analyticsService.sendAnalytics();
  }


  void loadSharedPreferences()async{
    sharedPreferences=await SharedPreferences.getInstance();
    print(sharedPreferences.containsKey("usage"));
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


  void loadModel()async{
    res = await Tflite.loadModel(
        model: "assets/model.tflite",
        labels: "assets/labels.txt",
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



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backwardsCompatibility: false,
        systemOverlayStyle: SystemUiOverlayStyle(statusBarColor: Colors.green),
        backgroundColor: Colors.white,
        elevation: 0,
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
                    radius: 35,
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.green,
                  ),
                  SizedBox(height: 15,),
                  Text("Agri-App",style: TextStyle(color: Colors.white,fontSize: 20,),)
                ],
              ),
            ),
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
              leading: Icon(Icons.settings),
              title: Text("Lend a Land"),
              onTap: (){
                Navigator.pop(context);
                Navigator.pushNamed(context, "/land");
              },
            ):Container(),
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
                sharedPreferences.remove("phone");
                setState(() {});
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
          IconButton(tooltip: "Community Chat",color: Colors.white,splashColor: Colors.transparent,focusColor: Colors.transparent,highlightColor: Colors.transparent,icon: Icon(Icons.message), onPressed: checkLogin()?() {
            print('Community Chat');
            Navigator.pushNamed(context, "/chat");
            fabKey.currentState!.close();
          }:null,),
          IconButton(tooltip: "Pick From Gallery",color: Colors.white,splashColor: Colors.transparent,focusColor: Colors.transparent,highlightColor: Colors.transparent,icon: Icon(Icons.photo), onPressed: ()async {
            print('');
            final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
            try {
              print(image!.path);
              var recognitions = await Tflite.runModelOnImage(
                  path: image.path,   // required
              );
              print(recognitions);
              if(recognitions![0]["label"].contains("healthy")){
                alertDialog("Your plant seems healthy!!");
              }
              else{
                var result = await dbObject.getDisease(
                    recognitions[0]["index"] + 1);
                Navigator.pushNamed(context, "/crop", arguments: result[0]);
              }
            }
            catch(e){
              print("Exception $e");
            }
            fabKey.currentState!.close();
          }),
          IconButton(tooltip: "Open Camera",color: Colors.white,splashColor: Colors.transparent,focusColor: Colors.transparent,highlightColor: Colors.transparent,icon: Icon(Icons.camera), onPressed: ()async {
            print('Camera');
            final XFile? image = await _picker.pickImage(source: ImageSource.camera);
            try {
              print(image!.path);
              var recognitions = await Tflite.runModelOnImage(
                path: image.path,   // required
              );
              print(recognitions);
              if(recognitions![0]["label"].contains("healthy")){
                alertDialog("Your plant seems healthy!!");
              }
              else {
                var result = await dbObject.getDisease(
                    recognitions[0]["index"] + 1);
                await dbObject.addDiseaseAnalytics(recognitions[0]["index"] );
                Navigator.pushNamed(context, "/crop", arguments: result[0]);
              }
            }
            catch(e){
              print("Exception $e");
            }
            fabKey.currentState!.close();
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
              child: Text("Agri App",style: TextStyle(color: Colors.green,fontSize: 40,fontWeight: FontWeight.bold),),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30,vertical: 5),
              child: Text("A User-Friendly App for farmers",style: TextStyle(fontSize: 17,color: Colors.green),),
            ),
            SizedBox(height: 25,),
            Row(
              children: [
                SizedBox(width: 30,),
                checkLogin()?ElevatedButton(
                  onPressed: (){
                    Navigator.pushNamed(context, "/profile");
                  },
                  child: Row(children: [Text("Your Profile",style: TextStyle(fontSize: 16),),SizedBox(width: 5,),Icon(Icons.person,size: 18,)],),
                  style: TextButton.styleFrom(elevation: 5,fixedSize: Size.fromWidth(double.infinity),padding: EdgeInsets.all(18),backgroundColor: Colors.green,primary: Colors.white,shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(50))),
                ):
                ElevatedButton(
                    onPressed: ()async{
                      Navigator.pushNamed(context, "/login").then((_) => setState(() {}));

                    },
                    child: Row(children: [Text("Get Started",style: TextStyle(fontSize: 16),),SizedBox(width: 5,),Icon(Icons.arrow_forward_rounded,size: 18,)],),
                    style: TextButton.styleFrom(elevation: 5,fixedSize: Size.fromWidth(double.infinity),padding: EdgeInsets.all(18),backgroundColor: Colors.green,primary: Colors.white,shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(50))),
                ),
              ],
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
            )
          ],
        ),
      ),
    );
  }
}
