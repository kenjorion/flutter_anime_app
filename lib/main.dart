import 'package:flutter/material.dart';
import 'package:flutter_anime_app/components/custom_navigation_bar.dart';
import 'package:flutter_anime_app/layouts/body_main.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
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

  int _currentIndex = 0;
  List<Widget> _topTabs = [ Tab(text: "Films"), Tab(text: "Séries") ];
  TabController _topController;
  PageController _bottomController;

  @override
  void initState() {
    _topController = TabController(length: _topTabs.length, vsync: this);
    _bottomController = PageController(
      initialPage: _currentIndex,
    );
    super.initState();
  }

  void _handleOnPageChanged(int index) {
    setState(() {
      this._currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BodyMain(
        topTabs: _topTabs,
        onPageChanged: _handleOnPageChanged,
        topController: _topController,
        bottomController: _bottomController,
      ),
      appBar: AppBar(title: Text("Anime App")),
      bottomNavigationBar: CustomNavigationBar(
        currentIndex: _currentIndex,
        bottomController: _bottomController,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => {},
        tooltip: 'Increment',
        child: Icon(Icons.arrow_back),
      ), // This trailing comma makes auto-formatting nicer for build methods.
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
