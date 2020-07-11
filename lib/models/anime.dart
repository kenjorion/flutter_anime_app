class Anime {
  final int id;
  final String type;
  final String title;

  Anime({ this.id, this.type, this.title });

  factory Anime.fromJson(Map<String, dynamic> json) {
    return Anime(
      id: json['mal_id'],
      type: json['type'],
      title: json['title'],
    );
  }
}