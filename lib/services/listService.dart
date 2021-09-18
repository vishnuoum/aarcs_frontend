
import 'dart:convert';

import 'package:http/http.dart';

class ListService{
  Future<dynamic> getItems({String query=""})async{
    try {
      Response response = await get(Uri.parse("http://10.0.2.2:3000/getItems?query=$query"),);
      print(response.body);
      return jsonDecode(response.body);
    }catch(e){
      return "error";
    }
  }

  Future<dynamic> getTools({String query=""})async{
    try {
      Response response = await get(Uri.parse("http://10.0.2.2:3000/getTools?query=$query"));
      print(response.body);
      return jsonDecode(response.body);
    }catch(e){
      return "error";
    }
  }
}