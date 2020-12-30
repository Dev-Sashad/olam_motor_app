import 'package:flutter/material.dart';
import 'package:motorapp/bloc.navigation_bloc/navigation_bloc.dart';

class  HelpPage extends StatelessWidget with NavigationStates{
  @override
  Widget build(BuildContext context) {
   return Scaffold(

     appBar: AppBar(
         shadowColor: Colors.black12,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: 
          Text('Help',textAlign:TextAlign.center, 
          style:TextStyle(color: Colors.green, fontSize:25),),
        centerTitle: true,
      ),

      body: Container(
            padding: EdgeInsets.only(top:20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
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
                       child: Image.asset('assets/user.png', fit:BoxFit.fill, color: Colors.blueGrey[300],)
                     ),
                    ),
                  )
                  
                  ),
            SizedBox(height:15),

            Container(
              padding: EdgeInsetsDirectional.only(start:10),
              height: 35,
              margin: EdgeInsets.symmetric(horizontal:15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Colors.white,
                      boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 4,
                      )
                      ]
                    ),

                child: Row(children: [
                  Text('Email:',style: TextStyle(color:Colors.grey, fontSize:20)),
                  SizedBox(height:5),
                  Text('sanni.shafeeq@gmail.com', style: TextStyle(color:Colors.green, fontSize:20),)
                ],),
            ),
       
            SizedBox(height:15),

            Container(
              padding: EdgeInsetsDirectional.only(start:10),
              height: 35,
              margin: EdgeInsets.symmetric(horizontal:15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Colors.white,
                      boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 4,
                      )
                      ]
                    ),

                child: Row(children: [
                  Text('Contact:',style: TextStyle(color:Colors.grey, fontSize:20)),
                  SizedBox(height:5),
                  Text('08109954727  |  09019117954', style: TextStyle(color:Colors.green, fontSize:20),)
                ],),
            )
        ]
      ),
      )
   );
  }
  
}