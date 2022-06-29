
import 'dart:convert';

import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WeatherService{

  late SharedPreferences sharedPreferences;

  WeatherService(){
    SharedPreferences.getInstance().then((value) {
      sharedPreferences = value;
    });
  }
  
  Future<dynamic> getWeather({String? phone})async{
    try {
      Response response = await post(
          Uri.parse("${sharedPreferences.getString("url")}/getWeather"), body: {"phone": phone});
      return jsonDecode(response.body);
    }
    catch(error){
      return "error";
    }
  }
}