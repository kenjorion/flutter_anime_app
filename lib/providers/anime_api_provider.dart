import 'package:dio/dio.dart';
import 'package:flutter_anime_app/models/anime.dart';
import 'package:flutter_anime_app/providers/db_provider.dart';

class AnimeApiProvider {
  Future<List<Anime>> getAll() async {
    var url = "http://demo8161595.mockable.io/employee";
    Response response = await Dio().get(url);
    return (response.data as List).map((anime) {
      print('Inserting anime...');
      DBProvider.db.createOne(Anime.fromJson(anime));
    }).toList();
  }
}