import 'package:flutter/material.dart';
import 'package:motorapp/bloc.navigation_bloc/navigation_bloc.dart';
import 'package:motorapp/mainhomepagetabs/chats.dart';
import 'package:motorapp/mainhomepagetabs/dashboard.dart';

class MainHomepage extends StatefulWidget with NavigationStates{
 
 @override
  _MainHomepageState createState() => _MainHomepageState();
}

class _MainHomepageState extends State<MainHomepage> with SingleTickerProviderStateMixin{
      TabController tabController;
    @override
    void initState (){
      super.initState();

      tabController = new TabController(length:3 , vsync: this);
    }

  @override
  Widget build(BuildContext context) {
   return Scaffold(
      bottomNavigationBar: new Material(
        color: Colors.green,
        child: TabBar(
          indicatorColor: Colors.white,
            controller: tabController,
          tabs: [
              new Tab(icon: Icon(Icons.home)),
              new Tab(icon: Icon(Icons.chat)),
          ]
          ),
        ),

        body: TabBarView(
          controller: tabController,
          children: [
              DashBoardPage(),
              ChatsPage(),
          ]
          ),
   );
  }
  
}