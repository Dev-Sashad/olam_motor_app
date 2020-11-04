import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MotorDetails extends StatelessWidget {

final String title, powerRating, currentRating,bearingNumber,gearboxInc, condition,
 speed, modelNumber, locationNumber , funcLocation ,mountingPosition;
final bool editing;
final formKey;
final QuerySnapshot historyquerySnapshot;

const MotorDetails ({Key key, this.title, this.editing, 
this.powerRating, this.currentRating, this.bearingNumber, this.condition, this.funcLocation, this.gearboxInc, 
this.speed, this.modelNumber , this.locationNumber, this.mountingPosition, this.formKey, this.historyquerySnapshot }) : super(key : key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        backgroundColor: Colors.orangeAccent,
        title: 
          Text(title,textAlign:TextAlign.center, 
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
        children:[
              SizedBox(height:10),
              Text('Motor Details', style: TextStyle(color: Colors.black, fontSize: 25),),
              SizedBox(height:10),
              container(
                leading:"Power Rating:",
                inputTitle:powerRating,
                editValue: "powerRating",
                validator: digitValidator 
              ),

                container(
                leading:"Current Rating:",
                inputTitle:currentRating,
                editValue: "currentRating",
                validator: digitValidator 
              ),

                container(
                leading:"Speed:",
                inputTitle:speed,
                editValue: "speed",
                validator: digitValidator 
              ),

                  container(
                leading:"Model",
                inputTitle: modelNumber,
                editValue: "modelNumber",
                validator: validator 
              ),

                  container(
                leading:"Mounting position",
                inputTitle:mountingPosition,
                editValue: "mountingPosition",
                validator: (value)=> value.isEmpty? 'field cannot be empty enter Foot/Flange':null 
              ),

                   Divider(
                   color: Colors.white.withOpacity(0.3),
                   height: 64,
                   thickness: 0.5,
                   indent: 32,
                   endIndent: 32,
                 ),  

                 container(
                leading:"Bearing Number:",
                inputTitle:bearingNumber,
                editValue: "bearingNumber",
                validator: validator 
              ),

                container(
                leading:"Gearbox inclusive:",
                inputTitle:gearboxInc,
                editValue: "gearBox",
                validator: (value)=> value.isEmpty? 'field cannot be empty enter Yes/No':null 
              ),

                container(
                leading:"Functional Location:",
                inputTitle:funcLocation,
                editValue: "funcLocation",
                validator: (value)=> value.isEmpty? 'field cannot be empty enter Mill/Pasta/Packing':null 
              ),

                  container(
                leading:"Condition",
                inputTitle: condition,
                editValue: "condition",
                validator: (value)=> value.isEmpty? 'field cannot be empty enter Good/Bad/Used':null 
              ),

                  container(
                leading:"Location Number",
                inputTitle:locationNumber,
                editValue: "locationNumber", 
                validator: validator
              ),

              Divider(
                   color: Colors.white.withOpacity(0.3),
                   height: 64,
                   thickness: 0.5,
                   indent: 32,
                   endIndent: 32,
                 ), 

              Text('History', style: TextStyle(color: Colors.black, fontSize: 25),),
              
              _motorInfo(),
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

Container container ({String leading, String inputTitle, String editValue, String validator(String value)}){

return Container(
  color: Colors.tealAccent[100],
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(8),
    boxShadow:[
      BoxShadow(
        blurRadius:4,
        color:Colors.black12
      )
    ]
  ),

  child: ListTile(
    onTap: (){
      QuerySnapshot querySnapshot;
FirebaseFirestore.instance.collection('motorList').where("modelNumber", isEqualTo: title).get().then((value) {
 querySnapshot = value;
});

FirebaseFirestore.instance.runTransaction((transaction) async {
  DocumentSnapshot documentSnapshot = await transaction.get(querySnapshot.docs.first.reference);

  transaction.update(documentSnapshot.reference, {"editing": !documentSnapshot["editing"]});
});
  } ,
  
  leading: Text(leading),

  title: !editing ? Text(inputTitle) : TextFormField(
    decoration: InputDecoration(     
      border: InputBorder.none
      ),
    validator: validator,
    initialValue: inputTitle,
    
    onFieldSubmitted: (String item){

         QuerySnapshot querySnapshot;
FirebaseFirestore.instance.collection('motorList').where("modelNumber", isEqualTo: title).get().then((value) {
 querySnapshot = value;
});
        if (validate()){
FirebaseFirestore.instance.runTransaction((transaction) async {
  DocumentSnapshot documentSnapshot = await transaction.get(querySnapshot.docs.first.reference);

  transaction.update(documentSnapshot.reference, {editValue: item});
});
        }
    }
    ),
  ),
);

}


  Row row({String text1, String text2 }) {
    return  Row(children: [
                      Text(text1, style:TextStyle(color: Colors.black,fontSize:15),),
                     SizedBox(width:5),
                   Text(text2, style:TextStyle(color: Colors.orangeAccent,fontSize:15),)]);
  }


Widget _motorInfo(){
    if (historyquerySnapshot!=null){

      return ListView.builder(
       itemCount:historyquerySnapshot.docs.length ,
       padding: EdgeInsets.only(top:8) ,
      itemBuilder: (context,i){
        return new Container(
           margin: EdgeInsets.symmetric(vertical:5, horizontal: 5),
          decoration: BoxDecoration(
            color: Colors.green[200],
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 4
              )
            ]
          ),
          
          child: Flexible(        
            child: ListTile(
            contentPadding: null,
            hoverColor: Colors.green[100],
            
            title: row(
                     text1: 'Date:',
                     text2: historyquerySnapshot.docs[i].data()['Date']
                   ),
                     
  
            subtitle: row(
                     text1: 'Infomation:',
                     text2: historyquerySnapshot.docs[i].data()['Date']
                   )
            )
          ),
        );
      },
     
      );
    }

     

    else{
      return Text('Loading, Please wait......', textAlign: TextAlign.center,);
    }
  }


}