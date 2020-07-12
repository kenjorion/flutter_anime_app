import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_anime_app/main.dart';
import 'package:flutter_anime_app/models/anime.dart';
import 'package:http/http.dart' as http;

class FavoritePage extends StatefulWidget {

  List<Widget> topTabs;
  int currentTopTabIndex;
  TabController topController;
  Function(int) onScreenChanged;
  Function(int) onTopTabChanged;

  FavoritePage({
    Key key, this.topTabs, this.topController, this.onScreenChanged, this.onTopTabChanged, this.currentTopTabIndex
  }) : super(key: key);

  @override
  _FavoritePageState createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {

  String searchTerm;
  bool isSearchTerm;
  Future<Anime> futureAnime;
  Future<List> futureMoviesList;
  Future<List> futureSeriesList;
  Future<List> futureSearchMoviesList;
  Future<List> futureSearchSeriesList;

  Future<Anime> fetchAnime() async {
    final response = await http.get('https://api.jikan.moe/v3/anime/1');
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return Anime.fromJson(json.decode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load anime');
    }
  }

  Future<List> fetchMoviesList() async {
    final response = await http.get('https://api.jikan.moe/v3/top/anime/1/movie');
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      Map<String, dynamic> responseResult = json.decode(response.body);
      return (responseResult['top'] as List)
          .map((data) => new Anime.fromJson(data))
          .toList();
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load anime list (movies)');
    }
  }

  Future<List> fetchSeriesList() async {
    final response = await http.get('https://api.jikan.moe/v3/top/anime/1/tv');
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      Map<String, dynamic> responseResult = json.decode(response.body);
      return (responseResult['top'] as List)
          .map((data) => new Anime.fromJson(data))
          .toList();
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load anime list (series)');
    }
  }

  Future<List> fetchSearchMoviesList() async {
    final response = await http.get('https://api.jikan.moe/v3/top/anime/1/movie');
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      Map<String, dynamic> responseResult = json.decode(response.body);
      return (responseResult['top'] as List)
          .map((data) => new Anime.fromJson(data))
          .toList();
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load anime list (movies)');
    }
  }

  @override
  void initState() {
    super.initState();
    searchTerm = "";
    isSearchTerm = false;
    futureAnime = fetchAnime();
    futureMoviesList = fetchMoviesList();
    futureSeriesList = fetchSeriesList();
  }

  void _handleOnSearchButtonClick() {
    setState(() {
      isSearchTerm = true;
    });
  }

  void _handleOnSearchInputChanged(String term) {
    setState(() {
      searchTerm = term;
    });
  }

  Widget _buildFutureBuilderList(Future<List<dynamic>> futureList, int nextScreenIndex) {
    return FutureBuilder<List>(
      future: futureList,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            itemCount: snapshot.data.length,
            itemBuilder: (context, index) {
              Anime anime = snapshot.data[index];
              return GestureDetector(
                child: Text(anime.title),
                onTap: () => {
                  widget.onScreenChanged(nextScreenIndex)
                },
              );
            },
          );
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
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

    Widget futureBuilderMoviesList = _buildFutureBuilderList(futureMoviesList, MyApp.detailsScreenIndex);
    Widget futureBuilderSeriesList = _buildFutureBuilderList(futureSeriesList, MyApp.detailsScreenIndex);
    Widget futureBuilderResultList;

    if (isSearchTerm && searchTerm.trim().isNotEmpty) {

      

    } else {

      if (widget.currentTopTabIndex == MyApp.topTabMoviesIndex)
        futureBuilderResultList = futureBuilderMoviesList;

      if (widget.currentTopTabIndex == MyApp.topTabSeriesIndex)
        futureBuilderResultList = futureBuilderSeriesList;
    }

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
        Container(
          height: 50,
          margin: EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0, bottom: 40.0),
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
            child: futureBuilderResultList
        )
      ],
    );
  }
}