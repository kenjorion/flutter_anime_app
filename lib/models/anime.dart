import 'package:flutter/cupertino.dart';

class Anime {
  final int id;
  final int rank;
  final String type;
  final String title;
  final String image;
  int episodes;
  String synopsis;

  Anime({
    this.id,
    this.rank,
    this.type,
    this.title,
    this.image,
    this.episodes,
    this.synopsis,
  });

  factory Anime.fromJson(Map<String, dynamic> json) {
    return Anime(
      id: json['mal_id'],
      rank: json['rank'],
      type: json['type'],
      title: json['title'],
      image: json['image_url'],
      episodes: 0,
      synopsis: "",
    );
  }

  factory Anime.fromJsonExtraDetails(Map<String, dynamic> json, Anime anime) {
    anime.episodes = json['episodes'];
    anime.synopsis = json['synopsis'];
    return anime;
  }

  Map<String, dynamic> toJson() => {
    "mal_id": id,
    "rank": rank,
    "type": type,
    "title": title,
    "image_url": image
  };
}