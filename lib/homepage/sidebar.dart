import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
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
  var userIdentity,name,surname,email,portfolio, _image;
 // final bool isCollapsed = false;
  final _animationDuration = const Duration(milliseconds:500);

  @override
  Future<void> initState() async {
    super.initState();
    _animationController = AnimationController(vsync: this, duration:_animationDuration);
    isCollapsedStreamController = PublishSubject<bool>();
    isCollapsedStream = isCollapsedStreamController.stream;
    isCollapsedSink = isCollapsedStreamController.sink;

     userIdentity= FirebaseAuth.instance.currentUser.uid;
     print('$userIdentity');
   await FirebaseFirestore.instance.collection('users').doc(userIdentity).get().then((value) async {
      setState(() {
       userDetails = value;
      });

      if (userDetails!=null){  
        name = userDetails.data()['name'].toString();
        surname = userDetails.data()['surname'].toString();
        email = userDetails.data()['email'].toString();
        portfolio = userDetails.data()['portfolio'].toString();
   }
     
     StorageReference firebaseStorageRef  = FirebaseStorage.instance.ref().child(userIdentity);
        FirebaseStorage uploadTask = firebaseStorageRef.getStorage();
       // await uploadTask.;
        setState(() {
            _image = uploadTask;

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
  Navigator.of(context).pushReplacement(
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
     left: isCollapsedAsync.data? 0: -screenWidth ,
     right: isCollapsedAsync.data? 0: screenWidth - 45,
     child: Row(
      
        children: [
         Expanded(
           child: Container(
             padding: EdgeInsets.symmetric(horizontal:20),
             color: Colors.green,
             child: Column(
               children: [
               SizedBox(height:100,),

               ListTile(
                 title: Row(
                   children:[
                     Text(surname, style: TextStyle(color:Colors.white, fontSize:30, fontWeight:FontWeight.w800),),
                     Text(name,  style: TextStyle(color:Colors.white, fontSize:30, fontWeight:FontWeight.w800))
                   
                   ]),
                 subtitle: Column(
                   children:[
                     Text(portfolio,  style: TextStyle(color:Colors.lightGreenAccent, fontSize:20, )),
                   Text(email,  style: TextStyle(color:Colors.lightGreenAccent, fontSize:20, )),
                   ]),
                 leading: CircleAvatar(
                   child: (_image !=null)? Image.file(_image,fit:BoxFit.fill): Image.asset('assets/user.png', fit:BoxFit.fill, color: Colors.blueGrey,),
                   radius: 40,
                 ),
                 ),

                 Divider(
                   color: Colors.white.withOpacity(0.3),
                   height: 64,
                   thickness: 0.5,
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
                   color: Colors.white.withOpacity(0.3),
                   height: 64,
                   thickness: 0.5,
                   indent: 32,
                   endIndent: 32,
                 ),
                MenuItem(
                  icon: Icons.help_outline, 
                  title: 'Add Item',
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
                     
                   },
                   ),
               ]
             ),
           )
         ),

          Align(
            alignment: Alignment(0, -0.9),
            child: GestureDetector(
              onTap: (){
                onIconpressed();
              },
            child:ClipPath(
              clipper: CustomMenuClipper(),
         child:Container(
            width: 30,
            height: 110,
            color: Colors.green,
            alignment: Alignment.centerLeft,
            child: AnimatedIcon(
              color: Colors.lightGreenAccent ,
              icon:AnimatedIcons.menu_close ,
              progress: _animationController.view,
              size: 25,
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
    path.quadraticBezierTo(0, 8, 10, 16);
    path.quadraticBezierTo(width - 1, height/2 - 20, width, height);
    path.quadraticBezierTo(width + 1, height/2 + 20, 10, height - 16);
    path.quadraticBezierTo(0, height - 8, 0, height);
    path.close();
      return path;
    }
  
    @override
    bool shouldReclip(CustomClipper<Path> oldClipper) {
  return true;
  }

  
  
}