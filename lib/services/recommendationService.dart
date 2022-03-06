
import 'package:http/http.dart';

class RecommendationService{
  Future<dynamic> recommend({required String N,required String K,required String P, required String temperature,required String rainfall,required String ph,required String humidity})async{
    try {
      Response response = await post(
          Uri.parse("http://192.168.18.2:3000/recommend"), body: {
        "N": N,
        "K": K,
        "P": P,
        "temperature": temperature,
        "rainfall": rainfall,
        "ph": ph,
        "humidity": humidity
      });
      if (response.body != "error") {
        return response.body;
      }
      else {
        return "error";
      }
    }
    catch(error){
      return "netError";
    }
  }
}