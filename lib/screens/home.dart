import 'package:flutter/material.dart';

class Home extends StatelessWidget {

  List<Widget> topTabs;
  TabController topController;

  Home({
    Key key, this.topTabs, this.topController
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
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
              tabs: topTabs,
              controller: topController,
              labelColor: Theme.of(context).primaryColor,
              indicatorColor: Theme.of(context).primaryColor,
              unselectedLabelColor: Colors.grey
          ),
        ),
        Expanded(
            child: Container(
                decoration: BoxDecoration(
                    color: Colors.black
                )
            )
        )
      ],
    );
  }
}