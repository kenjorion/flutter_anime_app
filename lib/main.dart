import 'package:flutter/material.dart';
import 'package:flutter_anime_app/components/custom_navigation_bar.dart';
import 'package:flutter_anime_app/layouts/body_main.dart';
import 'package:flutter_anime_app/screens/characters_screen.dart';
import 'package:flutter_anime_app/screens/details_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  static int navigationScreenIndex = 0;
  static int detailsScreenIndex = 1;
  static int charactersScreenIndex = 2;

  static int homePageIndex = 0;
  static int favoritePageIndex = 1;

  static int topTabMoviesIndex = 0;
  static int topTabSeriesIndex = 1;

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

  int _currentPageIndex;
  int _currentScreenIndex;
  int _currentTopTabIndex;

  List<Widget> _topTabs = [ Tab(text: "Films"), Tab(text: "Séries") ];
  TabController _topController;
  PageController _bottomController;

  @override
  void initState() {
    super.initState();
    _currentPageIndex = MyApp.homePageIndex;
    _currentTopTabIndex = MyApp.topTabMoviesIndex;
    _currentScreenIndex = MyApp.navigationScreenIndex;
    _topController = TabController(length: _topTabs.length, vsync: this);
    _bottomController = PageController(
      initialPage: _currentPageIndex,
    );
  }

  void _handleOnPageChanged(int pageIndex) {
    setState(() {
      this._currentPageIndex = pageIndex;
      this._topController.animateTo(_currentTopTabIndex);
    });
  }

  void _handleOnScreenChanged(int screenIndex) {
    setState(() {
      this._currentScreenIndex = screenIndex;
      this._bottomController = PageController(
        initialPage: _currentPageIndex,
      );
      this._topController.animateTo(_currentTopTabIndex);
    });
  }

  void _handleOnTopTabChanged(int topTabIndex) {
    setState(() {
      this._currentTopTabIndex = topTabIndex;
    });
  }

  @override
  Widget build(BuildContext context) {

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
      ),
      bottomNavigationBar: CustomNavigationBar(
        currentIndex: _currentPageIndex,
        bottomController: _bottomController,
      )
    );

    Widget charactersScreen = CharactersScreen(onScreenChanged: this._handleOnScreenChanged);
    Widget detailsScreen = DetailsScreen(onScreenChanged: this._handleOnScreenChanged);
    Widget mainScreen;

    if (_currentScreenIndex == MyApp.navigationScreenIndex)
      mainScreen = navigationScreen;

    if (_currentScreenIndex == MyApp.charactersScreenIndex)
      mainScreen = charactersScreen;

    if (_currentScreenIndex == MyApp.detailsScreenIndex)
      mainScreen = detailsScreen;

    return mainScreen;
  }
}
