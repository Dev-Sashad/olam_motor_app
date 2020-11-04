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
  String _email= '', _password= '', _name='', _surname='', _portfolio='';
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

//dialoge to show user already exist
  void _useralreadyexistDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Image.asset('assets/notsuccessful.png',),
          content: new Text(" email already exist \n kindly login to your account"),
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

// dialoge to show verify email is sent
  void _showVerifyEmailSentDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Image.asset('assets/successful.png',),
          content: new Text("Kindly verify your account \n Link to verify account has been sent to your email"),
          actions: <Widget>[
            new FlatButton(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
              color: Colors.green,
              child: new Text("goto LOGIN", style: TextStyle(color:Colors.white, fontSize:15),),
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
  //Create user
if (validate()){
  _loadingDialog();
     auth.signUp(_email, _password).then((value) async {
          if(value != null){
                User user = FirebaseAuth.instance.currentUser;
                user.sendEmailVerification();
                print('Signed up user: $value');
              userIdentity= value.user.uid;
               print('Signed up user: $userIdentity');
             checkSession().then((value){  
             FirebaseFirestore.instance.collection('users').doc(userIdentity)
             .set({'name':_name,'surname':_surname,'email':_email,'password':_password, 'portfolio': _portfolio});
              _showVerifyEmailSentDialog();
});
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
                              Text('Create Account', style: TextStyle( fontSize: 20, fontWeight:FontWeight.w200, color: Colors.green)),
                              SizedBox( height:10,),
                              Text('Making work easier, faster and smarter. No stress, No fuzz', style: TextStyle( fontSize:10,
                              color: Colors.black)),
                            
                              SizedBox( height:15,),

                               Form(key:formKey,
               
                              child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                    container(
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

                                    container(
                                      TextFormField(
                                        decoration: buildSignupInputDecoration(
                                          Icon(null),
                                          'name',
                                          // ignore: missing_required_param
                                          IconButton(icon: Icon(null))
                                        ),
                                        validator: nameValidator,
                                        onSaved: (value) {
                                       return _portfolio = value;
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
                                       return _name = value;
                                       }
                                        )                            
                                    ),

                                    SizedBox(height:10) ,
                                  
                                  container(
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

                              FlatButton(onPressed:(){
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

}