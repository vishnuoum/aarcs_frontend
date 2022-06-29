import 'dart:convert';

import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AskService{

  late SharedPreferences sharedPreferences;

  AskService(){
    SharedPreferences.getInstance().then((value) {
      sharedPreferences = value;
    });
  }
  
  Future<dynamic> ask({required String query,required String description, required String path,required String? phone})async{
    try{
      var request = new MultipartRequest("POST", Uri.parse("${sharedPreferences.getString("url")}/askCommunity"));
      request.fields['query'] = query;
      request.fields['description']=description;
      request.fields["phone"]=phone!;
      request.files.add(await MultipartFile.fromPath(
        'askPic',
        path,
      ));
      var response=await request.send();
      if(await response.stream.bytesToString()=="done"){
        return "done";
      }
      else{
        return "error";
      }

    }
    catch(e){
      print(e);
      return "error";
    }
  }

  Future<dynamic> showCommunity({required String? phone})async{
    try {
      print("showCommunity");
      Response response = await post(
          Uri.parse("${sharedPreferences.getString("url")}/showCommunity"),body: {"phone":phone});
      if (response.body != "error") {
        print(jsonDecode(response.body));
        return jsonDecode(response.body);
      }
      else {
        return "error";
      }
    }
    catch(e){
      print(e);
      return "error";
    }
  }

  Future<dynamic> answers({required String? phone,required String id})async{
    try {
      print("answersCommunity");
      Response response = await post(
          Uri.parse("${sharedPreferences.getString("url")}/answers"),body: {"phone":phone,"id":id});
      if (response.body != "error") {
        print(jsonDecode(response.body));
        return jsonDecode(response.body);
      }
      else {
        return "error";
      }
    }
    catch(e){
      print(e);
      return "error";
    }
  }

  Future<dynamic> postAnswer({required String? phone,required String id,required String answer})async{
    try {
      print("answersCommunity");
      Response response = await post(
          Uri.parse("${sharedPreferences.getString("url")}/postAnswer"),body: {"phone":phone,"id":id,"answer":answer});
      if (response.body == "done") {
        print("done");
        return "done";
      }
      else {
        return "error";
      }
    }
    catch(e){
      print(e);
      return "error";
    }
  }

  Future<dynamic> myQueries({required String? phone})async{
    try {
      print("myQueries");
      Response response = await post(
          Uri.parse("${sharedPreferences.getString("url")}/myQuery"),body: {"phone":phone});
      if (response.body != "error") {
        print(response.body);
        print(jsonDecode(response.body));
        return jsonDecode(response.body);
      }
      else {
        return "error";
      }
    }
    catch(e){
      print(e);
      return "error";
    }
  }

  Future<dynamic> markAnswer({required String id,required String doubtId})async{
    try {
      print("answersCommunity");
      Response response = await post(
          Uri.parse("${sharedPreferences.getString("url")}/markAnswer"),body: {"id":id,"doubtId":doubtId});
      if (response.body == "done") {
        print("done");
        return "done";
      }
      else {
        return "error";
      }
    }
    catch(e){
      print(e);
      return "error";
    }
  }
}