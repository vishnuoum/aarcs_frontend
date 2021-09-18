import 'package:agri_app/services/loginService.dart';
import 'package:flutter/material.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/otp_field_style.dart';
import 'package:otp_text_field/style.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OTP extends StatefulWidget {
  final Map arguments;
  OTP({Key? key,required this.arguments}) : super(key: key);

  @override
  _OTPState createState() => _OTPState();
}

class _OTPState extends State<OTP> {

  LoginService loginService=LoginService();
  String otp="";
  late SharedPreferences sharedPreferences;

  @override
  void initState() {
    loginService.otp(phone:widget.arguments["phone"]);
    print(widget.arguments);
    loadSharedPreferences();
    super.initState();
  }

  void loadSharedPreferences()async{
    sharedPreferences=await SharedPreferences.getInstance();
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
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(
          color: Colors.green
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 10,horizontal: 30),
        child: Container(
          width: MediaQuery.of(context).size.width-60,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 15,),
              Text("Verify Phone No.",style: TextStyle(color: Colors.green,fontSize: 25,fontWeight: FontWeight.bold),),
              SizedBox(height: 70,),
              Center(
                child: OTPTextField(
                  fieldStyle: FieldStyle.underline,
                  otpFieldStyle: OtpFieldStyle(focusBorderColor: Colors.green),
                  length: 6,
                  width: 300,
                  onChanged: (pin){},
                  onCompleted: (pin){
                    otp=pin;
                  },
                ),
              ),
              SizedBox(height: 30,),
              Row(
                children: [
                  Expanded(flex: 2,child: TextButton(onPressed: null, child: Text("Resend"),style: TextButton.styleFrom(backgroundColor: Colors.green,primary: Colors.white,padding: EdgeInsets.all(18),shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50))),)),
                  SizedBox(width: 10,),
                  Expanded(flex: 2,child: TextButton(onPressed: otp.length==6?()async{
                    showLoading(context);
                    var result=await loginService.signup(name: widget.arguments["name"], phone: widget.arguments["phone"], district: widget.arguments["district"], password: widget.arguments["password"], otp: otp);
                    if(result=="done"){
                      await sharedPreferences.setString("phone", widget.arguments["phone"]);
                      Navigator.pop(context);
                      Navigator.pop(context);
                      Navigator.pop(context);
                      Navigator.pushReplacementNamed(context,"/");
                    }
                    else if(result=="otp error"){
                      Navigator.pop(context);
                      alertDialog("Error in OTP");
                    }
                    else if(result=="netError"){
                      Navigator.pop(context);
                      alertDialog("Something went wrong. Please check your network connection and try again!!");
                    }
                  }:null, child: Text("Verify"),style: TextButton.styleFrom(backgroundColor: Colors.green,primary: Colors.white,padding: EdgeInsets.all(18),shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50))),)),                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
