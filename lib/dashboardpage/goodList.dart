import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:motorapp/pages/addItem.dart';

class GoodListPage extends StatefulWidget {

  @override
  _GoodListPageState createState() => _GoodListPageState();
}

class _GoodListPageState extends State<GoodListPage> {
bool debugShowCheckedModeBanner = false;
var userIdentity,item,documentId;
int index;
String newDateTime ;
var isEqualto1 , isEqualto2 ;
QuerySnapshot motorList;
FlatButton _iconButton;
bool isEmpty = true ;


       getData() async {
  await FirebaseFirestore.instance.collection('motorList')
   .where('condition' ,isEqualTo: 'Good')
   .orderBy('locationNumber', descending: true).get();
 }

  @override
  void initState() {

      setState(() {
     isEqualto1  = 0 ;
    isEqualto2 = 0;
      });
    
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
           title: Text('Good Motors List',style: TextStyle(fontSize: 20,
           fontWeight: FontWeight.w600, color: Colors.green),),
           centerTitle: true,
         ),
      body: Column(
        children: [
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal:10,),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children : [
                    _filterbypowerRating(),
                    SizedBox(width:10),
                    _filterbySpeed()
                  ]
                ),
              ),
            ),
            SizedBox(height:10),
          ( isEmpty != true )? _stockList() : _stocKListIsEmpty() 
        ],
      )
          
    );           
  }


// Subdropdown to filter by power Rating
  Widget _filterbypowerRating(){
    if (motorList !=null){
      List<String>powerRatingList=[];

             for(int i=0; i < motorList.docs.length; i++){
        
        item = motorList.docs[i].data()["powerRating"];
        
              powerRatingList.add(
                item.toString() 
              );
      }
      
        return new Theme(
            data: Theme.of(context).copyWith(
              canvasColor: Colors.green[200], // background color for the dropdown items
              buttonTheme: ButtonTheme.of(context).copyWith(
                alignedDropdown: true,  //If false (the default), then the dropdown's menu will be wider than its button.
              )
            ),
            child: DropdownButtonHideUnderline(

                child: DropdownButton(items: powerRatingList.map((String value)          
                {
                return new DropdownMenuItem<String>(
                   value: value,
                  child: new Text(value),
                     );
                         }).toList(),
                iconSize: 20,
                hint: Text('filter by powerRating', style: TextStyle(color: Colors.black)),
                onChanged: (value){
                  setState(() {             
                       isEqualto1=value;
                       print(isEqualto1);  
                  });
                },
                isExpanded: false,
                ),
                ),
                ); 
    }
    else{
      return new Theme(
            data: Theme.of(context).copyWith(
              canvasColor: Colors.green[200], // background color for the dropdown items
              buttonTheme: ButtonTheme.of(context).copyWith(
                alignedDropdown: true,  //If false (the default), then the dropdown's menu will be wider than its button.
              )
            ),
            child: DropdownButtonHideUnderline(

                child: DropdownButton(items: [],
                iconSize: 20,
                hint: Text('filter by powerRating', style: TextStyle(color: Colors.black)),
                onChanged: (value) {  },
                isExpanded: false,
                ),
                ),
                ); 
    }
  }


// Subdropdown to filter by speed
  Widget _filterbySpeed(){
     if (motorList !=null){
      List<String>speedList=[];
             for(int i=0; i < motorList.docs.length; i++){
        
        item = motorList.docs[i].data()["speed"];
        
              speedList.add(
                item.toString() 
              );
      }
        return new Theme(
            data: Theme.of(context).copyWith(
              canvasColor: Colors.green[200], // background color for the dropdown items
              buttonTheme: ButtonTheme.of(context).copyWith(
                alignedDropdown: true,  //If false (the default), then the dropdown's menu will be wider than its button.
              )
            ),
            child: DropdownButtonHideUnderline(

                child: DropdownButton(items: speedList.map((String value)          
                {
                return new DropdownMenuItem<String>(
                   value: value,
                  child: new Text(value),
                     );
                         }).toList(),
                iconSize: 20,
                 hint: Text('filter by speed', style: TextStyle(color: Colors.black)),
                onChanged: (value){
                  setState(() {             
                       isEqualto2=value;
                       print(isEqualto2);  
                  });
                },
                isExpanded: false,
                ),
                ),
                );  
  }
          
              else{
      return new Theme(
            data: Theme.of(context).copyWith(
              canvasColor: Colors.green[200], // background color for the dropdown items
              buttonTheme: ButtonTheme.of(context).copyWith(
                alignedDropdown: true,  //If false (the default), then the dropdown's menu will be wider than its button.
              )
            ),
            child: DropdownButtonHideUnderline(

                child: DropdownButton(items: [],
                iconSize: 20,
                hint: Text('filter by speed', style: TextStyle(color: Colors.black)),
                onChanged: (value) {  },
                isExpanded: false,
                ),
                ),
                ); 
    }
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
                  ) 

               ],
            ),

            onTap: (){
              setState(() {
                _iconButton = FlatButton(child: Text('use',
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
                        transaction.update(snapshot.reference, {
                          "condition": 'Used',
                          "locationNumber": 'Nil',
                        });
                        CollectionReference reference = FirebaseFirestore.instance.collection('usedMotor');
                        await reference.add(
                          snapshot.data(),
                        );

                        await reference.add(
                          {
                            "Date": newDateTime,
                          }
                        );
                      });
          CollectionReference collectionReference = FirebaseFirestore.instance.collection('motorList').doc(documentId).collection('motorInfo');
                    await collectionReference.add({
                          "Date": newDateTime,
                          "history": 'used in functional location'
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