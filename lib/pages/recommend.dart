import 'package:agri_app/services/decisionTree.dart';
import 'package:agri_app/services/recommendationService.dart';
import 'package:flutter/material.dart';

class Recommend extends StatefulWidget {
  const Recommend({Key? key}) : super(key: key);

  @override
  _RecommendState createState() => _RecommendState();
}

class _RecommendState extends State<Recommend> {



  TextEditingController N=TextEditingController();
  TextEditingController K=TextEditingController();
  TextEditingController P=TextEditingController();
  TextEditingController temperature=TextEditingController();
  TextEditingController humidity=TextEditingController();
  TextEditingController rainfall=TextEditingController();
  TextEditingController ph=TextEditingController();
  RecommendationService recommendationService=RecommendationService();
  String cropName= "Select a crop for checking (optional)";

  String capitalize(String string) {
    if (string.isEmpty) {
      return string;
    }

    return string[0].toUpperCase() + string.substring(1);
  }


  Future<void> alertDialog(String title,String text) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        titleSpacing: 5,
        iconTheme: IconThemeData(
          color: Colors.green
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Form(
        child: ListView(
          padding: EdgeInsets.symmetric(vertical: 20,horizontal: 30),
          children: [
            Align(child: Text("Recommendation System",style: TextStyle(color: Colors.green,fontSize: 30,fontWeight: FontWeight.bold),),alignment: Alignment.centerLeft,),
            SizedBox(height: 40,),
            Text("Nitrogen Content",style: TextStyle(fontWeight: FontWeight.bold),),
            SizedBox(height: 8,),
            Container(
              padding: EdgeInsets.symmetric(vertical: 5,horizontal: 20),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey[200]
              ),
              child: TextField(
                keyboardType: TextInputType.number,
                controller: N,
                focusNode: null,
                style: TextStyle(color: Colors.black),
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Nitrogen content in soil (Kg/ha)'
                ),
              ),
            ),
            SizedBox(height: 15,),
            Text("Potassium Content",style: TextStyle(fontWeight: FontWeight.bold),),
            SizedBox(height: 8,),
            Container(
              padding: EdgeInsets.symmetric(vertical: 5,horizontal: 20),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey[200]
              ),
              child: TextField(
                keyboardType: TextInputType.number,
                controller: K,
                focusNode: null,
                style: TextStyle(color: Colors.black),
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Potassium content in soil (Kg/ha)'
                ),
              ),
            ),
            SizedBox(height: 15,),
            Text("Phosphorus Content",style: TextStyle(fontWeight: FontWeight.bold),),
            SizedBox(height: 8,),
            Container(
              padding: EdgeInsets.symmetric(vertical: 5,horizontal: 20),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey[200]
              ),
              child: TextField(
                keyboardType: TextInputType.number,
                controller: P,
                focusNode: null,
                style: TextStyle(color: Colors.black),
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Phosphorus content in soil (Kg/ha)'
                ),
              ),
            ),
            SizedBox(height: 15,),
            Text("Temperature",style: TextStyle(fontWeight: FontWeight.bold),),
            SizedBox(height: 8,),
            Container(
              padding: EdgeInsets.symmetric(vertical: 5,horizontal: 20),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey[200]
              ),
              child: TextField(
                keyboardType: TextInputType.number,
                controller: temperature,
                focusNode: null,
                style: TextStyle(color: Colors.black),
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Temperature in °C'
                ),
              ),
            ),
            SizedBox(height: 15,),
            Text("Rainfall Content",style: TextStyle(fontWeight: FontWeight.bold),),
            SizedBox(height: 8,),
            Container(
              padding: EdgeInsets.symmetric(vertical: 5,horizontal: 20),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey[200]
              ),
              child: TextField(
                keyboardType: TextInputType.number,
                controller: rainfall,
                focusNode: null,
                style: TextStyle(color: Colors.black),
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Average Rainfall (mm)'
                ),
              ),
            ),
            SizedBox(height: 15,),
            Text("pH",style: TextStyle(fontWeight: FontWeight.bold),),
            SizedBox(height: 8,),
            Container(
              padding: EdgeInsets.symmetric(vertical: 5,horizontal: 20),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey[200]
              ),
              child: TextField(
                keyboardType: TextInputType.number,
                controller: ph,
                focusNode: null,
                style: TextStyle(color: Colors.black),
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'pH Value'
                ),
              ),
            ),
            SizedBox(height: 15,),
            Text("Humidity Content",style: TextStyle(fontWeight: FontWeight.bold),),
            SizedBox(height: 8,),
            Container(
              padding: EdgeInsets.symmetric(vertical: 5,horizontal: 20),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey[200]
              ),
              child: TextField(
                keyboardType: TextInputType.number,
                controller: humidity,
                focusNode: null,
                style: TextStyle(color: Colors.black),
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Humidity %'
                ),
              ),
            ),
            SizedBox(height: 15,),
            Text("Select a crop (optional)",style: TextStyle(fontWeight: FontWeight.bold),),
            SizedBox(height: 8,),
            Container(
              padding: EdgeInsets.symmetric(vertical: 5,horizontal: 20),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey[200]
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton(items: <String>['Select a crop for checking (optional)','Apple', 'Banana', 'Blackgram', 'Chickpea', 'Coconut', 'Coffee', 'Cotton', 'Grapes', 'Jute', 'Kidneybeans', 'Lentil', 'Maize', 'Mango', 'Mothbeans', 'Mungbean', 'Muskmelon', 'Orange', 'Papaya', 'Pigeonpeas', 'Pomegranate', 'Rice', 'Watermelon']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value,style: TextStyle(color:value=="Select a crop for checking (optional)"?Colors.grey[700]:Colors.black),),
                  );
                }).toList(),
                  isExpanded: true,
                  underline: null,
                  value: cropName,
                  onChanged: (String? newValue) {
                    setState(() {
                      cropName = newValue!;
                    });
                  },
                ),
              ),
            ),
            SizedBox(height: 15,),
            TextButton(onPressed: ()async{
              FocusScope.of(context).unfocus();
              if(N.text.length!=0 && P.text.length!=0 && K.text.length!=0 && temperature.text.length!=0 && rainfall.text.length!=0 && ph.text.length!=0 && humidity.text.length!=0) {
                if(!(double.parse(N.text)>=0 &&  double.parse(N.text)<=150)){
                  alertDialog("Alert", "Please check your nitrogen content value. As for the study it ranges between 0-150 Kg/ha");
                  return;
                }
                if(!(double.parse(P.text)>=0 &&  double.parse(P.text)<=150)){
                  alertDialog("Alert", "Please check your phosphorus content value. As for the study it ranges between 0-150 Kg/ha");
                  return;
                }
                if(!(double.parse(rainfall.text)>=200)){
                  alertDialog("Alert", "Please check your rainfall value. As per the study, in India lowest average annual rainfall in 200mm");
                  return;
                }
                if(!(double.parse(humidity.text)>=0 && double.parse(humidity.text)<=100)){
                  alertDialog("Alert", "Please check your humidity value.");
                  return;
                }
                if(!(double.parse(ph.text)>=0 &&  double.parse(ph.text)<=14)){
                  alertDialog("Alert", "Please fill the Ph value correctly. pH value ranges from 0 - 14.");
                  return;
                }
                showLoading(context);
                // var result=await recommendationService.recommend(N: N.text, K: K.text, P: P.text, temperature: temperature.text, rainfall: rainfall.text, ph: ph.text, humidity: humidity.text);
                DecisionTreeClassifier DT=DecisionTreeClassifier();
                var result=await DT.predict(features: [N.text,K.text,P.text,temperature.text,humidity.text,ph.text,rainfall.text]);
                Navigator.pop(context);
                if(result=="error"){
                  alertDialog("Alert", 'Something went wrong. Please try again later.');
                }
                else if(result=="netError"){
                  alertDialog("Alert", "Please check your network connection and try again.");
                }
                else{
                  Navigator.pushNamed(context, "/recommendationResult",arguments:{"result":result,"temp":temperature.text,"N":N.text,"P":P.text,"K":K.text,"humidity":humidity.text,"rainfall":rainfall.text,"ph":ph.text,"crop":cropName=="Select a crop for checking (optional)"?null:cropName});
                  N.clear();K.clear();P.clear();temperature.clear();
                  ph.clear();humidity.clear();rainfall.clear();
                  // if(cropName=="Select a crop for checking (optional)"){
                  //   alertDialog("Result", "Recommended Crop for your soil composition is: ${capitalize(result)}");
                  // }
                  // else if(capitalize(result)==cropName){
                  //   alertDialog("Result", "Selected crop will be suitable for the given soil composition.");
                  // }
                  // else{
                  //   alertDialog("Result", "Selected crop is not suitable for the given soil composition. Recommended Crop for your soil composition is: ${capitalize(result)}");
                  // }
                  cropName="Select a crop for checking (optional)";
                  setState(() {});
                }
              }
              else{
                alertDialog("Alert","Please complete the form!!");
              }
            }, child: Text("Analyse",style: TextStyle(fontSize: 17),),style: TextButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),backgroundColor: Colors.green,primary: Colors.white,padding: EdgeInsets.all(18)),),
          ],
        ),
      ),
    );
  }
}
