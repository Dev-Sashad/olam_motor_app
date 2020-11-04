import 'package:flutter/material.dart';
import 'package:motorapp/dashboardpage/badList.dart';
import 'package:motorapp/dashboardpage/goodList.dart';
import 'package:motorapp/dashboardpage/recentlyUsed.dart';
import 'package:motorapp/dashboardpage/totalList.dart';


class DashBoardPage extends StatefulWidget{
 
 @override
  _DashBoardPageState createState() => _DashBoardPageState();
}

class  _DashBoardPageState extends State<DashBoardPage> with SingleTickerProviderStateMixin{
  TabController tabController;
    @override
    void initState (){
      super.initState();

      tabController = new TabController(length:3 , vsync: this);
    }

    int selectedIndex =0;
    Color textColor = Colors.green;
    List<NavigationItem> items = [
        NavigationItem( Tab(icon: Icon(Icons.done_outline, size:24,)), Text('All',), Colors.grey),
        NavigationItem( Tab(icon: Icon(Icons.done_all, size:24,color: Colors.green,)), Text('Good'), Colors.green),
        NavigationItem( Tab(icon: Icon(Icons.close, size:24,color: Colors.red,)), Text('Bad'), Colors.red),
         NavigationItem( Tab(icon: Icon(Icons.close, size:24,color: Colors.blueAccent,)), Text('Used'), Colors.blueAccent),
    ];
    Widget _buildItem(NavigationItem item, bool isSelected){
              return AnimatedContainer(
                duration: Duration(milliseconds: 300),
                height: double.maxFinite,
                width: isSelected ? 150: 50,
                alignment: isSelected ? Alignment.center : null,
                padding: EdgeInsets.symmetric(horizontal:5),
                margin: isSelected? EdgeInsets.fromLTRB(5,8,8,0): null,
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
                    mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  item.tab,
                  Padding(padding: EdgeInsets.only(left:8),
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
         appBar: AppBar(
           backgroundColor: Colors.white,
           shadowColor: Colors.black12,
            automaticallyImplyLeading: false,
            title: Column(
              crossAxisAlignment:CrossAxisAlignment.center,
              mainAxisAlignment:MainAxisAlignment.spaceEvenly,
              children:[
                Text('Olam Motor',style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600, decorationColor: Colors.green),),
                
                TabBar(
                  indicatorWeight:0.0 ,
                controller: tabController,
              tabs: items.map((item) {
                var itemIndex = items.indexOf(item);
                  return GestureDetector (
                    onTap: (){
                      setState(() {
                        selectedIndex = itemIndex;
                      });
                    },
                    child: _buildItem(item, selectedIndex == itemIndex),
                  );
              }).toList(),
              
              ),
              ]
            ),
         ),
    
            body: TabBarView(
              controller: tabController,
              children: [
                  TotalListPage(),
                  GoodListPage(),
                  BadListPage(),
                  RecentlyUsedPage(),
              ]
              ),
       );
      }
      
    }
    
    class NavigationItem {
      final Tab tab;
      final Text title;
      final Color color;

  NavigationItem(this.tab, this.title, this.color);

}