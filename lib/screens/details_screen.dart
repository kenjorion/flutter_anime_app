import 'package:flutter/material.dart';
import 'package:flutter_anime_app/components/separator.dart';
import 'package:flutter_anime_app/components/style.dart';
import 'package:flutter_anime_app/main.dart';
import 'package:flutter_anime_app/models/anime.dart';
import 'package:flutter_anime_app/screens/CardRow.dart';

class DetailsScreen extends StatelessWidget {

  Function(int) onScreenChanged;

  DetailsScreen({
    Key key, this.onScreenChanged, this.anime
  }) : super(key: key);

  final Anime anime;


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Container(
        constraints: new BoxConstraints.expand(),
        color: new Color(0xFF736AB7),
        child: new Stack (
          children: <Widget>[
            _getBackground(),
            _getGradient(),
            _getContent(),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () =>
        {
          this.onScreenChanged(MyApp.navigationScreenIndex)
        },
        tooltip: 'Increment',
        child: Icon(Icons.arrow_back),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Container _getBackground() {
    return new Container(
      child: new Image.network("https://upload.wikimedia.org/wikipedia/commons/thumb/4/4d/Orion_3008_huge.jpg/1024px-Orion_3008_huge.jpg",
        fit: BoxFit.cover,
        height: 300.0,
      ),
      constraints: new BoxConstraints.expand(height: 295.0),
    );
  }

  Container _getGradient() {
    return new Container(
      margin: new EdgeInsets.only(top: 190.0),
      height: 110.0,
      decoration: new BoxDecoration(
        gradient: new LinearGradient(
          colors: <Color>[
            new Color(0x00736AB7),
            new Color(0xFF736AB7)
          ],
          stops: [0.0, 0.9],
          begin: const FractionalOffset(0.0, 0.0),
          end: const FractionalOffset(0.0, 1.0),
        ),
      ),
    );
  }

  Container _getContent() {
    final _overviewTitle = "Overview".toUpperCase();
    return new Container(
      child: new ListView(
        padding: new EdgeInsets.fromLTRB(0.0, 72.0, 0.0, 32.0),
        children: <Widget>[
          new CardRow(anime,
            horizontal: false,
          ),
          new Container(
            padding: new EdgeInsets.symmetric(horizontal: 32.0),
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Text(_overviewTitle,
                  style: Style.headerTextStyle,),
                new Separator(),
                new Text(
                    "hzhz", style: Style.commonTextStyle),
              ],
            ),
          ),
        ],
      ),
    );
  }


}