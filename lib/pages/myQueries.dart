import 'package:agri_app/services/askService.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyQueries extends StatefulWidget {
  const MyQueries({Key? key}) : super(key: key);

  @override
  State<MyQueries> createState() => _MyQueriesState();
}

class _MyQueriesState extends State<MyQueries> {

  dynamic result=[];
  bool loading=true;
  String txt="Loading";
  AskService askService = AskService();
  DateFormat dateFormat = DateFormat("dd/MM/yyyy hh:mm a");
  late SharedPreferences sharedPreference;

  @override
  void initState() {
    loadSP();
    super.initState();
  }

  void loadSP()async{
    sharedPreference = await SharedPreferences.getInstance();
    load();
  }

  void load()async{
    setState(() {});
    result = await askService.myQueries(phone: sharedPreference.getString("phone"));
    if(result=="error"){
      setState(() {
        txt="Something went wrong";
      });
      Future.delayed(Duration(seconds: 5),(){
        load();
      });
    }
    else{
      setState(() {
        loading = false;
        txt="Loading";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Queries"),
        elevation: 0,
      ),
      body: loading?Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 50,width: 50,child: CircularProgressIndicator(strokeWidth: 5,valueColor: AlwaysStoppedAnimation(Colors.green),),),
            SizedBox(height: 10,),
            Text(txt)
          ],
        ),
      ):result.length==0?Center(
        child: Text('Nothing to show',style: TextStyle(color: Colors.grey),),
      )
          :ListView.builder(
          padding: EdgeInsets.only(left: 5,right: 5,top: 10,bottom: 50),
          itemCount: result.length,
          itemBuilder: (context,index) {
            return GestureDetector(
              onTap: ()async{
                await Navigator.pushNamed(context, "/myDoubt",arguments: {"resolved":result[index]["resolved"],"phone":sharedPreference.getString("phone"),"id":result[index]["id"],"username":result[index]["username"],"district":result[index]["district"],
                  "query":result[index]["query"],"datetime":result[index]["datetime"],"answers":result[index]["answers"],
                  "description":result[index]["description"],"pic":result[index]["pic"]});
                loading=true;
                load();
              },
              child: Container(
                margin: EdgeInsets.only(bottom: 10),
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.6),
                      spreadRadius: 4,
                      blurRadius: 6,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(height: 200,decoration: BoxDecoration(
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(result[index]["pic"])
                        )
                    ),
                      child: Padding(
                        padding: const EdgeInsets.only(right: 12.0,top: 10),
                        child: Align(
                          alignment: Alignment.topRight,
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 5,horizontal: 12),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: Colors.white
                            ),
                            child: Text("${result[index]["answers"]} Answers"),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: Text(dateFormat.format(DateTime.parse(result[index]["datetime"])).toString()),
                    ),
                    SizedBox(height: 5,),
                    result[index]["resolved"]==null?SizedBox():Padding(
                      padding: const EdgeInsets.symmetric(horizontal:10),
                      child: Text("Resolved",style: TextStyle(color: Colors.green,fontWeight: FontWeight.bold),),
                    ),
                    SizedBox(height: 10,),
                    Padding(padding: EdgeInsets.symmetric(horizontal: 10),child: Text(result[index]["query"],style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),),
                    SizedBox(height: 5,),
                    Padding(padding: EdgeInsets.symmetric(horizontal: 10),child: Text(result[index]["description"],style: TextStyle(fontSize: 17),),),
                    SizedBox(height: 20,)
                  ],
                ),
              ),
            );
          }),
    );
  }
}
