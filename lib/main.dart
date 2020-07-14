import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_anime_app/models/anime.dart';
import 'package:flutter_anime_app/layouts/body_main.dart';
import 'package:flutter_anime_app/components/card_row.dart';
import 'package:flutter_anime_app/screens/details_screen.dart';
import 'package:flutter_anime_app/screens/characters_screen.dart';
import 'package:flutter_anime_app/components/custom_navigation_bar.dart';

import 'models/anime_detail.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  static const int navigationScreenIndex = 0;
  static const int detailsScreenIndex = 1;
  static const int charactersScreenIndex = 2;

  static const int homePageIndex = 0;
  static const int favoritePageIndex = 1;

  static const int topTabMoviesIndex = 0;
  static const int topTabSeriesIndex = 1;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {

  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin {

  Anime _currentAnime;
  AnimeDetail _currentAnimeDetail;
  int _currentPageIndex;
  int _currentScreenIndex;
  int _currentTopTabIndex;

  List<Widget> _topTabs = [ Tab(text: "Films"), Tab(text: "Séries") ];
  TabController _topController;
  PageController _bottomController;

  Future<Anime> futureAnime;
  Future<AnimeDetail> futureAnimeDetail;
  Future<List> futureMoviesList;
  Future<List> futureSeriesList;

  @override
  void initState() {
    super.initState();
    _currentAnime = null;
    _currentPageIndex = MyApp.homePageIndex;
    _currentTopTabIndex = MyApp.topTabMoviesIndex;
    _currentScreenIndex = MyApp.navigationScreenIndex;
    _topController = TabController(length: _topTabs.length, vsync: this);
    _bottomController = PageController(
      initialPage: _currentPageIndex,
    );
    futureAnime = fetchAnime();
    futureAnimeDetail = fetchAnimeDetail();
    futureMoviesList = fetchMoviesList();
    futureSeriesList = fetchSeriesList();
  }

  Future<AnimeDetail> fetchAnimeDetail() async {
    final response = await http.get('https://api.jikan.moe/v3/anime/1');
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return AnimeDetail.fromJson(json.decode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load anime');
    }
  }

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

  void _handleOnPageChanged(int pageIndex) {
    setState(() {
      this._currentPageIndex = pageIndex;
      this._topController.animateTo(_currentTopTabIndex);
    });
  }

  void _handleOnScreenChanged(int screenIndex, {Anime anime}) {
    setState(() {
      this._currentScreenIndex = screenIndex;
      if (screenIndex == MyApp.detailsScreenIndex) {
        this._currentAnime = anime;
      } else {
        this._bottomController = PageController(
          initialPage: _currentPageIndex,
        );
        this._topController.animateTo(_currentTopTabIndex);
      }
    });
  }

  void _handleOnTopTabChanged(int topTabIndex) {
    setState(() {
      this._currentTopTabIndex = topTabIndex;
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
                  _handleOnScreenChanged(MyApp.detailsScreenIndex, anime: anime)
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

    Widget futureBuilderList;
    Widget futureBuilderMoviesList = _buildFutureBuilderList(futureMoviesList);
    Widget futureBuilderSeriesList = _buildFutureBuilderList(futureSeriesList);
    Widget futureBuilderDetail = _buildFutureBuilderList(futureSeriesList);



    if (_currentTopTabIndex == MyApp.topTabMoviesIndex)
      futureBuilderList = futureBuilderMoviesList;

    if (_currentTopTabIndex == MyApp.topTabSeriesIndex)
      futureBuilderList = futureBuilderSeriesList;
    

    Widget navigationScreen = Scaffold(
      appBar: AppBar(title: Text("Anime App")),
      body: BodyMain(
        topTabs: _topTabs,
        onPageChanged: _handleOnPageChanged,
        onScreenChanged: _handleOnScreenChanged,
        onTopTabChanged: _handleOnTopTabChanged,
        topController: _topController,
        bottomController: _bottomController,
        currentTopTabIndex: _currentTopTabIndex,
        futureBuilderList: futureBuilderList
      ),
      bottomNavigationBar: CustomNavigationBar(
        currentIndex: _currentPageIndex,
        bottomController: _bottomController,
      )
    );

    Widget mainScreen;

    if (_currentScreenIndex == MyApp.navigationScreenIndex)
      mainScreen = navigationScreen;

    if (_currentScreenIndex == MyApp.charactersScreenIndex)
      mainScreen = CharactersScreen(
          onScreenChanged: this._handleOnScreenChanged
      );

    if (_currentScreenIndex == MyApp.detailsScreenIndex)
      mainScreen = DetailsScreen(
          anime: _currentAnime,
          animeDetail: _currentAnimeDetail,
          onScreenChanged: this._handleOnScreenChanged
      );

    return mainScreen;
  }
}
