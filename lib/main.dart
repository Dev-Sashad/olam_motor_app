import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';  
import 'package:motorapp/login_signup/resign_in.dart';
import 'package:shimmer/shimmer.dart';
import 'login_signup/firstpage.dart';


void main() async {
WidgetsFlutterBinding.ensureInitialized();
 await Firebase.initializeApp();
 return runApp(MyApp());
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
    await Future.delayed(Duration(milliseconds: 8000), (){});
    return true;
  }

void _navigatetoFirstPage(){
  Navigator.of(context).pushReplacement(
    MaterialPageRoute(builder: (BuildContext context)=>FirstPage())
  );
}

void _navigatetoResignin(){
  Navigator.of(context).pushReplacement(
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
            height: MediaQuery.of(context).size.height*0.2,),

            SizedBox(width: 20),

            Shimmer.fromColors(child:Text('OLAM',style: TextStyle(
                      fontSize:50 , fontFamily: 'Pacifico', fontWeight: FontWeight.w700), ),
                       baseColor: Colors.green[600],
                        highlightColor: Colors.greenAccent[100] ),
        ],),

        SizedBox(height: 20),

          Row(
              children:[
           Shimmer.fromColors(child:Text('MOTOR',style: TextStyle(
                      fontSize:30 , fontFamily: 'Pacifico', fontWeight: FontWeight.w700),),
                       baseColor: Colors.green[600],
                        highlightColor: Colors.greenAccent[100]),

          Shimmer.fromColors(child:Text('APP',style: TextStyle(
                      fontSize:30 , fontFamily: 'Pacifico', fontWeight: FontWeight.w700), ),
                       baseColor: Colors.green,
                        highlightColor: Colors.greenAccent[100] ),

              ]
          )

      ],

    ),
   );


  }
  
  
}
