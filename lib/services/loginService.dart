
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginService{

  late SharedPreferences sharedPreferences;

  LoginService(){
    SharedPreferences.getInstance().then((value) {
      sharedPreferences = value;
    });
  }


  Future<dynamic> login({required String phone,required String password})async{
    print(phone);
    print(password);
    try {
      Response response = await post(Uri.parse("${sharedPreferences.getString("url")}/login"),
          body: {"phone": phone, "password": password});
      if (response.body == "done") {
        return "done";
      }
      else {
        return "error";
      }
    }
    catch(e){
      print("Login exception: $e");
      return "netError";
    }
  }



  Future<dynamic> signup({required String name,required String phone,required String district,required String password,required String otp,required String place})async{
    print(phone);
    print(password);
    try {
      Response response = await post(Uri.parse("${sharedPreferences.getString("url")}/signup"),
          body: {"name":name,"phone": phone, "district":district,"password": password,"otp":otp,"place":place});
      if (response.body == "done") {
        return "done";
      }
      else if(response.body=="otp error"){
        return "otp error";
      }
      else{
        return "error";
      }
    }
    catch(e){
      print("Signup exception: $e");
      return "netError";
    }
  }


  Future<dynamic> update({required String name,required String phone,required String district,required String id,required String place})async{

    try {
      Response response = await post(Uri.parse("${sharedPreferences.getString("url")}/editProfile"),
          body: {"name":name,"phone": phone, "district":district,"id":id,"place":place});
      if (response.body == "done") {
        return "done";
      }
      else if(response.body=="otp error"){
        return "otp error";
      }
      else{
        return "error";
      }
    }
    catch(e){
      print("Update exception: $e");
      return "netError";
    }
  }
  
  
  
  Future<dynamic> updatePassword({required String password,required String otp,required String? phone})async{
    try{
      Response response = await post(Uri.parse("${sharedPreferences.getString("url")}/editPassword"),
          body: {"password":password,"phone": phone, "otp":otp});
      if(response.body=="done"){
        return "done";
      }
      else if(response.body=="otp error"){
        return "otp error";
      }
      else{
        return "error";
      }
    }
    catch(e){
      print("Update password exception: $e");
      return "error";
    }
  }

  
  void otp({required String? phone})async{
    try{
      await post(Uri.parse("${sharedPreferences.getString("url")}/getOTP"),body: {"phone":phone});
    }
    catch(e){
      print("OTP exception:$e");
    }
  }

  Future<dynamic> authenticate({required String phone})async{

    try {
      Response response = await post(Uri.parse("${sharedPreferences.getString("url")}/authenticate"),
          body: {"phone": phone});
      if (response.body == "done") {
        return "done";
      }
      else{
        return "error";
      }
    }
    catch(e){
      print("authenticate exception: $e");
      return "error";
    }
  }
}