
import 'dart:convert';

import 'package:http/http.dart';

class ChatService{
  Future<dynamic> getMessages({required String? phone})async{
    try {
      Response response = await post(
          Uri.parse("http://192.168.18.46:3000/getMessages",),
          body: {"phone": phone});
      print(response.body);
      return jsonDecode(response.body);
    }
    catch(e){
      return "error";
    }
  }
}