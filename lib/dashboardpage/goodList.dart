import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class GoodListPage extends StatefulWidget {

  @override
  _GoodListPageState createState() => _GoodListPageState();
}

class _GoodListPageState extends State<GoodListPage> {
bool debugShowCheckedModeBanner = false;
var userIdentity,item,documentId;
int index;
bool checkedValue1 , checkedValue2 , checkedValue3 ;
String where1, where2, where3, isEqualto1, isEqualto2, isEqualto3, newDateTime;
QuerySnapshot motorList;
FlatButton _iconButton;

   getData() async {
   return await FirebaseFirestore.instance.collection('motorList')
   .where(where1 ,isEqualTo: isEqualto1)
   .where(where2 ,isEqualTo: isEqualto2)
   .where(where3 ,isEqualTo: isEqualto3)
   .orderBy('locationNumber', descending: true).get();
 }

  @override
  void initState(){
    where1 = 'condition';
    where2 = 'condition';
    where3 = 'condition';
    isEqualto1 = 'Good';
    isEqualto2 = 'Good';
    isEqualto3 ='Good';
    getData().then((results){
      setState(() {
        motorList = results;
      });
    });
    _iconButton = FlatButton(child: null, onPressed: null);
    checkedValue1 = false;
     checkedValue2 = false;
      checkedValue3 = false;

    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height:10),
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: EdgeInsets.only(right:10),
                child: _filterBy(),
              ),
            ),
            SizedBox(height:10),
           _stockList() 
        ],
      )
          
    );           
  }

// Main dropdown to filter by funtional Location
  Widget _filterBy(){
      List<CheckboxListTile>stockList=[
       
          CheckboxListTile(value: checkedValue1,
           onChanged: (value){
                    checkedValue1 = value;
                    setState(() {
                      if(value){
                        where1 ='powerRating';
                      }
                    });
          }, 
          checkColor: Colors.green, 
          title:Text('Power Rating'),
          subtitle: _filterbypowerRating(),
          ),
         
           CheckboxListTile(value: checkedValue2, 
            onChanged: (value){
                    checkedValue2 = value;
                    setState(() {
                      if(value){
                        where2 ='speed';
                      }
                    });
          },  
          checkColor: Colors.green, 
          title:Text('speed'),
          subtitle: _filterbySpeed(),
          ),
    
          CheckboxListTile(value: checkedValue3, 
           onChanged: (value){
                    checkedValue3 = value;
                     setState(() {
                      if(value){
                       where3 ='funcLocation';
                      }
                    });
          }, 
          checkColor: Colors.green, 
          title:Text('FuncLocation'),
          subtitle: _filterbyFuncLocation(),
          ),
       
      ];
      
        return new Theme(
            data: Theme.of(context).copyWith(
              canvasColor: Colors.green[200], // background color for the dropdown items
              buttonTheme: ButtonTheme.of(context).copyWith(
                alignedDropdown: true,  //If false (the default), then the dropdown's menu will be wider than its button.
              )
            ),
            child: DropdownButtonHideUnderline(

                child: DropdownButton(items: stockList.map((CheckboxListTile value)          
                {
                return new DropdownMenuItem<CheckboxListTile>(
                   value: value,
                   child: value,
                     );
                         }).toList(),
                iconSize: 30,
                
                onChanged: (value){
                },
                isExpanded: false,
                hint: Text('Filter by', style: TextStyle(color: Colors.black)),
                ),
                ),
                );  
  }


// Subdropdown to filter by power Rating
  Widget _filterbypowerRating(){
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
                iconSize: 15,
                
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


// Subdropdown to filter by speed
  Widget _filterbySpeed(){
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
                iconSize: 30,
                
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


// Subdropdown to filter by funtional Location
  Widget _filterbyFuncLocation(){
      List<String>funcList=[];
        for(int i=0; i < motorList.docs.length; i++){
        
        item = motorList.docs[i].data()["funcLocation"];
        
             funcList.add(
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

                child: DropdownButton(items: funcList.map((String value)          
                {
                return new DropdownMenuItem<String>(
                   value: value,
                  child: new Text(value),
                     );
                         }).toList(),
                iconSize: 30,
                
                onChanged: (value){
                  setState(() {             
                       isEqualto3=value;
                       print(isEqualto3);  
                  });
                },
                isExpanded: false,
                ),
                ),
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