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

  Future<dynamic> showCommunity()async{
    try {
      print("showCommunity");
      Response response = await post(
          Uri.parse("http://192.168.18.46:3000/showCommunity"));
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
}