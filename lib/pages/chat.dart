
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:intl/intl.dart';

class Chat extends StatefulWidget {
  const Chat({Key? key}) : super(key: key);

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  late Socket socket;
  String date="0";
  int flag=0;
  late SharedPreferences sharedPreferences;
  List messages=[{"sender":"Sender","message":"Hello hai!","date":"17/08/2021","dateTime":"2021-09-20T13:30:25.660Z"},
    {"sender":"Sender","message":"Hello hai!","date":"17/08/2021","dateTime":"2021-09-20T09:30:25.660Z"},
    {"sender":"You","message":"Hello hai!","date":"17/08/2021","dateTime":"2021-09-20T09:30:25.660Z"}];

  TextEditingController msg=TextEditingController(text: "");
  ScrollController scrollController=ScrollController();
  String? phone="";

  @override
  void initState() {
    initSharedPreferences();
    init();
    super.initState();
  }

  void initSharedPreferences()async{
    sharedPreferences = await SharedPreferences.getInstance();
    phone=sharedPreferences.getString("phone");
  }

  void init()async{
    try {
      socket = io('http://10.0.2.2:3000', <String, dynamic>{
        'transports': ['websocket'],
        'autoConnect': false,
      });

      // Connect to web socket
      socket.connect();
      socket.on('connect', (_) => print('connected'));
      socket.on('message',(data) {
        setState(() {
          messages.add(data);
        });
      });
      socket.emit("connection");
    }catch(e){
      print(e);
    }
  }

  @override
  void dispose() {
    socket.dispose();
    super.dispose();
  }


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
        onDoubleTap: (){
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
                              Padding(padding: messages[index]["sender"]=="You"?EdgeInsets.only(right: 5):EdgeInsets.only(left: 5),child: Text(messages[index]["message"],style: TextStyle(fontSize: 16),),),
                              Padding(padding: EdgeInsets.only(top: 5),child: Text( DateFormat('dd/MM/yyyy hh:mm a').format(DateTime.parse(messages[index]["dateTime"])),style: TextStyle(fontSize: 11),),)
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
                                messages.add({"sender":"You","message":msg.text,"dateTime":"2021-09-20T09:30:25.660Z"});
                                // Future.delayed(Duration(milliseconds: 20),(){
                                //   scrollController.position.jumpTo(scrollController.position.maxScrollExtent);
                                // });
                              });
                              socket.emit('message', {"sender":phone,"message":msg.text});
                              msg.clear();
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




