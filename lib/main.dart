import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_anime_app/models/anime.dart';
import 'package:flutter_anime_app/layouts/body_main.dart';
import 'package:flutter_anime_app/components/card_row.dart';
import 'package:flutter_anime_app/screens/details_screen.dart';
import 'package:flutter_anime_app/screens/characters_screen.dart';
import 'package:flutter_anime_app/components/custom_navigation_bar.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  static const String SERIES_TYPE = "TV";
  static const String MOVIE_TYPE = "Movie";

  static const int navigationScreenIndex = 0;
  static const int detailsScreenIndex = 1;
  static const int charactersScreenIndex = 2;

  static const int homePageIndex = 0;
  static const int favoritePageIndex = 1;

  static const int topTabMoviesIndex = 0;
  static const int topTabSeriesIndex = 1;

  static getAnimeImage(Anime anime) {
    return NetworkImage(anime.image) != null ? NetworkImage(anime.image) : CardRow.defaultThumbnailPath;
  }
  static getAnimeTypeColor(Anime anime) {
    return anime.type == SERIES_TYPE ? 0xFF4C1B1B : 0xFF333366;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Anime App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Anime Home Page'),
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
  int _currentPageIndex;
  int _currentScreenIndex;
  int _currentTopTabIndex;

  List<Widget> _topTabs = [ Tab(text: "Films"), Tab(text: "Séries") ];
  TabController _topController;
  PageController _bottomController;

  Future<Anime> futureAnime;
  Future<List> futureMoviesList;
  Future<List> futureSeriesList;
  Future<List> futureSearchMoviesList;
  Future<List> futureSearchSeriesList;

  bool isSearchProcess;

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
    futureMoviesList = fetchMoviesList();
    futureSeriesList = fetchSeriesList();
    isSearchProcess = false;
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

  Future<List> fetchSearchList(String term, String type) async {
    final response = await http.get('https://api.jikan.moe/v3/search/anime?q=$term&type=${type.toLowerCase()}&page=1');
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

  void _handleOnPageChanged(int pageIndex) {
    setState(() {
      this._currentPageIndex = pageIndex;
      this._topController.animateTo(_currentTopTabIndex);
      this.isSearchProcess = false;
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

  void _handleOnSearchTap(String term) {
    setState(() {
      this.isSearchProcess = true;
      this.futureSearchMoviesList = fetchSearchList(term, MyApp.MOVIE_TYPE);
      this.futureSearchSeriesList = fetchSearchList(term, MyApp.SERIES_TYPE);
    });
  }

  Widget _getListItem(Anime anime)
  {
    return GestureDetector(
      child: CardRow(anime),
      onTap: () => {
        _handleOnScreenChanged(MyApp.detailsScreenIndex, anime: anime)
      },
    );
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
              return _getListItem(anime);
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

    if (this.isSearchProcess == false) {

      if (_currentTopTabIndex == MyApp.topTabMoviesIndex)
        futureBuilderList = futureBuilderMoviesList;

      if (_currentTopTabIndex == MyApp.topTabSeriesIndex)
        futureBuilderList = futureBuilderSeriesList;

    } else {

      if (_currentTopTabIndex == MyApp.topTabMoviesIndex)
        futureBuilderList = _buildFutureBuilderList(futureSearchMoviesList);

      if (_currentTopTabIndex == MyApp.topTabSeriesIndex)
        futureBuilderList = _buildFutureBuilderList(futureSearchSeriesList);
    }

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
        futureBuilderList: futureBuilderList,
        onSearchTap: _handleOnSearchTap,
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
          onScreenChanged: this._handleOnScreenChanged
      );

    return mainScreen;
  }
}
