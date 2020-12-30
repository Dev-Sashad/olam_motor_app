import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';  
import 'package:motorapp/login_signup/resign_in.dart';
import 'package:shimmer/shimmer.dart';
import 'login_signup/firstpage.dart';


void main() async {
WidgetsFlutterBinding.ensureInitialized();
 await Firebase.initializeApp();
 Timer(Duration (seconds: 4 ), (){
 return runApp(MyApp()
 );
 });
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application. 
  @override
 Widget build(BuildContext context) {

   return MaterialApp(
    debugShowCheckedModeBanner: false,
     home: MainPage()
  );
 }

}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  @override
  void initState() {
    checkSession().then((value){
    if  (value){
      FirebaseAuth.instance.authStateChanges().listen((User user) async {
        if(user != null){
      _navigatetoResignin();              
        } 

    else{
      _navigatetoFirstPage();
    }
      });
      
    }
    }
    );

    super.initState();
  }

  Future <bool> checkSession() async {
    await Future.delayed(Duration(milliseconds: 5000), (){});
    return true;
  }

void _navigatetoFirstPage(){
  Navigator.pushReplacement(context,
    MaterialPageRoute(builder: (BuildContext context)=>FirstPage())
  );
}

void _navigatetoResignin(){
  Navigator.pushReplacement(context,
    MaterialPageRoute(builder: (BuildContext context)=>ResigninPage())
  );
}

  @override
  Widget build(BuildContext context) {
   
   return Scaffold(
     backgroundColor: Colors.white,

    body: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/olam.png',
            height: MediaQuery.of(context).size.height*0.3,
            width: MediaQuery.of(context).size.width*0.4,
            ),

        ],),

        SizedBox(height: 20),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
              children:[

            Shimmer.fromColors(child:Text('OLAM',style: TextStyle(
                      fontSize:40 , fontFamily: 'Pacifico', fontWeight: FontWeight.w700), ),
                       baseColor: Colors.green[600],
                        highlightColor: Colors.greenAccent[100] ),
                  
                 SizedBox(width: 5),

           Shimmer.fromColors(child:Text('MOTOR',style: TextStyle(
                      fontSize:40 , fontFamily: 'Pacifico', fontWeight: FontWeight.w700),),
                       baseColor: Colors.green[600],
                        highlightColor: Colors.greenAccent[100]),

                   SizedBox(width: 5),

          Shimmer.fromColors(child:Text('APP',style: TextStyle(
                      fontSize:40 , fontFamily: 'Pacifico', fontWeight: FontWeight.w700), ),
                       baseColor: Colors.green,
                        highlightColor: Colors.greenAccent[100] ),

              ]
          )

      ],

    ),
   );


  }
  
  
}
