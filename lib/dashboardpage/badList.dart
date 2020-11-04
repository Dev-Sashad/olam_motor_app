import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
class BadListPage extends StatefulWidget {

  @override
  _BadListPageState createState() => _BadListPageState();
}

class _BadListPageState extends State<BadListPage> {
bool debugShowCheckedModeBanner = false;
var userIdentity,newDateTime,documentId;
QuerySnapshot motorList;
FlatButton _iconButton;

   getData() async {
   return await FirebaseFirestore.instance.collection('motorList')
   .where('condition' ,isEqualTo: 'Bad')
   .orderBy('locationNumber', descending: true).get();
 }

  @override
  void initState(){
    getData().then((results){
      setState(() {
        motorList = results;
      });
    });
    _iconButton = FlatButton(child: null, onPressed: null);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _stockList()      
    );           
  }

  Widget _stockList(){
    if (motorList!=null){

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
                  ) 

               ],
            ),

            onTap: (){
              setState(() {
                _iconButton = FlatButton(child: Text('Repaired',
                 style: TextStyle(color:Colors.white),
                 
                 ),
                 color:Colors.tealAccent,
                 shape: RoundedRectangleBorder(
                   borderRadius: BorderRadius.circular(10),
                 ),
                 onPressed: () async {
                     var date = new DateTime.now().toString();
 
      var dateParse = DateTime.parse(date);
 
      var formattedDateTime = "${dateParse.day}-${dateParse.month}-${dateParse.year} / ${dateParse.hour}:${dateParse.minute}:${dateParse.second}";

      setState(() {
 
      newDateTime = formattedDateTime.toString() ;
 
    });
                        documentId = motorList.docs[i].id;

                      FirebaseFirestore.instance.runTransaction((transaction) async{
                        DocumentSnapshot snapshot = await transaction.get(motorList.docs[i].reference);
                        transaction.update(snapshot.reference, {"condition": 'Good'});
                      });

                  CollectionReference collectionReference = FirebaseFirestore.instance.collection('motorList').doc(documentId).collection('motorInfo');
                    await collectionReference.add({
                          "Date": newDateTime,
                          "history": 'Repaired and recived'
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

     

    else{
      return Text('Loading, Please wait......', textAlign: TextAlign.center,);
    }
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