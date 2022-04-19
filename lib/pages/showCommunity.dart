import 'package:agri_app/services/askService.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ShowCommunity extends StatefulWidget {
  const ShowCommunity({Key? key}) : super(key: key);

  @override
  State<ShowCommunity> createState() => _ShowCommunityState();
}

class _ShowCommunityState extends State<ShowCommunity> {

  dynamic result=[];
  bool loading=true;
  String txt="Loading";
  AskService askService = AskService();
  DateFormat dateFormat = DateFormat("dd/MM/yyyy hh:mm a");

  @override
  void initState() {
    load();
    super.initState();
  }

  void load()async{
    setState(() {
      loading=true;
    });
    result = await askService.showCommunity();
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
        title: Text("Ask in Community"),
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton.extended(onPressed: (){

      }, icon: Icon(Icons.edit),label: Text("Ask Community")),
      body: loading?Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 50,width: 50,child: CircularProgressIndicator(strokeWidth: 5,valueColor: AlwaysStoppedAnimation(Colors.green),),),
            SizedBox(height: 10,),
            Text(txt)
          ],
        ),
      ):ListView.builder(
          padding: EdgeInsets.all(5),
          itemCount: result.length,
          itemBuilder: (context,index) {
            return GestureDetector(
              onTap: (){
                Navigator.pushNamed(context, "/doubt",arguments: {"id":result[index]["id"],"username":result[index]["username"],"district":result[index]["district"],
                  "query":result[index]["query"],"datetime":result[index]["datetime"],"answers":result[index]["answers"],
                  "description":result[index]["description"],"pic":result[index]["pic"]});
              },
              child: Container(
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
                        child: Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: Colors.green[400],
                              foregroundColor: Colors.white,
                              child: Icon(Icons.person),
                            ),
                            SizedBox(width: 20,),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(result[index]["username"],style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),),
                                    SizedBox(width: 5,),
                                    CircleAvatar(radius: 3,),
                                    SizedBox(width: 5,),
                                    Text(result[index]['district'],style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16,color: Colors.grey[700]))
                                  ],
                                ),
                                Text(dateFormat.format(DateTime.parse(result[index]["datetime"])).toString()),
                              ],
                            )
                          ],
                        ),
                      ),
                      SizedBox(height: 10,),
                      Padding(padding: EdgeInsets.only(left: 10),child: Text(result[index]["query"],style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),),
                      SizedBox(height: 5,),
                      Padding(padding: EdgeInsets.only(left: 10),child: Text(result[index]["description"],style: TextStyle(fontSize: 17),),),
                      SizedBox(height: 20,)
                    ],
                  ),
              ),
            );
          }),
    );
  }
}
