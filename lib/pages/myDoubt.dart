import 'package:agri_app/services/askService.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class MyDoubt extends StatefulWidget {
  final Map arguments;
  const MyDoubt({Key? key,required this.arguments}) : super(key: key);

  @override
  State<MyDoubt> createState() => _MyDoubtState();
}

class _MyDoubtState extends State<MyDoubt> {

  bool loading = true,sendEnabled=false;
  String txt="Loading";
  dynamic result=[];
  DateFormat dateFormat = DateFormat("dd/MM/yyyy hh:mm a");
  AskService askService = AskService();
  TextEditingController answerField = TextEditingController(text: "");

  @override
  initState() {
    load();
    super.initState();
  }

  void load()async{
    setState(() {});
    result = await askService.answers(phone: widget.arguments["phone"], id: widget.arguments["id"].toString());
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
        loading=false;
        txt="Loading";
      });
    }
  }

  showLoading(BuildContext context){
    AlertDialog alert =AlertDialog(
      content: SizedBox(
        height: 80,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 50,width: 50,child: CircularProgressIndicator(strokeWidth: 5,valueColor: AlwaysStoppedAnimation(Colors.green),),),
            SizedBox(height: 10,),
            Text("Loading")
          ],
        ),
      ),
    );

    showDialog(context: context,builder:(BuildContext context){
      return WillPopScope(onWillPop: ()async => false,child: alert);
    });
  }

  Future<void> alertDialog(var text) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Alert'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(text),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Answer the Query"),
      ),
      body: Container(
        decoration: BoxDecoration(
            color: Colors.green[100]
        ),
        height: MediaQuery.of(context).size.height,
        child: GestureDetector(
          onTap: (){
            FocusScope.of(context).unfocus();
          },
          child: Stack(
            children: [
              ListView(
                children: [
                  Container(
                    height: 200,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: NetworkImage(widget.arguments["pic"]),
                            fit: BoxFit.cover
                        )
                    ),
                  ),
                  SizedBox(height: 10,),
                  ListTile(
                      title: Text("Asked on",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17),),
                      subtitle: Text(dateFormat.format(DateTime.parse(widget.arguments["datetime"])).toString(),style: TextStyle(color: Colors.black),)
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 10),
                    child: Text(widget.arguments["query"],style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Text(widget.arguments["description"],style: TextStyle(fontSize: 16),),
                  ),
                  SizedBox(height: 20,),
                  Center(
                    child: Text("Responses",style: TextStyle(color: Colors.green[800],fontSize: 17,fontWeight: FontWeight.bold),),
                  ),
                  SizedBox(height: 10,),
                  loading?Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: 50,width: 50,child: CircularProgressIndicator(strokeWidth: 5,valueColor: AlwaysStoppedAnimation(Colors.green),),),
                        SizedBox(height: 10,),
                        Text(txt)
                      ],
                    ),
                  ):ListView.separated(
                    padding: EdgeInsets.only(bottom: 100),
                    shrinkWrap: true,
                    separatorBuilder: (context, index) {
                      return Divider();
                    },
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: result.length,
                    itemBuilder: (context, index) {
                      return Container(
                        color: widget.arguments["resolved"].toString()==result[index]["id"].toString()?Colors.green[200]:Colors.transparent,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ListTile(
                                leading: CircleAvatar(
                                  radius: 25,
                                  backgroundColor: Colors.green,
                                  foregroundColor: Colors.white,
                                  child: Icon(Icons.person),
                                ),
                                title: Row(
                                  children: [
                                    Text(result[index]["username"],style: TextStyle(fontWeight: FontWeight.bold),),
                                    SizedBox(width:5),
                                    CircleAvatar(radius: 3,backgroundColor: Colors.green,),
                                    SizedBox(width:5),
                                    Text(result[index]["district"],style: TextStyle(fontWeight: FontWeight.bold),),
                                  ],
                                ),
                                subtitle: Text(dateFormat.format(DateTime.parse(result[index]["datetime"])).toString(),),
                                trailing: widget.arguments["resolved"]!=null?SizedBox():DropdownButton<String>(
                                  icon: Icon(Icons.more_vert,color: Colors.black,),
                                  items: <String>['Mark as answer'].map((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                  onChanged: (val) async{
                                    showLoading(context);
                                    if(val=="Mark as answer"){
                                      var res = await askService.markAnswer(id: result[index]["id"].toString(), doubtId: widget.arguments["id"].toString());
                                      Navigator.pop(context);
                                      if(res=="done"){
                                        alertDialog("Marked as Answer");
                                        widget.arguments["resolved"]=result[index]["id"];
                                      }
                                      else{
                                        alertDialog("Something went wrong. Try again");
                                      }
                                    }
                                  },
                                ),
                            ),
                            Padding(padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                              child: Text(result[index]["answer"],style: TextStyle(fontSize: 17),),)
                          ],
                        ),
                      );
                    },
                  )
                ],
              ),
              Positioned(
                bottom: 0,
                child: Container(
                  constraints: BoxConstraints(
                      maxHeight: 150
                  ),
                  decoration: BoxDecoration(
                      color: Colors.white
                  ),
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.all(10),
                  child: Row(
                    children: [
                      Expanded(flex: 8,child: Container(
                        padding: EdgeInsets.symmetric(vertical: 5,horizontal: 20),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.green[200]
                        ),
                        child: TextField(
                          controller: answerField,
                          maxLines: null,
                          decoration: InputDecoration(
                              hintText: "Write your response",
                              border: InputBorder.none
                          ),
                          onChanged: (val){
                            if(val.length!=0){
                              setState(() {
                                sendEnabled=true;
                              });
                            }
                            else{
                              setState(() {
                                sendEnabled=false;
                              });
                            }
                          },
                        ),
                      )),
                      SizedBox(width: 10,),
                      Expanded(child: IconButton(onPressed: sendEnabled?()async{
                        FocusScope.of(context).unfocus();
                        showLoading(context);
                        var res= await askService.postAnswer(phone: widget.arguments["phone"], id: widget.arguments["id"].toString(), answer: answerField.text);
                        Navigator.pop(context);
                        if(res=="done"){
                          answerField.clear();
                          setState(() {
                            loading=true;
                          });
                          load();
                        }
                        else{
                          alertDialog("Something went wrong. Try again");
                        }
                      }:null,icon: Icon(Icons.send),color: Colors.green,))
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
