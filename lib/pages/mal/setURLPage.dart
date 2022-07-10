import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SetURLPageMal extends StatefulWidget {
  const SetURLPageMal({Key? key}) : super(key: key);

  @override
  State<SetURLPageMal> createState() => _SetURLPageMalState();
}

class _SetURLPageMalState extends State<SetURLPageMal> {

  TextEditingController url = TextEditingController(text: "");
  late SharedPreferences sharedPreferences;

  @override
  void initState() {
    SharedPreferences.getInstance().then((value){
      sharedPreferences = value;
      url.text = value.getString("url").toString();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Set URL"),
      ),
      body: ListView(
        padding: EdgeInsets.only(left: 25,right: 25,top: 60,bottom: 100),
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 15,vertical: 5),
            color: Colors.grey[100],
            child: TextField(
              controller: url,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "Enter URL"
              ),
            ),
          ),
          SizedBox(height: 15,),
          TextButton(onPressed: (){
            if(url.text.length!=0)
              sharedPreferences.setString("url", url.text);
          }, child: Text("Set"))
        ],
      ),
    );
  }
}
