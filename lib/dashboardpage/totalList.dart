import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:motorapp/homepage/motorDetails.dart';
import 'package:motorapp/pages/addItem.dart';


class TotalListPage extends StatefulWidget {

  @override
  _TotalListPageState createState() => _TotalListPageState();
}

class _TotalListPageState extends State<TotalListPage> {
bool debugShowCheckedModeBanner = false;
var userIdentity,documentId, query;
QuerySnapshot motorList;
IconButton _iconButton;
String arrayContains;
bool isEmpty = true ;

   getData() async {
   query = await FirebaseFirestore.instance.collection('motorList')
   .orderBy('locationNumber', descending: true).get();
   return query;
 }

  @override
  void initState(){
    getData().then((results){
      setState(() {
        motorList = results;
        isEmpty = motorList.docs.isEmpty;
      });
    });
   // _iconButton = IconButton(icon: null, onPressed: null);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          backgroundColor: Colors.white,
           shadowColor: Colors.black12,
            automaticallyImplyLeading: false,
           title: Text('All Motor List',style: TextStyle(fontSize: 20,
           fontWeight: FontWeight.w600, color: Colors.green),),
           centerTitle: true,
         ),
      body: Column(
        children:[
              (isEmpty != true)? Align(
                alignment: Alignment.topCenter,
              child:container(
                TextFormField(
                  decoration: buildSignupInputDecoration(
                    hint: 'search by motor model number',
                    icon: IconButton(
                      
                    icon: Icon(Icons.search),
                    
                     onPressed: (){
                        setState(() async {
                          query = await FirebaseFirestore.instance.collection('motorList')
                          .where('modelNumber', arrayContains: arrayContains)
                        .orderBy('locationNumber', descending: true).get();
                        return query;
                        });
                     },
                     )
                  ),

                  onChanged: (value){
                      arrayContains = value;
                  },
                  style: TextStyle(fontSize: 20, color:Colors.grey, fontWeight: FontWeight.w600),
                )
                ),
                ) : Text(' '), 

                   SizedBox(height:5),
           /// Align(
             //   alignment: Alignment.topLeft,
               // child:
                (isEmpty != true)? Text('Click info button for more details and editing',
                style:TextStyle( color:Colors.grey, fontSize:15),
                textAlign: TextAlign.center,
                ) : Text(' '), 
             // ),

                SizedBox(height:5),
              (isEmpty != true)? _stockList() : _stocKListIsEmpty()  
        ]
      )    
    );           
  }

  Widget _stockList(){      
      return ListView.builder(
       itemCount:motorList.docs.length ,
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
          
          child: Column(
            children: [         
          Align(
            alignment: Alignment.topRight,
            child: IconButton(
              icon: Icon(Icons.info_outline, size:20),          
              onPressed: () async {
                documentId = motorList.docs[i].id;
                MotorDetails(
                  title: motorList.docs[i].data()['modelNumber'].toString(),
                  editing: motorList.docs[i].data()['editing'],
                  powerRating: motorList.docs[i].data()['powerRating'].toString(),
                  currentRating: motorList.docs[i].data()['powerRating'].toString(),
                  bearingNumber: motorList.docs[i].data()['bearingNumber'].toString(),
                  condition: motorList.docs[i].data()['condition'].toString(),
                  funcLocation: motorList.docs[i].data()['funcLoacation'].toString(),
                  gearboxInc: motorList.docs[i].data()['modelNumber'].toString(),
                  speed: motorList.docs[i].data()['speed'].toString(),
                  modelNumber: motorList.docs[i].data()['modelNumber'].toString(),
                  locationNumber: motorList.docs[i].data()['locationNumber'].toString(),
                  mountingPosition: motorList.docs[i].data()['mountingPosition'].toString(),
                  formKey: GlobalKey<FormState>(),
                  historyquerySnapshot: await FirebaseFirestore.instance.collection('motorList').doc(documentId).collection('motorInfo').get(),
                );
              }
              ),
          ),
          
          Flexible(        
            child: ListTile(
            contentPadding: null,
            hoverColor: Colors.green[100],
            leading: _iconButton,
            
            title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                
                   row(
                     text1: motorList.docs[i].data()['powerRating'].toString(),
                     text2: 'KW'
                   ),

                     row(
                     text1: motorList.docs[i].data()['currentRating'].toString(),
                     text2: 'Amp'
                   ),

                     row(
                     text1: motorList.docs[i].data()['speed'].toString(),
                     text2: 'Rpm'
                   ),
                  
                  text(
                    text: motorList.docs[i].data()['modelNumber'].toString()
                  ),

                   text(
                    text: motorList.docs[i].data()['mountingPosition'].toString()
                  )  
                   
                    ],),
                     
  
            subtitle: Row(
               mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                
                     text(
                    text: motorList.docs[i].data()['bearingNumber'].toString()
                  ),

                   text(
                    text: 'With GearBox: ${motorList.docs[i].data()['modelNumber'].toString()}'
                  ),

                      text(
                    text: motorList.docs[i].data()['funcLoacation'].toString()
                  ),

                   text(
                    text: 'Status: ${motorList.docs[i].data()['condition'].toString()}'
                  ),

                   text(
                    text: motorList.docs[i].data()['locationNumber'].toString()
                  ) 

               ],
            ),

            onTap: (){
              setState(() {
                _iconButton = IconButton(icon: Icon(Icons.delete_outline),
                 onPressed: (){
                      FirebaseFirestore.instance.runTransaction((transaction) async{
                        DocumentSnapshot snapshot = await transaction.get(motorList.docs[i].reference);
                        transaction.delete(snapshot.reference);
                      });
                 });
              });
            },
            )
          ),
            ]
          )
        );
      },
     
      );

  }


  Container _stocKListIsEmpty(){
           return Container(
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                  Text('You have no motor in record \nClick button to add', 
                textAlign: TextAlign.center, style: TextStyle(fontSize:15),),

                  SizedBox(height:10),
                  
              FloatingActionButton(
       backgroundColor: Colors.white,
          onPressed: () {
           Navigator.of(context).pushReplacement(
                   MaterialPageRoute(builder: (BuildContext context)=>AddItemPage()));
          },
          child: Icon(Icons.add, size: 30, color: Colors.orangeAccent),
          tooltip: 'Add motor to list',
        )
         ]
      ) 
    );  
  }

  Row row({String text1, String text2 }) {
    return  Row(children: [
                      Text(text1, style:TextStyle(color: Colors.black,fontSize:15),),
                     SizedBox(width:5),
                   Text(text2, style:TextStyle(color: Colors.orangeAccent,fontSize:15),)]);
  }

  Text text({String text}){
    return  Text(text, style:TextStyle(color: Colors.green,fontSize:20,
                    fontWeight: FontWeight.bold
                    ),);
  }

    InputDecoration buildSignupInputDecoration( {String hint, IconButton icon}) {
return InputDecoration(
     suffixIcon: icon,
     hintText: hint,
     hintStyle: TextStyle( 
     fontSize: 15,
     fontFamily: 'Montserrat',
      color: Colors.grey,
      ),     
      border: InputBorder.none,
  contentPadding: EdgeInsets.fromLTRB(20, 10,0, 10),
      );

}

Container container (TextFormField child){
return Container(
        alignment: Alignment.center,
        width: MediaQuery.of(context).size.width*0.7,
        margin: EdgeInsets.symmetric(horizontal:10, vertical: 5),
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