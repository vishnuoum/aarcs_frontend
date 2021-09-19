
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
  
  Future<dynamic> getUserItems({required String? phone,String query=""})async{
    try{
      Response response=await post(Uri.parse("http://10.0.2.2:3000/getUserItems"),body: {"phone":phone,"query":query});
      print(response.body);
      return jsonDecode(response.body);
    }
    catch(e){
      return "error";
    }
  }

  Future<dynamic> editUserItems({required String id,required String name,required String price,required String place,required String district})async{
    try{
      Response response=await post(Uri.parse("http://10.0.2.2:3000/editUserItem"),body: {"id":id,"name":name,"price":price,"place":place,"district":district});
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
      Response response=await post(Uri.parse("http://10.0.2.2:3000/getUserTools"),body: {"phone":phone,"query":query});
      print(response.body);
      return jsonDecode(response.body);
    }
    catch(e){
      return "error";
    }
  }

  Future<dynamic> editUserTool({required String id,required String name,required String price,required String place,required String district})async{
    try{
      Response response=await post(Uri.parse("http://10.0.2.2:3000/editUserTool"),body: {"id":id,"name":name,"price":price,"place":place,"district":district});
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