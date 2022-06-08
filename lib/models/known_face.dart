// To parse this JSON data, do
//
//     final scanModel = scanModelFromMap(jsonString);

import 'dart:convert';

class KnownFace {
  KnownFace({
    required this.name,
    this.picture,
    this.age,
    required this.relation,
    this.id,
    this.localId,
  });

  String name;
  String? picture;
  int? age;
  String relation;
  String? id;
  String? localId;

  factory KnownFace.fromJson(String str) => KnownFace.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory KnownFace.fromMap(Map<String, dynamic> json) => KnownFace(
        localId: json["localId"],
        name: json["name"],
        picture: json["picture"],
        age: json["age"],
        relation: json["relation"],
      );

  Map<String, dynamic> toMap() => {
        "name": name,
        "picture": picture,
        "age": age,
        "relation": relation,
        "localId": localId,
      };

  KnownFace copy() => KnownFace(
        name: name,
        picture: picture,
        age: age,
        relation: relation,
        id: id,
        localId: localId,
      );
}
