import 'package:agri_app/services/loginService.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginMal extends StatefulWidget {
  const LoginMal({Key? key}) : super(key: key);

  @override
  _LoginMalState createState() => _LoginMalState();
}

class _LoginMalState extends State<LoginMal> {

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
          actions: [
            IconButton(onPressed: (){
              Navigator.pushNamed(context, "/setURLPageMal");
            }, icon: Icon(Icons.list_alt))
          ],
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
              Align(child: Text("ലോഗിൻ",style: TextStyle(color: Colors.green,fontSize: 30,fontWeight: FontWeight.bold),),alignment: Alignment.centerLeft,),
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
                  obscureText: true,
                  controller: password,
                  focusNode: null,
                  style: TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'പാസ്സ്‌വേർഡ്'
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
                              Align(child: Text("പാസ്സ്‌വേർഡ് മറന്നു",style: TextStyle(color: Colors.green,fontSize: 30,fontWeight: FontWeight.bold),),alignment: Alignment.centerLeft,),
                              SizedBox(height: 40,),
                              Text("ഫോൺ"),
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
                                      hintText: 'ഫോൺ നമ്പർ'
                                  ),
                                ),
                              ),
                              SizedBox(height: 15,),
                              TextButton(onPressed: ()async{
                                FocusScope.of(context).unfocus();
                                showLoading(context);
                                if(phoneController.text.length!=0){
                                  await Navigator.pushNamed(context, "/changePasswordMal",arguments: {"phone":phoneController.text});
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                  phoneController.clear();
                                  password.clear();
                                  phone.clear();
                                }
                                else{
                                  Navigator.pop(context);
                                  alertDialog("ദയവായി ഫോൺ നമ്പർ പൂരിപ്പിക്കുക");
                                }
                              }, child: Text("ഗോ അഹെഡ്",style: TextStyle(fontSize: 17),),style: TextButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),backgroundColor: Colors.green,primary: Colors.white,padding: EdgeInsets.all(18)),),
                              SizedBox(height: 15,),
                              TextButton(onPressed: (){Navigator.pop(context);}, child: Text("ക്യാൻസൽ",style: TextStyle(fontSize: 17)),style: TextButton.styleFrom(padding: EdgeInsets.all(18)),)
                            ],
                          ),
                        );
                      });
                    },
                    child: Text("പാസ്വേഡ് മറന്നോ?",style: TextStyle(color: Colors.green,fontWeight: FontWeight.bold),),
                  ),
                ),
              ):SizedBox(),
              TextButton(onPressed: ()async{
                showLoading(context);
                if(phone.text.length!=0 && password.text.length!=0){
                  var result=await loginService.login(phone: phone.text, password: password.text);
                  if(result=="done"){
                    await sharedPreferences.setString("phone", phone.text);
                    OneSignal.shared.setExternalUserId(phone.text).then((results) {
                      print(results.toString());
                    }).catchError((error) {
                      print(error.toString());
                    });
                    Navigator.pop(context);
                    Navigator.pop(context);
                    Navigator.pushReplacementNamed(context, "/initMal");
                  }
                  else if(result=="netError"){
                    Navigator.pop(context);
                    alertDialog("എന്തോ കുഴപ്പം സംഭവിച്ചു. നിങ്ങളുടെ നെറ്റ്‌വർക്ക് കണക്ഷൻ പരിശോധിച്ച് വീണ്ടും ശ്രമിക്കുക!!");
                  }
                  else{
                    Navigator.pop(context);
                    alertDialog("തെറ്റായ ഫോൺ നമ്പറോ പാസ്‌വേഡോ");
                    setState(() {
                      error=true;
                    });
                  }
                }
                else{
                  Navigator.pop(context);
                  alertDialog("ദയവായി ഫോം പൂരിപ്പിക്കുക");
                }
              }, child: Text("ലോഗിൻ",style: TextStyle(fontSize: 17),),style: TextButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),backgroundColor: Colors.green,primary: Colors.white,padding: EdgeInsets.all(18)),),
              SizedBox(height: 20,),
              Align(
                child: GestureDetector(
                  child: Text("സൈൻ അപ്പ്",style: TextStyle(fontSize: 16,color: Colors.green,decoration: TextDecoration.underline),),
                  onTap: (){
                    Navigator.pushReplacementNamed(context, "/signupMal");
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
