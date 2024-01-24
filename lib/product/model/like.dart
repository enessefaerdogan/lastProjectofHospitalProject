// To parse this JSON data, do
//
//     final like = likeFromJson(jsonString);

import 'dart:convert';

Like likeFromJson(String str) => Like.fromJson(json.decode(str));

String likeToJson(Like data) => json.encode(data.toJson());

class Like {
    String degerlendirmeId;
    String id;
    String kullanici;

    Like({
        required this.degerlendirmeId,
        required this.id,
        required this.kullanici,
    });

    factory Like.fromJson(Map<String, dynamic> json) => Like(
        degerlendirmeId: json["degerlendirme_id"],
        id: json["id"],
        kullanici: json["kullanici"],
    );

    Map<String, dynamic> toJson() => {
        "degerlendirme_id": degerlendirmeId,
        "id": id,
        "kullanici": kullanici,
    };
}
