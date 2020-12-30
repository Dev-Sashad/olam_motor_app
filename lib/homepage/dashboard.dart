import 'package:flutter/material.dart';
import 'package:motorapp/bloc.navigation_bloc/navigation_bloc.dart';
import 'package:motorapp/dashboardpage/badList.dart';
import 'package:motorapp/dashboardpage/goodList.dart';
import 'package:motorapp/dashboardpage/recentlyUsed.dart';
import 'package:motorapp/dashboardpage/totalList.dart';


class DashBoardPage extends StatefulWidget with NavigationStates {
 
 @override
  _DashBoardPageState createState() => _DashBoardPageState();
}

class  _DashBoardPageState extends State<DashBoardPage> with SingleTickerProviderStateMixin{
  TabController tabController;
    @override
    void initState (){
      super.initState();

      tabController = new TabController(length:4 , vsync: this);
    }
      int selectedIndex = 0;
    Color textColor = Colors.green;
    List<NavigationItem> items = [
        NavigationItem( Icon(Icons.done_outline, size:20,color: Colors.blueGrey,), Text('All',), Colors.blueGrey),
        NavigationItem( Icon(Icons.done_all, size:20,color: Colors.green,), Text('Good'), Colors.green),
        NavigationItem(Icon(Icons.close, size:20,color: Colors.red,), Text('Bad'), Colors.red),
         NavigationItem( Icon(Icons.close, size:20,color: Colors.blueAccent,), Text('Used'), Colors.blueAccent),
    ];
    Widget _buildItem(NavigationItem item, bool isSelected){
              return AnimatedContainer(
                duration: Duration(milliseconds: 300),
                height: 40,
                width: isSelected ? 150: 50,
                alignment: isSelected ? Alignment.center : null,
                //padding: EdgeInsets.symmetric(horizontal:5),
                //margin: isSelected? EdgeInsets.fromLTRB(0,0,0,0): null,
                decoration: isSelected? BoxDecoration(
                  border: Border.all(
                    color:  item.color,
                    width: 1.5,
                  ),
                  borderRadius: BorderRadius.circular(15),
                ) : null,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  item.icon,
                  Padding(padding: EdgeInsets.only(left:0),
                  child: isSelected? DefaultTextStyle.merge(style: TextStyle(
                    color: item.color
                  ), 
                  child: item.title) : Container())
              ],
              )
                ]
                )
              );
        }
      @override
      Widget build(BuildContext context) {
       return Scaffold(
    
            body: TabBarView(
              controller: tabController,
              children: [
                  TotalListPage(),
                  GoodListPage(),
                  BadListPage(),
                  RecentlyUsedPage(),
              ]
              ),

      bottomNavigationBar: new Material(
        color: Colors.white,
        child: TabBar(
                  indicatorWeight: 1.0 ,
                  indicatorColor: Colors.transparent,
                controller: tabController,
                onTap: (value){
                  setState ((){
                    selectedIndex = tabController.index ;
                  }
                  );
                },
              tabs: [

               new Tab(
                  child:_buildItem(items.elementAt(0), selectedIndex == items.indexOf(items.elementAt(0))) ,
               
                ),

                 new Tab(
                child:_buildItem(items.elementAt(1), selectedIndex == items.indexOf(items.elementAt(1))) ,
                
                ),

                  new Tab(
                child:_buildItem(items.elementAt(2), selectedIndex == items.indexOf(items.elementAt(2))) ,
                
                ),

                   new Tab(
                  child:_buildItem(items.elementAt(3), selectedIndex == items.indexOf(items.elementAt(3))) ,
                 
                ),
                
              ]
              ),
        ),
       );
      }
      
    }
    
    class NavigationItem {
      final Icon icon;
      final Text title;
      final Color color;

  NavigationItem(this.icon, this.title, this.color);

}

 