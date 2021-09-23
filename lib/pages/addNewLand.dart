import 'dart:io';

import 'package:agri_app/services/addService.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddNewLand extends StatefulWidget {
  const AddNewLand({Key? key}) : super(key: key);

  @override
  _AddNewLandState createState() => _AddNewLandState();
}

class _AddNewLandState extends State<AddNewLand> {

  String district = 'Select a District';
  ImagePicker _picker = ImagePicker();
  String path="";
  String? phone;
  TextEditingController name=TextEditingController();
  TextEditingController price=TextEditingController();
  TextEditingController place=TextEditingController();

  AddService addService=AddService();

  @override
  void initState() {
    init();
    super.initState();
  }

  void init()async{
    SharedPreferences sharedPreferences=await SharedPreferences.getInstance();
    phone=sharedPreferences.getString("phone");
  }

  showLoading(BuildContext context){
    AlertDialog alert =AlertDialog(
      content: SizedBox(
        height: 80,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 50,width: 50,child: CircularProgressIndicator(strokeWidth: 5,valueColor: AlwaysStoppedAnimation(Colors.green),),),
            SizedBox(height: 10,),
            Text("Loading")
          ],
        ),
      ),
    );

    showDialog(context: context,builder:(BuildContext context){
      return WillPopScope(onWillPop: ()async => false,child: alert);
    });
  }

  Future<void> alertDialog(var text) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Alert'),
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
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
            color: Colors.green
        ),
      ),
      body: Form(
        child: ListView(
          padding: EdgeInsets.symmetric(vertical: 20,horizontal: 30),
          children: [
            Align(child: Text("Add Your Land",style: TextStyle(color: Colors.green,fontSize: 30,fontWeight: FontWeight.bold),),alignment: Alignment.centerLeft,),
            SizedBox(height: 40,),
            Container(
              padding: EdgeInsets.symmetric(vertical: 5,horizontal: 20),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey[200]
              ),
              child: TextField(
                textCapitalization: TextCapitalization.words,
                controller: name,
                focusNode: null,
                style: TextStyle(color: Colors.black),
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Land Name'
                ),
              ),
            ),
            SizedBox(height: 15,),
            Container(
              padding: EdgeInsets.symmetric(vertical: 5,horizontal: 20),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey[200]
              ),
              child: TextField(
                controller: price,
                keyboardType: TextInputType.number,
                // textCapitalization: TextCapitalization.sentences,
                focusNode: null,
                style: TextStyle(color: Colors.black),
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Rent/Month'
                ),
              ),
            ),
            SizedBox(height: 15,),
            Container(
              padding: EdgeInsets.symmetric(vertical: 5,horizontal: 20),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey[200]
              ),
              child: TextField(
                controller: place,
                textCapitalization: TextCapitalization.words,
                focusNode: null,
                style: TextStyle(color: Colors.black),
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Place'
                ),
              ),
            ),
            SizedBox(height: 15,),
            Container(
              padding: EdgeInsets.symmetric(vertical: 5,horizontal: 20),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey[200]
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton(items: <String>['Select a District','Kasargod', 'Kannur', 'Wayanad', 'Palakkad','Malapuram','Kozhikode','Thrissur','Ernakulam','Idukki','Alappuzha','Kottayam','Pathanamthitta','Kollam','Thiruvananthapuram']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value,style: TextStyle(color:value=="Select a District"?Colors.grey[700]:Colors.black),),
                  );
                }).toList(),
                  isExpanded: true,
                  underline: null,
                  value: district,
                  onChanged: (String? newValue) {
                    setState(() {
                      district = newValue!;
                    });
                  },
                ),
              ),
            ),
            SizedBox(height: 15,),
            path.length!=0?GestureDetector(onTap: ()async{XFile? photo = await _picker.pickImage(source: ImageSource.camera);if(photo!=null){setState(() {path=photo.path;});}},child: Image.file(File(path),fit: BoxFit.cover,)):TextButton.icon(style: TextButton.styleFrom(padding: EdgeInsets.all(15),shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),icon: Icon(Icons.camera_alt),onPressed: ()async{
              XFile? photo = await _picker.pickImage(source: ImageSource.camera);if(photo!=null){setState(() {path=photo.path;});}
            },label: Text("Add a photo"),),
            SizedBox(height: 15,),
            TextButton(onPressed: ()async{
              print(path);
              print(phone);

              if(name.text.length!=0 && price.text.length!=0 && place.text.length!=0 && district!="Select a district" && path.length!=0){
                showLoading(context);
                var result=await addService.addLand(name: name.text, price: price.text, place: place.text, district: district, phone: phone, path: path);
                if(result=="done"){
                  Navigator.pop(context);
                  Navigator.pop(context);
                }
                else{
                  Navigator.pop(context);
                  alertDialog("Something went wrong. Please try Again!!");
                }
              }
              else{
                alertDialog("Please complete the form!!");
              }
            }, child: Text("Add",style: TextStyle(fontSize: 17),),style: TextButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),backgroundColor: Colors.green,primary: Colors.white,padding: EdgeInsets.all(18)),),
          ],
        ),
      ),
    );
  }
}
