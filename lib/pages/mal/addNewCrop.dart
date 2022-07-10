import 'dart:io';

import 'package:agri_app/services/addService.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';


class AddNewCropMal extends StatefulWidget {
  const AddNewCropMal({Key? key}) : super(key: key);

  @override
  _AddNewCropMalState createState() => _AddNewCropMalState();
}

class _AddNewCropMalState extends State<AddNewCropMal> {

  String district = 'ജില്ല തിരഞ്ഞെടുക്കുക';
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
          title: Text('അലെർട്'),
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
            Align(child: Text("നിങ്ങളുടെ ഇനം ചേർക്കുക",style: TextStyle(color: Colors.green,fontSize: 30,fontWeight: FontWeight.bold),),alignment: Alignment.centerLeft,),
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
                    hintText: 'ഇനത്തിന്റെ പേര്'
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
                    hintText: 'വില/കിലോ'
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
                    hintText: 'സ്ഥലം'
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
                child: DropdownButton(items: <String>['ജില്ല തിരഞ്ഞെടുക്കുക','കാസർകോട്', 'കണ്ണൂർ', 'വയനാട്', 'പാലക്കാട്','മലപ്പുറം','കോഴിക്കോട്','തൃശൂർ','എറണാകുളം','ഇടുക്കി','ആലപ്പുഴ','കോട്ടയം','പത്തനംതിട്ട','കൊല്ലം','തിരുവനന്തപുരം']
                  .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value,style: TextStyle(color:value=="ജില്ല തിരഞ്ഞെടുക്കുക"?Colors.grey[700]:Colors.black),),
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
            },label: Text("ഒരു ഫോട്ടോ ചേർക്കുക"),),
            SizedBox(height: 15,),
            TextButton(onPressed: ()async{
              print(path);
              if(name.text.length!=0 && price.text.length!=0 && place.text.length!=0 && district!="ജില്ല തിരഞ്ഞെടുക്കുക" && path.length!=0){
                showLoading(context);
                var result=await addService.addItem(name: name.text, price: price.text, place: place.text, district: district, phone: phone, path: path);
                if(result=="done"){
                  Navigator.pop(context);
                  Navigator.pop(context);
                }
                else{
                  Navigator.pop(context);
                  alertDialog("എന്തോ കുഴപ്പം സംഭവിച്ചു. ദയവായി വീണ്ടും ശ്രമിക്കുക!!");
                }
              }
              else{
                alertDialog("ദയവായി ഫോം പൂരിപ്പിക്കുക!!");
              }
            }, child: Text("ചേർക്കുക",style: TextStyle(fontSize: 17),),style: TextButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),backgroundColor: Colors.green,primary: Colors.white,padding: EdgeInsets.all(18)),),
          ],
        ),
      ),
    );
  }
}

