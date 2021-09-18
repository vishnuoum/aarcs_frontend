import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Crop extends StatelessWidget {

  final Map arguments;

  const Crop({Key? key,required this.arguments}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // print(arguments);
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        iconTheme: IconThemeData(
          color: Colors.green
        ),
        backgroundColor: Colors.transparent,
      ),
      body:Stack(
            children: [
              Container(constraints: BoxConstraints(minHeight: MediaQuery.of(context).size.height),),
              SizedBox(
                width: double.infinity,
                height: MediaQuery.of(context).size.height*0.4,
                child: Image.asset("assets/images/${arguments["name"]}.jpg",fit: BoxFit.cover,),
              ),
              Positioned(
                left: 0,
                top: MediaQuery.of(context).size.height*0.36,
                child: Container(
                  height: MediaQuery.of(context).size.height*0.64,
                  // padding: EdgeInsets.symmetric(vertical: 10,horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(15),topRight: Radius.circular(15)),
                    boxShadow: [BoxShadow(
                    color: Colors.black,
                    blurRadius: 15.0,
                    )]
                  ),
                  child: ListView(
                    padding: EdgeInsets.all(12),
                    children: [
                      SizedBox(height: 20,),
                      Text("${arguments["name"]}",style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold),),
                      SizedBox(height: 20,),
                      SizedBox(width: MediaQuery.of(context).size.width,child: Text("${arguments["details"]}",textAlign:TextAlign.justify,style: TextStyle(fontSize: 17),),),
                      SizedBox(height: 15,),
                      TextButton(onPressed: ()async{await canLaunch(arguments["link"]) ? await launch(arguments["link"]) : throw 'Could not launch ${arguments["link"]}';}, child: Text("Know More",style: TextStyle(fontSize: 16),),style: TextButton.styleFrom(backgroundColor: Colors.green,primary: Colors.white,shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),padding: EdgeInsets.all(15)),)
                    ],
                  ),
                  constraints: BoxConstraints(
                    maxWidth:MediaQuery.of(context).size.width,
                  ),
                )
                ),
            ],
          ),
    );
  }
}
