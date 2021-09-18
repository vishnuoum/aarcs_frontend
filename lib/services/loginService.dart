
import 'package:http/http.dart';

class LoginService{


  Future<dynamic> login({required String phone,required String password})async{
    print(phone);
    print(password);
    try {
      Response response = await post(Uri.parse("http://10.0.2.2:3000/login"),
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



  Future<dynamic> signup({required String name,required String phone,required String district,required String password,required String otp})async{
    print(phone);
    print(password);
    try {
      Response response = await post(Uri.parse("http://10.0.2.2:3000/signup"),
          body: {"name":name,"phone": phone, "district":district,"password": password,"otp":otp});
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


  Future<dynamic> update({required String name,required String phone,required String district,required String id})async{

    try {
      Response response = await post(Uri.parse("http://10.0.2.2:3000/editProfile"),
          body: {"name":name,"phone": phone, "district":district,"id":id});
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
      Response response = await post(Uri.parse("http://10.0.2.2:3000/editPassword"),
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
      await post(Uri.parse("http://10.0.2.2:3000/getOTP"),body: {"phone":phone});
    }
    catch(e){
      print("OTP exception:$e");
    }
  }
}