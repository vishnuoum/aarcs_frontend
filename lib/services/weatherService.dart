
import 'dart:convert';

import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WeatherService{


  
  Future<dynamic> getWeather({String? phone})async{
    try {
      Response response = await post(
          Uri.parse("http://192.168.18.2:3000/getWeather"), body: {"phone": phone});
      return jsonDecode(response.body);
    }
    catch(error){
      return "error";
    }
  }
}