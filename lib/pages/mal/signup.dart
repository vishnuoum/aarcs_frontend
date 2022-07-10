import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SignupMal extends StatefulWidget {
  const SignupMal({Key? key}) : super(key: key);

  @override
  _SignupMalState createState() => _SignupMalState();
}

class _SignupMalState extends State<SignupMal> {

  var district="ജില്ല തിരഞ്ഞെടുക്കുക";
  TextEditingController name=TextEditingController();
  TextEditingController phone=TextEditingController();
  TextEditingController password1=TextEditingController();
  TextEditingController password2=TextEditingController();
  TextEditingController place=TextEditingController();









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
    return GestureDetector(
      onTap: (){
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          systemOverlayStyle: SystemUiOverlayStyle(statusBarColor: Colors.green),
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(
              color: Colors.green
          ),
        ),
        body: Form(
          child: ListView(
            padding: EdgeInsets.symmetric(vertical: 20,horizontal: 30),
            children: [
              Align(child: Text("സൈൻ അപ്പ്",style: TextStyle(color: Colors.green,fontSize: 30,fontWeight: FontWeight.bold),),alignment: Alignment.centerLeft,),
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
                      hintText: 'പേര്'
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
                  keyboardType: TextInputType.phone,
                  controller: phone,
                  // textCapitalization: TextCapitalization.sentences,
                  focusNode: null,
                  style: TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'ഫോൺ നമ്പർ'
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
                  textCapitalization: TextCapitalization.words,
                  controller: place,
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
              Container(
                padding: EdgeInsets.symmetric(vertical: 5,horizontal: 20),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey[200]
                ),
                child: TextField(
                  obscureText: true,
                  controller: password1,
                  focusNode: null,
                  style: TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'പാസ്സ്‌വേർഡ്'
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
                  obscureText: true,
                  controller: password2,
                  focusNode: null,
                  style: TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'വീണ്ടും പാസ്സ്‌വേർഡ്'
                  ),
                ),
              ),
              SizedBox(height: 15,),
              TextButton(onPressed: ()async{
                if(name.text.length!=0 && phone.text.length!=0 && place.text.length!=0 && district!="Select a district" && password1.text.length!=0 && password2.text.length!=0) {
                  if (password1.text == password2.text) {
                    Navigator.pushNamed(context, "/otpMal",arguments: {"name":name.text,"phone":phone.text,"district":district,"password":password1.text,"place":place.text});
                  }
                  else{
                    alertDialog("പാസ്‌വേഡുകൾ പൊരുത്തപ്പെടുന്നില്ല!!");
                  }
                }
                else{
                  alertDialog("ദയവായി ഫോം പൂരിപ്പിക്കുക!!");
                }
              }, child: Text("സൈൻ അപ്പ് ",style: TextStyle(fontSize: 17),),style: TextButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),backgroundColor: Colors.green,primary: Colors.white,padding: EdgeInsets.all(18)),),
              SizedBox(height: 20,),
              Align(
                child: GestureDetector(
                  child: Text("ലോഗിൻ",style: TextStyle(fontSize: 16,color: Colors.green,decoration: TextDecoration.underline),),
                  onTap: (){
                    Navigator.pushReplacementNamed(context, "/LoginMal");
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
