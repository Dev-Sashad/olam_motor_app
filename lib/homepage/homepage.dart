import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:motorapp/bloc.navigation_bloc/navigation_bloc.dart';
import 'package:motorapp/homepage/mainhomepage.dart';
import 'package:motorapp/homepage/sidebar.dart';

class Homepage extends StatelessWidget {
  NavigationStates get initialState => MainHomepage();

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