import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:motorapp/login_signup/sign_in.dart';
import 'package:motorapp/services/authentication.dart';


class SignupPage extends StatefulWidget {


  @override
  SignupPageState createState() => SignupPageState();
}

class SignupPageState extends State<SignupPage> {
  final BaseAuth auth= Auth();
  final formKey = GlobalKey<FormState>();
  bool _passwordVisible;
  String _email= 'email', _password= '', _name='name', _surname='', _portfolio='';
  var userIdentity;


  //name and surname validator
  String nameValidator(String value) {
  
  RegExp upperCase = new RegExp(r'[A-Z]');
 

  if (!upperCase.hasMatch(value)) {
    return 'Item name should start with caps';
  }
  
  else if (value.isEmpty){
     return 'enter item name';
  }
   else 
    return null;
}

//email validator
 String emailValidator(String value) {
  Pattern pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp regex = new RegExp(pattern);
  if (!regex.hasMatch(value)) {
    return 'email format is invalid';
  }
  
  else if (value.isEmpty){
     return 'enter email';
  }
   else 
    return null;
  
}

//delay loading
 Future <bool> checkSession() async {
    await Future.delayed(Duration(milliseconds: 5000), (){});
    return true;
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
Future <void> _loadingDialog() {
   return showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          backgroundColor: Colors.white10,
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

//dialoge to show user already exist
  void _useralreadyexistDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Image.asset('assets/notsuccessful.png',),
          content: new Text(" email already exist \n kindly login to your account",textAlign: TextAlign.center),
          titlePadding: EdgeInsets.all(0),
          contentPadding: EdgeInsets.all(5),
          actionsPadding: EdgeInsets.symmetric(horizontal:20),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Dismiss"),
              onPressed: () {             
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context)=>SignupPage()));
              },
            ),
          ],
        );
      },
    );
  }

// dialoge to show verify email is sent
  void _showVerifyEmailSentDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Image.asset('assets/successful.png',),
          content: new Text("Kindly verify your account \nLink to verify account has been sent to your email",
          textAlign: TextAlign.center),
          titlePadding: EdgeInsets.all(0),
          contentPadding: EdgeInsets.all(5),
          actionsPadding: EdgeInsets.symmetric(horizontal:20),
          actions: <Widget>[
            new FlatButton(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
              color: Colors.green,
              child: new Text("goto LOGIN", style: TextStyle(color:Colors.white, fontSize:15),),
              onPressed: () {             
               Navigator.pushReplacement(context,
    MaterialPageRoute(builder: (BuildContext context)=>SigninPage())
  );
              },
            ),
          ],
        );
      },
    );
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
  //Create user
if (validate()){
  _loadingDialog();
      checkSession().then((value) {
     auth.signUp(_email, _password).then((value) async {
          if(value != null){
                User user = FirebaseAuth.instance.currentUser;
                user.updateProfile(displayName: _name).then((value) => user.sendEmailVerification());
                print('Signed up user: $value');
                
              userIdentity= value.user.uid;
               print('Signed up user: $userIdentity');
             FirebaseFirestore.instance.collection('users').doc(userIdentity)
             .set({'name':_name,'surname':_surname,'email':_email,'password':_password, 'portfolio': _portfolio});
              _showVerifyEmailSentDialog();
          }
    }).catchError((msg) {
      if (msg.code == 'weak-password') {
    print('The password provided is too weak.');
  } else 
    if(msg.code == 'email-already-in-use') {
      print('user already exist');
       _useralreadyexistDialog();  
  }
    }); 
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
    backgroundColor: Colors.white,
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
                            height: MediaQuery.of(context).size.height*0.3,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(5) , bottomRight: Radius.circular(5))
                            ),
                            child: Image.asset('assets/olamimage.png', height: MediaQuery.of(context).size.height*0.3,
                              width: MediaQuery.of(context).size.width,
                             ),

                          ),

                          SizedBox( height:10,),

                        Expanded(
                         child:Container(
                          color: Colors.white,
                          child: Padding(padding: EdgeInsets.symmetric(horizontal: 15),
                          child: Column(
                            children: [
                              Align(
                              alignment: Alignment.topLeft,
                              child:Text('Create Account', style: TextStyle( fontSize: 30, fontWeight:FontWeight.w600, color: Colors.green),
                              textAlign:TextAlign.left
                              )
                              ),

                              SizedBox( height:10,),

                              Align(
                              alignment: Alignment.topLeft,
                              child:Text('Making work easier, faster and smarter. No stress, No fuzz', style: TextStyle( fontSize:13,
                              color: Colors.black),textAlign:TextAlign.left),
                              ),
                              
                            
                              SizedBox( height:10,),

                               Form(key:formKey,
               
                              child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                    details(
                                       TextFormField(
                                        decoration: buildSignupInputDecoration(
                                          Icon(null),
                                          'surname',
                                          // ignore: missing_required_param
                                          IconButton(icon: Icon(null))
                                        ),
                                        validator: nameValidator,
                                        onSaved: (value) {
                                       return _surname = value;
                                       }
                                        )     
                                    ),

                                    details(
                                      TextFormField(
                                        decoration: buildSignupInputDecoration(
                                          Icon(null),
                                          _name,
                                          // ignore: missing_required_param
                                          IconButton(icon: Icon(null))
                                        ),
                                        validator: nameValidator,
                                        onSaved: (value) {
                                       return _name = value;
                                       }
                                        )                            
                                    )
                                  ],),

                                 SizedBox(height:10) ,

                                 container(
                                      TextFormField(
                                        decoration: buildSignupInputDecoration(
                                          Icon(null),
                                          'example: Electrical Engineer',
                                          // ignore: missing_required_param
                                          IconButton(icon: Icon(null))
                                        ),
                                        validator: nameValidator,
                                        onSaved: (value) {
                                       return _portfolio= value;
                                       }
                                        )                            
                                    ),

                                    SizedBox(height:10) ,
                                  
                                  container(
                             TextFormField(
                                        decoration: buildSignupInputDecoration(
                                          Icon(Icons.mail, color: Colors.green,),
                                          _email,
                                          // ignore: missing_required_param
                                          IconButton(icon: Icon(null))
                                        ),
                                        validator: emailValidator,
                                        onSaved: (value) {
                                       return _email = value;
                                       }
                                  ),
                                  ),

                             SizedBox(height:10) ,            

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

                              SizedBox(height:20) ,

                              
                            ]    
                           ),
                         ),

                            ],
                          )
                          )
                          
                          ),
                        ),
        

                  Align(
                      alignment: Alignment.bottomCenter,
                child: Column(
                  children: [
                        Container(
                          color: Colors.white,
                             padding:EdgeInsets.fromLTRB(20,0,20,10),
                              child:FlatButton(onPressed:(){
                                 _loadingDialog();
                                            auth.signInWithGoogle().then((value) { 
                                              User user = FirebaseAuth.instance.currentUser;
                                               _email = user.email.toString();
                                               _name = user.displayName.toString();
                                          
                                            });
                                  } ,
                        child: Row(
                               mainAxisAlignment: MainAxisAlignment.center,
                           children: [
                             Text('Sign in with Google', style: TextStyle( color:Colors.black, fontSize:15),),
                                 SizedBox(width: 5,),
                             Image.asset('assets/google.png', height:15,)
                        ],)
                              )
                  ), 
                         
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children:[
                       Container(
                     
                     alignment: Alignment.bottomLeft,
                height:  MediaQuery.of(context).size.height*0.12,
                width:  MediaQuery.of(context).size.width*0.5,
                child: FlatButton(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
                  color: Colors.green,
                    onPressed: submit,
                   child: Center(
                     child: Row(
                     mainAxisAlignment: MainAxisAlignment.center,
                       children: <Widget>[
                     Text('SIGN UP',
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
    MaterialPageRoute(builder: (BuildContext context)=>SigninPage())
  );

        });
       
      }, 
      child: Center(
        child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
        Text('Already have an account?', style: TextStyle(color: Colors.grey, fontSize: 15,),),
        SizedBox(height:5),
         Text('Login', style: TextStyle(color: Colors.green, fontSize: 15,),),
        ]
        )
          ),
         ) 
         )

                  ]  
                ),
                  ]
                )
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
     fontSize: 15,
      fontFamily: 'Montserrat',
      color: Colors.grey,
      ),     
      border: InputBorder.none
      );

}

Container container (TextFormField child){
return Container(
          margin: EdgeInsets.symmetric(horizontal:10),
          width:MediaQuery.of(context).size.width,
          height: 50,
          decoration: BoxDecoration(
            color:Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow:[
              BoxShadow(color: Colors.black12,   blurRadius: 4),
            
            ]
          ),
                child: child
              );
}

Container details (TextFormField child){
return Container(
          width:150,
          height: 50,
          decoration: BoxDecoration(
            color:Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow:[
              BoxShadow(color: Colors.black12,   blurRadius: 4),
            
            ]
          ),
                child: child
              );
}

}