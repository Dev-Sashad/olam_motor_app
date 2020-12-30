import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:motorapp/bloc.navigation_bloc/navigation_bloc.dart';


class MyProfilepage extends StatefulWidget with NavigationStates {

 @override

  MyProfilepageState createState() => MyProfilepageState();
  
}

class MyProfilepageState extends State<MyProfilepage>{
  final formKey = GlobalKey<FormState>();
  final buttonKey = GlobalKey<FormState>();
  var userIdentity, downloadUrl, profileImageUrl;
  DocumentSnapshot userDetails;
  File _image;
  Image profileImage;
  bool edit ;
  var name,surname,portfolio, email;


  //name and surname validator
  String nameValidator(String value) {
  
  RegExp upperCase = new RegExp(r'[A-Z]');
 

  if (!upperCase.hasMatch(value)) {
    return 'start with caps';
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
      builder: (BuildContext context)  {
        // return object of type Dialog
        return AlertDialog(
          title: new Column(
            children: [
              Image.asset('assets/successful.png',height:80, width:80),
              Text("Profile Updated",textAlign: TextAlign.center),
            ]
          ),
          titlePadding: EdgeInsets.all(0),
          contentPadding: EdgeInsets.all(5),
          actionsPadding: EdgeInsets.symmetric(horizontal:20),
          actions: <Widget>[
            new FlatButton(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
              color: Colors.green,
              child: new Text("Dismiss", style: TextStyle(color:Colors.white, fontSize:15),),
              onPressed: () { 
                Navigator.pop(context);         
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
            width: 60,
          child:SpinKitFadingCube(
        color: Colors.green[300],
        size: 50,
        //duration: Duration(milliseconds:500),
      ),
          )
        );
      },
    );
  }

        Future uploadPic()  async {
          if(_image = null ) {
            print('no image selected');
          }
          else{
       StorageReference firebaseStorageRef  = FirebaseStorage.instance.ref().child(userIdentity);
      var uploadTask = firebaseStorageRef .putFile(_image);
      var storageTaskSnapshot = await uploadTask.onComplete;
         setState(() async {
            downloadUrl = await storageTaskSnapshot.ref.getDownloadURL();
            
         });
         
        User user  = FirebaseAuth.instance.currentUser;
        user.updateProfile(
                     photoURL: downloadUrl.toString()
             ).then((value) => print('profile picture uploaded'))
             .catchError((e){
               print('$e');
             });
              print({downloadUrl.toString()});
          } 
      }

    Future getImage() async {
        // ignore: invalid_use_of_visible_for_testing_member
        // ignore: deprecated_member_use
        var image = await ImagePicker.pickImage(source: ImageSource.gallery);

        setState(() {
          _image = image ;
          print('Image path$_image');
        });

      }

 @override
  void initState() {

        edit = true;
      //to get User Details
        User user = FirebaseAuth.instance.currentUser;
        userIdentity = user.uid;
        print('$userIdentity');
   FirebaseFirestore.instance.collection('users').doc(userIdentity).get().then((value){
     setState(() {
       userDetails = value;
      });
  if (userDetails!=null){  
        surname = userDetails.data()['surname'].toString();
        name = userDetails.data()['name'].toString();
        portfolio = userDetails.data()['portfolio'].toString();
        email= userDetails.data()['email'].toString();
   }
   else{
   // name= null;
   // surname = null;
   }
   });

      setState(() {
        profileImageUrl = user.photoURL;

        if (profileImageUrl != null ){
            profileImage = Image.network(profileImageUrl, fit:BoxFit.fill);
        } 
        else{
          profileImage = Image.asset('assets/user.png', fit:BoxFit.fill, color: Colors.greenAccent,);
        }

      });

      
 
    super.initState();
  }
  
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
          appBar: AppBar(
        shadowColor: Colors.black12,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: 
          Text('Edit Profile',textAlign:TextAlign.center, 
          style:TextStyle(color: Colors.green, fontSize:25),),
        centerTitle: true,
      ),

      body: LayoutBuilder(
      builder: (ctx, constrains){
        return Scaffold(
          backgroundColor: Colors.white,
          body: Container(
             alignment: Alignment.center,
        height: constrains.maxHeight,
        child:SingleChildScrollView(
         child: Container(
            padding: EdgeInsets.symmetric(horizontal:10,),
            alignment: Alignment.center,
                    color: Colors.white,
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
      
      child: Column(
        children: [
                         Container(
                              child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Align(
                  alignment: Alignment.center,
                  child:CircleAvatar(
                    backgroundColor: Colors.grey[200],
                    radius: 80,
                    child: ClipOval(
                     child: SizedBox(
                       width:145,
                       height:145,
                       child: (_image !=null)? Image.file(_image,fit:BoxFit.cover): profileImage
                     ),
                    ),
                  )
                  ),

                  Padding(padding: EdgeInsets.only(top:80),
                  child: IconButton(
                    icon: Icon(
                      FontAwesomeIcons.camera,
                      size: 25,
                      ),
                  
                  onPressed:(){
                      getImage();
                  }
                  ),
                  )
              ],
            ),
                          ),
                        //  ),

            SizedBox(height:10),

                   Form(key:buttonKey,
                     child: Column(
                       crossAxisAlignment: CrossAxisAlignment.end,
                       children:buildButton(),
                     )
                   ),

                 Padding(
               padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                    child: Form(key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: buildInputs() 
                    ),
                )
                 ),

            SizedBox(height:20),

       
             !edit? flatbutton(FlatButton( 
                onPressed: () { 

                  if (validate()){
                      _loadingDialog();

                checkSession().then((value) {
                      uploadPic();
           DocumentReference documentReference = FirebaseFirestore.instance.collection('users').doc(userIdentity);
                  FirebaseFirestore.instance.runTransaction((Transaction transaction) async{

                transaction.update(documentReference, {
                "name": name, 
                'surname':surname, 
                'portfolio':portfolio
                });   
                
                transaction.update(documentReference, {"photoUrl" : FirebaseAuth.instance.currentUser.photoURL.toString()});
            });           

            _showProfileUpdatedDialog();       
          //Navigator.of(context).pop();    
                });         
                  }

                 },

                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text('Submit', style: TextStyle(fontSize:20, color:Colors.white),),
                    Icon(Icons.arrow_forward_ios, color:Colors.white, size:20)
                  ],

              ),)): SizedBox(),

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

  

// ignore: missing_return
List<Widget> buildInputs(){
List <Widget> textFields = [];

  textFields.add(
  
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
      children: [
      Text('Name',style: TextStyle(fontSize:15,color:Colors.green, fontWeight:FontWeight.w600,)),
      SizedBox(height:5),
      Row(
         
        children:[
          edit? info(Text(surname.toString(),style: TextStyle(fontSize:20),)): 
            container(TextFormField(decoration:buildSignupInputDecoration(surname.toString()),
            validator: nameValidator,
            onSaved: (value) {
              if (value = null){
            return surname = surname;
              }
              else{
                return surname = value;
              }
            }

           )),
           SizedBox(width:20),
          edit ? info(Text(name.toString(),style: TextStyle(fontSize:20),)) : 
           container(TextFormField(decoration:buildSignupInputDecoration(name.toString()),
           
            validator: nameValidator,
              onSaved: (value) {
               if (value = null){
             return  name = name;
              }
              else{
                return name = value;
              }
              }
           
           )),
        ]
      ),
      ]
      ),
  );

  textFields.add(  SizedBox(height:10));

     textFields.add(
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
      children: [
      Text('Portfolio',style: TextStyle(fontSize:15,color:Colors.green, fontWeight:FontWeight.w600,),),
      SizedBox(height:5),
      
       edit ? info(Text(portfolio.toString(),style: TextStyle(fontSize:20),)):
         
      container(TextFormField(decoration:buildSignupInputDecoration(portfolio.toString()),
      
       validator: nameValidator,
              onSaved: (value) {
                if (value = null){
             return  portfolio = portfolio;
              }
              else{
                return portfolio = value;
              }
              }
      
      )),
      
    ],
    ),
    );

    textFields.add(  SizedBox(height:10));

     textFields.add(
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,  
      children: [
      Text('Email',style: TextStyle(fontSize:15, color:Colors.green, fontWeight:FontWeight.w600,),),
      SizedBox(height:5),
    
     info(Text(email.toString(),style: TextStyle(fontSize:20),)),
      
    ],
    )
     );

return textFields;
}

  InputDecoration buildSignupInputDecoration(String hint) {
return InputDecoration(
     hintText: hint,
     hintStyle: TextStyle( 
     fontSize: 17,
      fontFamily: 'Montserrat',
      color: Colors.grey,
      ),     
      border: InputBorder.none,
      contentPadding: EdgeInsets.symmetric(vertical:7)
      );

}

  Container container (TextFormField child){
return Container(
          width: 150,
          height: 40,
          padding: EdgeInsets.symmetric(horizontal:10),
          alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border.all(
            width: 1.5,
            color: Colors.green
          ),
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color:Colors.black12,
              blurRadius: 4
            )
          ],
          color:Colors.white
        ),

                  child: child,
                    
              );
}

Container info (Text child){
return Container(
  height: 40,
        width: 150,
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
  margin: EdgeInsets.symmetric(horizontal:50),
                child: Material(
                  borderRadius: BorderRadius.circular(30),
                  shadowColor: Colors.grey,
                  color: Colors.green,
                  elevation: 2.0,
                  child: child,
                    )
              );
}

List<Widget> buildButton(){

   return [ 
     Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                    icon: Icon(
                      FontAwesomeIcons.pen,
                      size: 20,
                      ),
                  
                  onPressed:(){
           
             setState(() {
              edit = !edit; 
                });
   
                  }
                  )
                  )
   ];
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