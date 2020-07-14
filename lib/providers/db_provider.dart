import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_anime_app/models/anime.dart';

class DBProvider {

  static Database _database;
  static final DBProvider db = DBProvider._();

  DBProvider._();

  Future<Database> get database async {
    // If database exists, return database
    if (_database != null) return _database;

    // If database don't exists, create one
    _database = await initDB();

    return _database;
  }

  // Create the database and the Anime table
  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, 'anime_manager.db');

    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
          await db.execute('CREATE TABLE Anime('
              'id INTEGER PRIMARY KEY,'
              'mal_id INTEGER,'
              'type TEXT,'
              'rank INTEGER,'
              'title TEXT,'
              'image_url TEXT'
              ')');
        });
  }

  // Insert one anime
  createOne(Anime anime) async {
    final db = await database;
    final res = await db.insert('Anime', anime.toJson());
    return res;
  }

  // Delete one anime
  Future<int> deleteOne(Anime anime) async {
    final db = await database;
    final res = await db.rawDelete('DELETE FROM Anime WHERE mal_id=${anime.id}');
    if (res != 1) {
      var res = await createOne(anime);
      return 0;
    }
    return res;
  }

  // Get one anime
  Future<List> getOne(int id) async {
    final db = await database;
    final res = await db.rawQuery("SELECT * FROM Anime WHERE mal_id=$id");
    List<Anime> list = res.isNotEmpty ? res.map((data) => Anime.fromJson(data)).toList() : [];
    return list;
  }

  // Get all anime
  Future<List<Anime>> getAll() async {
    final db = await database;
    final res = await db.rawQuery("SELECT * FROM Anime");
    List<Anime> list = res.isNotEmpty ? res.map((data) => Anime.fromJson(data)).toList() : [];
    return list;
  }
}