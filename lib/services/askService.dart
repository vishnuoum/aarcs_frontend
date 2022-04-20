import 'dart:convert';

import 'package:http/http.dart';

class AskService{
  
  Future<dynamic> ask({required String query,required String description, required String path,required String? phone})async{
    try{
      var request = new MultipartRequest("POST", Uri.parse("http://192.168.18.46:3000/askCommunity"));
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
          Uri.parse("http://192.168.18.46:3000/showCommunity"),body: {"phone":phone});
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
          Uri.parse("http://192.168.18.46:3000/answers"),body: {"phone":phone,"id":id});
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
          Uri.parse("http://192.168.18.46:3000/postAnswer"),body: {"phone":phone,"id":id,"answer":answer});
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
          Uri.parse("http://192.168.18.46:3000/myQuery"),body: {"phone":phone});
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
          Uri.parse("http://192.168.18.46:3000/markAnswer"),body: {"id":id,"doubtId":doubtId});
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