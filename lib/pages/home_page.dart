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
  Function(int) onScreenChanged;
  Function(int) onTopTabChanged;
  FutureBuilder futureBuilderList;

  HomePage({
    Key key,
    this.topTabs,
    this.topController,
    this.onScreenChanged,
    this.onTopTabChanged,
    this.currentTopTabIndex,
    this.futureBuilderList
  }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  String searchTerm;
  bool isSearchTerm;
  FutureBuilder futureBuilderSearchList;

  @override
  void initState() {
    super.initState();
    searchTerm = "";
    isSearchTerm = false;
  }

  Future<List> fetchSearchList() async {
    String type = widget.currentTopTabIndex == MyApp.topTabMoviesIndex ? "movie" : "tv";
    final response = await http.get('https://api.jikan.moe/v3/search/anime?q=$searchTerm&type=$type&page=1');
    if (response.statusCode == 200) {
      Map<String, dynamic> responseResult = json.decode(response.body);

      return (responseResult['results'] as List)
          .map((data) => new Anime.fromJson(data))
          .toList();
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load anime list (movies)');
    }
  }

  void _handleOnSearchButtonClick() {
    setState(() {
      isSearchTerm = searchTerm.length > 0;
    });
  }

  void _handleOnSearchInputChanged(String term) {
    setState(() {
      searchTerm = term;
      if (searchTerm.trim().length == 0)
        isSearchTerm = false;
    });
  }

  Widget _buildFutureBuilderList(Future<List<dynamic>> futureList)
  {
    return FutureBuilder<List>(
      future: futureList,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            itemCount: snapshot.data.length,
            itemBuilder: (context, index) {
              Anime anime = snapshot.data[index];
              return GestureDetector(
                child: CardRow(anime),
                onTap: () => {
                  widget.onScreenChanged(MyApp.detailsScreenIndex)
                },
              );
            },
          );
        } else if (snapshot.hasError) {
          return Center(
              child: CircularProgressIndicator()
          );
        }
        // By default, show a loading spinner.
        return Center(
            child: CircularProgressIndicator()
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {

    Widget futureBuilderList = widget.futureBuilderList;

    if (isSearchTerm)
      futureBuilderList = _buildFutureBuilderList(fetchSearchList());

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
                          onPressed: _handleOnSearchButtonClick,
                        ),
                      )
                  )
              ),
            ],
          ),
        ),
        Expanded(
            child: futureBuilderList
        )
      ],
    );
  }
}

