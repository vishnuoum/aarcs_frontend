import 'package:agri_app/services/loginService.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  LoginService loginService=LoginService();

  TextEditingController phone=TextEditingController();
  TextEditingController password=TextEditingController();
  late SharedPreferences sharedPreferences;
  bool error=false;
  TextEditingController phoneController=TextEditingController();

  @override
  void initState() {
    super.initState();
    loadSharedPreferences();
  }

  void loadSharedPreferences()async{
    sharedPreferences=await SharedPreferences.getInstance();
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
              Align(child: Text("Login",style: TextStyle(color: Colors.green,fontSize: 30,fontWeight: FontWeight.bold),),alignment: Alignment.centerLeft,),
              SizedBox(height: 40,),
              Container(
                padding: EdgeInsets.symmetric(vertical: 5,horizontal: 20),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey[200]
                ),
                child: TextField(
                  controller: phone,
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
                  obscureText: true,
                  controller: password,
                  focusNode: null,
                  style: TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Password'
                  ),
                ),
              ),
              SizedBox(height: 15,),
              error?Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: GestureDetector(
                    onTap: (){
                      showModalBottomSheet(enableDrag: true,isScrollControlled: true,shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topRight: Radius.circular(10),topLeft: Radius.circular(10))),context: context, builder: (BuildContext context){
                        return Container(
                          child: ListView(
                            padding: EdgeInsets.symmetric(vertical: 20,horizontal: 20),
                            children:[
                              SizedBox(height: 60,),
                              Align(child: Text("Forgot Password",style: TextStyle(color: Colors.green,fontSize: 30,fontWeight: FontWeight.bold),),alignment: Alignment.centerLeft,),
                              SizedBox(height: 40,),
                              Text("Phone"),
                              Container(
                                margin: EdgeInsets.only(top: 10),
                                padding: EdgeInsets.symmetric(vertical: 5,horizontal: 20),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.grey[200]
                                ),
                                child: TextField(
                                  keyboardType: TextInputType.phone,
                                  controller: phoneController,
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
                              TextButton(onPressed: ()async{
                                FocusScope.of(context).unfocus();
                                showLoading(context);
                                if(phoneController.text.length!=0){
                                  await Navigator.pushNamed(context, "/changePassword",arguments: {"phone":phoneController.text});
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                  phoneController.clear();
                                  password.clear();
                                  phone.clear();
                                }
                                else{
                                  Navigator.pop(context);
                                  alertDialog("Please fill the Phone No.");
                                }
                              }, child: Text("Go Ahead",style: TextStyle(fontSize: 17),),style: TextButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),backgroundColor: Colors.green,primary: Colors.white,padding: EdgeInsets.all(18)),),
                              SizedBox(height: 15,),
                              TextButton(onPressed: (){Navigator.pop(context);}, child: Text("Cancel",style: TextStyle(fontSize: 17)),style: TextButton.styleFrom(padding: EdgeInsets.all(18)),)
                            ],
                          ),
                        );
                      });
                    },
                    child: Text("Forgot password?",style: TextStyle(color: Colors.green,fontWeight: FontWeight.bold),),
                  ),
                ),
              ):SizedBox(),
              TextButton(onPressed: ()async{
                showLoading(context);
                if(phone.text.length!=0 && password.text.length!=0){
                  var result=await loginService.login(phone: phone.text, password: password.text);
                  if(result=="done"){
                    await sharedPreferences.setString("phone", phone.text);
                    Navigator.pop(context);
                    Navigator.pop(context);
                  }
                  else if(result=="netError"){
                    Navigator.pop(context);
                    alertDialog("Something went wrong. Please check your network connection and try again!!");
                  }
                  else{
                    Navigator.pop(context);
                    alertDialog("Wrong Phone No. or Password");
                    setState(() {
                      error=true;
                    });
                  }
                }
                else{
                  Navigator.pop(context);
                  alertDialog("Please complete the form");
                }
              }, child: Text("Login",style: TextStyle(fontSize: 17),),style: TextButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),backgroundColor: Colors.green,primary: Colors.white,padding: EdgeInsets.all(18)),),
              SizedBox(height: 20,),
              Align(
                child: GestureDetector(
                  child: Text("Signup",style: TextStyle(fontSize: 16,color: Colors.green,decoration: TextDecoration.underline),),
                  onTap: (){
                    Navigator.pushReplacementNamed(context, "/signup");
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
