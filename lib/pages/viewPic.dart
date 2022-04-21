import 'package:flutter/material.dart';

class ViewPic extends StatefulWidget {
  final Map arguments;
  const ViewPic({Key? key,required this.arguments}) : super(key: key);

  @override
  _ViewPicState createState() => _ViewPicState();
}

class _ViewPicState extends State<ViewPic> {
  @override
  Widget build(BuildContext context) {
    print(widget.arguments);
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Hero(
              tag: "1",
              child: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(widget.arguments["pic"]),
                  )
                ),
              ),
            ),
            Positioned(
              top: 10,
              right: 10,
              child: Card(
                color: Colors.green,
                elevation: 10,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50)
                ),
                child: IconButton(color: Colors.white,icon: Icon(Icons.close),onPressed: (){
                  Navigator.pop(context);
                },),
              )
            )
          ],
        ),
      ),
    );
  }
}
