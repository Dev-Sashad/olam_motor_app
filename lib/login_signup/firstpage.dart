import 'package:flutter/material.dart';
import 'package:motorapp/login_signup/sign_in.dart';
import 'package:motorapp/login_signup/sign_up.dart';



class FirstPage extends StatefulWidget {
  @override
  FirstPageState createState() => FirstPageState();
}


class FirstPageState extends State<FirstPage> {

  void getStarted() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: Column(
            children:[
              Container(
                alignment: Alignment.topRight,
                child: FlatButton(onPressed: (){
             Navigator.of(context).pop();
         },           
         child:Icon(Icons.cancel, color: Colors.grey, size: 10,),
         
         ), 
                ),

            Text("Would you like to \n create a free account?", style: TextStyle(fontSize:20, color:Colors.green),),

            ]
          ),

          content: new Text("With an account, your data \n will be securely saved, \n allowing you to access it from \n multiple device "),
          actions: <Widget>[
            new FlatButton(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)
                  ),
              color: Colors.green,
              child: new Text("Create My Account", style: TextStyle(color:Colors.white, fontSize: 15),),
              onPressed: () {             
               Navigator.of(context).pushReplacement(
    MaterialPageRoute(builder: (BuildContext context)=>SignupPage())
  );
              },
            ),

          ],
        );
      },
    );
  }

  void signIn(){
               Navigator.of(context).pushReplacement(
    MaterialPageRoute(builder: (BuildContext context)=>SigninPage())
  );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.green,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,

      children: [
        Text('Welcome', style:TextStyle( fontSize: 30, color: Colors.white),),

        Text('This App helps to keep record of all motor details \n in the plant for adequate operation and planning', 
        style:TextStyle( fontSize: 20, color: Colors.white),),
      
        Container(
                height:  MediaQuery.of(context).size.height*0.15,
                width:  MediaQuery.of(context).size.width*0.6,
                child:FlatButton(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)
                  ),
                  color: Colors.greenAccent,
                    onPressed: getStarted,
                   child: Center(
                     child: Row(
                     mainAxisAlignment: MainAxisAlignment.center,
                       children: <Widget>[
                     Text('Get Started',
                     style: TextStyle(
                       color: Colors.white,
                       fontSize: 25,
                       fontWeight: FontWeight.bold,
                      fontFamily: 'Montserrat',
                     )),

                      SizedBox(width:5),
                      Icon(Icons.arrow_forward_ios, color:Colors.white, size:20,),

                       ]
                     )
                   ), 
                    )),

            Container(
                height:  MediaQuery.of(context).size.height*0.15,
                width:  MediaQuery.of(context).size.width*0.6,
                decoration: BoxDecoration(
                 borderRadius: BorderRadius.circular(5),
                 border: Border.all( color:Colors.green, width: 1.0),
                ),
                child:FlatButton(
                    onPressed: (){
                      signIn();
                    },
                   child: Center(
                     child: Row(
                     mainAxisAlignment: MainAxisAlignment.center,
                       children: <Widget>[
                     Text('Login',
                     style: TextStyle(
                       color: Colors.green,
                       fontSize: 25,
                       fontWeight: FontWeight.bold,
                      fontFamily: 'Montserrat',
                     )),

                      SizedBox(width:5),
                      Icon(Icons.arrow_forward_ios, color:Colors.white, size:20,),

                       ]
                     )
                   ), 
                    )),
            


      ],
      ),

    );
    
  }


}