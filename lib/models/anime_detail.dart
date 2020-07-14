import 'package:flutter/cupertino.dart';

class AnimeDetail {
  final int id;
  final String type;
  final String title;
  final String image;
  final int rank;
  final int episode;
  final String synopsis;
  final String duration;

  AnimeDetail({this.episode, this.synopsis, this.duration, this.id, this.type, this.title, this.image, this.rank });

  factory AnimeDetail.fromJson(Map<String, dynamic> json) {
    return AnimeDetail(
        episode: json["episodes"],
        synopsis: json["synopsis"],
        duration: json["duration"],
        id: json['mal_id'],
        type: json['type'],
        title: json['title'],
        image: json['image_url'],
        rank: json["rank"],
    );
  }
}