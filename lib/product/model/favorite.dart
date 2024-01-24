// To parse this JSON data, do
//
//     final favorite = favoriteFromJson(jsonString);

import 'dart:convert';

Favorite favoriteFromJson(String str) => Favorite.fromJson(json.decode(str));

String favoriteToJson(Favorite data) => json.encode(data.toJson());

class Favorite {
    String hastanead;
    String id;
    String kullanicimail;

    Favorite({
        required this.hastanead,
        required this.id,
        required this.kullanicimail,
    });

    factory Favorite.fromJson(Map<String, dynamic> json) => Favorite(
        hastanead: json["hastanead"],
        id: json["id"],
        kullanicimail: json["kullanicimail"],
    );

    Map<String, dynamic> toJson() => {
        "hastanead": hastanead,
        "id": id,
        "kullanicimail": kullanicimail,
    };
}
