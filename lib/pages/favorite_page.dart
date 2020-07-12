import 'package:flutter/material.dart';

class FavoritePage extends StatefulWidget {

  List<Widget> topTabs;
  int currentTopTabIndex;
  TabController topController;
  Function(int) onScreenChanged;
  Function(int) onTopTabChanged;
  FutureBuilder futureBuilderList;

  FavoritePage({
    Key key,
    this.topTabs,
    this.topController,
    this.onScreenChanged,
    this.onTopTabChanged,
    this.currentTopTabIndex,
    this.futureBuilderList
  }) : super(key: key);

  @override
  _FavoritePageState createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          height: 50,
          decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 2,
                  offset: Offset(0, 1), // changes position of shadow
                )
              ]
          ),
          child: TabBar(
              tabs: widget.topTabs,
              controller: widget.topController,
              labelColor: Theme.of(context).primaryColor,
              indicatorColor: Theme.of(context).primaryColor,
              unselectedLabelColor: Colors.grey,
              onTap: (index) {
                widget.onTopTabChanged(index);
              },
          ),
        ),
        Expanded(
            flex: 3,
            child: widget.futureBuilderList
        )
      ],
    );
  }
}