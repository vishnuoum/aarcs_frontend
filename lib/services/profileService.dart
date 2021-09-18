
import 'dart:convert';

import 'package:http/http.dart';

class ProfileService{
  Future<dynamic> getProfile({required String? phone})async{
    try {
      var response = await post(
          Uri.parse("http://10.0.2.2:3000/getProfile"), body: {"phone": phone});
      print(response.body);
      return jsonDecode(response.body);
    }
    catch(e){
      print("get profile error:$e");
      return "error";
    }
  }
}