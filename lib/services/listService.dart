
import 'dart:convert';

import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ListService{

  late SharedPreferences sharedPreferences;

  ListService(){
    SharedPreferences.getInstance().then((value) {
      sharedPreferences = value;
    });
  }

  Future<dynamic> getItems({String query=""})async{
    try {
      Response response = await get(Uri.parse("${sharedPreferences.getString("url")}/getItems?query=$query"),);
      print(response.body);
      return jsonDecode(response.body);
    }catch(e){
      return "error";
    }
  }

  Future<dynamic> getTools({String query=""})async{
    try {
      Response response = await get(Uri.parse("${sharedPreferences.getString("url")}/getTools?query=$query"));
      print(response.body);
      return jsonDecode(response.body);
    }catch(e){
      return "error";
    }
  }

  Future<dynamic> getLands({String query=""})async{
    try {
      Response response = await get(Uri.parse("${sharedPreferences.getString("url")}/getLands?query=$query"));
      print(response.body);
      return jsonDecode(response.body);
    }catch(e){
      return "error";
    }
  }
  
  Future<dynamic> getUserItems({required String? phone,String query=""})async{
    try{
      Response response=await post(Uri.parse("${sharedPreferences.getString("url")}/getUserItems"),body: {"phone":phone,"query":query});
      print(response.body);
      return jsonDecode(response.body);
    }
    catch(e){
      return "error";
    }
  }

  Future<dynamic> editUserItems({required String id,required String name,required String price,required String place,required String district})async{
    try{
      Response response=await post(Uri.parse("${sharedPreferences.getString("url")}/editUserItem"),body: {"id":id,"name":name,"price":price,"place":place,"district":district});
      print(response.body);
      if(response.body=="done"){
        return "done";
      }
      else{
        return "error";
      }
    }
    catch(e){
      return "netError";
    }
  }

  Future<dynamic> getUserTools({required String? phone,String query=""})async{
    try{
      Response response=await post(Uri.parse("${sharedPreferences.getString("url")}/getUserTools"),body: {"phone":phone,"query":query});
      print(response.body);
      return jsonDecode(response.body);
    }
    catch(e){
      return "error";
    }
  }

  Future<dynamic> editUserTool({required String id,required String name,required String price,required String place,required String district})async{
    try{
      Response response=await post(Uri.parse("${sharedPreferences.getString("url")}/editUserTool"),body: {"id":id,"name":name,"price":price,"place":place,"district":district});
      print(response.body);
      if(response.body=="done"){
        return "done";
      }
      else{
        return "error";
      }
    }
    catch(e){
      return "netError";
    }
  }


  Future<dynamic> getUserLands({required String? phone,String query=""})async{
    try{
      Response response=await post(Uri.parse("${sharedPreferences.getString("url")}/getUserLands"),body: {"phone":phone,"query":query});
      print(response.body);
      return jsonDecode(response.body);
    }
    catch(e){
      return "error";
    }
  }

  Future<dynamic> editUserLand({required String id,required String name,required String price,required String place,required String district})async{
    try{
      Response response=await post(Uri.parse("${sharedPreferences.getString("url")}/editUserLand"),body: {"id":id,"name":name,"price":price,"place":place,"district":district});
      print(response.body);
      if(response.body=="done"){
        return "done";
      }
      else{
        return "error";
      }
    }
    catch(e){
      return "netError";
    }
  }

}