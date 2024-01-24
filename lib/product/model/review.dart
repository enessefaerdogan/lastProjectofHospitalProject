// To parse this JSON data, do
//
//     final review = reviewFromJson(jsonString);

import 'dart:convert';

Review reviewFromJson(String str) => Review.fromJson(json.decode(str));

String reviewToJson(Review data) => json.encode(data.toJson());

class Review {
    String foto;
    String hastane;
    String id;
    String kullanici;
    String puan;
    String tarih;
    String yorum;

    Review({
        required this.foto,
        required this.hastane,
        required this.id,
        required this.kullanici,
        required this.puan,
        required this.tarih,
        required this.yorum,
    });

    factory Review.fromJson(Map<String, dynamic> json) => Review(
        foto: json["foto"],
        hastane: json["hastane"],
        id: json["id"],
        kullanici: json["kullanici"],
        puan: json["puan"],
        tarih: json["tarih"],
        yorum: json["yorum"],
    );

    Map<String, dynamic> toJson() => {
        "foto": foto,
        "hastane": hastane,
        "id": id,
        "kullanici": kullanici,
        "puan": puan,
        "tarih": tarih,
        "yorum": yorum,
    };
}
