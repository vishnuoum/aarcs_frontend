import 'package:agri_app/services/listService.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserTools extends StatefulWidget {
  const UserTools({Key? key}) : super(key: key);

  @override
  _UserToolsState createState() => _UserToolsState();
}

class _UserToolsState extends State<UserTools> {
  bool isSearch=false;
  TextEditingController searchController=TextEditingController();
  TextEditingController name=TextEditingController();
  TextEditingController price=TextEditingController();
  TextEditingController place=TextEditingController();
  ListService listService=ListService();
  bool loading=true;
  dynamic result=[];
  String txt="Loading";
  String district="Select a District";
  late SharedPreferences sharedPreferences;
  String url = "http://10.0.2.2:3000";

  @override
  void initState() {
    SharedPreferences.getInstance().then((value){
      url = value.getString("url").toString();
    });
    initPreference();
    super.initState();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void initPreference()async{
    sharedPreferences=await SharedPreferences.getInstance();
    init();
  }

  void init({String query=""})async{
    String? phone=sharedPreferences.getString("phone");
    result=await listService.getUserTools(phone: phone,query: query);
    print(result);
    if(result!="error"){
      setState(() {
        loading=false;
        txt="Loading";
      });
    }
    else{
      setState(() {
        txt="Loading...";
      });
      Future.delayed(Duration(seconds: 5),(){init(query: query);});
    }
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


  showPic(BuildContext context,String url){
    AlertDialog alert =AlertDialog(
      contentPadding: EdgeInsets.zero,
      content: Container(
        height: 250,
        width: 200,
        padding: EdgeInsets.zero,
        child: Image.network(url,fit: BoxFit.cover,),
      ),
    );

    showDialog(context: context,builder:(BuildContext context){
      return alert;
    });
  }


  showBottomSheet(BuildContext context,String id){
    showModalBottomSheet(enableDrag: true,isScrollControlled: true,shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topRight: Radius.circular(10),topLeft: Radius.circular(10))),context: context, builder: (BuildContext context){
      return StatefulBuilder(builder: (BuildContext context,setState){
        return Container(
          child: ListView(
            padding: EdgeInsets.symmetric(vertical: 20,horizontal: 20),
            children:[
              SizedBox(height: 60,),
              Align(child: Text("Edit Tool",style: TextStyle(color: Colors.green,fontSize: 30,fontWeight: FontWeight.bold),),alignment: Alignment.centerLeft,),
              SizedBox(height: 40,),
              Text("Tool Name"),
              Container(
                margin: EdgeInsets.only(top: 10),
                padding: EdgeInsets.symmetric(vertical: 5,horizontal: 20),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey[200]
                ),
                child: TextField(
                  textCapitalization: TextCapitalization.words,
                  controller: name,
                  focusNode: null,
                  style: TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Item Name'
                  ),
                ),
              ),
              SizedBox(height: 15,),
              Text("Price/Hr"),
              Container(
                margin: EdgeInsets.only(top: 10),
                padding: EdgeInsets.symmetric(vertical: 5,horizontal: 20),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey[200]
                ),
                child: TextField(
                  keyboardType: TextInputType.number,
                  controller: price,
                  // textCapitalization: TextCapitalization.sentences,
                  focusNode: null,
                  style: TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Price/Hr'
                  ),
                ),
              ),
              SizedBox(height: 15,),
              Text("Place"),
              Container(
                margin: EdgeInsets.only(top: 10),
                padding: EdgeInsets.symmetric(vertical: 5,horizontal: 20),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey[200]
                ),
                child: TextField(
                  controller: place,
                  textCapitalization: TextCapitalization.sentences,
                  focusNode: null,
                  style: TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Place'
                  ),
                ),
              ),
              SizedBox(height: 15,),
              Text("District"),
              Container(
                margin: EdgeInsets.only(top: 10),
                padding: EdgeInsets.symmetric(vertical: 5,horizontal: 20),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey[200]
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton(items: <String>['Select a District','Kasargod', 'Kannur', 'Wayanad', 'Palakkad','Malapuram','Kozhikode','Thrissur','Ernakulam','Idukki','Alappuzha','Kottayam','Pathanamthitta','Kollam','Thiruvananthapuram']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value,style: TextStyle(color:value=="Select a District"?Colors.grey[700]:Colors.black),),
                    );
                  }).toList(),
                    isExpanded: true,
                    underline: null,
                    value: district,
                    onChanged: (String? newValue) {
                      print(newValue);
                      setState(() {
                        district = newValue!;
                      });
                    },
                  ),
                ),
              ),
              SizedBox(height: 15,),
              TextButton(onPressed: ()async{
                showLoading(context);
                if(name.text.length!=0 && price.text.length!=0 && place.text.length!=0 && district!="Select a Distirct"){
                  var res=await listService.editUserTool(name:name.text,price: price.text, district: district,id:id,place: place.text);
                  if(res=="done"){
                    Navigator.pop(context);
                    Navigator.pop(context);
                    setState(() {
                      loading=true;
                      txt="Loading";
                    });
                    init();
                  }
                  else if(res=="netError"){
                    Navigator.pop(context);
                    alertDialog("Something went wrong. Please check your network connection and try again!!");
                  }
                  else{
                    Navigator.pop(context);
                    alertDialog("Something went wrong.");
                  }
                }
                else{
                  alertDialog("Please complete the form");
                }
              }, child: Text("Update",style: TextStyle(fontSize: 17),),style: TextButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),backgroundColor: Colors.green,primary: Colors.white,padding: EdgeInsets.all(18)),),
              SizedBox(height: 15,),
              TextButton(onPressed: (){Navigator.pop(context);}, child: Text("Cancel",style: TextStyle(fontSize: 17)),style: TextButton.styleFrom(padding: EdgeInsets.all(18)),)
            ],
          ),
        );
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: ()async{
          if(isSearch) {
            searchController.clear();
            setState(() {
              isSearch = false;
            });
            return false;
          }
          return true;
        },
        child: Scaffold(
          appBar: AppBar(
              backgroundColor: Colors.white,
              iconTheme: IconThemeData(
                color: Colors.green,
              ),
              automaticallyImplyLeading: !isSearch,
              title: isSearch?Container(
                padding: EdgeInsets.zero,
                margin: EdgeInsets.zero,
                width: MediaQuery.of(context).size.width,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: TextField(
                        keyboardType: TextInputType.text,
                        autofocus: true,
                        style: TextStyle(color: Colors.green),
                        controller: searchController,
                        decoration: InputDecoration(border: InputBorder.none,hintText: "Search"),
                        onChanged: (text){
                          setState(() {});
                        },
                        onSubmitted: (text){
                          setState(() {
                            loading=true;
                            isSearch=false;
                            result=[];
                          });
                          init(query: text);
                        },
                      ),
                    ),
                    searchController.text.length!=0?IconButton(onPressed: (){searchController.clear();setState(() {});}, icon: Icon(Icons.clear)):Container()
                  ],
                ),
              ):Text("Your Tools",style: TextStyle(color: Colors.green),),
              actions: !isSearch?[
              !loading?IconButton(onPressed: (){
                setState(() {
                  isSearch=true;
                });
                print("Search");
              }, icon: Icon(Icons.search)):Container(),
              SizedBox(width: 5,)
              ]:[Container()],
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
        ):isSearch?Container():ListView.builder(
            padding: EdgeInsets.all(10),
            itemCount: result.length,
            itemBuilder: (context,index) {
              return GestureDetector(
                onTap: (){showPic(context, result[index]["pic"].replaceAll("http://10.0.2.2:3000",url));},
                child: Container(
                  margin: EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                      image: NetworkImage(
                          result[index]["pic"].replaceAll("http://10.0.2.2:3000",url)),
                      fit: BoxFit.cover,
                    ),
                  ),
                  height: 220,
                  padding: EdgeInsets.zero,
                  child: Stack(
                    children: [
                      Positioned(
                          bottom: 0,
                          width: MediaQuery.of(context).size.width-20,
                          child: Container(
                            decoration: BoxDecoration(
                              boxShadow: [BoxShadow(
                                color: Colors.grey,
                                blurRadius: 5.0,
                              ),],
                              borderRadius: BorderRadius.only(bottomRight: Radius.circular(10),bottomLeft: Radius.circular(10)),
                              color: Colors.white,
                            ),
                            padding: EdgeInsets.all(10),
                            height: 90,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                    child: Column(
                                      children: [
                                        Text(result[index]["name"],style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
                                        SizedBox(height: 3,),
                                        Text("Rs.${result[index]["price"]}/Hr",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),),
                                        SizedBox(height: 3,),
                                        Text("${result[index]["place"]} ${result[index]["district"]}",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.grey,fontSize: 16),overflow: TextOverflow.ellipsis,),
                                      ],
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                    )
                                ),
                                ClipOval(
                                  child: Material(
                                    color: Colors.green, // Button color
                                    child: InkWell(
                                      splashColor: Colors.green[400], // Splash color
                                      onTap: () async{
                                        name.text=result[index]["name"];
                                        price.text=result[index]["price"];
                                        place.text=result[index]["place"];
                                        district=result[index]["district"];
                                        await showBottomSheet(context, result[index]["id"]);
                                        setState(() {
                                          loading=true;
                                          result=[];
                                        });
                                        init();
                                      },
                                      child: SizedBox(width: 56, height: 56, child: Icon(Icons.edit,color: Colors.white,)),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          )
                      )
                    ],
                  ),
                ),
              );
            }
        )
    ),
    );
  }
}
