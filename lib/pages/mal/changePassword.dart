import 'package:agri_app/services/loginService.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChangePasswordMal extends StatefulWidget {
  final Map arguments;
  ChangePasswordMal({Key? key,required this.arguments}) : super(key: key);

  @override
  _ChangePasswordMalState createState() => _ChangePasswordMalState();
}

class _ChangePasswordMalState extends State<ChangePasswordMal> {


  TextEditingController password1=TextEditingController();
  TextEditingController password2=TextEditingController();
  TextEditingController otp=TextEditingController();
  LoginService loginService=LoginService();
  late SharedPreferences sharedPreferences;
  String? phone;

  @override
  void initState() {
    init();
    super.initState();
  }


  void init()async{
    if(widget.arguments["phone"] == "") {
      sharedPreferences = await SharedPreferences.getInstance();
      phone = sharedPreferences.getString("phone");
    }
    else{
      phone=widget.arguments["phone"];
    }
    loginService.otp(phone: phone);
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
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(color: Colors.green),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(vertical: 10,horizontal: 30),
        children: [
          Text("പാസ്വേഡ് മാറ്റുക",style: TextStyle(color: Colors.green,fontSize: 30,fontWeight: FontWeight.bold),),
          SizedBox(height: 60,),
          Container(
            padding: EdgeInsets.symmetric(vertical: 5,horizontal: 20),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey[200]
            ),
            child: TextField(
              controller: otp,
              focusNode: null,
              style: TextStyle(color: Colors.black),
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'OTP'
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
                  hintText: 'പുതിയ പാസ്‌വേഡ്'
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
                  hintText: 'പുതിയ പാസ്‌വേഡ് വീണ്ടും'
              ),
            ),
          ),
          SizedBox(height: 20,),
          TextButton(
              onPressed: ()async{
                if(password1.text==password2.text){
                  showLoading(context);
                  var result=await loginService.updatePassword(password: password1.text, otp: otp.text, phone: phone);
                  Navigator.pop(context);
                  if(result=="done"){
                    Navigator.pop(context);
                  }
                  else if(result=="otp error"){
                    alertDialog("തെറ്റായ OTP");
                  }
                  else if(result=="error"){
                    alertDialog("എന്തോ കുഴപ്പം സംഭവിച്ചു. പിന്നീട് വീണ്ടും ശ്രമിക്കുക");
                  }
                }
                else{
                  alertDialog("പാസ്‌വേഡുകൾ പൊരുത്തപ്പെടുന്നില്ല");
                }
              },
              child: Text("പാസ്വേഡ് മാറ്റുക"),
            style: TextButton.styleFrom(backgroundColor: Colors.green,primary: Colors.white,padding: EdgeInsets.all(20),shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
          )
        ],
      ),
    );
  }
}
