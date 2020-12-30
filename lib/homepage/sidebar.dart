import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:motorapp/bloc.navigation_bloc/navigation_bloc.dart';
import 'package:motorapp/homepage/menuitem.dart';
import 'package:motorapp/login_signup/sign_in.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutter/material.dart';


class SideBarpage extends StatefulWidget {  
  @override

  SideBarpageState createState() => SideBarpageState();
}

class SideBarpageState extends State<SideBarpage>  with SingleTickerProviderStateMixin<SideBarpage>{
  AnimationController _animationController;
  StreamController<bool> isCollapsedStreamController;
  Stream <bool> isCollapsedStream;
  StreamSink<bool> isCollapsedSink;
  DocumentSnapshot userDetails;
  var userIdentity,name,surname,email,portfolio,_image;
 // final bool isCollapsed = false;
  final _animationDuration = const Duration(milliseconds:500);

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync:this, duration:_animationDuration);
    isCollapsedStreamController = PublishSubject<bool>();
    isCollapsedStream = isCollapsedStreamController.stream;
    isCollapsedSink = isCollapsedStreamController.sink;

     User user = FirebaseAuth.instance.currentUser;
     userIdentity = user.uid;
     print('$userIdentity');
    FirebaseFirestore.instance.collection('users').doc(userIdentity).get().then((value) async {
      setState(() {
       userDetails = value;
      });

      if (userDetails!=null){  
        name = userDetails.data()['name'].toString();
        surname = userDetails.data()['surname'].toString();
        email = userDetails.data()['email'].toString();
        portfolio = userDetails.data()['portfolio'].toString();
   }

          setState(() {
            _image = user.photoURL;
          });
     
});
  }

@override
void dispose(){
  super.dispose();
  _animationController.dispose();
  isCollapsedStreamController.close();
  isCollapsedSink.close();
}

void onIconpressed(){
  final animationStatus = _animationController.status;
  final isAnimationCompleted = animationStatus == AnimationStatus.completed;

  if (isAnimationCompleted){
    isCollapsedSink.add(false);
    _animationController.reverse();
  }
  else{
    isCollapsedSink.add(true);
      _animationController.forward();
  }
}

void logout() async{
        await FirebaseAuth.instance.signOut();
        onIconpressed();
  Navigator.pushReplacement(context,
    MaterialPageRoute(builder: (BuildContext context)=>SigninPage())
  );  
  }
  @override
  Widget build(BuildContext context) {
    final screenWidth= MediaQuery.of(context).size.width;

   return StreamBuilder <bool>(
     initialData: false,
     stream: isCollapsedStream,
     builder: (context, isCollapsedAsync){
      
       return AnimatedPositioned(
     duration: _animationDuration,
     top: 0,
     bottom: 0,
     left: isCollapsedAsync.data? -10: -screenWidth ,
     right: isCollapsedAsync.data? 20: screenWidth - 30,
     child: Row(
      
        children: [
         Expanded(
           child: Container(
             padding: EdgeInsets.symmetric(horizontal:10),
             color: Colors.green,
             child: Column(
               children: [
               SizedBox(height:100,),

               ListTile(
                 title: Row(
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children:[
                     Text(surname.toString(), style: TextStyle(color:Colors.white, fontSize:22, fontWeight:FontWeight.w600),),
                     SizedBox(width:5,),
                     Text(name.toString(),  style: TextStyle(color:Colors.white, fontSize:22, fontWeight:FontWeight.w600))
                   
                   ]),
                 subtitle: Column(
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children:[
                     Text(portfolio.toString(),  style: TextStyle(color:Colors.lightGreenAccent, fontSize:15, )),
                   Text(email.toString(),  style: TextStyle(color:Colors.lightGreenAccent, fontSize:15, )),
                   ]),
                 leading: CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 25,
                    child: ClipOval(
                     child: SizedBox(
                       width:80,
                       height:80,
                      child: (_image !=null)? Image.network(_image,fit:BoxFit.fill): 
                   Image.asset('assets/user.png',fit:BoxFit.fill, color: Colors.blueGrey,),

                     ),
                    ),
                  )
                 ),

                 Divider(
                   color: Colors.white.withOpacity(0.9),
                   height: 64,
                   thickness: 0.9,
                   indent: 32,
                   endIndent: 32,
                 ),
              
                MenuItem(
                  icon: Icons.home,
                   title: 'Homepage',
                   onTap: (){
                     onIconpressed();
                     BlocProvider.of<NavigationBloc>(context).add(NavigationEvents.HomePageClickedEvent);
                   },
                   ),
                MenuItem(
                  icon: Icons.person, 
                  title: 'Edit Profile',
                  onTap: (){
                    onIconpressed();
                     BlocProvider.of<NavigationBloc>(context).add(NavigationEvents.ProfileClickedEvent);
                   },
                  ),
                MenuItem(
                  icon: Icons.security, 
                  title: 'ResetPassword',
                  onTap: (){
                    onIconpressed();
                     BlocProvider.of<NavigationBloc>(context).add(NavigationEvents.ResetPasswordClickedEvent);
                   },
                  ),

                 Divider(
                   color: Colors.white.withOpacity(0.9),
                   height: 64,
                   thickness: 0.9,
                   indent: 32,
                   endIndent: 32,
                 ),
                MenuItem(
                  icon: Icons.help_outline, 
                  title: 'Add Motor',
                  onTap: (){
                    onIconpressed();
                     BlocProvider.of<NavigationBloc>(context).add(NavigationEvents.AddItemClickedEvent);
                   },
                  ),
                    MenuItem(
                  icon: Icons.help_outline, 
                  title: 'Help',
                  onTap: (){
                    onIconpressed();
                     BlocProvider.of<NavigationBloc>(context).add(NavigationEvents.HelpClickedEvent);
                   },
                  ),
                MenuItem(
                  icon: Icons.exit_to_app,
                   title: 'Logout',
                   onTap: (){
                     onIconpressed();
                     logout();
                   },
                   ),
               ]
             ),
           )
         ),

          Align(
            alignment: Alignment.topLeft,
            child: GestureDetector(
              onTap: (){
                onIconpressed();
              },
            child:ClipPath(
            //  clipper: CustomMenuClipper(),
         child:Container(
            padding: isCollapsedAsync.data? EdgeInsets.fromLTRB(20, 0, 0, 15) :EdgeInsets.fromLTRB(40, 0, 0, 15),
            width: 60,
            height: 110,
            alignment: Alignment.centerLeft,
            child: AnimatedIcon(
              color: Colors.green ,
              icon:AnimatedIcons.menu_close ,
              progress: _animationController.view,
              size: 30,
              ),
           )
          )
          )
          )
        ]
     )
   );
     }
     );
   
  }
  
}

class CustomMenuClipper extends CustomClipper <Path>{
  @override
  Path getClip(Size size) {

    Paint paint = Paint();
    paint.color= Colors.white;

    final width = size.width;
    final height= size.height;

    Path path = Path();
    path.moveTo(0, 0);
    path.quadraticBezierTo(0, 6, 10, 18);
    path.quadraticBezierTo(width - 1, height/2 - 20, width, height/2);
    path.quadraticBezierTo(width + 1, height/2 + 20, 10, height - 16);
    path.quadraticBezierTo(0, height - 4, 0, height);
    path.close();
      return path;
    }
  
    @override
    bool shouldReclip(CustomClipper<Path> oldClipper) {
  return true;
  }

  
  
}