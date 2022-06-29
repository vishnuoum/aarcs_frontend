
import 'dart:convert';

import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatService{

  late SharedPreferences sharedPreferences;

  ChatService(){
    SharedPreferences.getInstance().then((value) {
      sharedPreferences = value;
    });
  }

  Future<dynamic> getMessages({required String? phone})async{
    try {
      Response response = await post(
          Uri.parse("${sharedPreferences.getString("url")}/getMessages",),
          body: {"phone": phone});
      print(response.body);
      return jsonDecode(response.body);
    }
    catch(e){
      return "error";
    }
  }
}