import 'package:flutter/material.dart';
import 'package:flutter_anime_app/main.dart';

class DetailsScreen extends StatelessWidget {

  Function(int) onScreenChanged;

  DetailsScreen({
    Key key, this.onScreenChanged
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Détails Anime")),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Text("Top section"),
          ),
          Expanded(
            flex: 2,
            child: Text("Bottom section"),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => {
          this.onScreenChanged(MyApp.navigationScreenIndex)
        },
        tooltip: 'Increment',
        child: Icon(Icons.arrow_back),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}