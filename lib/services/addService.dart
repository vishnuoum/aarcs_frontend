
import 'package:http/http.dart';

class AddService{

  Future<dynamic> addItem({required String name,required String price,required String place,required String district,required String? phone,required String path})async{
    try{
      var request = new MultipartRequest("POST", Uri.parse("http://10.0.2.2:3000/addItem"));
      request.fields['name'] = name;
      request.fields['price']=price;
      request.fields["place"]=place;
      request.fields["district"]=district;
      request.fields["phone"]=phone!;
      request.files.add(await MultipartFile.fromPath(
        'itemPic',
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
      return "netError";
    }
  }


  Future<dynamic> addTool({required String name,required String price,required String place,required String district,required String? phone,required String path})async{
    try{
      var request = new MultipartRequest("POST", Uri.parse("http://10.0.2.2:3000/addTool"));
      request.fields['name'] = name;
      request.fields['price']=price;
      request.fields["place"]=place;
      request.fields["district"]=district;
      request.fields["phone"]=phone!;
      request.files.add(await MultipartFile.fromPath(
        'toolPic',
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
      return "netError";
    }
  }


  Future<dynamic> addLand({required String name,required String price,required String place,required String district,required String? phone,required String path})async{
    try{
      var request = new MultipartRequest("POST", Uri.parse("http://10.0.2.2:3000/addLand"));
      request.fields['name'] = name;
      request.fields['price']=price;
      request.fields["place"]=place;
      request.fields["district"]=district;
      request.fields["phone"]=phone!;
      request.files.add(await MultipartFile.fromPath(
        'landPic',
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
      return "netError";
    }
  }

}