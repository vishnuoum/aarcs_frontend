import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChooseHomeMal extends StatefulWidget {
  const ChooseHomeMal({Key? key}) : super(key: key);

  @override
  State<ChooseHomeMal> createState() => _ChooseHomeMalState();
}

class _ChooseHomeMalState extends State<ChooseHomeMal> {

  late SharedPreferences sharedPreferences;
  String? home="";

  @override
  void initState() {
    loadSP();
    super.initState();
  }

  void loadSP()async{
    sharedPreferences = await SharedPreferences.getInstance();
    if(sharedPreferences.containsKey("home")){
      home=sharedPreferences.getString("home");
    }
    else{
      home="home";
    }
    setState(() {});
  }

  void setHome(String val){
    sharedPreferences.setString("home", val);
    Navigator.pop(context);
    Navigator.pushReplacementNamed(context, "/"+home.toString()+"Mal");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text("ഹോം സ്‌ക്രീൻ തിരഞ്ഞെടുക്കുക"),
        actions: [
          IconButton(onPressed: (){
            setHome(home.toString());
          }, icon: Icon(Icons.check),iconSize: 25,)
        ],
      ),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: (){
                  setState(() {
                    home="home";
                  });
                },
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                            border: Border.all(color: home=="home"?Colors.green:Colors.transparent,width: 3)
                        ),
                        child: Image.asset("assets/images/home1.png",width: 150,)),
                    SizedBox(height: 12,),
                    Text("Home 1",style: TextStyle(color: Colors.green,fontSize: 17,fontWeight: FontWeight.bold),)
                  ],
                ),
              ),
              GestureDetector(
                onTap: (){
                  setState(() {
                    home="home2";
                  });
                },
                child: Column(
                  children: [
                    Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(color: home=="home2"?Colors.green:Colors.transparent,width: 3)
                        ),
                        child: Image.asset("assets/images/home3.png",width: 150,)),
                    SizedBox(height: 12,),
                    Text("Home 2",style: TextStyle(color: Colors.green,fontSize: 17,fontWeight: FontWeight.bold),)
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 20,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: (){
                  setState(() {
                    home="home1";
                  });
                },
                child: Column(
                  children: [
                    Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(color: home=="home1"?Colors.green:Colors.transparent,width: 3)
                        ),
                        child: Image.asset("assets/images/home2.png",width: 150,)),
                    SizedBox(height: 12,),
                    Text("Debug Mode",style: TextStyle(color: Colors.green,fontSize: 17,fontWeight: FontWeight.bold),)
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
