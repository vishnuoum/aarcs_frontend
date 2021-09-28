
import 'dart:convert';

import 'package:http/http.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
class AnalyticsService{
  late SharedPreferences sharedPreferences;


  var diseaseAnalyticsDB;
  
  void sendAnalytics()async{

    try {
      sharedPreferences = await SharedPreferences.getInstance();

      var databasesPath = await getDatabasesPath();
      String diseaseAnalytics = join(databasesPath, 'diseaseAnalytics.db');

      diseaseAnalyticsDB = await openDatabase(diseaseAnalytics, version: 1);
      List<Map> list = await diseaseAnalyticsDB.rawQuery(
          'SELECT disease FROM analytics');
      print(list);
      if(list.isNotEmpty) {
        Response response = await post(
            Uri.parse("http://10.0.2.2:3000/analyticsInfo"), body: {
          "diseaseInfo": jsonEncode(list),
          "phone": sharedPreferences.getString("phone")
        });
        print(response.body);
        if (response.body == "done") {
          await diseaseAnalyticsDB.rawQuery("Delete from analytics");
          await diseaseAnalyticsDB.rawQuery(
              "DELETE FROM SQLITE_SEQUENCE WHERE name='analytics';");
        }
      }
    }
    catch(e){
      print("Analytics error: $e");
    }
  }


}