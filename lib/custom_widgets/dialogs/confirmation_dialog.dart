
import 'package:flutter/material.dart';




class ConfirmationDialog extends StatelessWidget {
final String title;
final String message;

  const ConfirmationDialog({Key key,  @required this.title,@required this.message}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    
    return  LayoutBuilder(builder: (context,constraints){
 return AlertDialog(
   contentPadding: EdgeInsets.fromLTRB(24.0,0.0,24.0,0.0),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0))),
      content: SingleChildScrollView(
        child:  Container(
          width: constraints.maxWidth,
          child: Column(
          
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
                
                Container(
            margin: EdgeInsets.only(top: constraints.maxHeight *0.02),
                  child: Image.asset("assets/images/chat.png")),
             Padding(padding: EdgeInsets.all(10))
             ,Text(title,style: TextStyle(
               color: Colors.black,fontWeight: FontWeight.w700,fontSize: 15
             ),),
            Container(
              margin: EdgeInsets.only(bottom: constraints.maxHeight *0.04),
              child:  Text(message,style: TextStyle(
               color: Color(0xffC7C7C7),fontSize: 13,
             ),textAlign: TextAlign.center,
             ),
            )
            ],
          ),
        )),
      
    );
    });
  }
}
