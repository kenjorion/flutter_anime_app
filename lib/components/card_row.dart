import 'package:flutter/material.dart';
import 'package:flutter_anime_app/components/style.dart';
import 'package:flutter_anime_app/main.dart';
import 'package:flutter_anime_app/models/anime.dart';

class CardRow extends StatelessWidget {

  Anime anime;
  bool horizontal;

  static const defaultThumbnailPath = "https://cdn.futura-sciences.com/buildsv6/images/mediumoriginal/6/9/5/69505b8d4b_50148813_fs10-veadeiros-cerrado.jpg";

  CardRow(this.anime, { this.horizontal = true });
  CardRow.vertical(this.anime): horizontal = false;

  String _getAnimeTitle() {
    return anime.title != null ? anime.title : "Manga Ranked : ${anime.rank.toString()}";
  }

  @override
  Widget build(BuildContext context) {

    Widget _getDetailsRowItem({ String value, Icon icon }) {
      return Row(
          children: <Widget>[
            Icon(Icons.arrow_right, color: icon.color, size : 30 ),
            Container(width: 8.0),
            Text(value, style: Style.regularTextStyle),
          ]
      );
    }

    Widget _getDetailsRow() {

      int rank = anime.rank == null ? anime.id : anime.rank;

      return Row(
        children: <Widget>[
          _getDetailsRowItem(
              value: "Rank: ${rank.toString()}",
              icon: Icon(Icons.arrow_right, color: Colors.pink)
          )
        ],
      );
    }

    Widget _getBelowAnimeTypeSeparator() {
      return Container(
          height: 2.0,
          width: 24.0,
          color: Color(0xff00c6ff),
          margin: EdgeInsets.symmetric(vertical: 8.0)
      );
    }

    ImageProvider _getNetworkImage() {
      return NetworkImage(anime.image) != null ? NetworkImage(anime.image) : CardRow.defaultThumbnailPath;
    }

    Widget content = Container(
      margin: EdgeInsets.fromLTRB(horizontal ? 56.0 : 16.0, horizontal ? 16.0 : 42.0, 16.0, 16.0),
      constraints: BoxConstraints.expand(),
      child: Column(
        crossAxisAlignment: horizontal ? CrossAxisAlignment.start : CrossAxisAlignment.center,
        children: <Widget>[
          Container(height: 4.0),
          Text(
              _getAnimeTitle(),
              style: Style.headerTextStyle
          ),
          Container(height: 8.0),
          Text(
              anime.type,
              style: Style.subHeaderTextStyle
          ),
          _getBelowAnimeTypeSeparator(),
          _getDetailsRow(),
        ],
      ),
    );



    Widget container = Container(
      child: content,
      height: horizontal ? 170.0 : 154.0,
      margin: horizontal ? EdgeInsets.only(left: 40.0) : EdgeInsets.only(top: 72.0),
      decoration: BoxDecoration(
        color: Color(MyApp.getAnimeTypeColor(anime)),
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10.0,
            offset: Offset(0.0, 10.0),
          ),
        ],
      ),
    );

    Widget thumbnail = Container(
      alignment: horizontal ? FractionalOffset.centerLeft : FractionalOffset.center,
      margin: EdgeInsets.only(
          left: 0.0, top: 0.0, bottom: 12.0
      ),
      child: Image(
        image: MyApp.getAnimeImage(anime), // add a pic from the api data
        width: 100.0,
        height: 100.0,
      ),
    );

    return Container(
        height: 155.0,
        margin: EdgeInsets.only(
            top: 16.0,
            left: 8.0,
            right: 24.0,
            bottom: 16.0,
        ),
      child: Stack(
        children: <Widget>[
          container,
          thumbnail,
        ],
      )
    );
  }
}

