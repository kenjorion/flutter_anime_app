import 'package:flutter/material.dart';
import 'package:flutter_anime_app/components/separator.dart';
import 'package:flutter_anime_app/components/style.dart';
import 'package:flutter_anime_app/main.dart';
import 'package:flutter_anime_app/models/anime.dart';
import 'package:flutter_anime_app/components/card_row.dart';
import 'package:flutter_anime_app/models/anime_detail.dart';

class DetailsScreen extends StatelessWidget {

  Anime anime;
  AnimeDetail animeDetail;

  Function(int) onScreenChanged;

  DetailsScreen({
    Key key,
    this.anime,
    this.animeDetail,
    this.onScreenChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        //constraints: BoxConstraints.expand(),
        color: Color(0xFF736AB7),
        child: Stack (
          children: <Widget>[
            _getBackground(),
            _getGradient(),
            _getContent(),
          ],
        ),
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

  Container _getBackground() {
    return Container(
      child: Image.network("https://upload.wikimedia.org/wikipedia/commons/thumb/4/4d/Orion_3008_huge.jpg/1024px-Orion_3008_huge.jpg",
        fit: BoxFit.cover,
        height: 350.0,
      ),
      constraints: BoxConstraints.expand(height: 350.0),
    );
  }

  Container _getGradient() {
    return Container(
      margin: EdgeInsets.only(top: 240.0),
      height: 110.0,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: <Color>[
            Color(0x00736AB7),
            Color(0xFF736AB7)
          ],
          end: FractionalOffset(0.0, 1.0),
          begin: FractionalOffset(0.0, 0.0),
          stops: [0.0, 0.9],
        ),
      ),
    );
  }

  Container _getContent() {
    final _overviewTitle = "Overview".toUpperCase();
    return Container(
      child: ListView(
        padding: EdgeInsets.fromLTRB(0.0, 180.0, 0.0, 32.0),
        children: <Widget>[
          CardRow(anime,
            horizontal: false,
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 32.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(_overviewTitle,
                  style: Style.headerTextStyle,),
                Separator(),
                Text(
                    "Summary : ", style: Style.commonTextStyle),
              ],
            ),
          ),
        ],
      ),
    );
  }
}