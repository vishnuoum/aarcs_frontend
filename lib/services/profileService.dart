
import 'dart:convert';

import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileService{

  late SharedPreferences sharedPreferences;

  ProfileService(){
    SharedPreferences.getInstance().then((value) {
      sharedPreferences = value;
    });
  }

  Future<dynamic> getProfile({required String? phone})async{
    try {
      var response = await post(
          Uri.parse("${sharedPreferences.getString("url")}/getProfile"), body: {"phone": phone});
      print(response.body);
      return jsonDecode(response.body);
    }
    catch(e){
      print("get profile error:$e");
      return "error";
    }
  }
}