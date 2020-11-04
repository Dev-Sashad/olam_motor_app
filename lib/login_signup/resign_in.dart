import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:motorapp/homepage/homepage.dart';
import 'package:motorapp/login_signup/sign_in.dart';
import 'package:motorapp/services/authentication.dart';

class ResigninPage extends StatefulWidget {
  @override
  ResigninPageState createState() => ResigninPageState();
}

class ResigninPageState extends State<ResigninPage> {
  final formKey = GlobalKey<FormState>();
   final BaseAuth auth= Auth();
 String _email= '', _password= '';
 var name,surname,portfolio;
 bool _passwordVisible;
var userIdentity;
DocumentSnapshot userDetails;


//password validator

String passwordValidator(String value) {
  
  RegExp lowerCase = new RegExp(r'[a-z]');
  RegExp digit = new RegExp(r'[0-9]');

  if (!lowerCase.hasMatch(value)) {
    return 'Password should contain figure and letters';
  }

  if (!digit.hasMatch(value)) {
    return 'Password should contain figure and letters';
  }
  
  else if (value.length < 8){
     return 'password should contain 8 characters';
  }
   else 
    return null;
  
}



// loadng dialoge
void _loadingDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          backgroundColor: Colors.transparent,
          title: new Text(""),
          content: Container(
            height: MediaQuery.of(context).size.height*0.15,
          child:SpinKitFadingCube(
        color: Colors.green[300],
        size: 50,
       // duration: Duration(milliseconds:3000),
      ),
          )
        );
      },
    );
  }

// dialoge of wrong email
   void _showwrongCredentialsDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Image.asset('assets/notsuccessful.png',),
          content: new Text("Invalid Credentials \n kindly provide valid details"),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Dismiss"),
              onPressed: () {             
               Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

//dialoge of wrong password
  void _showwrongPasswordDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Image.asset('assets/notsuccessful.png',),
          content: new Text("Incorrect Password"),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Dismiss"),
              onPressed: () {             
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }




//to delay the loading befor next ation
 Future <bool> checkSession() async {
    await Future.delayed(Duration(milliseconds: 5000), (){});
    return true;
 }

//validate all conditions in the form 
bool validate(){

   final form = formKey.currentState;
   if(form.validate()){
     form.save();
     return true;
   }
   else{
     return false;
   }
 }


  void logOut() async{
        await FirebaseAuth.instance.signOut();
                 Navigator.of(context).pushReplacement(
    MaterialPageRoute(builder: (BuildContext context)=>SigninPage())
  );
  
  }

void submit() async {
   if (validate()){
     _loadingDialog();
    auth.signIn(_email, _password).catchError((error) {    
      if (error.code == 'user-not-found') {
    print('No user found for this email.');
        _showwrongCredentialsDialog();
  } else if (error.code == 'wrong-password') {
    print('Wrong password provided for that user.');
    _showwrongPasswordDialog();
  }
  }).then((result) async {      
          checkSession().then((value) async {
                if (value){
               
              Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (BuildContext context)=>Homepage())
           );
          }});
  });        
  }
}

 
@override
  Future<void> initState() async {
    _passwordVisible = true;

      //to get User Details
        userIdentity= FirebaseAuth.instance.currentUser.uid;
        print('$userIdentity');
   await FirebaseFirestore.instance.collection('users').doc(userIdentity).get().then((value){
     setState(() {
       userDetails = value;
      });
  if (userDetails!=null){  
        surname = userDetails.data()['surname'].toString();
        name = userDetails.data()['name'].toString();
        portfolio = userDetails.data()['portfolio'].toString();
        _email= userDetails.data()['email'].toString();
   }
   else
    name= null;
    surname = null;
    
   });
 
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
  
  return Scaffold(
    body: LayoutBuilder(
      builder: (ctx, constrains){
        return Scaffold(
          body: Container(
        height: constrains.maxHeight,
        child:SingleChildScrollView(
         child: Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,               
                    child: Column(
                        children: [
                          Container(
                            height: MediaQuery.of(context).size.height*0.35,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(5) , bottomRight: Radius.circular(5))
                            ),
                            child: Image.asset('assest/olamimage.png', height: MediaQuery.of(context).size.height*0.35,
                              width: MediaQuery.of(context).size.width,
                             ),

                          ),

                          SizedBox( height:10,),

                        Expanded(
                          child:Container(
                            color: Colors.white,
                          child: Padding(padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                                Column(
                                  children:[
                          Text('Welcome Back!', style:TextStyle(fontWeight: FontWeight.bold, fontSize:20, color:Colors.black)),
                              SizedBox(height:5),
                             Row(
                    children: [
                      SizedBox(width:5),
                    Text(surname, style:TextStyle(fontWeight: FontWeight.bold, fontSize:20, color:Colors.green)),
                    Text(name, style:TextStyle(fontWeight: FontWeight.bold, fontSize:20, color:Colors.green)),
                    ],
                  ),

                          SizedBox(height:5),
                        Text(portfolio, style:TextStyle(fontWeight: FontWeight.bold, fontSize:20, color:Colors.green)), 
                                   ] ),
                              SizedBox( height:10,),
                              Text('Enter your password', style: TextStyle( fontSize:20,
                              color: Colors.black)),
                            
                              SizedBox( height:15,),

                               Form(key:formKey,
               
                              child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [                 
                             container(
                             TextFormField(
                      decoration: buildSignupInputDecoration(
                      Icon(Icons.lock,color: Colors.green,),
                                'Password',
                          IconButton(
                                   icon: Icon(
              // Based on passwordVisible state choose the icon
                      _passwordVisible
                     ? Icons.visibility
                      : Icons.visibility_off,
                     color: Colors.grey,
                          ),
            onPressed: () {
               // Update the state i.e. toogle the state of passwordVisible variable
               setState(() {
                   _passwordVisible = !_passwordVisible;
               });
             },
            ),
                  ),
                            validator: passwordValidator,
                         obscureText: _passwordVisible,
                          onSaved: (value) {
                                 return _password = value;
                          }
                            ),
                              ),

                            flatbutton(
                            FlatButton(onPressed: (){
                                         submit();
                                       }, 
                        child:Text('Password Reset', style: TextStyle( color:Colors.white, fontSize:15),),
                  ),
                            ),
                                               
                            ]    
                           ),
                         ),

                            ],
                          )
                          )
                          
                          )
                        ),
        

             BottomAppBar(
             
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children:[
                       Container(
                     
                     alignment: Alignment.bottomLeft,
                height:  MediaQuery.of(context).size.height*0.15,
                width:  MediaQuery.of(context).size.width*0.5,
                child: FlatButton(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
                  color: Colors.green,
                    onPressed: (){
                      setState(() {
                  Navigator.of(context).pushReplacement(
    MaterialPageRoute(builder: (BuildContext context)=>SigninPage()));
                     });
                    },
                   child: Center(
                     child: Row(
                     mainAxisAlignment: MainAxisAlignment.center,
                       children: <Widget>[
                     Text('Login',
                     style: TextStyle(
                       color: Colors.white,
                       fontSize: 20,
                       fontWeight: FontWeight.bold,
                      fontFamily: 'Montserrat',
                     )),

                      SizedBox(width:5),

                      Icon(Icons.arrow_forward_ios, color:Colors.white, size:  20,),

                       ]
                     )
                   ), 
                    )
                   ),


                Container(
       alignment: Alignment.bottomRight,
      height: MediaQuery.of(context).size.height*0.12,
      width:  MediaQuery.of(context).size.width*0.5,
   child: FlatButton(
     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
     color: Colors.white,
      onPressed: logOut, 
      child: Center(
        child: 
        Text('Sign Out', style: TextStyle(color: Colors.grey, fontSize: 15,),
          textAlign:  TextAlign.center,
        ),      
        )
          ),
         )
                  ]  
                ),
              ), 

                        ],

                     )
                 )
               )
            )
        );

      }
      
      )

  );
  }

InputDecoration buildSignupInputDecoration( Icon prefixIcon, String hint, IconButton suffixIcon) {
return InputDecoration(
      
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
     hintText: hint,
     hintStyle: TextStyle( 
     fontSize: 10,
      fontFamily: 'Montserrat',
      color: Colors.grey,
      ),     
      border: InputBorder.none
      );

}

Container container (TextFormField child){
return Container(
                child: Material(
                  borderRadius: BorderRadius.circular(5),
                  shadowColor: Colors.grey,
                  color: Colors.white,
                  elevation: 2.0,
                  child: child,
                    )
              );
}

Container flatbutton (FlatButton child){
return Container(
  margin: EdgeInsets.symmetric(horizontal:20),
                child: Material(
                  borderRadius: BorderRadius.circular(5),
                  shadowColor: Colors.grey,
                  color: Colors.green,
                  elevation: 2.0,
                  child: child,
                    )
              );
}

}