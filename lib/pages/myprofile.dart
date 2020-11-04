import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:motorapp/bloc.navigation_bloc/navigation_bloc.dart';


enum AuthFormType {
  edit, notEdit
}

class MyProfilepage extends StatefulWidget with NavigationStates {

    final AuthFormType authFormType;
   MyProfilepage ({
   @required this.authFormType
});
 
 @override

  MyProfilepageState createState() => MyProfilepageState();
  
}

class MyProfilepageState extends State<MyProfilepage>{
  AuthFormType authFormType;
  MyProfilepageState ({this.authFormType});
  final formKey = GlobalKey<FormState>();
  final buttonKey = GlobalKey<FormState>();
  var userIdentity;
  DocumentSnapshot userDetails;
  File _image;

  var name,surname,portfolio, email;

  void switchFormState (state){
   formKey.currentState.reset();
   if  (state == 'edit'){
     setState(() {
      //loading=true;
       authFormType = AuthFormType.edit;
     });
   }
   else if (state == 'notEdit') {
     setState(() {
     // loading=true;
     authFormType = AuthFormType.notEdit;
     });
   }
 }

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

   void _showProfileUpdatedDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Image.asset('assets/successful.png',),
          content: new Text("Profile Updated"),
          actions: <Widget>[
            new FlatButton(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
              color: Colors.green,
              child: new Text("Dismiss", style: TextStyle(color:Colors.white, fontSize:15),),
              onPressed: () {             
               Navigator.of(context).pushReplacement(
    MaterialPageRoute(builder: (BuildContext context)=>MyProfilepage(authFormType:AuthFormType.notEdit))
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

  Future<void> uploadPic()  async {
        //String fileName= _image.path;
        StorageReference firebaseStorageRef  = FirebaseStorage.instance.ref().child(userIdentity);
        StorageUploadTask uploadTask = firebaseStorageRef.putFile(_image);
        await uploadTask.onComplete;
        setState(() {
            print('profile picture uploaded');

        });

       // var userInfo = FirebaseAuth.instance.currentUser.photoURL;
       // userInfo = _image;
      }

    Future getImage() async {
        // ignore: invalid_use_of_visible_for_testing_member
        var image = await ImagePicker.platform.pickImage(source: ImageSource.gallery);

        setState(() {
          _image = image as File;
          print('Image path$_image');
        });

      }

 @override
  Future<void> initState() async {
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
        email= userDetails.data()['email'].toString();
   }
   else
    name= null;
    surname = null;
    
   });
 
    super.initState();
  }
  
  
  @override
  Widget build(BuildContext context) {
      // ignore: missing_return
     // Future uploadPic(BuildContext context)  {
        //String fileName= _image.path;
      //  StorageReference firebaseStorageRef  = FirebaseStorage.instance.ref().child(userIdentity);
     //   StorageUploadTask uploadTask = firebaseStorageRef.putFile(_image);
     //   Future<StorageTaskSnapshot> taskSnapshot = uploadTask.onComplete;
      //  setState(() {
    //        print('profile picture uploaded');

     //   });
    //  }

    return Scaffold(
          appBar: AppBar(
        
        backgroundColor: Colors.green,
        title: 
          Text('Edit Profile',textAlign:TextAlign.center, 
          style:TextStyle(color: Colors.white, fontSize:25),),
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
            SizedBox(height:20),
            Row(
              children: [
                Align(
                  alignment: Alignment.center,
                  child:CircleAvatar(
                    radius: 100,
                    child: ClipOval(
                     child: SizedBox(
                       width:180,
                       height:180,
                       child: (_image !=null)? Image.file(_image,fit:BoxFit.fill): Image.asset('assets/user.png', fit:BoxFit.fill, color: Colors.blueGrey,)
                     ),
                    ),
                  )
                  ),

                  Padding(padding: EdgeInsets.only(top:80),
                  child: IconButton(
                    icon: Icon(
                      FontAwesomeIcons.camera,
                      size: 30,
                      ),
                  
                  onPressed:(){
                      getImage();
                  }
                  ),
                  )
              ],
            ),

                  SizedBox(height:10),

                   Form(key:buttonKey,
                     child: Column(
                       children:buildButton(),
                     )
                   ),

            Expanded(
              child: Padding(
               padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: buildInputs() 
                    ),
              )          
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
              flatbutton(FlatButton( 
                onPressed: () { 

                  if (validate()){
                      _loadingDialog();
                  checkSession().then((value) { 
           DocumentReference documentReference = FirebaseFirestore.instance.collection('users').doc(userIdentity);
                  FirebaseFirestore.instance.runTransaction((Transaction transaction) async{

                transaction.update(documentReference, {
                "name": name, 
                'surname':surname, 
                'portfolio':portfolio
                });    
            }); 

            uploadPic();            

            _showProfileUpdatedDialog();       
          //Navigator.of(context).pop();
         } 
                  );
                  
                  }

                 },

                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text('Sumit', style: TextStyle(fontSize:20, color:Colors.white),),
                    Icon(Icons.arrow_forward_ios, color:Colors.white, size:15)
                  ],

              ),)),

              flatbutton(FlatButton( 
                onPressed: () { 
                   Navigator.of(context).pushReplacement(
    MaterialPageRoute(builder: (BuildContext context)=>MyProfilepage(authFormType:AuthFormType.notEdit))
  );
                 },

                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text('Cancle', style: TextStyle(fontSize:20, color:Colors.white),),
                    Icon(Icons.cancel, color: Colors.white, size:15)
                  ],

              ),))
            ],)
        ]
      )
         )
        )
          )
          );
      }
        )
    );
  }

  

List<Widget> buildInputs(){
List <Widget> textFields = [];

if (authFormType == AuthFormType.notEdit){
  textFields.add(
    Container(
    child: Column(
      children: [
        Column(
      children: [
      Text('Name',style: TextStyle(fontSize:15,color:Colors.green),),
      SizedBox(height:5),
      Row(
        children:[
           Text(surname,style: TextStyle(fontSize:25),),
           SizedBox(height:10),
           Text(name,style: TextStyle(fontSize:25),),
        ]
      ),
      ]),

      SizedBox(height:10),

      Column(
      children: [
      Text('Portfolio',style: TextStyle(fontSize:15,color:Colors.green),),
      SizedBox(height:5),
    
      Text(portfolio,style: TextStyle(fontSize:25),),
      
    ],
    ),

    Column(
      children: [
      Text('Email',style: TextStyle(fontSize:15, color:Colors.green),),
      SizedBox(height:5),
    
      Text(email,style: TextStyle(fontSize:25),),
      
    ],
    )
    ],
    )
    )
  );



}

else if (authFormType == AuthFormType.edit){
  textFields.add(
    Form(key:formKey,
    child: Column(
      children: [
        Column(
      children: [
      Text('Name',style: TextStyle(fontSize:15),),
      SizedBox(height:5),
      Row(
        children:[
           container(TextFormField(decoration:buildSignupInputDecoration(surname),
            validator: nameValidator,
            onSaved: (value) {
            return surname = value;
            }

           )),
            SizedBox(height:10),
           container(TextFormField(decoration:buildSignupInputDecoration(name),
           
            validator: nameValidator,
              onSaved: (value) {
             return  name = value;
              }
           
           )),
        ]
      ),
      ]),

      SizedBox(height:10),

      Column(
      children: [
      Text('Portfolio',style: TextStyle(fontSize:15),),
      SizedBox(height:5),
    
      container(TextFormField(decoration:buildSignupInputDecoration(portfolio),
      
       validator: nameValidator,
              onSaved: (value) {
             return  portfolio = value;
              }
      
      )),
    ],
    )
    ],
    )
    )
  );

}
return textFields;
}
  InputDecoration buildSignupInputDecoration(String hint) {
return InputDecoration(
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

List<Widget> buildButton(){
  String newFormState;
  if(authFormType == AuthFormType.edit){
    newFormState = 'notEdit';
  }

  else if(authFormType == AuthFormType.notEdit){
    newFormState = 'edit';
  }
   return [ 
     Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                    icon: Icon(
                      FontAwesomeIcons.pen,
                      size: 20,
                      ),
                  
                  onPressed:(){
                    setState(() {
           switchFormState(newFormState);
        });
                  }
                  )
                  )
   ];
}
}