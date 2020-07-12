import 'package:flutter/cupertino.dart';

class Anime {
  final int id;
  final String type;
  final String title;
  final String image;
  final int rank;

  Anime({ this.id, this.type, this.title, this.image, this.rank });

  factory Anime.fromJson(Map<String, dynamic> json) {
    return Anime(
      id: json['mal_id'],
      type: json['type'],
      title: json['title'],
      image: json['image_url'],
      rank: json["rank"]
    );
  }
}