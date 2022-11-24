

import 'dart:convert';

class Genres {
  Genres({
    this.genres,
  });

  List<Genre>? genres;

  factory Genres.fromRawJson(String str) => Genres.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Genres.fromJson(Map<String, dynamic> json) => Genres(
        genres: List<Genre>.from(json["genres"].map((x) => Genre.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "genres": List<dynamic>.from(genres!.map((x) => x.toJson())),
      };
}

class Genre {
  Genre({
    this.id,
    this.name,
  });

  int? id;
  String? name;

  factory Genre.fromRawJson(String str) => Genre.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Genre.fromJson(Map<String, dynamic> json) => Genre(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}
