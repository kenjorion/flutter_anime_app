import 'package:flutter/material.dart';
import 'package:flutter_anime_app/components/style.dart';
import 'package:flutter_anime_app/models/anime.dart';

class CardRow extends StatelessWidget {

  final Anime anime;
  final bool horizontal;

  CardRow(this.anime, {this.horizontal = true});

  CardRow.vertical(this.anime): horizontal = false;

  @override
  Widget build(BuildContext context) {

    Widget _cardValue({String value, Icon icon}) {
      return new Row(
          children: <Widget>[
            new Icon(Icons.arrow_right, color: icon.color, size : 30 ),
            new Container(width: 8.0),
            new Text(value, style: Style.regularTextStyle),
          ]
      );
    }

    final cardContent = new Container(
      margin: new EdgeInsets.fromLTRB(horizontal ? 56.0 : 16.0, horizontal ? 16.0 : 42.0, 16.0, 16.0),
      constraints: new BoxConstraints.expand(),
      child: new Column(
        crossAxisAlignment: horizontal ? CrossAxisAlignment.start : CrossAxisAlignment.center,
        children: <Widget>[
          new Container(height: 4.0),
          new Text(anime.title != null ? anime.title : "manga ranked : " + anime.rank.toString(), style: Style.headerTextStyle),
          new Container(height: 8.0),
          new Text(anime.type, style: Style.subHeaderTextStyle),
          new Container(
              margin: new EdgeInsets.symmetric(vertical: 8.0),
              height: 2.0,
              width: 24.0,
              color: new Color(0xff00c6ff)
          ),
          new Row(
            children: <Widget>[
              new Expanded(
                  flex: horizontal ? 1 : 0,
                  child: _cardValue(
                      value: "rank: " + anime.rank.toString(),
                      icon: new Icon(Icons.arrow_right, color: Colors.pink))

              ),
              new Expanded(
                  flex: horizontal ? 1 : 0,
                  child: _cardValue(
                      value: "favourite",
                      icon: new Icon(Icons.arrow_right, color: Colors.pink))
              )
            ],
          ),
        ],
      ),
    );


    final card = new Container(
      child: cardContent,
      height: horizontal ? 170.0 : 154.0,
      margin: horizontal
        ? new EdgeInsets.only(left: 46.0)
        : new EdgeInsets.only(top: 72.0),
      decoration: new BoxDecoration(
        color: new Color(0xFF333366),
        shape: BoxShape.rectangle,
        borderRadius: new BorderRadius.circular(8.0),
        boxShadow: <BoxShadow>[
          new BoxShadow(
            color: Colors.black12,
            blurRadius: 10.0,
            offset: new Offset(0.0, 10.0),
          ),
        ],
      ),
    );

    final cardThumb = new Container(
      margin: new EdgeInsets.only(left: 0.0, top: 0.0, bottom: 12.0
      ),
      alignment: horizontal ? FractionalOffset.centerLeft : FractionalOffset.center,
      child: new Image(
        image: NetworkImage(anime.image) != null ? NetworkImage(anime.image) : "https://cdn.futura-sciences.com/buildsv6/images/mediumoriginal/6/9/5/69505b8d4b_50148813_fs10-veadeiros-cerrado.jpg",// add a pic from the api data
        height: 92.0,
        width: 92.0,
      ),
    );


    return new Container(
        height: 155.0,
        margin: const EdgeInsets.symmetric(
          vertical: 16.0,
          horizontal: 24.0,
        ),
      child: new Stack(
        children: <Widget>[
          card,
          cardThumb,
        ],
      )
    );
  }
}

