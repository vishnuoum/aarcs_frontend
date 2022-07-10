import 'package:agri_app/icons/icon_icons.dart';
import 'package:flutter/material.dart';


class RecommendationResultMal extends StatelessWidget {
  final Map argument;
  const RecommendationResultMal({Key? key,required this.argument}) : super(key: key);

  String capitalize(String string) {
    if (string.isEmpty) {
      return string;
    }

    return string[0].toUpperCase() + string.substring(1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green,
      body: ListView(
        children: [
          SizedBox(height: 10,),
          Align(
            child: IconButton(onPressed: (){
              Navigator.pop(context);
            }, icon: Icon(Icons.arrow_back),color: Colors.white,),
            alignment: Alignment.topLeft,
          ),
          Padding(padding: EdgeInsets.only(left: 25,top: 15),child: Text("ശുപാർശ ഫലം",style: TextStyle(color: Colors.white,fontSize: 25,fontWeight: FontWeight.bold),),),
          Padding(padding: EdgeInsets.only(left: 25,top: 15),child: Text("ഓൺ-എഡ്ജ് ഡിസിഷൻ ട്രീ മോഡൽ ഉപയോഗിച്ച് ലഭിച്ച ഫലം",style: TextStyle(color: Colors.green[800],fontWeight: FontWeight.bold),),),
          Padding(padding: EdgeInsets.only(left: 25,top: 5),child: Text("Model v.1.0",style: TextStyle(color: Colors.green[800],fontWeight: FontWeight.bold),),),
          SizedBox(height: 30,),
          Container(
            padding: EdgeInsets.all(25),
            constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height-160, minWidth: double.infinity),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
              color: Colors.white
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10,),
                Text("ശുപാർശ ചെയ്യുന്ന വിള:",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.grey[700]),),
                SizedBox(height: 10,),
                Text(capitalize(argument["result"]),style: TextStyle(fontSize: 35,fontWeight: FontWeight.bold,),),
                SizedBox(height: 5,),
                argument["crop"]==null?SizedBox():Column(
                  children: [
                    Text(argument["crop"]==capitalize(argument["result"])?"The chosen crop is suitable for planting.":"The chosen crop: ${argument['crop']} is not suitable.",style: TextStyle(fontSize: 17),overflow: TextOverflow.clip,),
                    SizedBox(height: 20,),
                  ],
                ),
                Text("നൽകിയിരിക്കുന്ന പാരാമീറ്ററുകൾ",style: TextStyle(color: Colors.green,fontSize: 17,fontWeight: FontWeight.bold),),
                SizedBox(height: 20,),
                Row(
                  children: [
                    Container(
                      child: Row(
                        children: [
                          CircleAvatar(
                            child: Text("N",style: TextStyle(color: Colors.white,fontSize: 25,fontWeight: FontWeight.bold),),
                            backgroundColor: Colors.green[300],
                            radius: 30,
                          ),
                          SizedBox(width: 10,),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("${argument["N"]}",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25),),
                              Text("Kg/ha",style: TextStyle(fontSize: 15),)
                            ],
                          )
                        ],
                      ),
                      width: 150,
                    ),
                    SizedBox(width: 40,),
                    Container(
                      width: 150,
                      child: Row(
                        children: [
                          CircleAvatar(
                            child: Text("P",style: TextStyle(color: Colors.white,fontSize: 25,fontWeight: FontWeight.bold),),
                            backgroundColor: Colors.green[300],
                            radius: 30,
                          ),
                          SizedBox(width: 10,),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("${argument["K"]}",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25),),
                              Text("Kg/ha",style: TextStyle(fontSize: 15),)
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      width: 150,
                      child: Row(
                        children: [
                          CircleAvatar(
                            child: Text("K",style: TextStyle(color: Colors.white,fontSize: 25,fontWeight: FontWeight.bold),),
                            backgroundColor: Colors.green[300],
                            radius: 30,
                          ),
                          SizedBox(width: 10,),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("${argument["K"]}",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25),),
                              Text("Kg/ha",style: TextStyle(fontSize: 15),)
                            ],
                          )
                        ],
                      ),
                    ),
                    SizedBox(width: 40,),
                    Container(
                      width: 150,
                      child: Row(
                        children: [
                          CircleAvatar(
                            child: Text("pH",style: TextStyle(color: Colors.white,fontSize: 25,fontWeight: FontWeight.bold),),
                            backgroundColor: Colors.green[300],
                            radius: 30,
                          ),
                          SizedBox(width: 10,),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("${argument["ph"]}",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25),),
                              Text("pH Value",style: TextStyle(fontSize: 15),)
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          child: Icon(FlutterIcon.temperatire,color: Colors.white,size: 25,),
                          backgroundColor: Colors.green[300],
                          radius: 30,
                        ),
                        SizedBox(width: 10,),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("${argument["temp"]}°C",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25),),
                            Text("താപനില",style: TextStyle(fontSize: 15),)
                          ],
                        )
                      ],
                    )
                  ],
                ),
                SizedBox(height: 20,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          child: Icon(FlutterIcon.humidity,color: Colors.white,size: 25,),
                          backgroundColor: Colors.green[300],
                          radius: 30,
                        ),
                        SizedBox(width: 10,),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("${argument["humidity"]}%",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25),),
                            Text("ഈർപ്പം",style: TextStyle(fontSize: 15),)
                          ],
                        )
                      ],
                    )
                  ],
                ),
                SizedBox(height: 20,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          child: Icon(FlutterIcon.rain_inv,color: Colors.white,size: 25,),
                          backgroundColor: Colors.green[300],
                          radius: 30,
                        ),
                        SizedBox(width: 10,),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("${argument["rainfall"]} mm",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25),),
                            Text("ശരാശരി മഴ",style: TextStyle(fontSize: 15),)
                          ],
                        )
                      ],
                    )
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
