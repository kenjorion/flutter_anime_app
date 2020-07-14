import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_anime_app/main.dart';
import 'package:flutter_anime_app/models/anime.dart';
import 'package:flutter_anime_app/layouts/details_core.dart';

class DetailsScreen extends StatefulWidget {

  Anime anime;
  Function(int) onScreenChanged;

  DetailsScreen({
    Key key,
    this.anime,
    this.onScreenChanged,
  }) : super(key: key);

  @override
  _DetailsScreenState createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {

  Future<Anime> futureAnime;

  @override
  void initState() {
    futureAnime = fetchAnime();
  }

  Future<Anime> fetchAnime() async {
    final response = await http.get('https://api.jikan.moe/v3/anime/${widget.anime.id}');
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return Anime.fromJsonExtraDetails(json.decode(response.body), widget.anime);
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load anime');
    }
  }

  Widget _buildFutureBuilder(Future<Anime> futureAnime)
  {
    return FutureBuilder<Anime>(
      future: futureAnime,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return DetailsCore(
            anime: snapshot.data
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

  Container _getBackground() {
    return Container(
      child: Image.asset(
        "lib/assets/img/details_screen.jpg",
        fit: BoxFit.cover,
        height: 300.0,
      ),
      constraints: BoxConstraints.expand(height: 295.0),
    );
  }

  Container _getGradient() {
    return Container(
      margin: EdgeInsets.only(top: 190.0),
      height: 110.0,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: <Color>[
            Color(0x00736AB7),
            Color(MyApp.getAnimeTypeColor(widget.anime))
          ],
          end: FractionalOffset(0.0, 1.0),
          begin: FractionalOffset(0.0, 0.0),
          stops: [0.0, 0.9],
        ),
      ),
    );
  }

  Container _getContent() {
    return Container(
      child: ListView(
        padding: EdgeInsets.fromLTRB(0.0, 72.0, 0.0, 130.0),
        children: <Widget>[
          Image(
            image: MyApp.getAnimeImage(widget.anime), // add a pic from the api data
            width: 200.0,
            height: 200.0,
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 32.0),
            margin: EdgeInsets.only(top: 50.0),
            child: _buildFutureBuilder(futureAnime)
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        constraints: BoxConstraints.expand(),
        color: Color(MyApp.getAnimeTypeColor(widget.anime)),
        child: Stack(
          children: <Widget>[
            _getBackground(),
            _getGradient(),
            _getContent(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => {
          this.widget.onScreenChanged(MyApp.navigationScreenIndex)
        },
        child: Icon(Icons.arrow_back),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}