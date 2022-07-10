import 'package:agri_app/services/loginService.dart';
import 'package:agri_app/services/profileService.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileMal extends StatefulWidget {
  const ProfileMal({Key? key}) : super(key: key);

  @override
  _ProfileMalState createState() => _ProfileMalState();
}

class _ProfileMalState extends State<ProfileMal> {

  bool loading=true;
  dynamic result=[];
  String txt="Loading";
  ProfileService profileService=ProfileService();
  late SharedPreferences sharedPreferences;
  String? phone="";
  TextEditingController name=TextEditingController();
  TextEditingController phoneController=TextEditingController();
  TextEditingController place=TextEditingController();
  String district="";
  LoginService loginService=LoginService();

  @override
  void initState() {
    init();
    super.initState();
  }


  void init()async{
    sharedPreferences=await SharedPreferences.getInstance();
    getProfile();
  }




  void getProfile()async{
    phone= sharedPreferences.getString("phone");
    result=await profileService.getProfile(phone: phone);
    print(result[0]);
    if(result!="error"){
      setState(() {
        loading=false;
      });
    }
    else{
      setState(() {
        txt="Something went wrong";
      });
      Future.delayed(Duration(seconds: 5),(){
        getProfile();
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
          title: Text('അലെർട്'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(text),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('ഓക്കേ'),
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
        elevation: 0,
        backgroundColor:Colors.white,
        iconTheme: IconThemeData(color: Colors.green),
      ),
      floatingActionButton: FloatingActionButton(onPressed: () {
        phoneController.text=phone!;
        district=result[0]["district"];
        name.text=result[0]["name"];
        place.text=result[0]["place"];
        showModalBottomSheet(enableDrag: true,isScrollControlled: true,shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topRight: Radius.circular(10),topLeft: Radius.circular(10))),context: context, builder: (BuildContext context){
          return StatefulBuilder(builder: (BuildContext context,setState)
          {
            return Container(
              child: ListView(
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                children: [
                  SizedBox(height: 60,),
                  Align(child: Text("പ്രൊഫൈൽ എഡിറ്റ് ചെയ്യുക", style: TextStyle(
                      color: Colors.green,
                      fontSize: 30,
                      fontWeight: FontWeight.bold),),
                    alignment: Alignment.centerLeft,),
                  SizedBox(height: 40,),
                  Text("പേര്"),
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
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
                          hintText: 'പേര്'
                      ),
                    ),
                  ),
                  SizedBox(height: 15,),
                  Text("ഫോൺ (എഡിറ്റ് ചെയ്യാനാകുില്ല)"),
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.grey[200]
                    ),
                    child: TextField(
                      enabled: false,
                      keyboardType: TextInputType.phone,
                      controller: phoneController,
                      // textCapitalization: TextCapitalization.sentences,
                      focusNode: null,
                      style: TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Phone No.'
                      ),
                    ),
                  ),
                  SizedBox(height: 15,),
                  Text("സ്ഥലം"),
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.grey[200]
                    ),
                    child: TextField(
                      textCapitalization: TextCapitalization.words,
                      controller: place,
                      focusNode: null,
                      style: TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'സ്ഥലം'
                      ),
                    ),
                  ),
                  SizedBox(height: 15,),
                  Text("ജില്ല"),
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.grey[200]
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton(items: <String>['ജില്ല തിരഞ്ഞെടുക്കുക','കാസർകോട്', 'കണ്ണൂർ', 'വയനാട്', 'പാലക്കാട്','മലപ്പുറം','കോഴിക്കോട്','തൃശൂർ','എറണാകുളം','ഇടുക്കി','ആലപ്പുഴ','കോട്ടയം','പത്തനംതിട്ട','കൊല്ലം','തിരുവനന്തപുരം']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value, style: TextStyle(
                              color: value == "ജില്ല തിരഞ്ഞെടുക്കുക" ? Colors
                                  .grey[700] : Colors.black),),
                        );
                      }).toList(),
                        isExpanded: true,
                        underline: null,
                        value: district,
                        onChanged: (String? newValue) {
                          setState(() {
                            district = newValue!;
                          });
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 15,),
                  TextButton(onPressed: () async {
                    showLoading(context);
                    if (name.text.length != 0 &&
                        phoneController.text.length != 0 &&
                        district != "ജില്ല തിരഞ്ഞെടുക്കുക" && place.text.length!=0) {
                      var res = await loginService.update(name: name.text,
                          phone: phoneController.text,
                          place: place.text,
                          district: district,
                          id: result[0]["id"]);
                      if (res == "done") {
                        await sharedPreferences.setString(
                            "phone", phoneController.text);
                        Navigator.pop(context);
                        Navigator.pop(context);
                        setState(() {
                          loading = true;
                        });
                        getProfile();
                      }
                      else if (res == "netError") {
                        Navigator.pop(context);
                        alertDialog(
                            "എന്തോ കുഴപ്പം സംഭവിച്ചു. നിങ്ങളുടെ നെറ്റ്‌വർക്ക് കണക്ഷൻ പരിശോധിച്ച് വീണ്ടും ശ്രമിക്കുക!!");
                      }
                      else {
                        Navigator.pop(context);
                        alertDialog("തെറ്റായ ഫോൺ നമ്പറോ പാസ്‌വേഡോ");
                      }
                    }
                    else {
                      alertDialog("ദയവായി ഫോം പൂരിപ്പിക്കുക");
                    }
                  },
                    child: Text("Update", style: TextStyle(fontSize: 17),),
                    style: TextButton.styleFrom(shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                        backgroundColor: Colors.green,
                        primary: Colors.white,
                        padding: EdgeInsets.all(18)),),
                  SizedBox(height: 15,),
                  TextButton(onPressed: () {
                    Navigator.pop(context);
                  },
                    child: Text("Cancel", style: TextStyle(fontSize: 17)),
                    style: TextButton.styleFrom(padding: EdgeInsets.all(18)),)
                ],
              ),
            );
          });
        });
      },child: Icon(Icons.edit),tooltip: "Edit Profile",),
      body: loading?Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 50,width: 50,child: CircularProgressIndicator(strokeWidth: 5,valueColor: AlwaysStoppedAnimation(Colors.green),),),
            SizedBox(height: 10,),
            Text(txt)
          ],
        ),
      ):ListView(
        padding: EdgeInsets.symmetric(vertical: 10,horizontal: 20),
        children: [
          SizedBox(height: 10,),
          Text("പ്രൊഫൈൽ",style: TextStyle(color: Colors.green,fontWeight: FontWeight.bold,fontSize: 30),),
          SizedBox(height: 30,),
          Align(alignment: Alignment.centerLeft,child: Text("പേര്",style: TextStyle(color: Colors.green,fontWeight: FontWeight.bold,fontSize: 17),),),
          SizedBox(height: 10,),
          Padding(padding: EdgeInsets.only(left: 20),child: Text(result[0]["name"],style: TextStyle(fontSize: 20),),),
          SizedBox(height: 30,),
          Align(alignment: Alignment.centerLeft,child: Text("ഫോൺ",style: TextStyle(color: Colors.green,fontWeight: FontWeight.bold,fontSize: 17),),),
          SizedBox(height: 10,),
          Padding(padding: EdgeInsets.only(left: 20),child: Text(phone!,style: TextStyle(fontSize: 20),),),
          SizedBox(height: 30,),
          Align(alignment: Alignment.centerLeft,child: Text("സ്ഥലം",style: TextStyle(color: Colors.green,fontWeight: FontWeight.bold,fontSize: 17),),),
          SizedBox(height: 10,),
          Padding(padding: EdgeInsets.only(left: 20),child: Text(result[0]["place"],style: TextStyle(fontSize: 20),),),
          SizedBox(height: 30,),
          Align(alignment: Alignment.centerLeft,child: Text("ജില്ല",style: TextStyle(color: Colors.green,fontWeight: FontWeight.bold,fontSize: 17),),),
          SizedBox(height: 10,),
          Padding(padding: EdgeInsets.only(left: 20),child: Text(result[0]["district"],style: TextStyle(fontSize: 20),),),
          SizedBox(height: 30,),
          Align(alignment: Alignment.centerLeft,child: TextButton.icon(style: TextButton.styleFrom(backgroundColor: Colors.green,primary: Colors.white,shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))),onPressed: (){Navigator.pushNamed(context, "/changePasswordMal",arguments: {"phone":""});}, icon: Icon(Icons.vpn_key), label: Text("പാസ്വേഡ് മാറ്റുക")))
        ],
      ),
    );
  }
}
