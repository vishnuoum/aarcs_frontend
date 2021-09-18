import 'package:flutter/material.dart';

class Chat extends StatefulWidget {
  const Chat({Key? key}) : super(key: key);

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  List messages=[{"sender":"Sender","message":"Hello hai!","date":"17/08/2021","time":"6.40PM"},
    {"sender":"Sender","message":"Hello hai!","date":"17/08/2021","time":"6.40PM"},
    {"sender":"You","message":"Hello hai!","date":"17/08/2021","time":"7.00PM"}];

  TextEditingController msg=TextEditingController(text: "");
  ScrollController scrollController=ScrollController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[200],
      appBar: AppBar(
        title: Text("Community Chat",style: TextStyle(color: Colors.green),),
        iconTheme: IconThemeData(
          color: Colors.green
        ),
        elevation: 6,
        backgroundColor: Colors.white,
      ),
      body: GestureDetector(
        onTap: (){
          FocusScope.of(context).unfocus();
        },
        child: SizedBox.expand(
          child: Column(
            children: [
              Expanded(
                  flex: 10,
                  child: ListView.builder(
                    reverse: true,
                    controller: scrollController,
                    padding: EdgeInsets.only(left: 20,right: 20,bottom: 10),
                    itemCount: messages.length,
                    itemBuilder: (context,index){
                      index=messages.length - 1 - index;
                      return Align(
                        alignment: messages[index]["sender"]!="You"?Alignment.centerLeft:Alignment.centerRight,
                        child: Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: messages[index]["sender"]!="You"?Colors.green[50]:Colors.white
                          ),
                          constraints: BoxConstraints(
                              maxWidth: MediaQuery.of(context).size.width*0.65
                          ),
                          margin: EdgeInsets.only(top: index!=0?messages[index-1]["sender"]==messages[index]["sender"]?5:12:12,),
                          child: Column(
                            crossAxisAlignment: messages[index]["sender"]!="You"?CrossAxisAlignment.start:CrossAxisAlignment.end,
                            children: [
                              index!=0?messages[index-1]["sender"]==messages[index]["sender"]?SizedBox():Padding(
                                padding: const EdgeInsets.only(bottom: 5.0),
                                child: Text(messages[index]["sender"],style: TextStyle(fontSize: 11),),
                              ):Padding(
                                padding: const EdgeInsets.only(bottom: 5.0),
                                child: Text(messages[index]["sender"],style: TextStyle(fontSize: 11),),
                              ),
                              Padding(padding: messages[index]["sender"]=="You"?EdgeInsets.only(right: 5):EdgeInsets.only(left: 5),child: Text(messages[index]["message"],style: TextStyle(fontSize: 16),),)
                            ],
                          ),
                        ),
                      );
                    },
                  )
              ),
              Container(
                constraints: BoxConstraints(
                    minHeight: 50,
                    maxHeight: 80
                ),
                decoration: BoxDecoration(
                    color: Colors.green[200]
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        flex:5,
                        child: Padding(
                          padding: const EdgeInsets.only(left:5.0,right: 5),
                          child: Container(
                            constraints: BoxConstraints(
                                minHeight: 30,
                                maxHeight: 80
                            ),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(30)
                            ),
                            child: TextField(
                              controller: msg,
                              keyboardType: TextInputType.multiline,
                              maxLines: null,
                              decoration: InputDecoration(
                                  hintText: "Type Your Message",
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(horizontal: 20,vertical: 10)
                              ),
                              onChanged: (text){
                                setState(() {});
                              },
                            ),
                          ),
                        ),
                      ),
                      msg.text.length==0?SizedBox():Expanded(
                          child: TextButton(
                            child: Icon(Icons.send),
                            onPressed: (){
                              print("Send");
                              setState(() {
                                messages.add({"sender":"You","message":msg.text,"date":"09/08/2021","time":"9.00PM"});
                                msg.clear();
                                // Future.delayed(Duration(milliseconds: 20),(){
                                //   scrollController.position.jumpTo(scrollController.position.maxScrollExtent);
                                // });
                              });
                            },
                            style: TextButton.styleFrom(backgroundColor: Colors.green,shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),padding: EdgeInsets.all(12),primary: Colors.white),
                          )
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      )
    );
  }
}




