import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:motorapp/bloc.navigation_bloc/navigation_bloc.dart';
import 'package:motorapp/homepage/dashboard.dart';
import 'package:motorapp/homepage/sidebar.dart';



class Homepage extends StatefulWidget {


    @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  
  NavigationStates get initialState => DashBoardPage();

  @override
  Widget build(BuildContext context) {
   return Scaffold(
      body:BlocProvider<NavigationBloc>(
            create: (context) => NavigationBloc (initialState ),
            child: Stack(
              children: [
                BlocBuilder <NavigationBloc, NavigationStates>(
                  builder: (context, navigationStates){
                    return navigationStates as Widget;
                  }
                  
                  ),
              SideBarpage(),
              ]
            ),
            ),
   );
  }
  
}