import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Signup extends StatefulWidget {
  const Signup({Key? key}) : super(key: key);

  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {

  var district="Select a District";
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
              Align(child: Text("Signup",style: TextStyle(color: Colors.green,fontSize: 30,fontWeight: FontWeight.bold),),alignment: Alignment.centerLeft,),
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
                      hintText: 'Name'
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
                      hintText: 'Phone No.'
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
                  child: DropdownButton(items: <String>['Select a District','Kasargod', 'Kannur', 'Wayanad', 'Palakkad','Malappuram','Kozhikode','Thrissur','Ernakulam','Idukki','Alappuzha','Kottayam','Pathanamthitta','Kollam','Thiruvananthapuram']
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
                      hintText: 'Password'
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
                      hintText: 'Re-enter Password'
                  ),
                ),
              ),
              SizedBox(height: 15,),
              TextButton(onPressed: ()async{
                if(name.text.length!=0 && phone.text.length!=0 && place.text.length!=0 && district!="Select a district" && password1.text.length!=0 && password2.text.length!=0) {
                  if (password1.text == password2.text) {
                    Navigator.pushNamed(context, "/otp",arguments: {"name":name.text,"phone":phone.text,"district":district,"password":password1.text,"place":place.text});
                  }
                  else{
                    alertDialog("Passwords does not match!!");
                  }
                }
                else{
                  alertDialog("Please complete the form!!");
                }
              }, child: Text("Signup",style: TextStyle(fontSize: 17),),style: TextButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),backgroundColor: Colors.green,primary: Colors.white,padding: EdgeInsets.all(18)),),
              SizedBox(height: 20,),
              Align(
                child: GestureDetector(
                  child: Text("Login",style: TextStyle(fontSize: 16,color: Colors.green,decoration: TextDecoration.underline),),
                  onTap: (){
                    Navigator.pushReplacementNamed(context, "/Login");
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
