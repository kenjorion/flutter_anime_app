import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_anime_app/components/card_row.dart';
import 'package:flutter_anime_app/main.dart';
import 'package:flutter_anime_app/models/anime.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {

  List<Widget> topTabs;
  int currentTopTabIndex;
  TabController topController;
  Function(int) onTopTabChanged;
  FutureBuilder futureBuilderList;
  Function(String) onSearchTap;

  HomePage({
    Key key,
    this.topTabs,
    this.topController,
    this.onTopTabChanged,
    this.currentTopTabIndex,
    this.futureBuilderList,
    this.onSearchTap
  }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  String searchTerm;

  @override
  void initState() {
    super.initState();
    searchTerm = "";
  }

  void _handleOnSearchInputChanged(String term) {
    setState(() {
      searchTerm = term;
    });
  }

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
            tabs: widget.topTabs,
            controller: widget.topController,
            labelColor: Theme.of(context).primaryColor,
            indicatorColor: Theme.of(context).primaryColor,
            unselectedLabelColor: Colors.grey,
            onTap: (index) => {
              widget.onTopTabChanged(index)
            },
          ),
        ),
        Container(
          height: 50,
          margin: EdgeInsets.all(20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(
                  flex: 10,
                  child: TextFormField(
                    decoration: InputDecoration(
                        hintText: "Cherche ton anime",
                        contentPadding: EdgeInsets.symmetric(horizontal: 10.0)
                    ),
                    onChanged: _handleOnSearchInputChanged,
                  )
              ),
              Expanded(
                  flex: 2,
                  child: Center(
                      child: Ink(
                        decoration: const ShapeDecoration(
                          color: Colors.lightBlue,
                          shape: CircleBorder(),
                        ),
                        child: IconButton(
                          icon: Icon(Icons.search),
                          color: Colors.white,
                          onPressed: () => {
                            widget.onSearchTap(this.searchTerm)
                          },
                        ),
                      )
                  )
              ),
            ],
          ),
        ),
        Expanded(
            child: widget.futureBuilderList
        )
      ],
    );
  }
}

