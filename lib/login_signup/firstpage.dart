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
         child:Icon(Icons.cancel, color: Colors.grey, size: 20,),
         
         ), 
                ),

            Text("Would you like to \ncreate a free account?", style: TextStyle(fontSize:20, color:Colors.green),),

            ]
          ),

          content: new Text("With an account, your data will be \nsecurely saved, allowing you to \naccess it from multiple device "),
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
     backgroundColor: Colors.white,
      body: Container(
        margin: EdgeInsets.symmetric(horizontal:50),
      child: Column(
       // crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,

      children: [
              SizedBox(height:20) ,
        Text('Welcome', style:TextStyle( fontSize: 30, color: Colors.green, fontWeight:FontWeight.bold),
        textAlign:TextAlign.center
        ),
              SizedBox(height:20) ,

        Flexible(child: Text('This App helps to keep record of \n all motor details in the plant for \n adequate operation and planning', 
        style:TextStyle( fontSize: 20, color: Colors.green),
        textAlign:TextAlign.center
        ),
        ),
        
              SizedBox(height:20) ,
        Container(
                height:  MediaQuery.of(context).size.height*0.1,
                width:  MediaQuery.of(context).size.width*0.7,
                decoration: BoxDecoration(
                    color: Colors.green,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                   BoxShadow(
                     blurRadius:4,
                     color:Colors.black12
                   )
                 ],
                ),
                child:FlatButton(
                  //shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)
                  //),
                  //color: Colors.greenAccent,
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
                      SizedBox(height:20) ,
            Container(
                height:  MediaQuery.of(context).size.height*0.1,
                width:  MediaQuery.of(context).size.width*0.7,
                decoration: BoxDecoration(
                 borderRadius: BorderRadius.circular(5),
                // border: Border.all( color:Colors.green, width: 1.5),
                 boxShadow: [
                   BoxShadow(
                     blurRadius:4,
                     color:Colors.black12
                   )
                 ],
                 color: Colors.white
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
                      Icon(Icons.arrow_forward_ios, color:Colors.green, size:20,),

                       ]
                     )
                   ), 
                    )),
            


      ],
      ),
      )
    );
    
  }


}