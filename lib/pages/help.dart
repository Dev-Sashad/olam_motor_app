import 'package:flutter/material.dart';
import 'package:motorapp/bloc.navigation_bloc/navigation_bloc.dart';

class  HelpPage extends StatelessWidget with NavigationStates{
  @override
  Widget build(BuildContext context) {
   return Scaffold(

     appBar: AppBar(
        
        backgroundColor: Colors.green,
        title: 
          Text('Help',textAlign:TextAlign.center, 
          style:TextStyle(color: Colors.white, fontSize:25),),
        centerTitle: true,
      ),

      body: Container(
            padding: EdgeInsets.only(top:20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
        children: [

              Align(
                  alignment: Alignment.center,
                  child:Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 4,
                      )
                      ]
                    ),
                  child:CircleAvatar(
                    radius: 100,
                    child: ClipOval(
                     child: SizedBox(
                       width:180,
                       height:180,
                       child: Image.asset('assets/user.png', fit:BoxFit.fill, color: Colors.blueGrey,)
                     ),
                    ),
                  )
                  )
                  ),
            SizedBox(height:15),

            Container(
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