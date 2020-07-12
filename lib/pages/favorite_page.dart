import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_anime_app/main.dart';
import 'package:flutter_anime_app/models/anime.dart';
import 'package:flutter_anime_app/screens/CardRow.dart';
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

  Future<Anime> futureAnime;
  Future<List> futureMoviesList;
  Future<List> futureSeriesList;

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

  @override
  void initState() {
    super.initState();
    futureAnime = fetchAnime();
    futureMoviesList = fetchMoviesList();
    futureSeriesList = fetchSeriesList();
  }

  @override
  Widget build(BuildContext context) {
    Widget futureBuilderMoviesList = FutureBuilder<List>(
      future: futureMoviesList,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            itemCount: snapshot.data.length,
            itemBuilder: (context, index) {
              Anime anime = snapshot.data[index];
              return GestureDetector(
                child: new CardRow(anime),
                onTap: () => {
                  widget.onScreenChanged(MyApp.detailsScreenIndex)
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
    Widget futureBuilderSeriesList = FutureBuilder<List>(
      future: futureSeriesList,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            itemCount: snapshot.data.length,
            itemBuilder: (context, index) {
              Anime anime = snapshot.data[index];
              return GestureDetector(
                child: new CardRow(anime),
                onTap: () => {
                  widget.onScreenChanged(MyApp.detailsScreenIndex)
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
    Widget futureBuilderResultList;

    if (widget.currentTopTabIndex == MyApp.topTabMoviesIndex)
      futureBuilderResultList = futureBuilderMoviesList;

    if (widget.currentTopTabIndex == MyApp.topTabSeriesIndex)
      futureBuilderResultList = futureBuilderSeriesList;

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
            child: futureBuilderResultList
        )
      ],
    );
  }
}