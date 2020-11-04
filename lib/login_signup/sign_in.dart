import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:motorapp/homepage/homepage.dart';
import 'package:motorapp/login_signup/forgetpassword.dart';
import 'package:motorapp/login_signup/sign_up.dart';
import 'package:motorapp/services/authentication.dart';

class SigninPage extends StatefulWidget {


  @override
  SigninPageState createState() => SigninPageState();
}

class SigninPageState extends State<SigninPage> {
  final formKey = GlobalKey<FormState>();
   final BaseAuth auth= Auth();
  bool _passwordVisible;
  String _email= '', _password= '';
  


//email validator
 String emailValidator(String value) {
  Pattern pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp regex = new RegExp(pattern);
  if (!regex.hasMatch(value)) {
    return 'Email format is invalid';
  }
  
  else if (value.isEmpty){
     return 'enter email';
  }
   else 
    return null;
  
}

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

// dialoge od email not verified
  void _showVerifyEmailDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Image.asset('assets/successful.png',),
          content: new Text(" Email is not verified \n kindly login to your mail for verification"),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Dismiss"),
             onPressed: () {             
               Navigator.of(context).pushReplacement(
    MaterialPageRoute(builder: (BuildContext context)=>SigninPage())
  );
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
                 User user = FirebaseAuth.instance.currentUser;
               if(!user.emailVerified){
                 user.sendEmailVerification();
                 FirebaseAuth.instance.signOut();
                    _showVerifyEmailDialog();
                }          
             else{  
              Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (BuildContext context)=>Homepage())
           );
                } 

          }});
  });        
  }
}

@override
  void initState() {
    _passwordVisible = true;
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
                            children: [
                              Text('Login', style: TextStyle( fontSize: 20, fontWeight:FontWeight.w200, color: Colors.green)),
                              SizedBox( height:10,),
                              Text('Making work easier, faster and smarter. No stress, No fuzz', style: TextStyle( fontSize:10,
                              color: Colors.black)),
                            
                              SizedBox( height:15,),

                               Form(key:formKey,
               
                              child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                                  
                             TextFormField(
                                        decoration: buildSignupInputDecoration(
                                          Icon(Icons.mail, color: Colors.grey,),
                                          'email',
                                          // ignore: missing_required_param
                                          IconButton(icon: Icon(null))
                                        ),
                                        validator: emailValidator,
                                        onSaved: (value) {
                                       return _email = value;
                                       }
                                  ),

                             SizedBox(height:10) ,            

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

                              SizedBox(height:20) ,

                            Row(
                              mainAxisSize: MainAxisSize.max,
                              children:[

                                       FlatButton(onPressed: (){
                                         auth.signInWithGoogle();
                                       }, 
                        child: Row(
                               mainAxisAlignment: MainAxisAlignment.center,
                           children: [
                             Text('Sign in with Google', style: TextStyle( color:Colors.black, fontSize:15),),
                                 SizedBox(width: 5,),
                             Image.asset('assets/google.png',)
                        ],)

                  ),

                          FlatButton(onPressed: (){
                              Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (BuildContext context)=>ForgetPasswordPage()));

                          }, 
                        
                          child:Text('Forgot password?', style: TextStyle( color:Colors.green, fontSize:15),),
                              ),

                              ]
                            )                   
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
                      submit();
                    },
                   child: Center(
                     child: Row(
                     mainAxisAlignment: MainAxisAlignment.center,
                       children: <Widget>[
                     Text('SIGN IN',
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
      onPressed: (){
        setState(() {
                  Navigator.of(context).pushReplacement(
    MaterialPageRoute(builder: (BuildContext context)=>SignupPage())
  );

        });
       
      }, 
      child: Center(
        child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
        Text('New User?', style: TextStyle(color: Colors.grey, fontSize: 15,),),
        SizedBox(height:5),
         Text('Create New Account', style: TextStyle(color: Colors.green, fontSize: 15,),),
        ]
        )
          ),
         ) 
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
      enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey, width:1.0), 
      borderRadius: BorderRadius.circular(5),),
      );

}


}