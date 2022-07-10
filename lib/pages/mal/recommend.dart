import 'package:agri_app/services/decisionTree.dart';
import 'package:agri_app/services/recommendationService.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RecommendMal extends StatefulWidget {
  const RecommendMal({Key? key}) : super(key: key);

  @override
  _RecommendMalState createState() => _RecommendMalState();
}

class _RecommendMalState extends State<RecommendMal> {

  Map logs={"logs":[]};
  DateFormat format = DateFormat("dd/MM/yyyy hh:mm:ss a");

  TextEditingController N=TextEditingController();
  TextEditingController K=TextEditingController();
  TextEditingController P=TextEditingController();
  TextEditingController temperature=TextEditingController();
  TextEditingController humidity=TextEditingController();
  TextEditingController rainfall=TextEditingController();
  TextEditingController ph=TextEditingController();
  RecommendationService recommendationService=RecommendationService();
  String cropName= "പരിശോധിക്കുന്നതിനായി ഒരു ക്രോപ്പ് തിരഞ്ഞെടുക്കുക (ഓപ്ഷണൽ)";

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
    if(logs["logs"].length==0 && ModalRoute.of(context)!.settings.arguments !=null)
      logs = ModalRoute.of(context)!.settings.arguments as Map;
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
            Align(child: Text("ശുപാർശ സംവിധാനം",style: TextStyle(color: Colors.green,fontSize: 30,fontWeight: FontWeight.bold),),alignment: Alignment.centerLeft,),
            SizedBox(height: 40,),
            Text("നൈട്രജൻ",style: TextStyle(fontWeight: FontWeight.bold),),
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
            Text("പൊട്ടാസ്യം",style: TextStyle(fontWeight: FontWeight.bold),),
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
            Text("ഫോസ്ഫറസ്",style: TextStyle(fontWeight: FontWeight.bold),),
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
            Text("താപനില",style: TextStyle(fontWeight: FontWeight.bold),),
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
            Text("മഴ",style: TextStyle(fontWeight: FontWeight.bold),),
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
            Text("ഈർപ്പം",style: TextStyle(fontWeight: FontWeight.bold),),
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
            Text("ഒരു ക്രോപ്പ് തിരഞ്ഞെടുക്കുക (ഓപ്ഷണൽ)",style: TextStyle(fontWeight: FontWeight.bold),),
            SizedBox(height: 8,),
            Container(
              padding: EdgeInsets.symmetric(vertical: 5,horizontal: 20),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey[200]
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton(items: <String>['പരിശോധിക്കുന്നതിനായി ഒരു ക്രോപ്പ് തിരഞ്ഞെടുക്കുക (ഓപ്ഷണൽ)','ആപ്പിൾ', 'വാഴപ്പഴം', 'ബ്ലാക്ക്ഗ്രാം', 'ചിക്കപ്പ', 'തേങ്ങ', 'കാപ്പി', 'പരുത്തി', 'മുന്തിരി', 'ചണം', 'കിഡ്നിബീൻസ്', 'പയർ', 'ചോളം', 'മാമ്പഴം' , 'മോത്ത്ബീൻസ്', 'മുങ്ങ്ബീൻ', 'മസ്‌ക്‌മെലൺ', 'ഓറഞ്ച്', 'പപ്പായ', 'പ്രാവ്', 'മാതളനാരകം', 'അരി', 'തണ്ണിമത്തൻ']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value,style: TextStyle(color:value=="പരിശോധിക്കുന്നതിനായി ഒരു ക്രോപ്പ് തിരഞ്ഞെടുക്കുക (ഓപ്ഷണൽ)"?Colors.grey[700]:Colors.black),),
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
              logs["logs"].add("${format.format(DateTime.now())} Recommendation Service started!!!");
              if(N.text.length!=0 && P.text.length!=0 && K.text.length!=0 && temperature.text.length!=0 && rainfall.text.length!=0 && ph.text.length!=0 && humidity.text.length!=0) {
                logs["logs"].add("${format.format(DateTime.now())} Preprocessing.....");
                if(!(double.parse(N.text)>=0 &&  double.parse(N.text)<=150)){
                  alertDialog("അലെർട്", "നിങ്ങളുടെ നൈട്രജൻ മൂല്യം പരിശോധിക്കുക. പഠനത്തെ സംബന്ധിച്ചിടത്തോളം ഇത് 0-150 കി.ഗ്രാം/ഹെക്ടറിന് ഇടയിലാണ്");
                  return;
                }
                if(!(double.parse(P.text)>=0 &&  double.parse(P.text)<=150)){
                  alertDialog("അലെർട്", "നിങ്ങളുടെ ഫോസ്ഫറസ് മൂല്യം പരിശോധിക്കുക. പഠനത്തെ സംബന്ധിച്ചിടത്തോളം ഇത് 0-150 കി.ഗ്രാം/ഹെക്ടറിന് ഇടയിലാണ്");
                  return;
                }
                if(!(double.parse(rainfall.text)>=200)){
                  alertDialog("അലെർട്", "നിങ്ങളുടെ മഴയുടെ മൂല്യം പരിശോധിക്കുക. പഠനമനുസരിച്ച്, ഇന്ത്യയിലെ ഏറ്റവും കുറഞ്ഞ ശരാശരി വാർഷിക മഴ 200 മില്ലിമീറ്ററാണ്.");
                  return;
                }
                if(!(double.parse(humidity.text)>=0 && double.parse(humidity.text)<=100)){
                  alertDialog("അലെർട്", "നിങ്ങളുടെ ഈർപ്പം മൂല്യം പരിശോധിക്കുക.");
                  return;
                }
                if(!(double.parse(ph.text)>=0 &&  double.parse(ph.text)<=14)){
                  alertDialog("അലെർട്", "പിഎച്ച് മൂല്യം ശരിയായി പൂരിപ്പിക്കുക. pH മൂല്യം 0 മുതൽ 14 വരെയാണ്.");
                  return;
                }
                logs["logs"].add("${format.format(DateTime.now())} Preprocessing completed!!!");
                showLoading(context);
                // var result=await recommendationService.recommend(N: N.text, K: K.text, P: P.text, temperature: temperature.text, rainfall: rainfall.text, ph: ph.text, humidity: humidity.text);
                logs["logs"].add("${format.format(DateTime.now())} Loading Decision Tree model.....");
                DecisionTreeClassifier DT=DecisionTreeClassifier();
                logs["logs"].add("${format.format(DateTime.now())} Loaded Decision Tree model!!!");
                var result=await DT.predict(features: [N.text,K.text,P.text,temperature.text,humidity.text,ph.text,rainfall.text]);
                Navigator.pop(context);
                if(result=="error"){
                  logs["logs"].add("${format.format(DateTime.now())} Error thrown.....");
                  alertDialog("അലെർട്", 'എന്തോ കുഴപ്പം സംഭവിച്ചു. ദയവായി പിന്നീട് വീണ്ടും ശ്രമിക്കുക.');
                }
                else if(result=="netError"){
                  alertDialog("അലെർട്", "നിങ്ങളുടെ നെറ്റ്‌വർക്ക് കണക്ഷൻ പരിശോധിച്ച് വീണ്ടും ശ്രമിക്കുക.");
                }
                else{
                  logs["logs"].add("${format.format(DateTime.now())} Result=$result");
                  Navigator.pushNamed(context, "/recommendationResultMal",arguments:{"result":result,"temp":temperature.text,"N":N.text,"P":P.text,"K":K.text,"humidity":humidity.text,"rainfall":rainfall.text,"ph":ph.text,"crop":cropName=="പരിശോധിക്കുന്നതിനായി ഒരു ക്രോപ്പ് തിരഞ്ഞെടുക്കുക (ഓപ്ഷണൽ)"?null:cropName});
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
                  cropName="പരിശോധിക്കുന്നതിനായി ഒരു ക്രോപ്പ് തിരഞ്ഞെടുക്കുക (ഓപ്ഷണൽ)";
                  setState(() {});
                }
              }
              else{
                alertDialog("അലെർട്","ദയവായി ഫോം പൂരിപ്പിക്കുക!!");
              }
            }, child: Text("അനലൈസ്",style: TextStyle(fontSize: 17),),style: TextButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),backgroundColor: Colors.green,primary: Colors.white,padding: EdgeInsets.all(18)),),
          ],
        ),
      ),
    );
  }
}
