import 'package:flutter/material.dart';
import 'package:flutter_anime_app/components/style.dart';
import 'package:flutter_anime_app/components/separator.dart';
import 'package:flutter_anime_app/models/anime.dart';
import 'package:flutter_anime_app/providers/db_provider.dart';

class DetailsCore extends StatefulWidget {

  Anime anime;

  DetailsCore({
    Key key,
    this.anime,
  }) : super(key: key);

  @override
  _DetailsCoreState createState() => _DetailsCoreState();
}

class _DetailsCoreState extends State<DetailsCore> {

  Widget favoriteButton;
  Future<bool> futureIsFavorite;

  @override
  void initState() {
    futureIsFavorite = fetchIsFavorite();
    favoriteButton = _buildFutureBuilder(futureIsFavorite);
  }

  Future<bool> fetchIsFavorite() async {
    List<Anime> list = await DBProvider.db.getOne(widget.anime.id);
    return list.isNotEmpty;
  }

  Future<int> fetchCreateOrNot() async {
    int res = await DBProvider.db.deleteOne(widget.anime);
    return res;
  }

  void _handleOnFavoriteButtonPressed() {
    setState(() {
      favoriteButton = FutureBuilder<int>(
          future: fetchCreateOrNot(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return FlatButton(
                child: Text(
                  snapshot.data == 0 ? "Je n'aime plus 👎" : "J'aime 👍",
                  style: TextStyle(
                      color: Colors.white
                  ),
                ),
                color: Colors.lightBlue,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6.0)
                ),
                onPressed: _handleOnFavoriteButtonPressed,
              );
            } else if (snapshot.hasError) {
              return CircularProgressIndicator();
            }
            return CircularProgressIndicator();
          }
      );
    });
  }

  Widget _buildFutureBuilder(Future<bool> futureBool)
  {
    return FutureBuilder<bool>(
        future: futureBool,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return FlatButton(
              child: Text(
                snapshot.data ? "Je n'aime plus 👎" : "J'aime 👍",
                style: TextStyle(
                    color: Colors.white
                ),
              ),
              color: Colors.lightBlue,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6.0)
              ),
              onPressed: _handleOnFavoriteButtonPressed,
            );
          } else if (snapshot.hasError) {
            print(snapshot.error.toString());
            return CircularProgressIndicator();
          }
          return CircularProgressIndicator();
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          "${widget.anime.title.toUpperCase()} 🇯🇵",
          style: Style.headerTextStyle.copyWith(
              fontSize: 20.0
          ),
        ),
        Separator(),
        Text(
            widget.anime.synopsis,
            style: Style.commonTextStyle
        ),
        Divider(
          color: Colors.transparent,
          height: 20,
        ),
        Text(
          "Épisodes",
          style: Style.headerTextStyle,
        ),
        Separator(),
        Text(
            widget.anime.episodes.toString(),
            style: Style.commonTextStyle
        ),
        Divider(
          color: Colors.transparent,
          height: 20,
        ),
        Text(
          "Favorite",
          style: Style.headerTextStyle,
        ),
        Separator(),
        favoriteButton
      ],
    );
  }
}