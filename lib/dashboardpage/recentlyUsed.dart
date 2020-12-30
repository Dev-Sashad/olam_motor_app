import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:motorapp/pages/addItem.dart';

class RecentlyUsedPage extends StatefulWidget {

  @override
  _RecentlyUsedPageState createState() => _RecentlyUsedPageState();
}

class _RecentlyUsedPageState extends State<RecentlyUsedPage> {
bool debugShowCheckedModeBanner = false;
var userIdentity;
QuerySnapshot motorList;
IconButton _iconButton;
bool isEmpty = true ;

   getData() async {
   return await FirebaseFirestore.instance.collection('usedMotor')
   .orderBy('modelNumber', descending: true).get();
 }

  @override
  void initState(){
    getData().then((results){
      setState(() {
        motorList = results;
        isEmpty = motorList.docs.isEmpty;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.white,
           shadowColor: Colors.black12,
            automaticallyImplyLeading: false,
           title: Text('Recently Used Motors',style: TextStyle(fontSize: 20,
           fontWeight: FontWeight.w600, color: Colors.green),),
           centerTitle: true,
         ),
      body:(isEmpty != true)? _stockList() : Align( alignment: Alignment.center,
      child: _stocKListIsEmpty() )    
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
          
          child: Flexible(        
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
                  ), 

                  text(
                    text: motorList.docs[i].data()['Date'].toString()
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
}