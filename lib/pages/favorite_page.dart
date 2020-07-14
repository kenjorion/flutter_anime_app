import 'package:flutter/material.dart';
import 'package:flutter_anime_app/models/anime.dart';
import 'package:flutter_anime_app/components/card_row.dart';
import 'package:flutter_anime_app/providers/db_provider.dart';

class FavoritePage extends StatefulWidget {

  Function(int) onScreenChanged;

  FavoritePage({
    Key key,
    this.onScreenChanged,
  }) : super(key: key);

  @override
  _FavoritePageState createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {

  Future<List> futureAnimeList;

  @override
  void initState() {
    super.initState();
    futureAnimeList = fetchAnimeList();
  }

  Future<List> fetchAnimeList() async {
    List<Anime> list = await DBProvider.db.getAll();
    return list;
  }

  Widget _getListItem(Anime anime)
  {
    return GestureDetector(
      child: CardRow(anime),
      onTap: () => {},
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
    return Column(
      children: <Widget>[
        Expanded(
            child: Container(
              margin: EdgeInsets.only(top: 25.0),
              child: _buildFutureBuilderList(futureAnimeList),
            )
        )
      ],
    );
  }
}