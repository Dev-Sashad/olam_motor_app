import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:motorapp/login_signup/sign_in.dart';
import 'package:motorapp/login_signup/sign_up.dart';
import 'package:motorapp/services/authentication.dart';

class ForgetPasswordPage extends StatefulWidget {


  @override
  ForgetPasswordState createState() => ForgetPasswordState();
}

class ForgetPasswordState extends State<ForgetPasswordPage> {
  final formKey = GlobalKey<FormState>();
   final BaseAuth auth= Auth();
  String _email= '';
  


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

// dialoge of wrong email
   void _showwrongCredentialsDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Image.asset('assets/notsuccessful.png',),
          content: new Text("Invalid Credentials \nkindly provide valid details",textAlign: TextAlign.center),
          titlePadding: EdgeInsets.all(0),
          contentPadding: EdgeInsets.all(5),
          actionsPadding: EdgeInsets.symmetric(horizontal:20),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Dismiss"),
              onPressed: () {             
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context)=>ForgetPasswordPage()));
              },
            ),
          ],
        );
      },
    );
  }

  //delay loading
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

//forgot password dialoge
 void _showforgotPasswordDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Image.asset('assets/successful.png',),
          content: new Text("Link to reset password has been sent to this mail \n kindly login to your mail"),
          titlePadding: EdgeInsets.all(0),
          contentPadding: EdgeInsets.all(5),
          actionsPadding: EdgeInsets.symmetric(horizontal:20),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Dismiss"),
              onPressed: () {             
                Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (BuildContext context)=>SigninPage()));
              },
            ),
          ],
        );
      },
    );
  }

Future<void> submit() async {
   if (validate()){
     _loadingDialog();

     checkSession().then((value) async {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: _email).then((value) {
                     return _showforgotPasswordDialog();       
                  }
                  ).catchError((error) {    
      if (error.code == 'user-not-found') {
    print('No user found for this email.');
        _showwrongCredentialsDialog();
  } 

  });

   });   
  

  }
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
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text('Forgot Password', style: TextStyle( fontSize: 20, fontWeight:FontWeight.w200, color: Colors.green)),
                              SizedBox( height:10,),
                              Text('Making work easier, faster and smarter. No stress, No fuzz', style: TextStyle( fontSize:10,
                              color: Colors.black)),
                            
                              SizedBox( height:15,),

                               Form(key:formKey,
               
                              child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(height:50),
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

                              SizedBox(height:40),

                            flatbutton(
                              FlatButton(onPressed: (){
                                         submit();
                                       }, 
                        child:Text('Reset Password', style: TextStyle( color:Colors.white, fontSize:15),),
                  ),
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
      border: InputBorder.none
      );

}

Container container (TextFormField child){
return Container(  
  margin: EdgeInsets.symmetric(horizontal:20),
  width: MediaQuery.of(context).size.width,
  height: 50,            
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
  width: MediaQuery.of(context).size.width*0.6,
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