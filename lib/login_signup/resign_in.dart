import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:motorapp/homepage/homepage.dart';
import 'package:motorapp/login_signup/forgetpassword.dart';
import 'package:motorapp/login_signup/sign_in.dart';
import 'package:motorapp/services/authentication.dart';

class ResigninPage extends StatefulWidget {
  @override
  ResigninPageState createState() => ResigninPageState();
}

class ResigninPageState extends State<ResigninPage> {
  final formKey = GlobalKey<FormState>();
   final BaseAuth auth= Auth();
 var _email= ' ', _password= ' ', name=' ',surname=' ',portfolio=' ', _image;
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

//delay loading
 Future <bool> checkSession() async {
    await Future.delayed(Duration(milliseconds: 5000), (){});
    return true;
 }


// loadng dialoge
Future <void> _loadingDialog() {
   return showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          backgroundColor: Colors.transparent,
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
               Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context)=>ResigninPage()));
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
          content: new Text("Incorrect Password",textAlign: TextAlign.center),
          titlePadding: EdgeInsets.all(0),
          contentPadding: EdgeInsets.all(5),
          actionsPadding: EdgeInsets.symmetric(horizontal:20),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Dismiss"),
              onPressed: () {             
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context)=>ResigninPage()));
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


  void logOut() async{
        await FirebaseAuth.instance.signOut();
                 Navigator.of(context).pushReplacement(
    MaterialPageRoute(builder: (BuildContext context)=>SigninPage()));
  
  }

void submit() async {
   if (validate()){
     _loadingDialog();
     checkSession().then((value) {
    auth.signIn(_email, _password).catchError((error) {    
      if (error.code == 'user-not-found') {
    print('No user found for this email.');
        _showwrongCredentialsDialog();
  } else if (error.code == 'wrong-password') {
    print('Wrong password provided for that user.');
    _showwrongPasswordDialog();
  }
  }).then((result) async {
               
              Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (BuildContext context)=>Homepage())
           );
         
  });
     });        
  }
}

 
@override
  void initState() {
    _passwordVisible = true;

      //to get User Details
        User user = FirebaseAuth.instance.currentUser;
        userIdentity = user.uid;
        print('$userIdentity');
   
      FirebaseFirestore.instance.collection('users').doc(userIdentity).get().then((value){
     setState(() {
       userDetails = value;
      });

      if (userDetails != null){  
        surname = userDetails.data()['surname'].toString();
        name = userDetails.data()['name'].toString();
        portfolio = userDetails.data()['portfolio'].toString();
        _email= userDetails.data()['email'].toString();
   }

   });

   
          setState(() {
            _image = user.photoURL;
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
                    decoration: BoxDecoration(
                                  color: Colors.white
                                  ),               
                    child: Column(
                        children: [
                    
                          Container(
                              margin: EdgeInsets.only(top:10),
                              height: MediaQuery.of(context).size.height*0.4,
                          
                         child:    Align(
                  alignment: Alignment.center,
                  child:CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 80,
                    child: ClipOval(
                     child: SizedBox(
                       width:150,
                       height:150,
                      child: (_image !=null)? Image.network(_image,fit:BoxFit.cover,loadingBuilder:(BuildContext context, Widget child,ImageChunkEvent loadingProgress) {
  if (loadingProgress == null) return child;
    return Container(
      width: 100,
      alignment: Alignment.center,
      child: CircularProgressIndicator(
        strokeWidth: 2.0,
      value: loadingProgress.expectedTotalBytes != null ? 
             loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes
             : null,
      ),
    );
  },): 
                   Image.asset('assets/user.png',fit:BoxFit.fill, color: Colors.blueGrey,),

                     ),
                    ),
                  )
                  ),
                         ),

                        Expanded(
                          child:Container(
                            color: Colors.white,
                          child: Padding(padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                                Column(
                                  children:[                          
                
                     Text('Welcome Back!', style:TextStyle(fontWeight: FontWeight.bold, fontSize:20, color:Colors.black)),
                            
                           SizedBox(height:10),
                      
                        Text(portfolio.toString(), style:TextStyle(fontWeight: FontWeight.bold, fontSize:15, color:Colors.green)), 
                             SizedBox(height:5),      
                             Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                     
                    Text(surname.toString(), style:TextStyle(fontWeight: FontWeight.bold, fontSize:20, color:Colors.green)),
                     SizedBox(width:5),
                    Text(name.toString(), style:TextStyle(fontWeight: FontWeight.bold, fontSize:20, color:Colors.green)),
                    ],
                  ),

                          ] ),
                              SizedBox( height:10,),
                          

                               Form(key:formKey,
               
                              child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [  
                                  Text('Enter your password', style: TextStyle( fontSize:15,
                              color: Colors.black)),
                            
                              SizedBox( height:5,),               
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
                                            Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (BuildContext context)=>ForgetPasswordPage()));
                                       }, 
                        child:Text('Forgot Password ?', style: TextStyle( color:Colors.white, fontSize:15),),
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
        

                  Align(
                    alignment: Alignment.bottomCenter,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children:[
                       Container(
                     
                     alignment: Alignment.bottomLeft,
                height:  MediaQuery.of(context).size.height*0.12,
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
     fontSize: 15,
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
  margin: EdgeInsets.symmetric(horizontal:20, vertical:30),
                child: Material(
                  borderRadius: BorderRadius.circular(5),
                  shadowColor: Colors.grey,
                  color: Colors.blueGrey,
                  elevation: 3.0,
                  child: child,
                    )
              );
}

}

class CustomMenuClipper extends CustomClipper <Path>{
  @override
  Path getClip(Size size) {

    Path path = Path();
    path.moveTo(0, 0);
    path.lineTo(0.0, size.height/1.9);
    path.lineTo(size.width +125, 0.0);
    path.close();
      return path;
    }
  
    @override
    bool shouldReclip(CustomClipper<Path> oldClipper) {
  return true;
  }
}