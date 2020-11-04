import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:motorapp/bloc.navigation_bloc/navigation_bloc.dart';
import 'package:motorapp/homepage/mainhomepage.dart';


class  AddItemPage extends StatefulWidget with NavigationStates{  
  @override

  AddItemPageState createState() => AddItemPageState();
}

class AddItemPageState extends State<AddItemPage> {
final formKey = GlobalKey<FormState>();
int  powerRating, currentRating, speed;
int _groupValue = -1;
String mountPost, gearboxInc, funcLocation, condition, locationNumber, modelNumber, bearingNumber;
QuerySnapshot motorList;


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
  // validator
String validator(String value) {
  
  RegExp lowerCase = new RegExp(r'[a-z]');
  RegExp digit = new RegExp(r'[0-9]');

  if (!lowerCase.hasMatch(value)) {
    return 'Password should contain figure and letters';
  }

  if (!digit.hasMatch(value)) {
    return 'Password should contain figure and letters';
  }
  
  else if (value.isEmpty){
     return 'password should contain 8 characters';
  }
   else 
    return null; 
}


String digitValidator(String value) {
  
  RegExp digit = new RegExp(r'[0-9]');

  if (!digit.hasMatch(value)) {
    return 'Password should contain figure and letters';
  }
  
  else if (value.isEmpty){
     return 'password should contain 8 characters';
  }
   else 
    return null; 
}


 void _motorSucessfullyChanged() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Image.asset('assets/successful.png',),
          content: new Text("Motor successfully added \n Thank you", textAlign:TextAlign.center ,),
          actions: <Widget>[
            flatbutton(
            FlatButton(
              child: new Text("Go to Homepage", style: TextStyle(fontSize:20, color:Colors.white),),
              onPressed: () {             
               //authFormType = AuthFormType.signIn;
              Navigator.of(context).pushReplacement(
    MaterialPageRoute(builder: (BuildContext context)=>MainHomepage())
  );
               // loading=false;
              },
            ),
            )
          ],
        );
      },
    );
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

  //to delay the loading befor next ation
 Future <bool> checkSession() async {
    await Future.delayed(Duration(milliseconds: 5000), (){});
    return true;
 }

void _motorNotSucessfullyChanged() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Image.asset('assets/notsuccessful.png',),
          content: new Text("Motor not succesfully added"),
          actions: <Widget>[
             flatbutton(
            FlatButton(
              child: new Text("Dismiss", style: TextStyle(fontSize:20, color:Colors.white),),
              onPressed: () {             
               //authFormType = AuthFormType.signIn;
              Navigator.of(context).pop();
               // loading=false;
              },
            ),
             )
          ],
        );
      },
    );
  }

void _motorExist() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Image.asset('assets/notsuccessful.png',),
          content: new Text("Motor already exist"),
          actions: <Widget>[
             flatbutton(
            FlatButton(
              child: new Text("Dismiss", style: TextStyle(fontSize:20, color:Colors.white),),
              onPressed: () {             
               //authFormType = AuthFormType.signIn;
              Navigator.of(context).pop();
               // loading=false;
              },
            ),
             )
          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
   return Scaffold(
          appBar: AppBar(
        
        backgroundColor: Colors.green,
        title: 
          Text('Add Motor',textAlign:TextAlign.center, 
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
          
        Form(key:formKey,
        child: Column(
        children: <Widget>[

           SizedBox(height:50),

          container(
            hintText:'Power rating',
            unit:'KW',
            input:powerRating
          ),

          SizedBox(height:10),

            container(
            hintText:'Current rating',
            unit:'Amp',
            input: currentRating
          ),

           SizedBox(height:10),

            container(
            hintText:'Speed',
            unit: 'Rpm',
            input: speed
          ),

          SizedBox(height:10),

            textFormField(
            hintText:'Model Number',
            input: modelNumber
          ),

          SizedBox(height:10),

          Row(
            children: [
              Text('Mounting Position', style: TextStyle(fontSize:20,)),

              SizedBox(width: 15,),

               Row(
                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: <Widget>[
      _myRadioButton(
        title: "Foot",
        value: 0,
        mtpost: mountPost,
      ),
      _myRadioButton(
        title: "Flange",
        value: 1,
        mtpost: mountPost,
      ),
    ],
  )
            ],
          ),

          
          SizedBox(height:10),

            textFormField(
            hintText:'Bearing Number',
            input: bearingNumber
          ),

        SizedBox(height:10),

          Row(
            children: [
              Text('Gearbox Inclusion', style: TextStyle(fontSize:20,)),

              SizedBox(width: 15,),

               Row(
                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: <Widget>[
      _myRadioButton(
        title: "Yes",
        value: 0,
        mtpost: gearboxInc,
      ),
      _myRadioButton(
        title: "NO",
        value: 1,
        mtpost: gearboxInc,
      ),
    ],
  ),
            ],
          ),

           SizedBox(height:10),

            textFormFieldWithDropdownButton(
            hintText:'Functional Location',
            input: funcLocation
          ),

       SizedBox(height:10),

          Row(
            children: [
              Text('Condition', style: TextStyle(fontSize:20,)),

              SizedBox(width: 15,),

               Row(
                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: <Widget>[
      _myRadioButton(
        title: "Good",
        value: 0,
        mtpost: condition,
      ),
      _myRadioButton(
        title: "Bad",
        value: 1,
        mtpost: condition,
      ),
    ],
  ),
            ],
          ),

          SizedBox(height:10),

          textFormField(
            hintText:'Location in motor room i.e M(1,x)',
            input: locationNumber
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
                if (powerRating !=null && currentRating !=null && speed !=null && modelNumber !=null
                 && mountPost !=null && bearingNumber !=null && gearboxInc !=null && funcLocation !=null
                  && condition !=null && locationNumber !=null ){ 

                    motorList = await FirebaseFirestore.instance.collection('motorList')
            .where('modelNumber',isEqualTo: modelNumber)
            .orderBy('locationNumber', descending: true).get();

                  if (motorList != null){
                    _motorExist();
                  }

                  else{
                FirebaseFirestore.instance.runTransaction((Transaction transaction) async{  
                CollectionReference reference = FirebaseFirestore.instance.collection('motorList');
                await reference.add({
                  "powerRating": powerRating,
                  "currentRating": currentRating,
                  "speed": speed,
                  "modelNumber": modelNumber,
                  "mountingPosition": mountPost,
                  "bearingNumber": bearingNumber,
                  "gearBox": gearboxInc,
                  "funcLocation": funcLocation,
                  "condition": condition,
                  "locationNumber": locationNumber,
                  "editing": false
                  });
            });
                  _motorSucessfullyChanged();
                  }
                }

                 else {
                      _motorNotSucessfullyChanged();
                   }

              });
              }

         
        },
      child: Text('Add Motor', style: TextStyle(fontSize:20, color:Colors.white),)
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
     fontSize: 15,
      fontFamily: 'Montserrat',
      color: Colors.grey,
      ),     
      border: InputBorder.none,
      contentPadding: EdgeInsets.only(left:10)
      );

}

Container container ({String hintText, String unit, var input}){
return Container(
        margin: EdgeInsets.symmetric(horizontal:20),
                child: Material(
                  borderRadius: BorderRadius.circular(5),
                  shadowColor: Colors.grey,
                  color: Colors.white,
                  elevation: 2.0,
                  child: Row(
              children: [
                 TextFormField(decoration: buildSignupInputDecoration(hintText),
          keyboardType: TextInputType.number,
          style: TextStyle(fontSize:20, color:Colors.grey, fontWeight:FontWeight.w600),
          onChanged: (value){
            setState(() {
               input = value;
            });
          },
          
          validator: digitValidator,
          ),
          SizedBox(width:5),
              Text(unit,style:TextStyle(color: Colors.grey, fontSize: 20, fontWeight: FontWeight.w600))
              ],
            ),
                    )
              );
}

Container textFormField ({String hintText, var input}){
return Container(
        margin: EdgeInsets.symmetric(horizontal:20),
                child: Material(
                  borderRadius: BorderRadius.circular(5),
                  shadowColor: Colors.grey,
                  color: Colors.white,
                  elevation: 2.0,
                  child:  TextFormField(decoration: buildSignupInputDecoration(hintText),
          keyboardType: TextInputType.number,
          style: TextStyle(fontSize:20, color:Colors.grey, fontWeight:FontWeight.w600),
          onChanged: (value){
            setState(() {
            input = value;
            });
          },
          
          validator: validator,
          ),
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

Widget _myRadioButton({String title, int value, String mtpost}) {
  return RadioListTile(
    activeColor: Colors.green,
    value: value,
    groupValue: _groupValue,
    onChanged:  (newValue) { 
      setState(() {
         _groupValue = newValue;
         mtpost= title;
      });
      
    },
    title: Text(title),
  );
}

Widget _listView({String  selectedItem}){
      List<String>stockList=['Mill', 'Pasta', 'Packaging'];
      
        return new Theme(
            data: Theme.of(context).copyWith(
              canvasColor: Colors.green[200], // background color for the dropdown items
              buttonTheme: ButtonTheme.of(context).copyWith(
                alignedDropdown: true,  //If false (the default), then the dropdown's menu will be wider than its button.
              )
            ),
            child: DropdownButtonHideUnderline(

                child: DropdownButton(items: stockList.map((String value)          
                {
                return new DropdownMenuItem<String>(
                   value: value,
                  child: new Text(value),
                     );
                         }).toList(),
                iconSize: 30,
                
                onChanged: (value){
                  setState(() {             
                       selectedItem=value;
                       print(selectedItem);  
                  });
                },
                isExpanded: false,
                ),
                ),
                );
    
  }

  Container textFormFieldWithDropdownButton ({String hintText, String input}){
return Container(
        margin: EdgeInsets.symmetric(horizontal:20),
                child: Material(
                  borderRadius: BorderRadius.circular(5),
                  shadowColor: Colors.grey,
                  color: Colors.white,
                  elevation: 2.0,
                  child: Row(
                    mainAxisAlignment:MainAxisAlignment.spaceBetween,
                    children: [
          TextFormField(decoration: buildSignupInputDecoration(hintText),
          keyboardType: TextInputType.number,
          style: TextStyle(fontSize:20, color:Colors.grey, fontWeight:FontWeight.w600),
          onChanged: (value){
            setState(() {
            input = value;
            });
          },
          
          validator: validator,
          ),

          _listView(
            selectedItem: input
          )
                    ]
                  )
              )
              );
}
}