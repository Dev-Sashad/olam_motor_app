import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:motorapp/bloc.navigation_bloc/navigation_bloc.dart';



class ResetPasswordpage extends StatefulWidget with NavigationStates {  
  @override

  ResetPasswordpageState createState() => ResetPasswordpageState();
}

class ResetPasswordpageState extends State<ResetPasswordpage> {
final formKey = GlobalKey<FormState>();
String  getoldPassword,oldPassword, newPassword;
DocumentSnapshot userDetails;
var userIdentity;



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


 void _passwordSucessfullyChanged() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Image.asset('assets/successful.png', height:80 , width:80),
          content: new Text("Password successfully changed \nThank you",textAlign: TextAlign.center),
          titlePadding: EdgeInsets.all(0),
          contentPadding: EdgeInsets.all(5),
          actionsPadding: EdgeInsets.symmetric(horizontal:20),
          actions: <Widget>[
            flatbutton(
            FlatButton(
              child: new Text("Go to Homepage", style: TextStyle(fontSize:20, color:Colors.white),),
              onPressed: () {             
                  Navigator.pop(context);
              },
            ),
            )
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



void _passwordNotSucessfullyChanged() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Image.asset('assets/notsuccessful.png',height:80 , width:80),
          content: new Text("Wrong old password",textAlign: TextAlign.center),
          titlePadding: EdgeInsets.all(0),
          contentPadding: EdgeInsets.all(5),
          actionsPadding: EdgeInsets.symmetric(horizontal:20),
          actions: <Widget>[
             flatbutton(
            FlatButton(
              child: new Text("Dismiss", style: TextStyle(fontSize:20, color:Colors.white),),
              onPressed: () {             
               //authFormType = AuthFormType.signIn;
               Navigator.pop(context);
               // loading=false;
              },
            ),
             )
          ],
        );
      },
    );
  }

void initState()  {

 userIdentity= FirebaseAuth.instance.currentUser.uid;
     print('$userIdentity');
  FirebaseFirestore.instance.collection('users').doc(userIdentity).get().then((value){
      setState(() {
       userDetails = value;
      });

      if (userDetails!=null){  
        getoldPassword = userDetails.data()['password'].toString();
   }
     
});
 super.initState();
}



  @override
  Widget build(BuildContext context) {
   return Scaffold(
          appBar: AppBar(
          automaticallyImplyLeading: false,
           shadowColor: Colors.black12,
        backgroundColor: Colors.white,
        title: 
          Text('Change Password',textAlign:TextAlign.center, 
          style:TextStyle(color: Colors.green, fontSize:25),),
        centerTitle: true,
      ),

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
          
        Form(key:formKey,
        child: Column(
        children: <Widget>[

           SizedBox(height:50),
          container(
          TextFormField(decoration: buildSignupInputDecoration('old password'),
          
          onChanged: (value){
            this.oldPassword = value;
          },
          
          validator: passwordValidator,
          ),
          ),

          SizedBox(height:15),

          container(
          TextFormField(decoration: buildSignupInputDecoration('new password'),

               validator: passwordValidator,
          onChanged: (value){
              this.newPassword = value;       
          },),
          ),
        ]
        )
        ),

             SizedBox(height:40),

            flatbutton(
             FlatButton(onPressed:() {
              if(validate()){
                    _loadingDialog();
                checkSession().then((value) async {
            if(getoldPassword != oldPassword){
              _passwordNotSucessfullyChanged();
            }
            else{
           
                 DocumentReference documentReference = FirebaseFirestore.instance.collection('users').doc(userIdentity);
                  FirebaseFirestore.instance.runTransaction((Transaction transaction) async{

                transaction.update(documentReference, {
                "password": newPassword, 
                });    
            });
               await FirebaseAuth.instance.currentUser.updatePassword(newPassword).then((value){
                  BlocProvider.of<NavigationBloc>(context).add(NavigationEvents.ResetPasswordClickedEvent);
                      _passwordSucessfullyChanged();  
                });                
           
            }
              });
              }          
        },
      child: Text('Change Password', style: TextStyle(fontSize:20, color:Colors.white),)
      )
            )
        ]
      ),
         )
         )
          )
          );
      }
        )
   );
  }
  
  InputDecoration buildSignupInputDecoration(  String hint) {
return InputDecoration(
     hintText: hint,
     hintStyle: TextStyle( 
     fontSize: 17,
      fontFamily: 'Montserrat',
      color: Colors.grey,
      ), 
      contentPadding: EdgeInsets.symmetric(horizontal:20),   
      border: InputBorder.none
      );

}

Container container (TextFormField child){
return Container(
  height: 50,
        margin: EdgeInsets.symmetric(horizontal:20),
     //   padding: EdgeInsets.symmetric(horizontal:20),
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
  width: MediaQuery.of(context).size.width*0.6,
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